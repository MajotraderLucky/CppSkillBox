# M26.2 — Публичные и приватные члены класса

**Длительность:** ~10 минут
**Тема:** `class` vs `struct`, `public:`/`private:`, инкапсуляция, naming convention

## Главная идея

> `class` — это `struct` где **по умолчанию `private`**.
> Инкапсуляция: данные скрыты, доступ — через **методы-интерфейс**.

## class vs struct

```cpp
struct Foo { int x; };   // x по умолчанию public
class  Bar { int x; };   // x по умолчанию private
```

**Это единственное** различие в C++. Обе сущности поддерживают:
- Поля
- Методы
- Конструкторы / деструкторы
- Наследование, virtual, ...

> **Конвенция:** `struct` для POD/data-bag, `class` для инкапсуляции.

## Naming convention в C++ ООП

```cpp
class PlayingControl {       // PascalCase для типов
    double elevator = 0.0;   // camelCase для членов
    double aileronLeft = 0.0;
};

PlayingControl playingControl;   // объект (instance) — camelCase
```

| Стиль        | Применение                     |
|--------------|--------------------------------|
| `PascalCase` | имена классов, типов           |
| `camelCase`  | члены, переменные, методы      |
| `snake_case` | C-стиль, namespace, file names |
| `UPPER_CASE` | макросы, константы #define     |

## Терминология

| Термин                           | Значение                           |
|----------------------------------|------------------------------------|
| **Class**                        | определение типа                   |
| **Object** / **Instance**        | экземпляр класса                   |
| **Instantiation**                | процесс создания экземпляра        |
| **Member**                       | поле или метод класса              |
| **Field** / **Data member**      | поле (данные)                      |
| **Method** / **Member function** | метод (функция-член)               |

## Доступ private/public

```cpp
class PlayingControl {
    double elevator = 0.0;     // private (default)

public:
    void turnLeft();           // public — доступно извне
    void turnRight();          // public

private:                       // обратно в private
    double aileronLeft = 0.0;
};
```

### Правило

```text
class FooName {
    [private по умолчанию]   ← всё до первого спецификатора

public:
    [всё public]            ← до следующего спецификатора

private:
    [снова private]
};
```

Спецификатор **«окрашивает»** всё что идёт после, до следующего спецификатора.

## Зачем разделение доступа

### Без private — опасно

```cpp
class PlayingControl {
public:
    double elevator = 0.0;
};

PlayingControl* p = new PlayingControl();
p->elevator = 90;   // никаких проверок — самолёт «свечкой» вверх
```

Пользователь может задать любое **дикое значение**. Класс не контролирует
свои инварианты.

### С private + setter — безопасно

```cpp
class PlayingControl {
    double elevator = 0.0;

public:
    void setElevator(double newValue) {
        if (newValue < -30) newValue = -30;
        if (newValue >  30) newValue =  30;
        elevator = newValue;
    }
};

p->setElevator(90);   // → внутри будет 30, всё ок
```

> Это и есть **инкапсуляция**: класс контролирует свои данные.

## Pattern: согласованное изменение нескольких полей

Если для «поворота налево» нужно изменить **2 поля** (левый и правый элерон),
прямой доступ опасен — пользователь может забыть одно. Метод инкапсулирует
всю логику:

```cpp
class PlayingControl {
    double aileronLeft  = 0.0;
    double aileronRight = 0.0;

public:
    void turnLeft() {
        aileronLeft  = -15;
        aileronRight =  15;
    }
    void turnRight() {
        aileronLeft  =  15;
        aileronRight = -15;
    }
};
```

## delete над nullptr — безопасно

```cpp
PlayingControl* p = new PlayingControl();
delete p;
p = nullptr;     // good practice — обнулить после delete

// Можно делать так несколько раз:
delete p;        // OK — delete над nullptr ничего не делает
delete p;        // OK
```

> Привычка: **`delete p; p = nullptr;`** — защита от двойного удаления.

## Полный пример: airplane control

```cpp
#include <iostream>

class PlayingControl {
    double elevator     = 0.0;
    double aileronLeft  = 0.0;
    double aileronRight = 0.0;

public:
    void setElevator(double v) {
        if (v < -30) v = -30;
        if (v >  30) v =  30;
        elevator = v;
    }

    void turnLeft() {
        aileronLeft  = -15;
        aileronRight =  15;
    }

    void turnRight() {
        aileronLeft  =  15;
        aileronRight = -15;
    }

    void status() {
        std::cout << "elevator=" << elevator
                  << " aileronL=" << aileronLeft
                  << " aileronR=" << aileronRight << "\n";
    }
};

int main() {
    PlayingControl* p = new PlayingControl();
    p->setElevator(90);   // зажмётся в 30
    p->turnLeft();
    p->status();          // elevator=30 aileronL=-15 aileronR=15

    delete p;
    p = nullptr;
}
```

## Конвенция для setter/getter

```cpp
class Foo {
    int value;

public:
    int  getValue() const   { return value; }
    void setValue(int v)    { value = v; }
};
```

Не Java, но C++ часто делает то же самое.

## Practical relevance для DevOps

- **API design:** только public — это контракт; private — реализация
- **Refactoring safety:** меняешь private — снаружи никто не сломается
- **Validation:** все входы через setters → центральная точка проверок
- **Thread-safety:** mutex inside class, не expose raw data
- **Audit:** хочешь логировать изменения? — добавь в setter

## Связь с другими модулями

- **M21 struct:** теперь видим что class = struct + private-default
- **M26.1:** методы внутри класса — теперь добавляем доступ
- **M26.3 (next):** скорее всего конструкторы и инициализация
- **OOP:** инкапсуляция = первый из 3 принципов (далее — наследование, полиморфизм)
