# M22.3 — Вставка и просмотр элементов std::map

**Длительность:** ~9 минут
**Тема:** `insert`, `std::pair`, `std::make_pair`, `find`, итераторы

## Главная идея

> `std::map` хранит пары `(key, value)`. Доступ через `[]`, `insert(pair)`, `find(key)`.
> `find` возвращает итератор — указатель на пару.

## std::pair

`std::map` хранит элементы типа `std::pair<K, V>` — структура из двух полей:

```cpp
std::pair<std::string, int> opair("hello", 5);
//        ^^^^^^^^^^^^^^^^^^^^^      ^^^^^^^^^^
//        типы (как у map)             значения

std::cout << opair.first  << " " << opair.second;
// hello 5
```

**Поля пары:**
- `.first`  — первый элемент (для map = key)
- `.second` — второй элемент (для map = value)

## Метод insert

### Способ 1: явная пара

```cpp
#include <map>
#include <string>

std::map<std::string, int> ourMap;
std::pair<std::string, int> opair("hello", 5);
ourMap.insert(opair);

std::cout << ourMap["hello"];   // 5
```

### Способ 2: пара inline

```cpp
ourMap.insert(std::pair<std::string, int>("world", 6));
```

### Способ 3: std::make_pair

`std::make_pair` — фабрика, которая выводит типы автоматически:

```cpp
ourMap.insert(std::make_pair<std::string, int>("banana", 7));
// или короче (типы выводятся компилятором):
ourMap.insert(std::make_pair("banana", 7));
```

## КРИТИЧЕСКОЕ ОТЛИЧИЕ: insert vs []

### Поведение при существующем ключе

```cpp
ourMap.insert(std::make_pair("hello", 5));
ourMap.insert(std::make_pair("hello", 8));   // <-- значение 8 НЕ запишется
std::cout << ourMap["hello"];                // 5 (старое!)

// vs.

ourMap["hello"] = 8;                          // <-- перезаписывает
std::cout << ourMap["hello"];                // 8
```

| Метод     | Если ключ есть     | Если ключа нет        |
|-----------|--------------------|-----------------------|
| `insert`  | НЕ заменяет        | вставляет новый       |
| `[] = v`  | заменяет           | создаёт + присваивает |
| `[]` read | возвращает старое  | создаёт `K → V{}`     |

**insert возвращает** `pair<iterator, bool>`: bool=`false` если ключ уже был.

## Итераторы

> **Итератор** — указатель на конкретный элемент контейнера.
> Для map — указатель на `std::pair<K, V>`.

### Объявление

```cpp
std::map<std::string, int>::iterator it;
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
//       полный тип map
//                                   ^^^^^^^^
//                                   вложенный тип
```

`iterator` — внутренний тип `std::map`. Доступ через `::` (scope resolution).

В современном C++ короче:
```cpp
auto it = ourMap.find("hello");
```

### Метод find

`find(key)` ищет ключ и возвращает итератор:
- На найденную пару — если ключ есть
- На `end()` (sentinel) — если ключа нет

```cpp
auto it = ourMap.find("hello");
if (it != ourMap.end()) {
    std::cout << it->first << " " << it->second;   // hello 5
}
```

### Доступ через `->`

Итератор — это указатель, поэтому используется `->` (а не `.`):

```cpp
it->first    // ключ
it->second   // значение
```

`->` = `(*it).` — разыменовать + получить поле.

## Зачем find если есть `[]`?

| `[]`                            | `find`                                |
|---------------------------------|---------------------------------------|
| Создаёт элемент если ключа нет  | Не модифицирует контейнер             |
| Возвращает только value         | Возвращает pair (key + value)         |
| Не отличает «нет» от «default»  | Можно проверить `!= end()`            |

**Правильный pattern для проверки:**

```cpp
auto it = m.find(key);
if (it == m.end()) {
    // ключа нет
} else {
    // используем it->second
}
```

## Сводка операций

| Операция                | Синтаксис                              |
|-------------------------|----------------------------------------|
| Создать                 | `std::map<K, V> m;`                    |
| Вставить (no overwrite) | `m.insert({k, v});`                    |
| Вставить (overwrite)    | `m[k] = v;`                            |
| Прочитать               | `m[k]` (создаёт!) или `m.find(k)`      |
| Проверить наличие       | `m.find(k) != m.end()`                 |
| Получить ключ из it     | `it->first`                            |
| Получить значение       | `it->second`                           |

## Practical relevance для DevOps

- **Counter:** `++counts[event_type]` — `[]` создаёт `0` если ключа нет, идиома
- **Lookup с дефолтом:** `find` для проверки vs `[]` для guaranteed-create
- **Configuration:** `if (auto it = config.find("port"); it != config.end()) {...}`
- **Caching:** `insert` чтобы НЕ переписать существующий cached entry

## Связь с другими модулями

- **M22.1:** базовые операции, `[]`, уникальность ключей
- **M22.2:** теория BST → понимаем что find = O(log N)
- **M22.4 (next):** возможно итерация по всему map (range-for)
- **M22.5 hwork:** практика insert/find/`[]`
- **M17 указатели:** `it->field` = `(*it).field` — синтаксис указателей применим
