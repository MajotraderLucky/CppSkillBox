# M35.4 — Modern структуры данных (array, tuple, unordered_*, smart_ptr)

**Длительность:** ~22 минуты
**Тема:** `std::array`, `std::tuple`, `std::unordered_map/set`, `unique_ptr` vs `shared_ptr`

## Главная идея

> Modern C++ обогатил **стандартную библиотеку** новыми контейнерами:
> 1. **`std::array`** — обёртка над C-массивом для STL алгоритмов
> 2. **`std::tuple`** — анонимная структура для возврата нескольких значений
> 3. **`std::unordered_map/set`** — хэш-таблицы (O(1) поиск)
> 4. **Smart pointers** — автоматическое управление памятью

## 1. std::array (C++11) — обёртка над C-массивом

### Зачем

Старые C-массивы **не работают** со стандартными STL алгоритмами (`std::sort`, `std::find`, etc.) — у них нет `begin()`/`end()`.

### Использование

```cpp
#include <array>
#include <algorithm>

std::array<int, 5> arr {3, 1, 4, 1, 5};       // фиксированный размер
std::sort(arr.begin(), arr.end());             // ← работает, потому что есть iterators
```

| Особенность         | Значение                          |
|---------------------|-----------------------------------|
| Размер              | **Фиксированный** (compile-time)  |
| Накладные расходы   | Близко к нулю (тонкая обёртка)    |
| Совместимость с STL | Да — есть `begin/end`             |
| C-массив внутри     | Доступен через `.data()`          |

> Это **не** замена `std::vector`. `array` — для **известного размера**, `vector` — для динамического.

## 2. std::tuple (C++11) — анонимная структура

### Зачем

Когда функция должна вернуть **несколько разнородных значений**, есть варианты:
1. Вернуть через **out-параметры** по ссылке (некрасиво)
2. Описать **структуру** (нужно где-то определить)
3. Вернуть **`std::tuple`** (inline, безымянно)

### До: out-параметры

```cpp
void averageAndExtremums(const std::vector<int>& data,
                         int& avg, int& min, int& max) {
    if (data.empty()) return;
    avg = min = max = data.front();
    for (auto current : data) {
        if (current > max) max = current;
        if (current < min) min = current;
        avg += current;
    }
    avg /= data.size();
}

// Вызов:
int a, mn, mx;
averageAndExtremums(temps, a, mn, mx);
```

### После: возврат tuple

```cpp
#include <tuple>

std::tuple<int, int, int> averageAndExtremums(const std::vector<int>& data) {
    if (data.empty()) return {};
    int avg = data.front(), mn = avg, mx = avg;
    for (auto c : data) {
        if (c > mx) mx = c;
        if (c < mn) mn = c;
        avg += c;
    }
    avg /= data.size();
    return std::make_tuple(avg, mn, mx);
}

// Вызов:
auto result = averageAndExtremums(temps);
int avg = std::get<0>(result);
int mn  = std::get<1>(result);
int mx  = std::get<2>(result);
```

### C++17: structured bindings

```cpp
auto [avg, mn, mx] = averageAndExtremums(temps);   // в одну строку
```

> **Best practice** — для возврата 2-3 значений `tuple` (или `std::pair`). Для большего — лучше **именованная struct**.

## 3. std::unordered_map / unordered_set (C++11) — хэш-таблицы

### Сравнение с обычными map/set

| Аспект               | `std::map` / `set`     | `std::unordered_map` / `set` |
|----------------------|------------------------|------------------------------|
| Внутренняя структура | Красно-чёрное дерево   | Хэш-таблица                  |
| Доступ по ключу      | O(log n)               | **O(1)** average             |
| Worst-case           | O(log n)               | O(n) — при коллизиях         |
| Порядок ключей       | Сортированный          | **Не определён**             |
| Память               | Меньше                 | Больше (buckets)             |
| Когда выбирать       | Нужен порядок / range  | Нужен **быстрый поиск**      |

### Хэш-таблица — как устроено

```text
hash(key) → bucket index → linked list buckets → найти точное совпадение
```

| Термин    | Значение                                                   |
|-----------|------------------------------------------------------------|
| Hash      | Целое число — «отпечаток» ключа                            |
| Bucket    | Ячейка таблицы для группы хэшей                            |
| Collision | Два разных ключа → одинаковый хэш (обрабатывается линейно) |

> **Современные процессоры** имеют аппаратные блоки для вычисления хэшей → быстро.

### Пример unordered_set

```cpp
#include <unordered_set>

std::unordered_set<std::string> words {"apple", "banana", "cherry"};

// Старый способ — цикл с проверкой:
bool found = false;
for (const auto& w : words) if (w == "banana") found = true;

// С unordered_set:
if (words.count("banana") > 0) {
    // нашли (быстро)
}

// С C++20:
if (words.contains("banana")) { ... }
```

### Когда выбирать unordered

> Если задача = **«быстро проверить, существует ли элемент в большом наборе»** — `unordered_set` / `unordered_map`.
>
> Если **нужен порядок** или iterator stability — `set` / `map`.

## 4. Smart pointers (C++11) — `unique_ptr` & `shared_ptr`

> Уже подробно разбирали в **M31.3 / M31.4**. Здесь — резюме от нового преподавателя.

### Без smart pointers (legacy)

```cpp
{
    Unit* u = new Unit();
    // ... use u ...
    delete u;        // если забыли — утечка
}                    // или delete упустили из-за исключения / early return
```

### С smart pointers

```cpp
{
    auto u = std::make_unique<Unit>();    // unique
    // или
    auto s = std::make_shared<Unit>();    // shared
    // ...
}   // delete вызовется автоматически
```

### unique_ptr vs shared_ptr — quick rules

| Признак                       | unique_ptr            | shared_ptr                      |
|-------------------------------|-----------------------|---------------------------------|
| Кол-во владельцев             | 1                     | N                               |
| Копирование                   | Запрещено             | OK (refcount++)                 |
| Передача                      | `std::move`           | Просто copy                     |
| Накладные расходы             | ~0 (как raw pointer)  | atomic refcount + control block |
| Когда выбирать                | **Default choice**    | Нужно делиться                  |

### Аналогии преподавателя

| Указатель    | Аналогия из реального мира                                        |
|--------------|-------------------------------------------------------------------|
| unique_ptr   | **Жетон в гардеробе** — у одного человека, ниоткуда не копируется |
| shared_ptr   | **Подписка** — несколько подписчиков получают тот же контент      |

> Когда последний подписчик отписался — издательство закрывает рассылку. Так же и shared_ptr — последний reset = delete.

### Recommendation

> **Всегда** используй `unique_ptr`. Если не подходит — `shared_ptr` (с пониманием что менее производительный).

## Сводка: новые modern контейнеры

| Контейнер                 | Когда                                    | Аналог в legacy          |
|---------------------------|------------------------------------------|--------------------------|
| `std::array<T, N>`        | Известный размер, нужны STL алгоритмы    | C-массив `T[N]`          |
| `std::tuple<T1, T2, ...>` | Возврат N значений из функции            | Безымянная структура     |
| `std::unordered_map`      | Быстрый поиск по ключу                   | Хэш-таблицы (свои)       |
| `std::unordered_set`      | Быстрая проверка вхождения               | -                        |
| `std::unique_ptr<T>`      | Single owner heap object                 | Raw `T*` + ручной delete |
| `std::shared_ptr<T>`      | Shared owner                             | Refcount вручную         |

## Practical relevance для DevOps

- **Кэши:** `unordered_map<string, T>` — быстрый lookup конфигов / connections
- **Множественный возврат:** `tuple<HttpStatus, Body, Headers>` для API responses
- **STL алгоритмы:** `std::array` для fixed-size sensors / coordinates
- **Resource management:** `unique_ptr<Connection>` + `shared_ptr<Pool>` для DB
- **Hash collisions:** в worst-case unordered может быть O(n) — учитывать при adversarial input

## Связь с другими модулями

- **M14, M21:** массивы и структуры — теперь modern замены
- **M22 std::map:** `unordered_map` — быстрая альтернатива
- **M31.3-4 smart pointers:** этот урок — резюме того что уже знаем
- **M35.3 auto:** часто используется для упрощения объявлений `std::tuple`
- **M35.5+ (next):** скорее всего хоумворк или ещё фичи (move semantics?)
