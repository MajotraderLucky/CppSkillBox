# M29.2 — Наследование (2-й принцип ООП)

**Длительность:** ~14 минут
**Тема:** наследование как принцип ООП, **множественное наследование**, ромбовидная проблема, virtual inheritance

## Главная идея

> **Наследование** = переиспользование общего кода + расширение поведения.
> **Множественное наследование** в C++ возможно — но создаёт **diamond problem**.
> Решение: **virtual inheritance**.

## Базовая идея

Несколько похожих классов:

```cpp
class Dog { int age; std::string name; void bark(); };
class Cat { int age; std::string name; void meow(); };
```

Дублирование. Выделяем общее в базовый класс:

```cpp
class Animal {
protected:
    int         age;
    std::string name;
public:
    Animal(int age, std::string name) : age(age), name(name) {
        if (age < 0 || age > 30) std::cout << "Incorrect age\n";
    }
    void setAge(int a) { /* validate */ age = a; }
    int  getAge() const { return age; }
    const std::string& getName() const { return name; }
};

class Dog : public Animal {
public:
    Dog(int age, std::string name) : Animal(age, name) {}
    void bark() { /* лает getAge() раз */ }
};

class Cat : public Animal {
public:
    Cat(int age, std::string name) : Animal(age, name) {}
    void meow() { /* мяукает */ }
};
```

## Множественное наследование

```cpp
class CatDog : public Cat, public Dog {
public:
    CatDog(int age, std::string name)
        : Cat(age, name), Dog(age, name) { /* ... */ }
};
```

Котопёс наследует от **двух** классов. Может и лаять, и мяукать.

## Diamond Problem (ромбовидное наследование)

```text
        Animal
        /    \
      Cat    Dog
        \    /
        CatDog
```

`CatDog` наследует от `Cat` и `Dog`, но оба содержат `Animal`. Получается **2 копии** полей `Animal` (age, name).

```cpp
CatDog cd(10, "Шарик");
cd.age;     // ERROR: ambiguous — Cat::Animal::age или Dog::Animal::age?
cd.name;    // ERROR: тоже неоднозначно
```

Конструктор тоже не компилируется — какому из двух Animal присваивать?

## Решение: `virtual` inheritance

`virtual` базовый класс **существует в одном экземпляре**:

```cpp
class Animal { ... };

class Cat : public virtual Animal { ... };   // ← virtual
class Dog : public virtual Animal { ... };   // ← virtual

class CatDog : public Cat, public Dog {
public:
    CatDog(int age, std::string name)
        : Animal(age, name),    // ← конструктор виртуального базового
          Cat(),
          Dog() { ... }
};
```

### Что происходит

- Только **один** Animal внутри CatDog (а не два)
- Animal **не** наследуется напрямую через Cat и Dog (через указатели)
- CatDog **сам** должен вызвать конструктор Animal в init list
- `Cat()` и `Dog()` нужны **default ctor** — компилятор не знает, какие аргументы передать

### Требование: default ctor у промежуточных классов

```cpp
class Cat : public virtual Animal {
public:
    Cat() {}                                  // ← default ctor (для virtual inheritance)
    Cat(int age, std::string name) : Animal(age, name) {}
};
```

## Полный пример

```cpp
#include <iostream>
#include <string>

class Animal {
protected:
    int         age = 0;
    std::string name;
public:
    Animal() = default;
    Animal(int a, std::string n) : age(a), name(std::move(n)) {}
    void setAge(int a) {
        if (a >= 0 && a <= 30) age = a;
    }
    int  getAge()  const { return age; }
    const std::string& getName() const { return name; }
};

class Cat : public virtual Animal {
public:
    Cat() = default;
    Cat(int a, std::string n) : Animal(a, n) {}
    void meow() {
        for (int i = 0; i < age; ++i) std::cout << "MEOW! ";
        std::cout << "\n";
    }
};

class Dog : public virtual Animal {
public:
    Dog() = default;
    Dog(int a, std::string n) : Animal(a, n) {}
    void bark() {
        for (int i = 0; i < age; ++i) std::cout << "WOOF! ";
        std::cout << "\n";
    }
};

class CatDog : public Cat, public Dog {
public:
    CatDog(int a, std::string n) : Animal(a, n), Cat(), Dog() {}
};

int main() {
    CatDog cd(3, "Шарик");
    cd.bark();        // WOOF! WOOF! WOOF!
    cd.setAge(2);
    cd.meow();        // MEOW! MEOW!
    std::cout << cd.getName() << "\n";   // Шарик
}
```

## Когда использовать множественное наследование

> **Учитель:** в реальном коде — **редко**. C++ позволяет, но:
> - Усложняет понимание
> - Может привести к diamond problem
> - Требует virtual inheritance + default ctors

**Альтернативы:**
- **Composition** — Container содержит Cat + Dog как поля
- **Mixins** — наследование от классов с одной функцией
- **Interface segregation** — наследование от интерфейсов

В Java/C# вообще нет multiple inheritance (только interfaces).

## Иерархия наследования

```text
Базовый (Base) class — общие поля и методы
   ↓
Производный (Derived) class — добавляет специфичное
   ↓
Может наследоваться дальше (grand-derived)
```

> Каждый уровень дочерних классов **расширяет**, **переопределяет**
> или **дополняет** родителя.

## Practical relevance для DevOps

- **Exception иерархии:** `class NetworkError : public std::runtime_error`
- **GUI widgets:** Button, Label наследуются от Widget
- **Plugin systems:** `class MyPlugin : public PluginBase`
- **Database drivers:** разные backend'ы наследуются от общего DbDriver
- **Multiple inheritance:** редко в production C++; больше в legacy code (MFC, Qt)

## Связь с другими модулями

- **M27.3 наследование (intro):** базовые public/protected/private inheritance
- **M29.1:** инкапсуляция → теперь добавляем reuse через наследование
- **M29.3+ (next):** наверняка полиморфизм (virtual functions)
- **C++ best practices:** prefer composition over inheritance
