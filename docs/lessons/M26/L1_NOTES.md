# M26.1 — Классы (Classes)

**Длительность:** ~13 минут
**Тема:** ООП — методы внутри struct, оператор `new`/`delete`, утечки памяти

## Главная идея

> **Класс** = struct + методы внутри. Это переход от C к C++.
> `new` — выделение в куче (heap). Парный `delete` — обязателен.

## От C-стиля к C++

### C-стиль: struct + free-floating функции

```c
struct Robot {
    int health;
    int damage;
    int speed;
};

void robot_attack(Robot* r) {
    std::cout << "Robot attacks: " << r->damage;
}

void robot_take_damage(Robot* r, int dmg) { /* ... */ }
void robot_move(Robot* r) { /* ... */ }
```

**Префикс `robot_`** нужен чтобы избежать конфликта имён с другими сущностями
(монстры, танки): `monster_attack`, `tank_attack`.

### C++ стиль: методы внутри struct

```cpp
struct Robot {
    int health;
    int damage;
    int speed;

    // методы — функции, привязанные к struct
    void attack() {
        std::cout << "Robot attacks: " << damage;
        //                              ^^^^^^^^^
        // прямой доступ к полям — без указателей и аргументов!
    }

    void takeDamage(int dmg) { /* ... */ }
    void move() { /* ... */ }
};
```

**Что произошло:**
- `attack` — больше не отдельная функция, а **метод** struct
- Префиксы убраны (имя теперь scope'ировано в `Robot::attack`)
- Внутри `attack()` поля доступны **напрямую** (`damage`, не `r->damage`)

## Вызов методов

### Через `.` для значения/ссылки

```cpp
Robot r;
r.attack();
r.takeDamage(50);
```

### Через `->` для указателя

```cpp
Robot* p = &r;
p->attack();
p->takeDamage(50);
```

Тот же `(*p).attack()` = `p->attack()` — синтаксис указателей.

## struct vs class

> **В C++ `struct` == `class`** автоматически становится классом.
> Любая C-структура в C++ имеет методы, конструкторы и т.д.

Различие:
- `struct` — поля по умолчанию **public**
- `class` — поля по умолчанию **private**

Тема public/private — следующих уроков.

## Оператор `new`

### Стек vs куча (heap)

```cpp
Robot r;          // на стеке — авто-уничтожение при выходе из функции
Robot* p = new Robot();   // в куче — живёт пока не вызовешь delete
```

| Стек                        | Куча (heap)                    |
|-----------------------------|--------------------------------|
| Авто-управление памятью     | Ручное управление              |
| Время жизни = scope         | Время жизни = до `delete`      |
| Быстро (просто move SP)     | Медленнее (есть аллокатор)     |
| Размер ограничен (~MB)      | Большой (GB)                   |
| Объект уничтожается auto    | Утечка если забыть delete      |

### Синтаксис new

```cpp
Robot* p = new Robot();
//          ^^^^^^^^^^^
//          выделить память в куче, вернуть указатель

p->attack();    // используем как обычно
```

`new` возвращает **указатель** на тип. Потому переменная теперь `Robot*`.

## ОБЯЗАТЕЛЬНО: парный delete

```cpp
Robot* p = new Robot();
p->attack();
delete p;       // ← БЕЗ ЭТОГО — утечка памяти
```

> Правило: **на каждый `new` — ровно один `delete`**.

### Что такое утечка памяти

```cpp
void leakyFunction() {
    Robot* p = new Robot();
    p->attack();
    // забыли delete!
}   // p уходит из scope — указатель потерян, но память НЕ освобождается

for (int i = 0; i < 1000000; ++i) leakyFunction();
// → 1М утёкших Robot'ов в памяти, программа жрёт RAM
```

**Опасность:**
- Долгая программа → постепенный рост RSS → OOM kill
- Невозможно «найти» утёкший объект — указателя на него нет

### При завершении программы

ОС освободит **всю** память программы. Но:
- Деструкторы не вызовутся → не закроются файлы / соединения / mutex
- Промежуточный leak до завершения = реальная проблема

## Инструменты обнаружения leaks

- **Valgrind:** `valgrind --leak-check=full ./program`
- **AddressSanitizer:** компиляция с `-fsanitize=address`
- **LeakSanitizer:** `-fsanitize=leak`
- **Visual Studio:** CRT Debug Heap

## Когда использовать new

- Объект должен **пережить** функцию, в которой создан
- Объект **большой** (десятки KB+) — стек ограничен
- **Полиморфизм** — указатели для виртуальных функций (далее в курсе)

## Когда НЕ использовать new

- Маленькие объекты с локальной областью видимости → стек
- В современном C++ — **`std::unique_ptr` / `std::shared_ptr`** (RAII)
- Контейнеры STL (`vector`, `map`) сами управляют памятью

## Полный пример

```cpp
#include <iostream>

struct Robot {
    int health = 100;
    int damage = 50;
    int speed  = 10;

    void attack() {
        std::cout << "Attack with damage " << damage << "\n";
    }

    void takeDamage(int dmg) {
        health -= dmg;
        std::cout << "Took " << dmg << " damage, health=" << health << "\n";
    }
};

int main() {
    // На стеке
    Robot r;
    r.attack();

    // В куче
    Robot* p = new Robot();
    p->takeDamage(30);
    delete p;
    p = nullptr;   // good practice — обнулить после delete
}
```

## Practical relevance для DevOps

- **Memory profiling:** Valgrind/ASAN/heaptrack для long-running daemons
- **Resource leaks:** не только память — file descriptors, sockets, locks
- **Production OOM:** утечка в logger / cache / connection pool
- **Smart pointers:** в современном C++ — почти никогда не пишут `new` напрямую
- **RAII pattern:** объект «владеет» ресурсом, освобождает в деструкторе

## Связь с другими модулями

- **M21 struct:** теперь struct = класс с методами
- **M17 указатели:** `new` возвращает указатель, `->` для доступа
- **M26.2+ (next):** конструкторы, деструкторы, инкапсуляция
- **C++ smart pointers** (далее): `unique_ptr<Robot>` вместо `Robot*` + `delete`
