# M25.1 — Заголовочные файлы (header files)

**Длительность:** ~8 минут
**Тема:** свои `.h` файлы, `#include "..." vs <...>`, `#pragma once`

## Главная идея

> Header file (`.h`) = переиспользуемый блок кода.
> `#include` склеивает текст. `#pragma once` защищает от двойной вставки.

## Зачем свой header

Допустим есть универсальные функции:

```cpp
#include <cmath>

double pi() { return 4 * std::atan(1); }
double circumference(double r) { return 2 * pi() * r; }
```

Хочется использовать в **разных** программах (разные `main.cpp`).
Решение: вынести в отдельный header.

## Создание header-файла

`my_math.h`:

```cpp
#include <cmath>

double pi() { return 4 * std::atan(1); }
double circumference(double r) { return 2 * pi() * r; }
```

**Расширение `.h`** = "header". На самом деле компилятор всеяден — расширение
важно для IDE/конвенций. Можно `.hpp`, `.hxx`, или вообще без расширения.

**Важно:** включаем `<cmath>` внутри header'а, потому что код header'а от него зависит.
Если не включить — header не скомпилируется при отдельном использовании.

## Использование своего header

`main.cpp`:

```cpp
#include <iostream>
#include "my_math.h"

int main() {
    std::cout << circumference(5);   // 31.4159...
}
```

## `#include "..."` vs `#include <...>`

| Синтаксис         | Где ищется                     | Когда использовать       |
|-------------------|--------------------------------|--------------------------|
| `#include <name>` | системные пути компилятора     | стандартные/системные .h |
| `#include "name"` | сначала локально, потом систем | свои header'ы            |

> **Правило:** `<>` для системных, `""` для своих. Оба валидны, отличаются
> только порядком поиска файлов.

## Проблема двойного включения

```cpp
#include "my_math.h"
#include "my_math.h"   // случайно включили дважды
```

После препроцессинга получим:

```cpp
double pi() { return 4 * std::atan(1); }
double circumference(double r) { ... }
double pi() { return 4 * std::atan(1); }       // дубль!
double circumference(double r) { ... }         // дубль!
```

**Compile error:** redefinition of `pi`, redefinition of `circumference`.

### Когда это случается на практике

Косвенно, через цепочку:
```text
main.cpp → physics.h → my_math.h
        → graphics.h → my_math.h    ← my_math.h включён ДВАЖДЫ
```

## Решение: `#pragma once`

```cpp
// my_math.h
#pragma once

#include <cmath>

double pi() { return 4 * std::atan(1); }
double circumference(double r) { return 2 * pi() * r; }
```

`#pragma once` — директива препроцессора:
> Включать содержимое **только один раз** независимо от количества `#include`.

При повторном включении — препроцессор просто пропускает файл.

## Альтернатива: include guards (классика)

```cpp
#ifndef MY_MATH_H
#define MY_MATH_H

#include <cmath>
double pi() { ... }
double circumference(double r) { ... }

#endif // MY_MATH_H
```

Логика:
1. При первом включении — `MY_MATH_H` не определён → весь блок включается + определяется макрос
2. При втором — `MY_MATH_H` уже определён → блок пропускается

| Способ              | Плюсы                          | Минусы                                               |
|---------------------|--------------------------------|------------------------------------------------------|
| `#pragma once`      | короче, проще                  | нестандартно (но поддерживается всеми компиляторами) |
| Include guards      | стандартно (С89/С++98)         | многословно, риск опечатки в имени макроса           |

> **На практике:** оба пишут одновременно для совместимости (или только pragma — она везде работает).

## ВАЖНО: ограничение «всё в header»

Подход «определить функцию прямо в header'е» работает для **этого примера**,
но нарушается при включении в **несколько `.cpp`** файлов:

```text
main.cpp → my_math.h → определение pi(), circumference()
util.cpp → my_math.h → ОПЯТЬ определение → linker error: multiple definition!
```

**Правильный подход** (тема следующих уроков):
- В **`.h`** — только **объявления** (`double pi();`)
- В **`.cpp`** — **определения** (`double pi() { ... }`)

Альтернатива: `inline double pi() { ... }` в header — компилятор разрешит.

## Practical relevance для DevOps

- **Своя библиотека утилит:** вынес в `utils.h` + `utils.cpp` — переиспользуй
- **Cross-platform конфиги:** один header с `#ifdef _WIN32 / __linux__`
- **Header-only библиотеки:** Catch2, json, fmt — всё в `.h`, легко интегрировать
- **Boost-подобные подходы:** template + inline в header'ах
- **Build dependencies:** `make` отслеживает включения через `.d` файлы

## Связь с другими модулями

- **M23.1-3:** препроцессор и `#include` — теперь применяем для своих файлов
- **M25.2 (next):** разделение header / source (.h + .cpp)
- **M25.3+ build system:** как линкер собирает несколько .cpp
- **C/C++ projects:** структура файлов как проект, не «один main.cpp»
