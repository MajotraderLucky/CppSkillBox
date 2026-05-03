# M21.3 — Работа со структурами

**Длительность:** ~7 минут
**Тема:** массивы структур, std::string в полях, передача по указателю vs по ссылке

## Главная идея

> Структуры можно складывать в массивы и передавать в функции тремя способами:
> по значению, по указателю, по ссылке.

## Массив структур

```cpp
struct Character {
    std::string name;     // динамическая строка вместо const char*
    int health = 0;
    int armor = 0;
};

Character people[10];   // 10 персонажей
```

### Ручная инициализация

Каждый элемент инициализируется как отдельная переменная:

```cpp
Character people[10] = {
    {"Hero1", 100, 20},
    {"Hero2", 150, 30},
    // ... и так далее для всех 10
};
```

Длинно — поэтому учитель использует `rand()`:

### Random init через цикл

```cpp
#include <cstdlib>
#include <string>

for (int i = 0; i < 10; ++i) {
    people[i].name   = "character " + std::to_string(i);
    people[i].health = 100 + rand() % 101;   // [100, 200]
    people[i].armor  = 10  + rand() % 41;    // [10, 50]
}
```

**Доступ:** `people[i].field` — комбинация `[]` (массив) и `.` (поле структуры).

## Передача массива структур в функцию

### Способ 1: цикл с `&` для каждого элемента

```cpp
void takeDamage(Character* p, int damage);

for (int i = 0; i < 10; ++i) {
    takeDamage(&people[i], 30);   // адрес i-го элемента
}
```

### Способ 2: арифметика указателей

Переменная массива `people` уже указатель на первый элемент.
Можно прибавлять `i` для получения указателей на следующие элементы:

```cpp
for (int i = 0; i < 10; ++i) {
    takeDamage(people + i, 30);   // эквивалент &people[i]
}
```

**Почему работает:** `Character* + 1` сдвигается на `sizeof(Character)` байт
(не на 1 байт). Это арифметика указателей с типом.

## Ссылки (references) — `&` после типа

```cpp
void takeDamage(Character& p, int damage) {   // & вместо *
    p.armor = p.armor - damage;               // точка вместо ->
    if (p.armor < 0) {
        p.health = p.health + p.armor;
        p.armor = 0;
    }
}

for (int i = 0; i < 10; ++i) {
    takeDamage(people[i], 30);   // передаём элемент, не его адрес
}
```

### Свойства ссылок

- **Синтаксически = обычная переменная** (точка для полей, без разыменования)
- **Семантически = указатель** (изменения видны снаружи)
- **Статичны:** всегда ссылаются на один и тот же объект (нельзя «переназначить»)
- **Нет арифметики:** `ref + 1` — ошибка
- **Не могут быть `nullptr`** (всегда привязаны к объекту)

### Применимы к любым типам

```cpp
void increment(int& x) { x++; }
void scale(double& d) { d *= 2.0; }
```

## Три способа передачи параметра

| Способ          | Синтаксис              | Когда использовать                              |
|-----------------|------------------------|-------------------------------------------------|
| По значению     | `void f(Character p)`  | Малая struct, не нужно менять оригинал          |
| По указателю    | `void f(Character* p)` | Менять оригинал, может быть `nullptr`           |
| По ссылке       | `void f(Character& p)` | Менять оригинал, гарантированно валидный объект |

### Правила выбора

- **Большая структура / массив** → по ссылке или указателю (избежать копирования)
- **Нужно изменить параметр** → по ссылке или указателю
- **Малые данные + read-only** → по значению (просто и безопасно)
- **Read-only большая структура** → `const Character& p`

## Пример: takeDamage три варианта

```cpp
// 1) Pointer (M21.2 версия)
void takeDamage(Character* p, int dmg) {
    p->armor -= dmg;
    if (p->armor < 0) { p->health += p->armor; p->armor = 0; }
}
takeDamage(&people[i], 30);

// 2) Reference (M21.3 версия)
void takeDamage(Character& p, int dmg) {
    p.armor -= dmg;
    if (p.armor < 0) { p.health += p.armor; p.armor = 0; }
}
takeDamage(people[i], 30);

// 3) By value (БЕСПОЛЕЗНО — копия не меняет оригинал)
void takeDamage(Character p, int dmg) { p.armor -= dmg; }   // изменения теряются!
```

## Practical relevance для DevOps

- **Configs:** `void apply(const Config& cfg)` — read-only передача большой структуры
- **Mutable state:** `void update(Stats& s)` — счётчики/гистограммы
- **C-style APIs:** `struct sockaddr*` — почти всегда указатель (POSIX legacy)
- **RAII wrappers:** ссылки на ресурсы (FileHandle&, DbConnection&)

## Связь со следующими уроками

- **M21.2 (prev):** интро в struct — поля, доступ через `.` и `->`
- **M21.4 (next):** структуры в контексте файлов (read/write структур из/в файл)
- **M21.5 hwork:** практика структур
- **M22+ classes:** ссылки активно используются в методах (`this`, return refs)
