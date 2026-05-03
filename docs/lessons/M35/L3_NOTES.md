# M35.3 — Базовые возможности modern C++ (range-for, auto, init-list, lambda)

**Длительность:** ~27 минут
**Тема:** range-based for, `auto`, uniform initialization, `std::initializer_list`, лямбда-выражения

## Главная идея

> Современный C++ имеет **4 базовых инструмента**, которые радикально упрощают
> повседневный код:
> 1. **Range-based for** — итерация без индексов
> 2. **`auto`** — компилятор сам выводит тип
> 3. **Uniform init `{}`** — единый способ инициализации
> 4. **Lambda** — функции inline без отдельных описаний

## 1. Range-based for loops (C++11)

### До

```cpp
for (int i = 0; i < 10; ++i) {
    std::cout << i << std::endl;
}
```

### После

```cpp
for (auto& file : files) {
    file.close();
}
```

> Сравните с **Python**:
> ```python
> for file in files:
>     file.close()
> ```

### Что нужно от типа

Чтобы тип работал с range-for, у него должны быть методы **`begin()`** и **`end()`**, возвращающие **итераторы**.

### Что такое итератор

> Итератор — объект, дающий доступ к **текущему** и **следующему** элементу последовательности, и определяющий **является ли он последним**.

Аналогии:
- Палец, читающий по строкам книги
- Игральная кость в настольной игре

> Все стандартные контейнеры (`vector`, `map`, `list`) уже имеют begin/end → range-for работает «из коробки».

## 2. `auto` — type deduction (C++11)

### Базовый синтаксис

```cpp
auto x = 42;          // x — int
auto y = 3.14;        // y — double
auto z = std::sqrt(2.0);   // z — тип возвращаемого значения sqrt
```

> **Без значения** `auto` не работает: `auto x;` → ошибка. Компилятор не может угадать.

### Особенно полезно с длинными типами

#### До auto

```cpp
std::vector<int>::iterator it = vec1.begin();
```

#### После auto

```cpp
auto it = vec1.begin();
```

### Когда применять auto

> «**Везде где можно**, лучше использовать auto.»
>
> Исключение: когда хотите оставить **подсказку** программисту, что в этом месте ожидается **конкретный** тип (`int` / `float`).

### Бонус: устойчивость к рефакторингу

Если функция начинает возвращать **другой** тип (но с теми же операциями) — код с `auto` достаточно **перекомпилировать**, переписывать ничего не надо.

```cpp
auto a = some_func();   // тип не критичен
auto b = other_func();
auto c = a + b;         // если оба сменили тип — операция всё равно работает
```

## 3. Uniform initialization (C++11) — фигурные скобки

### Старые способы инициализации

```cpp
int a;                  // не инициализирован (UB при чтении)
int b = 10;             // copy-init
int c(10);              // direct-init
int arr[] = {1, 2, 3};  // C-style для массивов
```

### Новый единый стиль (`{}`)

```cpp
int a{};                // 0 (zero-init)
int b{10};              // 10
int arr[]{1, 2, 3};     // C-style тоже OK
std::vector<int> v{1, 2, 3};   // ← вектор инициализируется так же!
```

> **Преимущество:** один способ для **всего** — встроенные типы, контейнеры, свои классы.

### Дополнительный бонус: запрет narrowing

```cpp
int x = 3.14;       // OK, конвертит в 3 (потеря точности)
int y(3.14);        // OK
int z{3.14};        // ОШИБКА компиляции: narrowing запрещён
```

## 4. std::initializer_list (C++11)

> **Шаблон-обёртка** над C-массивом, передаваемым через `{...}`.

### Как стандартный vector это поддерживает

```cpp
std::vector<int> v{1, 2, 3, 4, 5};
//                ↑ initializer_list<int>
```

### Чтобы свой класс умел `{...}` — нужен ctor от `initializer_list`

```cpp
#include <initializer_list>

class Tool {
    std::vector<std::string> parts;
public:
    Tool(std::initializer_list<std::string> p) : parts(p) {}
};

// Использование:
Tool t{"hammer", "saw", "drill"};
```

### Пример с вложенными initializer_list

```cpp
class GeoPoint {
    double lon, lat;
public:
    GeoPoint(double a, double b) : lon(a), lat(b) {}
};

class Road {
    std::vector<GeoPoint> points;
public:
    Road(std::initializer_list<GeoPoint> pts) : points(pts) {}
};

// Использование (вложенные {}):
Road route{
    {0.0, 0.0},
    {10.0, 5.0},
    {15.0, 7.0}
};
```

> **Brace initialization** = другое имя для uniform init. От «brace» — фигурная скобка.

## 5. Lambda expressions (C++11)

### Зачем

> Лямбда = **код, сохранённый в переменную**. Полезен в **функциональном** стиле — когда алгоритм принимает функцию как аргумент.

### Базовый синтаксис

```cpp
[capture](args) -> return_type {
    body
};
```

| Часть          | Назначение                                    |
|----------------|-----------------------------------------------|
| `[...]`        | **Capture list** — переменные снаружи         |
| `(...)`        | Параметры (как у обычной функции)             |
| `-> T`         | Тип возврата (опционально, выводится сам)     |
| `{...}`        | Тело                                          |

### Capture list варианты

| Запись    | Что захватывает                              |
|-----------|----------------------------------------------|
| `[]`      | Ничего                                       |
| `[x]`     | x по значению (const копия)                  |
| `[&x]`    | x по ссылке (можно менять)                   |
| `[=]`     | Все переменные снаружи **по значению**       |
| `[&]`     | Все по **ссылке**                            |
| `[this]`  | Указатель `this` (методы класса)             |

### Пример: сортировка по полю

```cpp
struct Unit { int height; };
std::vector<Unit> units;

// Старый способ — отдельная функция:
bool comp(const Unit& a, const Unit& b) {
    return a.height < b.height;
}
std::sort(units.begin(), units.end(), comp);

// С лямбдой — inline:
std::sort(units.begin(), units.end(),
    [](const Unit& a, const Unit& b) {
        return a.height < b.height;
    }
);
```

> Лямбда живёт **на месте использования** → не нужно описывать функцию где-то отдельно.

### Пример: std::for_each с capture

```cpp
class Map { void teleport(Unit*); };
Map gameMap;
std::vector<Unit*> warriors;

std::for_each(warriors.begin(), warriors.end(),
    [&gameMap](Unit* u) {
        if (auto* h = dynamic_cast<Human*>(u)) {
            gameMap.teleport(h);
        }
    }
);
```

> `[&gameMap]` — захватили ссылку на карту, чтобы вызывать `teleport()` внутри лямбды.

## Аналогия с Python

| C++ modern                          | Python                            |
|-------------------------------------|-----------------------------------|
| `for (auto& x : v)`                 | `for x in v:`                     |
| `auto x = 42;`                      | `x = 42`                          |
| `vec{1, 2, 3}`                      | `[1, 2, 3]`                       |
| `[x](int y) { return x + y; }`      | `lambda y: x + y`                 |

> Modern C++ читается **очень похоже на Python**, особенно в типичных задачах.

## Когда применять (рекомендации)

| Инструмент         | Когда                                                      |
|--------------------|------------------------------------------------------------|
| Range-based for    | Всегда, когда не нужен индекс                              |
| `auto`             | Везде, где не хочется явной подсказки типа                 |
| Uniform init `{}`  | Везде новый код; в legacy — по контексту                   |
| `initializer_list` | В своих классах с переменным числом аргументов одного типа |
| Lambda             | Inline-функции для алгоритмов; короткие колбэки            |

## Подводные камни

### auto + ссылки

```cpp
auto x = vec[0];      // x — копия!
auto& x = vec[0];     // x — ссылка
const auto& x = vec[0]; // const ссылка (best для read-only)
```

### Uniform init и initializer_list ambiguity

```cpp
std::vector<int> v1(10);       // 10 элементов, все 0
std::vector<int> v2{10};       // 1 элемент = 10 ← initializer_list берёт верх!
std::vector<int> v3{10, 20};   // 2 элемента
```

> При наличии `initializer_list` ctor — `{}` всегда вызывает его.

### Lambda захват по умолчанию

```cpp
auto f = [&]() { return localVar; };   // OK пока scope жив
return f;                              // BAD: dangling reference после возврата
```

> С `[&]` будь осторожен, если лямбда переживает scope.

## Practical relevance для DevOps

- **Pipelines:** `transform`, `filter`, `for_each` с лямбдами для обработки коллекций
- **Async callbacks:** лямбды передаются в `std::async`, threads, IO callbacks
- **Config:** `auto` для длинных типов из YAML/JSON парсеров
- **Testing:** uniform init упрощает создание test fixtures
- **Logging:** lazy logging через лямбду — не сериализовать сообщение если уровень отключён

## Связь с другими модулями

- **M28 std::vector / M22 std::map:** уже работали с range-for и uniform init интуитивно
- **M33.3 templates:** `auto` использует ту же дедукцию типов что и шаблоны
- **M31.3 unique_ptr:** часто создаётся через `auto p = std::make_unique<T>(...)`
- **M35.4+ (next):** скорее всего ещё больше modern фич (move semantics, smart_ptr advanced, optional?)
