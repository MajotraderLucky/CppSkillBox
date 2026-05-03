# M31.3 — Знакомство с умными указателями (smart pointers)

**Длительность:** ~9 минут
**Тема:** custom smart pointer, `unique_ptr`, `make_unique`, RAII над `new`/`delete`

## Главная идея

> **Умный указатель** = класс-обёртка над `T*`, который сам вызывает `delete`
> в деструкторе. Программист больше не следит за временем жизни **вручную**.
>
> Это применение **Rule of Three** к управлению памятью.

## Зачем нужен умный указатель

Из M31.2 мы узнали: класс с `new` в конструкторе обязан реализовать:
- деструктор (delete)
- copy ctor (deep copy)
- copy assignment (delete + new + self-guard)

Это **скучный boilerplate**. Решение — вынести его в **отдельный класс-обёртку**.

> Статические поля (`std::string name;`) живут и умирают вместе с объектом
> автоматически. А динамика (`Toy* toy = new Toy(...)`) — нет. Хотим:
> чтобы поле-указатель тоже **умирало само**.

## Custom smart pointer (учебный пример)

```cpp
class SmartToyPointer {
    Toy* object;                                    // private — то чем владеем

public:
    // (1) default ctor — Toy с пустым именем
    SmartToyPointer() : object(new Toy("")) {}

    // (2) ctor от строки
    SmartToyPointer(const std::string& name)
        : object(new Toy(name)) {}

    // (3) copy ctor — deep copy
    SmartToyPointer(const SmartToyPointer& other)
        : object(new Toy(*other.object)) {}

    // (4) copy assignment — full Rule-of-Three idiom
    SmartToyPointer& operator=(const SmartToyPointer& other) {
        if (this == &other) return *this;           // self-assignment guard
        delete object;                              // освободить старое
        object = new Toy(*other.object);            // deep copy
        return *this;
    }

    // (5) destructor
    ~SmartToyPointer() { delete object; }
};
```

### Всё что нужно для управления памятью — заперто здесь

Класс **Dog** теперь не знает о `new`/`delete`:

```cpp
class Dog {
    std::string       name;
    int               age;
    SmartToyPointer   lovelyToy;   // ← было: Toy* lovelyToy

public:
    Dog(const std::string& n, int a, const std::string& toyName)
        : name(n), age(a), lovelyToy(toyName) {}

    // НЕТ деструктора — компилятор сгенерирует, SmartToyPointer удалит игрушку
    // НЕТ copy ctor — компилятор сгенерирует, SmartToyPointer глубоко скопирует
    // НЕТ operator= — компилятор сгенерирует, SmartToyPointer корректно присвоит
};
```

> **Магия:** Dog — снова **Rule of Zero** класс. Никаких ручных `~Dog()`.

## Недостаток custom smart pointer

> Писать **отдельный** smart pointer для **каждого** класса:
> - Сложно (повторяющийся boilerplate)
> - Иногда **невозможно** — непонятно как копировать (например, файловый дескриптор)

Поэтому в **стандартной библиотеке** уже есть готовые — для **любого** типа `T`.

## Готовые умные указатели в C++

| Тип            | Семантика владения                   | Заголовок  |
|----------------|--------------------------------------|------------|
| `unique_ptr`   | **Один** владелец                    | `<memory>` |
| `shared_ptr`   | **Несколько** владельцев (refcount)  | `<memory>` |
| `weak_ptr`     | Слабая ссылка, не продлевает жизнь   | `<memory>` |

Темы будут раскрыты в следующих уроках. Сейчас — **`unique_ptr`**.

## std::unique_ptr — exclusive ownership

> «Один объект — один владелец». Передать владение **сложно** (только через `move`).

### Объявление и создание

```cpp
#include <memory>

std::unique_ptr<Dog> d = std::make_unique<Dog>("Sharik", "Ball", 5);
//                       └────────── factory ──────────┘
//                                  внутри: new Dog("Sharik", "Ball", 5)
```

### `make_unique<T>(args...)`

- `<T>` — тип объекта (как у `unique_ptr<T>`)
- `(args...)` — аргументы конструктора `T`
- Возвращает `unique_ptr<T>` владеющий **новым** `T(args...)`

> **Best practice:** `make_unique` > прямой `new` — exception-safe и без явного `new`.

### Использование как обычного указателя

```cpp
d->voice();          // оператор -> работает как у raw pointer
(*d).age();          // оператор * тоже
```

### Автоматическое удаление

```cpp
{
    auto d = std::make_unique<Dog>("Sharik", "Ball", 5);
    // ... работа с d ...
}   // ← здесь d уничтожается → ~unique_ptr<Dog>() → delete dog
```

### Запрет копирования (deleted copy)

```cpp
void foo(std::unique_ptr<Dog> d) { /* ... */ }

auto d = std::make_unique<Dog>(...);
foo(d);             // ← COMPILE ERROR
                    // unique_ptr(const unique_ptr&) = delete;
```

`unique_ptr` имеет **`= delete`** на copy ctor и copy assignment — отсюда защита от двух владельцев.

### Передать владение можно через std::move

```cpp
foo(std::move(d));  // OK — d теперь nullptr, владение переехало в foo
```

## Преимущества unique_ptr

- **Автоматическое освобождение** — нет утечек
- **Zero overhead** — то же, что raw `T*` по размеру (нет refcount)
- **Compile-time safety** — двойное владение поймает компилятор
- **Exception safety** — `make_unique` не оставит сырого `new` в воздухе

## Недостатки unique_ptr

- **Только один владелец** — нельзя «поделиться»
- Передача в функцию — только `std::move` (с потерей владения у source)

> Если нужен shared ownership — следующий урок про **`shared_ptr`**.

## Сравнение: custom vs unique_ptr

| Аспект                | Custom SmartToyPointer        | std::unique_ptr<Toy>        |
|-----------------------|-------------------------------|-----------------------------|
| Применимость          | Только Toy                    | Любой `T`                   |
| Copy semantics        | Deep copy                     | **Запрещено**               |
| Move semantics        | -                             | Поддерживается              |
| Custom deleter        | Жёстко `delete`               | Можно задать deleter        |
| Размер                | sizeof(T*)                    | sizeof(T*) (без deleter)    |
| Best practice         | Только в учебных целях        | Использовать всегда         |

## Полная переделка примера M31.2 на unique_ptr

```cpp
#include <iostream>
#include <memory>
#include <string>

class Toy {
    std::string name;
public:
    Toy(const std::string& n) : name(n) {}
    ~Toy() { std::cout << "Toy " << name << " gone\n"; }
};

class Dog {
    std::string             name;
    int                     age;
    std::unique_ptr<Toy>    lovelyToy;     // ← unique_ptr вместо raw Toy*

public:
    Dog(const std::string& n, int a, const std::string& toyName)
        : name(n), age(a),
          lovelyToy(std::make_unique<Toy>(toyName)) {}

    // Rule of Zero — компилятор генерирует:
    // ~Dog() = default          → unique_ptr вызовет delete на toy
    // Dog(const Dog&) = delete  → потому что unique_ptr non-copyable
    // operator= = delete        → то же самое
    // Dog(Dog&&) = default      → move работает
    // Dog& operator=(Dog&&)     → то же
};

int main() {
    auto d1 = std::make_unique<Dog>("Druzhok", 3, "Ball");
    // Dog d2(*d1);            // ← COMPILE ERROR: unique_ptr non-copyable → Dog тоже
    auto d2 = std::move(d1);   // OK — передача владения
}
```

> **Сравните с M31.2 finale:** там было ~40 строк boilerplate (ctor + dtor + copy ctor + op=). Здесь — **0 строк** управления памятью.

## Practical relevance для DevOps

- **Resource management:** unique_ptr — стандарт для owner-pointers
- **API design:** возвращать `unique_ptr<T>` вместо raw `T*` — explicit ownership transfer
- **PIMPL idiom:** `unique_ptr<Impl>` для скрытия реализации в .cpp
- **Factory functions:** `make_unique<Concrete>(...)` → `unique_ptr<Base>`
- **Custom deleter:** `unique_ptr<FILE, decltype(&fclose)>` — RAII над C-API
- **Modern C++ rule:** **никогда** не пиши `new`/`delete` в user-коде — только `make_unique`/`make_shared`

## Связь с другими модулями

- **M26.1:** `new`/`delete` — теперь автоматизировано
- **M31.1, M31.2:** Rule of Three — теперь Rule of Zero (благодаря smart_ptr)
- **M31.4+ (next):** `shared_ptr` (refcount) и `weak_ptr` (cycles)
- **C++ best practices:** «No naked `new`» — основное правило modern C++
