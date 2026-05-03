# M27.3 — Наследование (Inheritance)

**Длительность:** ~14 минут
**Тема:** базовый/дочерний класс, public наследование, переиспользование кода

## Главная идея

> **Наследование** — выделить общие поля/методы в **базовый класс**.
> Дочерние классы получают всё «бесплатно» + добавляют своё.

## Проблема: copy-paste классы

Рассмотрим монстров:

```cpp
class WalkingMonster {
    std::string name;
    int health, damage, weight;
public:
    void walk() { /* ... */ }
    void attack() { std::cout << name << " attacks for " << damage; }
};

class FlyingMonster {
    std::string name;
    int health, damage, weight;     // ← дублируется
    int flightSpeed;
public:
    void fly() { /* ... */ }
    void attack() { std::cout << name << " attacks for " << damage; }   // ← дублируется
};

class ShootingMonster {
    std::string name;
    int health, damage, weight;     // ← опять
    int range;
public:
    void shoot() { /* ... */ }
    void attack() { /* ... */ }
};
```

Если 10 монстров — 10x copy-paste общих полей и методов. Ужас.

## Решение: базовый класс

Выделяем общее в **базовый** (он же **родительский**, parent):

```cpp
class Monster {
protected:                       // ← protected: видно дочерним классам
    std::string name;
    int health = 0;
    int damage = 0;
    int weight = 0;
public:
    void attack() {
        std::cout << name << " attacks for " << damage;
    }
};
```

Теперь дочерние классы (children) **наследуют** от него:

```cpp
class FlyingMonster : public Monster {     // ← наследование
    int flightSpeed = 0;
public:
    void fly() {
        std::cout << name << " flies at " << flightSpeed;
        //         ^^^^^^^
        //         доступно из базового класса!
    }
};

class ShootingMonster : public Monster {
    int range = 0;
public:
    void shoot() {
        std::cout << name << " shoots in radius " << range;
        attack();   // ← вызов унаследованного метода
    }
};
```

## Синтаксис

```cpp
class Child : public Parent {
//      ^^^   ^^^^^^^ ^^^^^^
//      имя   тип     базовый класс
//            наследования
};
```

## Терминология

| Английский     | Русский            |
|----------------|--------------------|
| Base class     | Базовый класс      |
| Parent class   | Родительский класс |
| Child class    | Дочерний класс     |
| Derived class  | Производный класс  |
| Inheritance    | Наследование       |

`base`/`parent` — синонимы. `child`/`derived` — синонимы.

## Что наследуется

- **Все поля** базового класса
- **Все методы** базового класса
- **Конструктор** дочернего автоматически вызывает конструктор родительского

## Типы наследования

```cpp
class Child : public    Parent { };   // public — самый частый
class Child : protected Parent { };
class Child : private   Parent { };
```

| Тип         | Доступ к public Parent в Child извне | Семантика                          |
|-------------|--------------------------------------|------------------------------------|
| `public`    | public                               | "Child IS-A Parent"                |
| `protected` | protected                            | редко                              |
| `private`   | private                              | "Child HAS-A Parent" (composition) |

> **На практике 99% случаев — `public`.**

## Уровни доступа в иерархии

```cpp
class Monster {
public:    int x;       // видно всем
protected: int y;       // видно Monster + child + grandchild
private:   int z;       // видно ТОЛЬКО Monster
};

class Flying : public Monster {
public:
    void f() {
        x = 1;          // OK
        y = 1;          // OK (protected)
        z = 1;          // ERROR — private parent'а
    }
};
```

| Спецификатор | Видим в самом классе | В дочерних | Снаружи |
|--------------|----------------------|------------|---------|
| `public`     | да                   | да         | да      |
| `protected`  | да                   | да         | НЕТ     |
| `private`    | да                   | НЕТ        | НЕТ     |

> **Правило:** если поле base нужно использовать в derived — делай `protected`,
> а не `private`. Снаружи всё равно скрыто.

## Использование экземпляров

```cpp
int main() {
    FlyingMonster* m = new FlyingMonster();
    m->fly();        // свой метод
    m->attack();     // унаследованный метод
    delete m;
}
```

С точки зрения пользователя — никакой разницы между «своими» и «унаследованными»
методами. Всё работает через одну точку.

## Полный пример

```cpp
#include <iostream>
#include <string>

class Monster {
protected:
    std::string name = "Monster";
    int health = 100;
    int damage = 10;

public:
    void attack() {
        std::cout << name << " attacks for " << damage << "\n";
    }
};

class FlyingMonster : public Monster {
    int flightSpeed = 50;

public:
    void fly() {
        std::cout << name << " flies at " << flightSpeed << "\n";
    }
};

class ShootingMonster : public Monster {
    int range = 100;

public:
    void shoot() {
        std::cout << name << " shoots in radius " << range << "\n";
        attack();   // ← вызываем унаследованный метод
    }
};

int main() {
    FlyingMonster*   f = new FlyingMonster();
    ShootingMonster* s = new ShootingMonster();

    f->fly();        // Monster flies at 50
    f->attack();     // Monster attacks for 10
    s->shoot();      // Monster shoots in radius 100 + Monster attacks for 10

    delete f;
    delete s;
}
```

## Аналогии из жизни

> Дети наследуют черты от родителей: рост, цвет глаз, привычки.
> Так же и классы: child получает всё от parent + добавляет своё.

## Practical relevance для DevOps

- **Иерархии Exception:** `class NetworkError : public std::runtime_error`
- **UI/widget системы:** `class Button : public Widget`
- **Plugin architectures:** `class MyPlugin : public PluginBase`
- **Logger backends:** `class FileLogger : public Logger`
- **Database connectors:** `class PostgresConn : public DbConnection`

## Подводные камни

- **Diamond problem:** множественное наследование от двух классов с общим predок'ом
- **Slicing:** `Monster m = flyingMonster;` (копия по значению) теряет flying-часть
- **Lifetime:** виртуальные деструкторы нужны для polymorphic delete (тема дальше)
- **Tight coupling:** дети зависят от внутренностей родителя — хрупко при рефакторинге

## Связь с другими модулями

- **M26 классы:** инкапсуляция — теперь добавляем наследование (2-й принцип ООП)
- **M27.1, M27.2:** конструкторы и this — оба важны для дочерних классов
- **M28+ (далее):** virtual functions = полиморфизм (3-й принцип ООП)
- **C++ STL:** `std::exception`, `std::ios_base` — крупные иерархии в стандартной библиотеке
