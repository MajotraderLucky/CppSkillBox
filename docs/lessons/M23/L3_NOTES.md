# M23.3 — Компиляция и этап препроцессинга

**Длительность:** ~10 минут
**Тема:** оператор `##` (token-pasting), `#if`, как смотреть результат препроцессинга

## Главная идея

> Препроцессор работает с **токенами** — отдельными единицами кода.
> Их можно склеивать оператором `##`, и условно компилировать через `#if`.

## Что такое токен

> Token = атомарная единица языка: имя, ключевое слово, число, литерал, оператор.

Препроцессор и компилятор оперируют токенами, не символами:
- `int x = 5;` — это 5 токенов: `int`, `x`, `=`, `5`, `;`
- `armata_weight` — один токен (имя)

## Оператор `##` (token-pasting)

Соединяет два токена в **один** на этапе препроцессинга:

```cpp
#define CONCAT(a, b) a##b

int xy = 10;
CONCAT(x, y) = 20;     // → xy = 20;
```

## Пример: динамический доступ к полям «структуры»

Допустим, моделируем танк через отдельные переменные:

```cpp
double armata_weight    = 49.5;
int    armata_crew      = 3;
int    armata_max_speed = 90;

void armata_drive(int dir) { /* ... */ }
void armata_shoot(int n)   { /* ... */ }
```

И хотим обращаться к ним «через имя модели»:

```cpp
#define TANK(model, name) model##_##name

TANK(armata, weight) = 55;        // → armata_weight = 55;
std::cout << TANK(armata, weight); // → std::cout << armata_weight;
TANK(armata, shoot)(5);            // → armata_shoot(5);
```

### Почему НЕТ скобок в определении

В макросах с выражениями обычно `((a) op (b))`. Но для `##` — скобки **сломают**:

```cpp
#define BAD(a, b) (a)##(b)        // НЕ компилируется
#define GOOD(a, b) a##b           // правильно
```

`##` склеивает токены **буквально**, скобки попадут в результат.

### Разделители тоже токены

```cpp
#define TANK(model, name) model##_##name
//                              ^^^
//                              отдельный токен подчёркивание
TANK(armata, weight)
//   armata + _ + weight = armata_weight
```

## Условная компиляция: `#if`

Препроцессор может **вырезать** куски кода:

```cpp
#if 1                       // компилировать
    std::cout << weight;
#endif

#if 0                       // НЕ компилировать (вырезается препроцессором)
    std::cout << weight;
#endif
```

В IDE отрезанный блок обычно **затемняется** (`#if 0` ветка).

### Связанные директивы

```cpp
#define DEBUG 1

#if DEBUG
    std::cout << "debug info\n";
#elif PRODUCTION
    std::cout << "prod info\n";
#else
    std::cout << "default\n";
#endif

// или:
#ifdef DEBUG          // если DEBUG определён (любое значение)
    ...
#endif

#ifndef RELEASE       // если RELEASE НЕ определён
    ...
#endif
```

### Применение

- **Debug vs release builds** — вырезать assert/log в release
- **Платформенный код** — `#ifdef _WIN32 ... #else ... #endif`
- **Header guards** (классический pattern):
  ```cpp
  #ifndef MY_HEADER_H
  #define MY_HEADER_H
  // ... содержимое header
  #endif
  ```

## Как посмотреть результат препроцессинга

### gcc/clang флаг

```bash
g++ -E main.cpp -o main.preprocessed.cpp
# или
g++ --preprocess main.cpp
```

Файл будет содержать:
- Раскрытые `#include` (весь iostream и т.п.)
- Раскрытые макросы (CONCAT → xy, etc.)
- Удалённые `#if 0` блоки

### CLion (IDE учителя)

`Shift+Shift` → `Pre-Process Current TU` (TU = Translation Unit = .cpp файл)

### Зачем смотреть

- **Дебагать макросы** — увидеть что именно генерируется
- **Понять ошибку компиляции** в макросе (когда сообщение туманное)
- **Изучить header'ы STL** — увидеть содержимое `<vector>` целиком

## Стадии сборки C++

```text
.cpp + .h
   ↓
PREPROCESSOR  ← #include, #define, #if, ## , #
   ↓ (выдаёт чистый C++ без директив)
COMPILER      ← синтаксический анализ, оптимизация
   ↓ (выдаёт .o object file)
LINKER        ← склеивает .o + библиотеки
   ↓
.exe / a.out
```

## Сводка операторов препроцессора

| Оператор / директива              | Назначение                           |
|-----------------------------------|--------------------------------------|
| `#include "x"`                    | вставить содержимое файла            |
| `#define X V`                     | макрос-константа                     |
| `#define F(a) ...`                | функциеподобный макрос               |
| `##`                              | склеить два токена                   |
| `#`                               | превратить токен в строковый литерал |
| `#if`, `#elif`, `#else`, `#endif` | условная компиляция                  |
| `#ifdef`, `#ifndef`               | проверка определён ли макрос         |
| `#undef X`                        | удалить определение макроса          |
| `#error "msg"`                    | прервать компиляцию с сообщением     |
| `#pragma once`                    | альтернатива header guards           |

## Practical relevance для DevOps

- **Header guards** — каждый `.h` начинается с `#ifndef`/`#define`/`#endif`
- **Конфиги через `-D`:** `gcc -DBUILD_DATE=\"$(date)\" main.cpp`
- **Логирование с `__FILE__` и `__LINE__`:** макрос с conditional compile
- **Cross-compile:** `#ifdef __APPLE__ #include <mach.h> #endif`
- **Debug builds:** `-DDEBUG` включает доп. логи в release-готовом коде
- **Изучить `g++ -E`** при странных compile errors в шаблонах/макросах

## Связь с другими модулями

- **M23.1, M23.2:** базовый и функциеподобный макросы
- **M23.4 hwork:** практика макросов (наверное)
- **C++ Templates:** заменяет большинство случаев `##`-склейки в современном коде
- **Header files:** условная компиляция критична для multi-file проектов
