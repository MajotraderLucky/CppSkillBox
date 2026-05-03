# M21.2 — Знакомство со структурами (struct)

**Длительность:** ~13 минут
**Тема:** struct — группировка разнородных полей в один тип

## Главная идея

> `struct` = пользовательский тип, объединяющий несколько именованных полей разных типов.

## Мотивация

Без struct — для 10 персонажей с N параметрами нужны N массивов:

```cpp
const char* names[10];
int health[10];
int armor[10];
// ... + ещё параметры — массивов всё больше
```

Функция получает 3+ аргумента-указателя:
```cpp
void takeDamage(const char* name, int* hp, int* armor, int dmg);
```

С каждым новым полем — новый массив + параметр. Не масштабируется.

## Объявление struct

```cpp
struct Character {
    const char* name;
    int health = 0;     // C++ позволяет default values, C — нет
    int armor = 0;
};   // не забыть точку с запятой!
```

**Поля = members.** Может быть любого типа (int, double, string, указатель, другая struct).

## Создание экземпляра

```cpp
// Defaults:
Character a;   // name=nullptr, health=0, armor=0

// Positional initialization (C++11+):
Character b = {"Hero", 100, 20};

// Designated initializers (C++20+ официально, GCC поддерживает раньше):
Character c = {.name = "Hero", .health = 100, .armor = 20};
```

**Notе из видео:** старые компиляторы могут не поддерживать `.field=` синтаксис.
Учитель столкнулся с этим — пришлось вернуться к positional init.

## Доступ к полям

### Через точку — для прямого экземпляра

```cpp
Character p = {"Hero", 100, 20};
std::cout << p.name;     // read
p.armor = 50;            // write
```

### Через `->` — для указателя на структуру

```cpp
Character* ptr = &p;
std::cout << ptr->name;  // эквивалент (*ptr).name
ptr->armor = 50;
```

**Mnemonic:** `->` — «стрелка», т.к. ptr указывает на нужный объект.

## Функция, принимающая struct

```cpp
void takeDamage(Character* person, int damage) {
    person->armor = person->armor - damage;
    if (person->armor < 0) {
        person->health = person->health + person->armor;  // оставшийся урон
        person->armor = 0;
    }
    std::cout << person->name << " получил " << damage;
}

int main() {
    Character p = {"Hero", 100, 20};
    takeDamage(&p, 30);
    // p.armor = 0, p.health = 90
}
```

## Преимущества vs параллельные массивы

- **Cohesion:** все поля одного объекта вместе
- **Type safety:** компилятор гарантирует все поля правильного типа
- **Один параметр функции** вместо N
- **Легко расширять:** добавить поле — не меняешь сигнатуру функции
- **Можно передавать by-value, by-pointer, by-reference**

## По значению vs по ссылке/указателю

```cpp
void readOnly(const Character& p);    // const reference — best for read-only large struct
void modify(Character* p);            // pointer — modify
void byValue(Character p);            // copy — для маленьких struct, иначе дорого
```

## Связь со следующими уроками

- **M21.3+ (next):** скорее всего более сложные struct — массивы of struct, nested struct
- **M22+ (потом):** classes — это struct + методы + access control
- **M19/M20 file I/O:** struct можно сохранять/читать бинарно (alignment caveat)

## Practical relevance для DevOps

- **Config объекты:** `struct Config { string host; int port; bool tls; };`
- **Network packets:** struct headers (например IP/TCP)
- **POD (Plain Old Data):** прямая запись/чтение в file/socket
- **Linux kernel APIs:** `struct sockaddr`, `struct stat`, etc.
