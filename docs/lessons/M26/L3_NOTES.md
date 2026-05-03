# M26.3 — Методы класса (getters, setters, friend, static)

**Длительность:** ~10 минут
**Тема:** методы vs функции, getter/setter pattern, `friend`, `static` функции

## Главная идея

> Метод vs функция: **метод** имеет доступ к private полям класса.
> Getter/setter — стандартный pattern инкапсуляции.
> `friend` — дать конкретной функции/классу доступ к private.
> `static` — функция «класса», без объекта.

## Метод vs внешняя функция

```cpp
class PlayingControl {
    double elevator = 0.0;     // private
public:
    void method() {
        elevator = 10;          // OK — внутри класса
    }
};

void externalFunc(PlayingControl* p) {
    p->elevator = 10;           // ERROR — private!
}
```

| Доступ к private | Метод    | Внешняя функция         |
|------------------|----------|-------------------------|
| Свободный        | да       | НЕТ                     |
| Передача `this`  | implicit | через аргумент `Class*` |
| Синтаксис полей  | `field`  | `obj->field`            |

## Getter/Setter pattern

Если внешней функции нужны private поля — добавить **методы доступа**:

```cpp
class PlayingControl {
    double elevator = 0.0;
    double aileronLeft = 0.0;
    double aileronRight = 0.0;

public:
    // Getters
    double getElevator()     const { return elevator; }
    double getAileronLeft()  const { return aileronLeft; }
    double getAileronRight() const { return aileronRight; }

    // Setter с валидацией
    void setElevator(double v) {
        if (v < -30) v = -30;
        if (v >  30) v =  30;
        elevator = v;
    }
};

void showInfo(PlayingControl* p) {
    std::cout << "elevator="  << p->getElevator()
              << " aileronL=" << p->getAileronLeft()
              << " aileronR=" << p->getAileronRight() << "\n";
}
```

### Конвенция

- **`getXxx()`** — возвращает значение поля (часто `const`)
- **`setXxx(v)`** — устанавливает поле (часто с валидацией)
- Не для всех полей нужны оба: иногда только getter (read-only),
  иногда только setter (write-only)

## friend — дать доступ исключению

Если функция «свой» (написана нами, доверяем) — можно объявить её **другом**:

```cpp
class PlayingControl {
    double elevator = 0.0;

    friend void showInfo(PlayingControl* p);   // ← объявление дружбы
};

void showInfo(PlayingControl* p) {
    std::cout << "elevator=" << p->elevator;   // OK — мы friend
}
```

### Свойства friend

- Объявление **внутри класса**, в любой секции (public/private не важно)
- Указывает: «эта функция/класс имеет доступ ко всем моим полям»
- Не наследуется, не транзитивна
- Может быть и **friend class**:
  ```cpp
  class Foo {
      friend class Bar;   // Bar имеет доступ к Foo
  };
  ```

### Когда использовать

> **Учитель:** в простых случаях — лучше getter'ы.
>
> friend оправдан когда:
> - Класс A работает с приватными B (тесная связь)
> - Operator overloading (`operator<<` для cout)
> - Тестовый код хочет проверить инварианты

## Производительность getter vs friend

```cpp
double v = p->getElevator();     // вызов функции?
double v = p->elevator;           // прямой доступ?
```

> Современный компилятор **inline'ит** простые getter'ы.
> Производительность одинакова. Безопасность getter'ов выше.

## Статические методы (`static`)

```cpp
class PlayingControl {
    double elevator = 0.0;

public:
    static void showInfo(PlayingControl* p) {   // ← static
        std::cout << "elevator=" << p->elevator;
    }
};

int main() {
    PlayingControl pc;
    PlayingControl::showInfo(&pc);   // вызов через имя класса!
}
```

### Свойства static

- Не привязан к объекту (нет implicit `this`)
- Может работать с любыми объектами через явный аргумент
- Доступен ко всем private полям класса
- Вызывается через `ClassName::method()`, не через `obj.method()`
- Подчиняется правилам доступа (public/private)

### Когда использовать

- Утилитные функции, связанные с классом по смыслу
- Factory methods (`Foo::create(...)`)
- Counters / registries (общие для всех объектов)
- Constants (в комбинации с `static const`)

## Сводка способов доступа

| Способ            | Объект нужен?  | Доступ к private | Контекст              |
|-------------------|----------------|------------------|-----------------------|
| Метод (`obj.m()`) | да             | да               | implicit `this`       |
| Static method     | нет            | да               | `Class::method()`     |
| Friend function   | да (через arg) | да               | глобальная            |
| Friend class      | да             | да               | другой класс          |
| External function | да (через arg) | только public    | глобальная            |
| Getter/Setter     | да             | да (внутри)      | контролируемый доступ |

## Практический пример

```cpp
#include <iostream>

class PlayingControl {
    double elevator = 0.0;
    double aileronLeft = 0.0;
    double aileronRight = 0.0;

public:
    double getElevator()     const { return elevator; }
    double getAileronLeft()  const { return aileronLeft; }
    double getAileronRight() const { return aileronRight; }

    void setElevator(double v) {
        if (v < -30) v = -30;
        if (v >  30) v =  30;
        elevator = v;
    }

    void turnLeft()  { aileronLeft = -15; aileronRight =  15; }
    void turnRight() { aileronLeft =  15; aileronRight = -15; }

    static void showInfo(PlayingControl* p) {
        std::cout << "elevator=" << p->elevator
                  << " aileronL=" << p->aileronLeft
                  << " aileronR=" << p->aileronRight << "\n";
    }
};

int main() {
    PlayingControl pc;
    pc.setElevator(45);
    pc.turnLeft();
    PlayingControl::showInfo(&pc);   // elevator=30 aileronL=-15 aileronR=15
}
```

## Practical relevance для DevOps

- **Getter'ы для metrics:** `class Connection { int getRetries() const; }`
- **Validation в setter'ах:** одна точка проверки, не разбросано
- **friend для serialization:** Boost.Serialization использует friend
- **static factory:** `Logger::create("path")` вместо `new Logger("path")`
- **Modern C++:** `getX() const` помогает компилятору + читателю кода

## Связь с другими модулями

- **M26.1, M26.2:** методы внутри класса, доступ public/private
- **M26.4 hwork:** наверняка задачи на getter/setter + ООП
- **C++ best practices:** «прятать состояние, экспортировать поведение»
- **Конструкторы / деструкторы** (далее в курсе): инициализация при `new`
