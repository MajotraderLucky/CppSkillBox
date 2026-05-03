# M31.1 — Перегрузка методов (function overloading + delegating ctors)

**Длительность:** ~12 минут
**Тема:** статический полиморфизм через overloading, цепочка конструкторов

## Главная идея

> **Перегрузка** = несколько функций/методов с **одинаковым именем**, но **разными сигнатурами**.
> Компилятор выбирает нужную по типам аргументов (compile-time).

## Динамический vs статический полиморфизм

| Тип             | Когда выбор    | Механизм               |
|-----------------|----------------|------------------------|
| Динамический    | runtime        | virtual + vtable       |
| **Статический** | compile-time   | overloading, templates |

В M29.3 был динамический. Теперь — статический.

## Overloading функций

```cpp
void print(const std::string& s) { std::cout << "STR: " << s; }
void print(int i)                { std::cout << "INT: " << i; }
void print(double d)             { std::cout << "DBL: " << d; }

print("hello");   // STR: hello
print(42);        // INT: 42
print(3.14);      // DBL: 3.14
```

> Компилятор смотрит на типы аргументов и выбирает подходящий вариант.

### Правила overloading

- Имя одинаковое
- **Сигнатура** разная (типы и/или количество аргументов)
- Возвращаемый тип **НЕ** участвует в выборе (это не overloading)

```cpp
int  foo();
void foo();   // ERROR: ambiguous, разные return types недостаточно
```

## Overloading методов класса

```cpp
class Wrapper {
public:
    void print(const std::string& s) { /* ... */ }
    void print(int i)                { /* ... */ }
};

Wrapper w;
w.print("hello");
w.print(42);
```

## Overloading конструкторов

Самое практическое применение — **множественные способы создания объекта**:

```cpp
class Dog {
    std::string name;
    int age;
public:
    Dog(const std::string& _name, int _age)   // (1) полная инфо
        : name(_name)
    {
        if (_age >= 0 && _age <= 30) age = _age;
        else age = 0;
    }
};

Dog d1("Pushok", 10);   // OK
```

## Цепочка конструкторов (delegating ctors)

Несколько конструкторов с переадресацией к «полному»:

```cpp
class Dog {
    std::string name;
    int age;
public:
    Dog(const std::string& _name, int _age) {            // (1) full
        name = _name;
        if (_age >= 0 && _age <= 30) age = _age;
        else age = 0;
    }

    Dog() : Dog("Snezhok", 0) {}                         // (2) default → (1)
    Dog(const std::string& _name) : Dog(_name, 0) {}     // (3) name only → (1)
    Dog(int _age) : Dog("Snezhok", _age) {}              // (4) age only → (1)
};
```

### Использование

```cpp
Dog d1("Pushok", 10);   // (1)
Dog d2("Druzhok");      // (3) → (1)
Dog d3(5);              // (4) → (1)
Dog d4;                 // (2) → (1)
```

> **Преимущество:** валидация в **одной точке** (полный конструктор).
> Остальные просто переадресуют.

## Member initializer list (повтор из M27)

Сокращает простые присваивания:

```cpp
Dog(const std::string& _name, int _age)
    : name(_name)        // ← инициализация в init-list
{
    if (_age >= 0 && _age <= 30) age = _age;
    else age = 0;
}
```

Можно **скомбинировать** init-list + delegating:

```cpp
Dog() : Dog("Snezhok", 0) {}               // delegate
Dog(const std::string& n) : name(n), age(0) {}   // init-list, без проверок
```

## Когда применять overloading

- **Универсальные API:** `print(int)`, `print(string)`, `print(double)`
- **Конструкторы:** разные источники данных
- **Operator overloading:** `+`, `-`, `==`, `<<` для своих типов
- **Generic containers:** `at(int index)` vs `at(const Key& k)`

## Ограничения и подводные камни

### Ambiguity при неявных конверсиях

```cpp
void f(int);
void f(double);

f(3.14);      // OK → f(double)
f(42);        // OK → f(int)
f('a');       // ambiguous? → f(int) (char promotes to int)
f(3.14f);     // ambiguous между f(double) и f(int)?
```

### Default arguments + overloading

```cpp
void f(int x);
void f(int x, int y = 0);   // ERROR: ambiguous для f(42)
```

## Сравнение: overloading vs templates

| Подход        | Когда                             |
|---------------|-----------------------------------|
| Overloading   | Известно несколько типов заранее  |
| Templates     | Один алгоритм для **любого** типа |

Templates — следующий шаг (модули M32+).

## Practical relevance для DevOps

- **Logging:** `log(int code)`, `log(string msg)`, `log(exception& e)`
- **Builder pattern:** `Config()` / `Config(path)` / `Config(path, defaults)`
- **Operator overloading:** `Duration + Duration`, `BigInt * int`
- **API design:** одно имя — много способов вызова
- **Refactoring:** разделить «один большой ctor с default'ами» на несколько

## Связь с другими модулями

- **M27.1 конструкторы:** теперь умеем делегировать между ними
- **M29.3 polymorphism:** ↔ статический vs runtime
- **M31.2+ (next):** наверняка operator overloading или templates
- **C++ best practices:** delegating ctors >>> копирование валидации
