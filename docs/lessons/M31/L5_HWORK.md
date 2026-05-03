# M31.5 — Практическая работа (homework)

**Тема:** умные указатели (`shared_ptr`) — использование и реализация

## Цели

- Закрепить навыки работы с классами в C++
- Разобраться в механике `shared_ptr` (refcount)
- Освоить перегрузку методов класса

## Что входит в работу

1. **Использование** умного указателя (`std::shared_ptr<Toy>` в Dog)
2. **Реализация** аналога умного указателя (`shared_ptr_toy`)

---

## Задание 1. Использование умного указателя

### Что нужно сделать

- Реализуйте класс **Dog**, использующий `std::shared_ptr<Toy>` для класса Toy.
- Метод **`getToy`** — собака подбирает игрушку:
  - Если у собаки **уже** есть **эта** игрушка → `I already have this toy`
  - Если игрушка сейчас у **другой** собаки → `Another dog is playing with this toy`
  - Иначе — собака подбирает игрушку.
- Метод **`dropToy`** — собака бросает игрушку на пол:
  - Если у собаки **нет** игрушки → `Nothing to drop`
  - Иначе — отпускает.

### Класс Toy (фиксированный, дан в задании)

```cpp
class Toy {
public:
    Toy(const std::string& name) { name_ = name; }
    std::string getNmae() { return name_; }   // sic — опечатка из задания
    ~Toy() {
        std::cout << "Toy " << name_ << " was dropped " << std::endl;
    }
private:
    std::string name_;
};
```

### Подсказки

- Использовать `use_count()` — но учесть: создание `shared_ptr<Toy>` тоже **увеличивает** счётчик.
- «Другая собака держит игрушку» определяется как `use_count > 1` для **передаваемого** указателя.
  То есть: если кто-то ещё (кроме «уличной» переменной с этой игрушкой) держит её — она занята.

---

## Задание 2. Реализация умного указателя

### Что нужно сделать

Реализуйте класс **`shared_ptr_toy`** — простой аналог `std::shared_ptr<Toy>`,
управляющий памятью объектов класса Toy.

Должен:
- Иметь все стандартные методы класса
- Быть **функциональной заменой** `shared_ptr<Toy>`

Реализовать **сервисную функцию** `make_shared_toy(name)` → возвращает `shared_ptr_toy`.

### Архитектура

Каждый `shared_ptr_toy` хранит:
- `Toy*` — указатель на сам объект Toy
- `int*` — указатель на **общий** счётчик ссылок (refcount)

Несколько `shared_ptr_toy` на один Toy → у всех одинаковые `Toy*` и `int*`.

### Конструкторы

| Конструктор               | Что делает                                                  |
|---------------------------|-------------------------------------------------------------|
| `shared_ptr_toy()`        | Пустой указатель: `toy = nullptr; counter = nullptr;`       |
| `shared_ptr_toy(string)`  | Новый `new Toy(name)` + `new int(1)`                        |
| `shared_ptr_toy(const&)`  | Копирует `Toy*` и `int*` от другого, увеличивает `*counter` |

### Деструктор

```text
если counter != nullptr:
    *counter -= 1
    если *counter == 0:
        delete toy
        delete counter
        toy = nullptr; counter = nullptr
```

### operator=

```text
если &other == this: return *this           # self-assignment
если other.toy == toy: return *this         # уже на ту же игрушку
# Освободить текущее (как в деструкторе)
если counter != nullptr:
    *counter -= 1
    если *counter == 0:
        delete toy; delete counter
# Захватить новое
toy     = other.toy
counter = other.counter
если counter != nullptr: *counter += 1
return *this
```

### Сервисные функции

| Метод                           | Назначение                                                           |
|---------------------------------|----------------------------------------------------------------------|
| `void reset()`                  | То же, что деструктор, но объект остаётся жив. Указатели обнуляются. |
| `Toy* get() const`              | Сырой указатель                                                      |
| `int use_count() const`         | Текущее значение `*counter` (или 0 если nullptr)                     |
| `std::string getToyName()`      | Имя игрушки или `"Nothing"` если пусто                               |

### Тестовая программа (из задания)

```cpp
int main() {
    shared_ptr_toy toy_01 = make_shared_toy("ball");
    shared_ptr_toy toy_02(toy_01);
    shared_ptr_toy toy_03("duck");

    std::cout << "=================================================\n";
    std::cout << toy_01.getToyName() << " links:" << toy_01.use_count() << "  "
              << toy_02.getToyName() << " links:" << toy_02.use_count() << "  "
              << toy_03.getToyName() << " links:" << toy_03.use_count() << "\n";
    std::cout << "=================================================\n";

    toy_02 = toy_03;
    std::cout << toy_01.getToyName() << " links:" << toy_01.use_count() << "  "
              << toy_02.getToyName() << " links:" << toy_02.use_count() << "  "
              << toy_03.getToyName() << " links:" << toy_03.use_count() << "\n";
    std::cout << "=================================================\n";

    toy_01.reset();
    std::cout << toy_01.getToyName() << " links:" << toy_01.use_count() << "  "
              << toy_02.getToyName() << " links:" << toy_02.use_count() << "  "
              << toy_03.getToyName() << " links:" << toy_03.use_count() << "\n";
    std::cout << "=================================================\n";
    return 0;
}
```

### Ожидаемый вывод

```text
=================================================
ball links:2  ball links:2  duck links:1
=================================================
ball links:1  duck links:2  duck links:2
=================================================
Toy ball was dropped
Nothing links:0  duck links:2  duck links:2
=================================================
Toy duck was dropped
```

---

## Критерии оценки

- Программы запускаются и работают корректно, нет синтаксических ошибок
- Имена переменных корректны
- Текстовый интерфейс
- Контроль ввода
- Выполнено два задания

## Сабмит

Replit URL или .cpp файл через форму. **Note:** проверка отключена → submission gated.
