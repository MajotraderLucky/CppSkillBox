# M27.1 — Конструктор класса

**Длительность:** ~20 минут
**Тема:** конструкторы, default ctor, member initializer list, naming conventions

## Главная идея

> **Конструктор** = специальный метод инициализации.
> Имя совпадает с именем класса, не возвращает ничего.
> Member initializer list `: field(value)` — предпочтительный способ инициализации.

## Задача (контекст)

Класс `Train` содержит N вагонов. Хотим:
- Задать N при создании поезда
- У каждого вагона задать максимум пассажиров
- Загружать вагоны через метод

```cpp
class TrainCar {
    int passengersMax = 0;
    int passengers    = 0;
public:
    void load(int count) {
        if (passengers + count > passengersMax) count = passengersMax - passengers;
        passengers += count;
    }
    int getPassengers() const { return passengers; }
};

class Train {
    int        count = 0;
    TrainCar** cars  = nullptr;     // указатель на массив указателей
public:
    int getCount() const { return count; }
    TrainCar* getCar(int idx) {
        if (idx < 0 || idx >= count) return nullptr;
        return cars[idx];
    }
};
```

## Проблема: как инициализировать?

Нельзя напрямую снаружи (private поля):

```cpp
Train* t = new Train();
t->count = 10;     // ERROR — private
```

### Решение 1: статический factory method

```cpp
class Train {
public:
    static Train* create(int n, int passengersMax) {
        Train* t = new Train();
        t->count = n;
        t->cars  = new TrainCar*[n];
        for (int i = 0; i < n; ++i) {
            t->cars[i] = new TrainCar();
            t->cars[i]->passengersMax = passengersMax;   // ← снова надо обходить private
        }
        return t;
    }
};
```

Громоздко и не идиоматично. Решение лучше — **конструктор**.

## Default constructor

C++ генерирует **конструктор по умолчанию** автоматически:

```cpp
Train* t = new Train();   // вызовется default ctor
```

Default ctor:
- Без аргументов
- Инициализирует поля их default значениями
- Появляется автоматически если не объявлены другие конструкторы

## Свой конструктор

Свойства:
- **Имя = имя класса** (без `void`, без return type)
- Может иметь аргументы
- Вызывается через `new ClassName(args)` или `ClassName obj(args)`

```cpp
class TrainCar {
    int passengersMax = 0;
    int passengers    = 0;
public:
    TrainCar(int inPassengersMax) {        // ← конструктор
        passengersMax = inPassengersMax;
    }
    // ...
};

TrainCar* car = new TrainCar(30);   // вагон с 30 местами
```

## Naming conventions для аргументов

Проблема: **collision** имени аргумента с полем класса:

```cpp
TrainCar(int passengersMax) {
    passengersMax = passengersMax;   // BUG: что присваивается чему?
}
```

### Решения

| Стиль                       | Пример                                                                |
|-----------------------------|-----------------------------------------------------------------------|
| Префикс `_` для полей       | `int _passengers; ctor(int passengers) { _passengers = passengers; }` |
| Префикс `m_` (Hungarian)    | `int m_passengers; ctor(int passengers) {...}`                        |
| Префикс `in` для аргументов | `int passengers; ctor(int inPassengers) {...}` ← учитель              |
| Suffix `_` для полей        | `int passengers_; ctor(int passengers) {...}`                         |
| `this->` (см. M27.2)        | `ctor(int passengers) { this->passengers = passengers; }`             |

> **Учитель:** избегает `_field` / `m_field` (некрасиво).
> Использует `in` префикс для аргументов конструктора.

## Member initializer list (init list)

Альтернативный синтаксис инициализации полей **до** тела конструктора:

```cpp
class TrainCar {
    int passengersMax;
    int passengers;
public:
    TrainCar(int inPassengersMax)
        : passengersMax(inPassengersMax),     // ← init list
          passengers(0)
    {
        // тело конструктора (можно пустое)
    }
};
```

### Синтаксис

```cpp
ClassName(args) : field1(value1), field2(value2), ... {
    // тело
}
```

- После `)` конструктора — **двоеточие**
- Список полей через **запятую**
- Каждое поле: `name(initial_value)`
- **Порядок** инициализации = порядок объявления полей в классе (НЕ порядок в списке!)
- После `{}` — обычное тело

### Зачем init list

| Аспект                  | Init list             | Присваивание в теле       |
|-------------------------|-----------------------|---------------------------|
| Время                   | до тела конструктора  | в теле                    |
| `const` поля            | работает              | НЕ работает               |
| Reference поля          | работает              | НЕ работает               |
| Поля без default ctor   | работает              | НЕ работает               |
| Производительность      | optimal               | строится → перезатирается |

> **Современный C++:** **всегда** предпочитать init list.

## assert для безопасности

```cpp
#include <cassert>

TrainCar(int inPassengersMax)
    : passengersMax(inPassengersMax)
{
    assert(inPassengersMax > 0);
}
```

`assert` остановит программу в debug-сборке если условие false.

## Конструктор поезда

```cpp
class Train {
    int        count;
    TrainCar** cars;
public:
    Train(int inCount, int inPassengersMax)
        : count(inCount)
    {
        assert(inCount > 0);
        cars = new TrainCar*[inCount];
        for (int i = 0; i < inCount; ++i) {
            cars[i] = new TrainCar(inPassengersMax);
        }
    }
};

int main() {
    Train* t = new Train(10, 30);   // 10 вагонов по 30 мест
    t->getCar(0)->load(15);
}
```

> Массив инициализировать через init list нельзя (приходится в теле).
> Сами объекты вагонов создаются через `new TrainCar(...)`.

## Важно: `new` с аргументами

```cpp
Train* t = new Train(10, 30);
//          ^^^^^^^^^^^^^^^^^^
//          выделяет память + вызывает конструктор с аргументами
```

`new ClassName(arg1, arg2)` — выделение + конструктор за один шаг.

## Полный пример

```cpp
#include <cassert>
#include <iostream>

class TrainCar {
    int passengersMax;
    int passengers;
public:
    TrainCar(int inPassengersMax)
        : passengersMax(inPassengersMax),
          passengers(0)
    {
        assert(inPassengersMax > 0);
    }

    void load(int count) {
        if (passengers + count > passengersMax)
            count = passengersMax - passengers;
        passengers += count;
    }

    int getPassengers() const { return passengers; }
    int getMax()        const { return passengersMax; }
};

class Train {
    int        count;
    TrainCar** cars;
public:
    Train(int inCount, int inPassengersMax)
        : count(inCount)
    {
        assert(inCount > 0);
        cars = new TrainCar*[inCount];
        for (int i = 0; i < inCount; ++i)
            cars[i] = new TrainCar(inPassengersMax);
    }

    int       getCount()      const { return count; }
    TrainCar* getCar(int idx) const {
        if (idx < 0 || idx >= count) return nullptr;
        return cars[idx];
    }
};

int main() {
    Train* t = new Train(3, 30);
    t->getCar(0)->load(15);
    t->getCar(1)->load(50);
    std::cout << "Car0: " << t->getCar(0)->getPassengers() << "\n";  // 15
    std::cout << "Car1: " << t->getCar(1)->getPassengers() << "\n";  // 30 (clipped)
}
```

## Practical relevance для DevOps

- **RAII pattern:** конструктор открывает ресурс (файл, mutex), деструктор закрывает
- **Validation на входе:** все инварианты проверены в конструкторе → объект всегда валиден
- **Зависимости через ctor:** `Logger(const std::string& path)` — DI в C++
- **Factory functions:** `make_unique<Foo>(args)` — обёртка над `new` + ctor
- **Init list для конст-полей:** `const std::string serverName_;` нельзя присвоить в теле

## Связь с другими модулями

- **M21 struct:** теперь видим зачем были default values полей — для default ctor
- **M26 классы:** конструктор — следующий шаг инкапсуляции
- **M27.2 (next):** `this`, и наверняка деструктор
- **C++ best practices:** init list — must-have для production кода
