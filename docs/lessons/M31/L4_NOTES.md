# M31.4 — Указатели с подсчётом ссылок (shared_ptr, weak_ptr)

**Длительность:** ~19 минут
**Тема:** `std::shared_ptr`, refcount, `std::make_shared`, `reset()`, циклы → `std::weak_ptr`

## Главная идея

> **`shared_ptr<T>`** = **разделённое владение** объектом. Внутри хранит
> (1) сырой указатель `T*` и (2) указатель на **счётчик ссылок** (refcount).
>
> Объект уничтожается ровно тогда, когда **последний** `shared_ptr` на него
> уничтожен или переустановлен.
>
> Главная **опасность** — циклические ссылки → утечка. Решение — `weak_ptr`.

## Зачем shared_ptr

`unique_ptr` (M31.3) — **один** владелец. Но иногда нужно:

- Один объект, **несколько** независимых ссылок (несколько собак ↔ одна игрушка)
- Передать «копию» владения в другую функцию / поток
- Не знать заранее, **кто** удалит объект последним

> **Пример из урока:** в семье несколько собак, у каждой любимая игрушка.
> Иногда **разные собаки любят одну и ту же** игрушку. Игрушка должна жить,
> пока её любит **хотя бы одна** собака.

## std::shared_ptr<T>

### Создание через make_shared

```cpp
#include <memory>

auto ball = std::make_shared<Toy>("Ball");      // refcount = 1
auto bone = std::make_shared<Toy>("Bone");      // refcount = 1
```

### Копирование = новая ссылка, **не** новый объект

```cpp
auto p1 = std::make_shared<Toy>("X");           // refcount = 1
auto p2 = p1;                                   // refcount = 2 (один Toy)
auto p3 = p1;                                   // refcount = 3
```

> В отличие от custom Smart Pointer из M31.3 — копия `shared_ptr` **не** делает deep copy игрушки. Она увеличивает счётчик.

### reset() — отказаться от владения

```cpp
ball.reset();   // ball больше не владеет → refcount уменьшается
                // если был последний → объект удаляется
                // если ещё кто-то держит → объект жив
```

## Полный пример: собаки и общие игрушки

```cpp
class Dog {
    std::string             name;
    int                     age;
    std::shared_ptr<Toy>    lovelyToy;          // ← shared, не unique

public:
    // Конструктор от готового shared_ptr (приходит извне)
    Dog(const std::string& n, std::shared_ptr<Toy> toy, int a)
        : name(n), age(a), lovelyToy(std::move(toy)) {}

    // Delegating ctor для случая «дефолтная игрушка»
    Dog(const std::string& n, int a)
        : Dog(n, std::make_shared<Toy>("default"), a) {}

    void copyLovelyToy(const Dog& other) {
        lovelyToy = other.lovelyToy;             // shared, refcount++
    }
};

int main() {
    auto ball = std::make_shared<Toy>("Ball");   // refcount = 1
    auto bone = std::make_shared<Toy>("Bone");   // refcount = 1

    Dog a("Sharik",  ball, 10);                  // ball refcount = 2
    Dog b("Druzhok", ball, 11);                  // ball refcount = 3
    Dog c("Pushok",  ball, 7);                   // ball refcount = 4
    Dog d("Vanya",   bone, 5);                   // bone refcount = 2
    Dog e("Iriska",  bone, 6);                   // bone refcount = 3

    ball.reset();                                // ball refcount = 3 (3 собаки)
    bone.reset();                                // bone refcount = 2 (2 собаки)

    // Локальные ball/bone пустые. Но игрушки **живы** — собаки держат.
}
```

### Что покажет отладчик

| Объект    | strong refs | Кто держит              |
|-----------|-------------|-------------------------|
| Toy Ball  | 3           | Sharik, Druzhok, Pushok |
| Toy Bone  | 2           | Vanya, Iriska           |

> В IDE рядом с `shared_ptr` обычно показывается «Strong Refs: N».

## Передача игрушки между собаками

```cpp
void Dog::copyLovelyToy(const Dog& other) {
    lovelyToy = other.lovelyToy;     // refcount у other.lovelyToy ++
                                     // refcount у старой lovelyToy --
                                     // (если был последний — освобождается)
}

// e любила косточку, теперь любит мяч (копия указателя shared с Sharik)
e.copyLovelyToy(a);

// Bone теперь держит только Vanya → refcount = 1
// Если Vanya тоже сменит → refcount = 0 → Bone удаляется
```

## .get() — сырой указатель (только для observe)

```cpp
auto bone = std::make_shared<Toy>("Bone");
Toy* raw = bone.get();          // raw указатель — не для delete!

// ... уберём всех владельцев Bone ...
// raw теперь указывает в **освобождённую** память → use-after-free
std::cout << raw->name;         // UB
```

> **Никогда** не делайте `delete raw_ptr`, полученный из `.get()`. И не используйте после освобождения. `.get()` — только для интеропа со старым C-API, который ждёт `T*`.

## Механика shared_ptr (внутри)

```text
shared_ptr<T> ──┬──> Toy object
                └──> Control Block
                     ├── strong refs (uses_count)
                     └── weak   refs
```

- Копирование `shared_ptr`: ++strong_refs
- Уничтожение `shared_ptr`: --strong_refs; если 0 → `delete object`
- Деструктор Control Block: когда и strong=0 и weak=0

> **`make_shared` vs `shared_ptr<T>(new T(...))`**: `make_shared` выделяет объект **и** control block в **одной** аллокации (быстрее, локальнее), а сырой `new` — в двух. Best practice: `make_shared` всегда, кроме случаев с custom deleter.

## Циклические ссылки → утечка памяти

### Типичный пример: «лучший друг»

```cpp
class Dog {
    std::string                 name;
    std::shared_ptr<Dog>        bestie;      // ← std::shared_ptr<Dog>!

public:
    Dog(const std::string& n) : name(n) {}
    void setBestie(std::shared_ptr<Dog> b) { bestie = std::move(b); }
};

int main() {
    auto a = std::make_shared<Dog>("A");     // a.refcount = 1
    auto b = std::make_shared<Dog>("B");     // b.refcount = 1

    a->setBestie(b);                         // b.refcount = 2 (a.bestie держит b)
    b->setBestie(a);                         // a.refcount = 2 (b.bestie держит a)

    // Сохраним сырые указатели для наблюдения
    Dog* pa = a.get();
    Dog* pb = b.get();

    a.reset();                               // a.refcount = 1 (b.bestie ещё держит)
    b.reset();                               // b.refcount = 1 (a.bestie ещё держит)

    // ↑ ОБА объекта живы, но из main к ним нет доступа → УТЕЧКА.
    // pa и pb указывают в живые, но «потерянные» объекты.
}
```

> **Почему утечка:**
> - A удалить нельзя — на неё указывает `B::bestie`
> - B удалить нельзя — на неё указывает `A::bestie`
> - Цикл взаимного владения → refcount никогда не дойдёт до нуля

## std::weak_ptr — слабая ссылка

> **`weak_ptr`** = ссылка на объект, которой **владеет** `shared_ptr`,
> но сама **не считается** в strong refcount.
>
> «Я знаю, как добраться до объекта, но я **не** претендую на владение.»

### Использование для разрыва цикла

```cpp
class Dog {
    std::string             name;
    std::weak_ptr<Dog>      bestie;          // ← было shared_ptr — теперь weak

public:
    Dog(const std::string& n) : name(n) {}
    void setBestie(std::shared_ptr<Dog> b) { bestie = b; }   // weak от shared
};

int main() {
    auto a = std::make_shared<Dog>("A");     // a strong = 1
    auto b = std::make_shared<Dog>("B");     // b strong = 1

    a->setBestie(b);                         // b strong = 1 (weak += 1)
    b->setBestie(a);                         // a strong = 1 (weak += 1)

    a.reset();                               // a strong = 0 → A удалена
    b.reset();                               // b strong = 0 → B удалена
    // ✓ нет утечки
}
```

### Преобразование weak → shared

```cpp
std::weak_ptr<Dog> w = a;

if (auto sp = w.lock()) {       // sp — shared_ptr (или nullptr если объект мёртв)
    sp->voice();                // безопасно использовать
}
```

> `lock()` атомарно проверяет «жив ли объект» и возвращает `shared_ptr` (или пустой). Только так можно **безопасно** доступиться к объекту через `weak_ptr`.

## Сравнение трёх умных указателей

| Аспект              | `unique_ptr`        | `shared_ptr`             | `weak_ptr`               |
|---------------------|---------------------|--------------------------|--------------------------|
| Владение            | Эксклюзивное        | Разделённое (refcount)   | **Не владеет**           |
| Копирование         | Запрещено           | OK (++refcount)          | OK (++weak count)        |
| Move                | OK                  | OK                       | OK                       |
| Размер              | sizeof(T*)          | 2 × sizeof(T*)           | 2 × sizeof(T*)           |
| Overhead            | 0                   | atomic refcount          | atomic refcount          |
| Где использовать    | Default choice      | Когда нужно shared       | Циклы, observers, cache  |

## Когда выбрать какой

| Ситуация                                | Указатель                                      |
|-----------------------------------------|------------------------------------------------|
| Локальный owner, не делится             | `unique_ptr`                                   |
| Несколько модулей нужны одному ресурсу  | `shared_ptr`                                   |
| Циклы (A↔B, parent↔child)               | parent: `shared_ptr`, child→parent: `weak_ptr` |
| Кэш, observer, optional reference       | `weak_ptr`                                     |
| Уверен, что не нужен smart_ptr          | RAII guard / автоматика по value               |

## Practical relevance для DevOps

- **Pub/sub:** publisher держит `shared_ptr<Topic>`, subscribers — `weak_ptr<Topic>`
- **Connection pools:** `shared_ptr<Connection>` — клиенты делят соединение
- **Resource cache:** `weak_ptr` в кэше → не продлевает жизнь объекта
- **Tree structures:** parent → children: `shared_ptr`, child → parent: `weak_ptr`
- **Thread-safety:** refcount у `shared_ptr` атомарный — безопасно копировать между потоками
- **Modern C++ rule:** `shared_ptr` — последний выбор. Сначала try `unique_ptr`. Лишний refcount = atomic overhead.

## Связь с другими модулями

- **M31.2 Rule of Three:** ручной refcount → теперь автоматический в shared_ptr
- **M31.3 unique_ptr:** дополнение для случая «несколько владельцев»
- **M31.5 (next):** скорее всего hwork модуля
- **C++ best practices:** «Prefer `unique_ptr`. Use `shared_ptr` only if shared ownership genuinely needed. Use `weak_ptr` to break cycles.»
