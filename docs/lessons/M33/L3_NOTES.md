# M33.3 — Шаблонные классы и функции (templates)

**Длительность:** ~20 минут
**Тема:** `template<typename T>`, шаблонные функции и классы, type deduction

## Главная идея

> **Шаблоны** = механизм языка для **обобщения по типу**. Один код, много типов.
>
> Альтернатива макросам: **типобезопасны**, проверяются компилятором,
> вписаны в namespaces и классы.

## Шаблоны vs макросы

| Аспект           | `#define MAX(a, b) ...`          | `template<typename T> max(T a, T b)` |
|------------------|----------------------------------|--------------------------------------|
| Когда обработка  | Перед компиляцией (preprocessor) | Во время компиляции                  |
| Типобезопасность | Нет (текстовая подстановка)      | Да (компилятор проверяет типы)       |
| Namespace        | Глобальный                       | Можно в namespace / class            |
| Side effects     | `MAX(i++, j++)` — ой             | OK, аргументы вычисляются один раз   |
| Отладка          | Сложно (preprocessor)            | Возможна, есть type info             |
| C++ idiomatic    | Legacy                           | Modern                               |

> Templates — **правильный** способ обобщения в C++.

## Шаблонная функция: `max` для двух чисел

### Синтаксис

```cpp
template <typename T>
T max(T a, T b) {
    return a > b ? a : b;
}
```

| Часть              | Значение                                            |
|--------------------|-----------------------------------------------------|
| `template`         | Ключевое слово (вместо `#define`)                   |
| `<typename T>`     | Параметр шаблона: `T` — переменная-тип              |
| `T max(T, T)`      | Функция, в которой `T` используется как обычный тип |

> `typename` и `class` в шаблонах — **синонимы**. Можно `template<class T>`. Современная практика — `typename`.

### Использование

```cpp
std::cout << max(10, 20);          // T deduced → int      → 20
std::cout << max(3.14, 2.71);      // T deduced → double   → 3.14
std::cout << max('a', 'z');        // T deduced → char     → 'z'
```

> **Type deduction:** компилятор сам выводит `T` из аргументов. Нужно вызвать `max<double>(...)` явно — только если deduction не работает.

## Проблема: разные типы аргументов

```cpp
max(10, 20.5);     // ← ERROR: T is int? double? ambiguous
```

### Решение №1: два параметра-типа

```cpp
template <typename T1, typename T2>
T1 max(T1 a, T2 b) {
    return a > b ? a : b;
}

max(10, 20.5);     // OK — T1=int, T2=double, returns int!
```

**Подвох:** возвращает `T1` (int), теряем дробную часть → результат `20`, не `20.5`.

### Решение №2: явное приведение типа

```cpp
max(10.0, 20.5);   // оба double → return 20.5
```

> Best modern practice: `auto`-возврат + `decltype`:
> ```cpp
> template <typename T1, typename T2>
> auto max(T1 a, T2 b) -> decltype(a > b ? a : b) { ... }
> ```

## Шаблонная функция для контейнера: max(vector)

### Базовая версия (для int)

```cpp
#include <vector>
#include <stdexcept>

int max(const std::vector<int>& v) {
    if (v.empty()) {
        throw std::invalid_argument("v cannot be empty");
    }
    int m = v[0];
    for (size_t i = 1; i < v.size(); ++i) {
        if (v[i] > m) m = v[i];
    }
    return m;
}
```

> Защита от пустого вектора — иначе `v[0]` → segfault.

### Шаблонизация

```cpp
template <typename T>
T max(const std::vector<T>& v) {
    if (v.empty()) {
        throw std::invalid_argument("v cannot be empty");
    }
    T m = v[0];
    for (size_t i = 1; i < v.size(); ++i) {
        if (v[i] > m) m = v[i];
    }
    return m;
}
```

> Обратите внимание: `std::vector<T>` — потому что **`vector` сам шаблон класса**! Мы лишь подставляем `T` в его параметр.

### Использование

```cpp
std::vector<double> v = {1.5, 10.5, 5.5, 7.0};
std::cout << max(v);     // T deduced → double → 10.5
```

> **Type deduction** работает: компилятор смотрит на `std::vector<double>` → выводит `T = double`.

## Шаблонные классы (структуры)

### Постановка

Универсальное «сообщение», которое может хранить:
- C-строку (`const char*`)
- `std::string`

### Без шаблона (для C-string)

```cpp
struct Message {
    const char* data;

    Message(const char* d) : data(d) {}
    void print() const { std::cout << data << std::endl; }
};
```

### Шаблонизация

```cpp
template <typename T>
struct Message {
    T data;

    Message(const char* d) : data(d) {}    // Принимает C-string, T-конструктор сам сделает
    void print() const { std::cout << data << std::endl; }
};
```

> `std::string` имеет конструктор от `const char*` → инициализация `data(d)` работает для обоих типов.

### Использование

```cpp
Message<const char*> m1("hello");          // T = const char*
m1.print();                                 // → hello

Message<std::string> m2("world");          // T = std::string
m2.print();                                 // → world
```

> **Класс-шаблон** требует **явного** указания типа в `<...>`. Type deduction для **классов** появилась только в C++17 (CTAD).

## std::vector — шаблон класса

```cpp
std::vector<int>     vi;        // T = int
std::vector<double>  vd;        // T = double
std::vector<MyClass> vm;        // T = MyClass
```

> Вся **STL** (Standard Template Library) — это шаблонные классы и функции. `vector`, `map`, `unique_ptr`, `optional`, ...

## Type deduction (где работает / не работает)

### Работает

```cpp
template <typename T> T add(T a, T b);

add(1, 2);                  // OK: T = int
add(1.5, 2.5);              // OK: T = double

std::vector<int> v;
fill(v);                    // OK: T = int (deduced from std::vector<T>)
```

### НЕ работает

```cpp
template <typename T> T make_default();

make_default();             // ERROR: T нельзя deduce — нет аргументов
make_default<int>();        // OK: указали явно
```

```cpp
template <typename T> struct Holder { T data; };

Holder h{42};               // C++17: OK (CTAD)
                            // До C++17 → нужно: Holder<int> h{42};
```

## Когда использовать шаблоны

### Подходит
- **Контейнеры:** `vector<T>`, `map<K,V>`, кастомные коллекции
- **Алгоритмы:** `min`/`max`/`sort` для любых типов с `operator<`
- **Smart pointers:** `unique_ptr<T>`, `shared_ptr<T>`
- **Generic utilities:** `optional<T>`, `variant<T,U,...>`, `tuple<...>`

### Не подходит
- **Hot path с одним типом:** перегрузка / простая функция чище
- **Code bloat:** каждое использование с новым `T` → отдельный код после компиляции
- **API boundary:** клиенту нужно понимать, что обобщается; иногда лучше базовый класс с `virtual`

## Compile-time vs runtime polymorphism

| Подход                     | Когда выбор    | Перфоманс          | Гибкость            |
|----------------------------|----------------|--------------------|---------------------|
| Templates (M33.3)          | Compile-time   | Нет vtable, inline | Любой type          |
| Virtual methods (M29)      | Runtime        | vtable lookup      | Subclass only       |
| Function overloading (M31) | Compile-time   | Нет overhead       | Перечисленные types |

## Подводные камни

### 1. Code bloat

```cpp
template <typename T> void foo(T) { /* много кода */ }

foo(1);     // создаст foo<int>
foo(1.0);   // создаст foo<double>
foo("x");   // создаст foo<const char*>
```

→ Три копии. Может раздуть бинарь.

### 2. Длинные сообщения об ошибках

`std::vector<std::map<int, std::pair<...>>>` — при ошибке шаблона компилятор выдаёт километровую трассу.

### 3. Header-only

Тело шаблона должно быть **в .h** (или `.tpp` подключаемый). Компилятор должен видеть полное определение при инстанцировании. Нельзя положить в .cpp.

### 4. SFINAE и concepts

Жёсткий контроль ограничений на типы — отдельная сложная тема (`std::enable_if`, C++20 `concepts`).

## Practical relevance для DevOps

- **STL знакомство:** все стандартные коллекции — templates
- **Generic logging:** `template<typename T> void log(const T& msg)`
- **Type-safe converters:** `template<typename From, typename To> To convert(From x)`
- **JSON/protobuf:** `nlohmann::json::get<int>()` — шаблонный getter
- **Smart pointers:** `unique_ptr<Connection>`, `shared_ptr<Config>`
- **Modern C++:** STL + algorithms + ranges → весь pipeline на templates

## Связь с другими модулями

- **M23 макросы:** type-unsafe старая школа → templates типобезопасны
- **M28 std::vector / M22 std::map:** были шаблонами **с самого начала**
- **M31.3 unique_ptr:** шаблонный класс
- **M31.4 shared_ptr:** шаблонный класс
- **C++ best practices:** шаблоны + concepts (C++20) — modern way
