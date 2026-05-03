# M29.3 — Полиморфизм (3-й принцип ООП)

**Длительность:** ~14 минут
**Тема:** virtual функции, vtable, абстрактные классы, единообразное обращение через base*

## Главная идея

> **Полиморфизм** = разные классы обрабатывают **одинаковый вызов** по-своему.
> Реализуется через **virtual функции** + указатели на базовый класс.

## Задача: единообразное обращение

```cpp
class Animal { public: void voice() { /* ??? */ } };
class Cat : public Animal { public: void voice() { std::cout << "meow"; } };
class Dog : public Animal { public: void voice() { std::cout << "bark"; } };

Animal* arr[3] = { new Cat(), new Dog(), new Cat() };
for (int i = 0; i < 3; ++i) arr[i]->voice();   // хочется: meow, bark, meow
```

**Без virtual** — будет вызван `Animal::voice()` для **всех** элементов
(статическая привязка по типу указателя).

## Решение: `virtual` функции

```cpp
class Animal {
public:
    virtual void voice() { std::cout << "?\n"; }   // ← virtual
};

class Cat : public Animal {
public:
    void voice() override { std::cout << "meow\n"; }   // переопределение
};

class Dog : public Animal {
public:
    void voice() override { std::cout << "bark\n"; }
};
```

| Без virtual                                             | С virtual                          |
|---------------------------------------------------------|------------------------------------|
| Привязка по типу указателя                              | Привязка по реальному типу объекта |
| `Animal* p = new Cat(); p->voice()` → `Animal::voice()` | → `Cat::voice()`                   |

## override (рекомендуется)

```cpp
void voice() override { ... }   // явно говорим: это переопределение
```

**Зачем:**
- Компилятор проверит что родитель имеет такой virtual
- Опечатка в имени → ошибка компиляции, не молчаливое создание новой функции
- Документирует намерение

## vtable (virtual function table)

Под капотом:
- Каждый объект класса с virtual функцией хранит **указатель на vtable**
- vtable — таблица функций для конкретного класса
- При вызове `p->voice()` — лукап в vtable → конкретная реализация

```text
Cat object:
+---------+-------+
| vptr | data |
+----+----+-------+
     ↓
   vtable[Cat]:
   +-------------+
   | Cat::voice  |   ← здесь vptr указывает
   +-------------+
```

## Полный пример с CatDog

```cpp
class Animal {
public:
    virtual void voice() = 0;        // pure virtual (абстрактный)
};

class Cat : public virtual Animal {
public:
    void voice() override { std::cout << "meow\n"; }
};

class Dog : public virtual Animal {
public:
    void voice() override { std::cout << "bark\n"; }
};

class CatDog : public Cat, public Dog {
public:
    void voice() override { std::cout << "bark-meow\n"; }
};

int main() {
    Animal* arr[4] = {
        new Cat(),
        new Dog(),
        new CatDog(),
        new Dog()
    };
    for (int i = 0; i < 4; ++i) arr[i]->voice();
    // meow / bark / bark-meow / bark
    for (int i = 0; i < 4; ++i) delete arr[i];
}
```

## Абстрактный класс

Класс с **хотя бы одной pure virtual функцией** (`= 0`) — **абстрактный**:

```cpp
class Animal {
public:
    virtual void voice() = 0;   // ← pure virtual, нет тела
};

Animal a;     // ERROR: нельзя создать объект абстрактного класса
Animal* p;    // OK — указатель/ссылка можно
```

### Зачем абстрактные классы

- **Интерфейс** — контракт «вы должны реализовать voice()»
- **Защита от ошибок** — нельзя создать «пустое» Animal
- **Forced implementation** — наследник обязан переопределить pure virtual

> **Abstract class в C++ ≈ interface в Java/C#**
> (но C++ позволяет иметь и поля, и реализованные методы в abstract class).

## ВАЖНО: virtual destructor

```cpp
class Animal {
public:
    virtual ~Animal() = default;   // ← обязательно для базовых классов!
    virtual void voice() = 0;
};
```

**Почему:** при `delete p` где `p` — это `Animal*`, но реальный тип `Cat`:
- Без `virtual ~Animal()` — вызовется только `~Animal()`, **утечка** Cat-частей
- С `virtual ~Animal()` — корректно вызовется `~Cat()`, потом `~Animal()`

> **Правило:** базовый класс **должен** иметь `virtual` деструктор.

## 3 основных принципа ООП (повторение)

1. **Инкапсуляция** (M29.1) — скрыть состояние, контролировать изменения
2. **Наследование** (M29.2) — переиспользование через is-a отношения
3. **Полиморфизм** (M29.3) — единообразное обращение к разным реализациям

(4-й иногда — **Абстракция**: моделирование через классы.)

## Виды полиморфизма в C++

| Вид                   | Механизм                           | Когда             |
|-----------------------|------------------------------------|-------------------|
| Runtime polymorphism  | virtual functions + vtable         | base* / base&     |
| Static polymorphism   | templates (CRTP, traits)           | compile-time      |
| Function overloading  | разные сигнатуры одного имени      | compile-time      |
| Operator overloading  | `operator+`, `operator==`, ...     | compile-time      |

В этом модуле — **runtime polymorphism**.

## Practical relevance для DevOps

- **Plugin systems:** `IPlugin* p = factory.create(...)` → загрузка `.so`
- **GUI frameworks:** Qt / GTK — все виджеты от Widget с virtual paint()
- **Database drivers:** `IDbDriver*` — Postgres/MySQL/SQLite реализации
- **Strategy pattern:** разные алгоритмы за общим интерфейсом
- **Tools/games:** entity component system, behavior trees

## Связь с другими модулями

- **M27.3 / M29.2:** наследование — необходимая база для полиморфизма
- **M29.1:** инкапсуляция — каждый дочерний класс защищён своими полями
- **C++ best practices:** abstract base + virtual destructor — must-have паттерн
- **C++ STL:** `std::function`, `std::unique_ptr<Base>` — современные обёртки
