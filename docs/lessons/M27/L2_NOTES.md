# M27.2 — Указатель this

**Длительность:** ~15 минут
**Тема:** что такое `this`, неявная передача в методы, явное использование, forward declaration

## Главная идея

> `this` — **скрытый указатель** на текущий объект, доступен в каждом нестатическом методе.
> Через него можно явно обращаться к полям, передавать «себя» в другие методы.

## Что такое this

Каждый нестатический метод **неявно** получает указатель на объект, в контексте
которого он вызван:

```cpp
class Train {
    int count;
public:
    int getCount() { return count; }   // на самом деле: return this->count;
};

Train* t = new Train(...);
t->getCount();
// эквивалент:
// Train::getCount(t);   ← t передаётся как this
```

> Метод = функция с **неявным первым аргументом** `ClassName* this`.

## Явное использование this

Можно везде писать `this->field` вместо просто `field`:

```cpp
TrainCar* getCar(int index) {
    if (index < 0 || index >= this->count) return nullptr;
    return this->cars[index];
}
```

Эквивалентно (компилятор сам подставляет `this->`):

```cpp
TrainCar* getCar(int index) {
    if (index < 0 || index >= count) return nullptr;
    return cars[index];
}
```

## Защита от nullptr

Если объект «плохой» (`nullptr`) — вызов метода → краш.
Можно проверить **сам this**:

```cpp
TrainCar* getCar(int index) {
    if (this == nullptr) return nullptr;   // безопасный фоллбэк
    if (index < 0 || index >= count) return nullptr;
    return cars[index];
}
```

```cpp
Train* t = nullptr;
t->getCar(0);   // не упадёт — выход через nullptr
```

> **На практике** это редкость. Метод обычно должен быть вызван на валидном объекте.
> UB-формально: `this == nullptr` уже UB. Современные компиляторы могут оптимизировать
> такую проверку. Но в простых сборках работает.

## Передача «себя» в другие методы

Если нужен указатель на текущий объект — передаём `this`:

```cpp
class Train {
    TrainCar** cars;
public:
    void createCars() {
        for (int i = 0; i < count; ++i)
            cars[i] = new TrainCar(this, passengersMax);   // ← this
    }
};

class TrainCar {
    Train* myTrain;
public:
    TrainCar(Train* inTrain, int inMax)
        : myTrain(inTrain), passengersMax(inMax) {}
};
```

## Решение коллизии имён через this

```cpp
class Foo {
    int passengers;
public:
    Foo(int passengers) {
        this->passengers = passengers;   // ← однозначно
    }
};
```

> **Учитель:** не его любимый способ — потому что:
> - Не работает в **member initializer list** (там `passengers(passengers)` UB)
> - Использует префикс `in` для аргументов вместо

## Forward declaration (предварительное объявление)

Циклическая зависимость: `TrainCar` ссылается на `Train`, `Train` создаёт `TrainCar`.

### Проблема

```cpp
class TrainCar {
    Train* myTrain;   // ERROR: Train ещё не объявлен!
};

class Train {
    TrainCar** cars;
};
```

### Решение 1: явное `class Foo*`

```cpp
class TrainCar {
    class Train* myTrain;   // ← говорим компилятору: "Train — это class"
};

class Train {
    TrainCar** cars;
};
```

`class Train*` = forward declaration внутри объявления.

### Решение 2: forward declaration отдельно

```cpp
class Train;   // ← forward declaration

class TrainCar {
    Train* myTrain;
};

class Train {
    TrainCar** cars;
};
```

> **Лучший pattern.** Указатели на forward-declared тип — OK.
> Полный объект (Train, не Train*) — нельзя, нужно полное определение.

## Out-of-class definition методов

Если метод TrainCar нуждается в методах Train — определение метода нужно
перенести **после** определения Train:

```cpp
class TrainCar {
    Train* myTrain;
public:
    int myIndex();   // ← только объявление
};

class Train {
    TrainCar** cars;
public:
    int getCount() const { return count; }
    TrainCar* getCar(int i) const { return cars[i]; }
};

// Определение метода вне класса:
int TrainCar::myIndex() {
    for (int i = 0; i < myTrain->getCount(); ++i) {
        if (myTrain->getCar(i) == this) return i;   // ← сравнение указателей
    }
    return -1;
}
```

### Синтаксис

```cpp
ReturnType ClassName::methodName(args) { ... }
//          ^^^^^^^^^^^
//          scope-resolution: куда метод принадлежит
```

## Сравнение указателей = идентичность объектов

```cpp
if (myTrain->getCar(i) == this) {
    // нашли «себя» в массиве — значит мой индекс = i
}
```

Если адреса в памяти равны — это **тот же самый объект**.

## Использование this — резюме

| Сценарий                          | Зачем                                                          |
|-----------------------------------|----------------------------------------------------------------|
| `this->field` явно                | Снять коллизию имён                                            |
| `if (this == nullptr)`            | Защитить метод от nullptr-объекта                              |
| `f(this)` — передать себя         | Зарегистрировать в другом объекте                              |
| `if (other == this)`              | Сравнить идентичность                                          |
| `return *this`                    | Вернуть себя по ссылке (chaining)                              |
| `Class& operator=(const Class&)`  | Защита от self-assignment: `if (&other == this) return *this;` |

## Полный пример: вагон знает свой номер

```cpp
#include <cassert>
#include <iostream>

class Train;

class TrainCar {
    Train* myTrain;
    int    passengersMax;
    int    passengers = 0;
public:
    TrainCar(Train* inTrain, int inMax)
        : myTrain(inTrain), passengersMax(inMax) {}

    int myIndex();      // out-of-class

    void load(int n) {
        if (passengers + n > passengersMax) n = passengersMax - passengers;
        passengers += n;
    }
    int getPassengers() const { return passengers; }
};

class Train {
    int        count;
    TrainCar** cars;
public:
    Train(int inCount, int inMax) : count(inCount) {
        cars = new TrainCar*[inCount];
        for (int i = 0; i < inCount; ++i)
            cars[i] = new TrainCar(this, inMax);    // ← this!
    }
    int       getCount() const { return count; }
    TrainCar* getCar(int i) const {
        if (i < 0 || i >= count) return nullptr;
        return cars[i];
    }
};

int TrainCar::myIndex() {
    for (int i = 0; i < myTrain->getCount(); ++i) {
        if (myTrain->getCar(i) == this) return i;
    }
    assert(false);
    return -1;
}

int main() {
    Train* t = new Train(5, 30);
    std::cout << "Car #2 index = " << t->getCar(2)->myIndex() << "\n";  // 2
}
```

## Practical relevance для DevOps

- **Self-registration:** объект регистрирует себя в манагере (`registry.add(this)`)
- **Builder pattern:** `obj.method1().method2()` — каждый метод возвращает `*this`
- **Self-assignment guard:** `operator=` всегда начинается с `if (&other == this) return *this;`
- **Observer pattern:** subject хранит указатели на observers — используется this при subscribe

## Связь с другими модулями

- **M17 указатели:** this = указатель, синтаксис `->` тот же
- **M27.1:** конструктор может использовать this для self-reference
- **M27.3 (next):** возможно деструктор + наследование
- **C++ patterns:** RAII, builder, observer — все используют this
