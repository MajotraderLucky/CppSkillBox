# M31.2 — Деструкторы класса (+ virtual, override, final, copy ctor, Rule of Three)

**Длительность:** ~22 минуты
**Тема:** деструкторы, virtual destructor, override/final, copy ctor, copy assignment, Rule of Three

## Главная идея

> **Деструктор** = код, выполняемый при уничтожении объекта.
> Если есть `new` в классе → нужен деструктор, copy ctor, copy assignment (**Rule of Three**).

## Деструктор класса

```cpp
class Toy {
    std::string name;
public:
    Toy(const std::string& n) : name(n) {}
    ~Toy() { std::cout << "Toy " << name << " destroyed\n"; }
};
```

### Свойства

- Имя: **`~ClassName()`**
- Без аргументов, без return type
- Вызывается **автоматически** при уничтожении объекта (выход из scope или `delete`)
- Может быть **только один** на класс (overloading запрещён)

## Зачем деструктор

Освободить ресурсы которыми владеет объект:
- `delete` для динамически выделенной памяти
- `close()` для файла / сокета
- `unlock()` для мьютекса
- Удалить из реестра / очереди

```cpp
class Dog {
    Toy* lovelyToy;
public:
    Dog(const std::string& toyName) {
        lovelyToy = new Toy(toyName);
    }
    ~Dog() {
        delete lovelyToy;        // ← без этого утечка
    }
};
```

## virtual destructor — обязателен для базовых классов

```cpp
class Animal {
public:
    virtual ~Animal() = default;   // ← virtual!
};

class Dog : public Animal {
    Toy* toy;
public:
    ~Dog() override { delete toy; }
};

Animal* a = new Dog();
delete a;        // ← без virtual ~Animal вызовется только ~Animal, утечка Toy
```

> **Правило:** если у класса есть **virtual метод** → `virtual ~Destructor()` обязателен.

## override и final

### override

Явно указывает что метод **переопределяет** виртуальный из базового:

```cpp
class Dog : public Animal {
public:
    void voice() override { std::cout << "bark"; }   // переопределение
};
```

**Польза:**
- Опечатка в имени → compile error (без override создаётся **новый** метод)
- Документирует намерение
- Современный C++ best practice

### final

Запрещает дальнейшее переопределение:

```cpp
class OperaDog : public Dog {
public:
    void voice() override final {       // ← последний override
        std::cout << "BARK!!!\n";
    }
};

class SuperOperaDog : public OperaDog {
public:
    void voice() override { ... }       // COMPILE ERROR — final
};
```

`final` можно применить:
- К **методу** — нельзя переопределить дальше
- К **классу** (`class Foo final {}`) — нельзя наследовать

## Copy constructor (конструктор копирования)

Вызывается при создании объекта **из существующего**:

```cpp
class Dog {
    std::string name;
    int age;
    Toy* lovelyToy;
public:
    // Copy ctor: const reference на объект того же типа
    Dog(const Dog& other)
        : name(other.name), age(other.age),
          lovelyToy(new Toy(*other.lovelyToy))   // ← deep copy!
    {}
};

Dog d1("Druzhok", 3);
Dog d2(d1);    // copy ctor
Dog d3 = d1;   // тоже copy ctor (не assignment!)
```

### Shallow copy vs deep copy

```cpp
// Shallow (плохо для указателей):
Dog(const Dog& other) : lovelyToy(other.lovelyToy) {}
// → две собаки на ОДНУ игрушку → double delete!

// Deep (правильно):
Dog(const Dog& other) : lovelyToy(new Toy(*other.lovelyToy)) {}
// → у каждой своя игрушка
```

## Copy assignment operator (operator=)

Вызывается при присваивании уже существующих объектов:

```cpp
Dog& operator=(const Dog& other) {
    if (this == &other) return *this;     // self-assignment guard

    delete lovelyToy;                     // освободить старое
    name      = other.name;
    age       = other.age;
    lovelyToy = new Toy(*other.lovelyToy);

    return *this;                         // chaining: a = b = c
}

Dog d1, d2;
d1 = d2;    // operator=
d1 = d1;    // защита нужна!
```

### Self-assignment guard

```cpp
if (this == &other) return *this;
```

Защита от случая `a = a`. Без неё — `delete other.toy` через `this == &other` =
**use-after-free** на следующей строчке.

## Rule of Three (правило трёх)

> Если класс реализует **один** из этих трёх методов — он **должен** реализовать **все три**:
>
> 1. **Деструктор** (`~Class`)
> 2. **Copy constructor** (`Class(const Class&)`)
> 3. **Copy assignment** (`Class& operator=(const Class&)`)

**Почему:** все три связаны с управлением ресурсами (память, файлы). Игнорирование одного из них → утечки/double-delete/UB.

### По умолчанию C++ генерирует все три (shallow copy)

```cpp
class Simple { int x, y; };   // компилятор сам сгенерирует все три
```

Но если в классе **указатели/ресурсы** → дефолтные **shallow copies** опасны.

## Rule of Five (C++11+)

Дополнительно ещё **move ctor** и **move assignment**:

4. `Class(Class&& other) noexcept`
5. `Class& operator=(Class&& other) noexcept`

(Тема следующих уроков.)

## Пример полностью

```cpp
#include <iostream>
#include <string>

class Toy {
    std::string name;
public:
    Toy(const std::string& n) : name(n) {}
    ~Toy() { std::cout << "Toy " << name << " gone\n"; }
    const std::string& getName() const { return name; }
};

class Dog {
    std::string name;
    int         age;
    Toy*        lovelyToy;

public:
    Dog(const std::string& n, int a, const std::string& toyName)
        : name(n), age(a), lovelyToy(new Toy(toyName)) {}

    ~Dog() {
        delete lovelyToy;
    }

    Dog(const Dog& other)
        : name(other.name), age(other.age),
          lovelyToy(new Toy(other.lovelyToy->getName())) {}

    Dog& operator=(const Dog& other) {
        if (this == &other) return *this;
        delete lovelyToy;
        name      = other.name;
        age       = other.age;
        lovelyToy = new Toy(other.lovelyToy->getName());
        return *this;
    }
};

int main() {
    Dog d1("Druzhok", 3, "Ball");
    Dog d2(d1);             // copy ctor — d2 со своей копией Toy
    Dog d3("Pushok", 5, "Bone");
    d3 = d1;                // operator= — освобождение Bone, копия Ball
}
```

## Practical relevance для DevOps

- **RAII pattern:** конструктор открывает ресурс, деструктор закрывает
- **File handles:** `~File()` вызывает `close()` гарантированно
- **DB connections:** `~Connection()` возвращает в pool
- **Mutex guards:** `std::lock_guard`/`unique_lock` — RAII над mutex
- **Smart pointers:** `unique_ptr`/`shared_ptr` — автоматический Rule of Three

> В современном C++ **`unique_ptr<Toy>`** уберёт нужду в Rule of Three:
> ```cpp
> std::unique_ptr<Toy> lovelyToy;
> ```
> Тогда деструктор / copy / move генерируются автоматически и **корректно**.

## Связь с другими модулями

- **M26.1:** `new`/`delete` без классов — теперь добавляем lifecycle
- **M27.1, M31.1:** конструкторы — теперь add destructor
- **M29.3:** virtual functions — теперь virtual destructor
- **M31.3+ (next):** наверняка smart pointers / move semantics
- **C++ best practices:** Rule of Three / Five / Zero
