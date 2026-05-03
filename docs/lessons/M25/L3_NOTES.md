# M25.3 — Структура проекта (.h + .cpp + CMake subdirs)

**Длительность:** ~10 минут
**Тема:** разделение declaration/definition, src/include layout, `add_subdirectory`

## Главная идея

> **Header (`.h`)** = объявления (declarations)
> **Source (`.cpp`)** = определения (definitions)
> Папки `src/` и `include/` + `add_subdirectory` для масштабируемых проектов.

## Шаг 1: разделение .h / .cpp

### Header `my_math.h` — только объявления

```cpp
#pragma once

double pi();
double circumference(double r);
```

Никаких определений. Только **сигнатуры** функций.
`#include <cmath>` тоже **не нужен** в header'е (не используется).

### Source `my_math.cpp` — определения

```cpp
#include "my_math.h"   // ← обязательно: чтобы видеть свои объявления
#include <cmath>       // ← нужно для std::atan

double pi() {
    return 4 * std::atan(1);
}

double circumference(double r) {
    return 2 * pi() * r;
}
```

**Зачем `#include "my_math.h"` в `my_math.cpp`:**
- Чтобы компилятор сверил сигнатуры declaration vs definition
- Catch несовпадения типов на этапе компиляции (а не linker)

### `main.cpp` — пользователь

```cpp
#include <iostream>
#include "my_math.h"

int main() {
    std::cout << circumference(5);
}
```

`main.cpp` **не должен** включать `my_math.cpp`.
Достаточно header'а с объявлениями.

## Linker error: «forgot to add to CMake»

```cmake
add_executable(my_proj main.cpp my_math.h)   # ← my_math.cpp пропущен!
```

При сборке: `undefined reference to pi()` — линкер не находит реализацию.

**Fix:**
```cmake
add_executable(my_proj main.cpp my_math.h my_math.cpp)
```

## Шаг 2: организация в папки

```text
my_project/
├── CMakeLists.txt
├── main.cpp
├── include/
│   └── my_math.h
└── src/
    └── my_math.cpp
```

**Конвенция:**
- **`include/`** — публичные header'ы
- **`src/`** — приватные source'ы

После переноса CMake перестаёт находить файлы:
```text
fatal error: my_math.h: No such file or directory
```

## Шаг 3: target_include_directories

```cmake
add_executable(my_proj main.cpp src/my_math.cpp include/my_math.h)
target_include_directories(my_proj PUBLIC include)
```

`target_include_directories` добавляет директории, в которых компилятор
будет искать `#include "..."`.

| Visibility  | Применение                                     |
|-------------|------------------------------------------------|
| `PUBLIC`    | для самой цели + для тех, кто её использует    |
| `PRIVATE`   | только для самой цели                          |
| `INTERFACE` | только для тех, кто использует (header-only)   |

Для executable разница не важна. Для library — важна.

## Шаг 4: subdirectory CMake

При большом проекте — отдельный `CMakeLists.txt` для каждой подпапки:

```text
my_project/
├── CMakeLists.txt        ← root
├── main.cpp
├── include/
│   └── my_math.h
└── src/
    ├── CMakeLists.txt    ← вложенный
    └── my_math.cpp
```

### Root `CMakeLists.txt`

```cmake
cmake_minimum_required(VERSION 3.17)
project(MyProject VERSION 1.0)
set(CMAKE_CXX_STANDARD 17)

# Своя переменная (используется в дочерних CMake)
set(MY_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)

add_subdirectory(src)
```

### `src/CMakeLists.txt`

```cmake
add_executable(my_proj ${CMAKE_SOURCE_DIR}/main.cpp my_math.cpp)
target_include_directories(my_proj PUBLIC ${MY_INCLUDE_DIR})
```

## CMake переменные

### Встроенные

| Переменная                    | Значение                    |
|-------------------------------|-----------------------------|
| `${CMAKE_SOURCE_DIR}`         | корневая папка проекта      |
| `${CMAKE_BINARY_DIR}`         | папка сборки (build/)       |
| `${CMAKE_CURRENT_SOURCE_DIR}` | текущая папка с CMakeLists  |
| `${PROJECT_NAME}`             | имя проекта из `project()`  |

### Свои

```cmake
set(MY_VAR "value")
message("Variable: ${MY_VAR}")
```

Объявленные в **родительском** CMake — доступны в дочерних через `add_subdirectory`.

## Структура хорошего C++ проекта

```text
my_project/
├── CMakeLists.txt           ← root config
├── README.md
├── .gitignore
├── include/                 ← публичные API
│   └── my_lib/              ← namespace-like группировка
│       ├── module1.h
│       └── module2.h
├── src/                     ← реализация
│   ├── CMakeLists.txt
│   ├── module1.cpp
│   └── module2.cpp
├── tests/                   ← тесты
│   ├── CMakeLists.txt
│   └── test_module1.cpp
└── build/                   ← out-of-source build (не коммитится)
```

## Compile-time vs Link-time errors

| Тип                       | Когда                                      | Решение                          |
|---------------------------|--------------------------------------------|----------------------------------|
| `undeclared identifier`   | Компиляция: нет `#include`                 | Добавить include                 |
| `expected ;` etc.         | Компиляция: синтаксис                      | Исправить                        |
| `undefined reference to`  | Линковка: нет реализации                   | Добавить .cpp в `add_executable` |
| `multiple definition of`  | Линковка: одно определение в нескольких .o | Перенести в .cpp / `inline`      |

## Practical relevance для DevOps

- **Open source convention:** все большие C++ проекты следуют src/include layout
- **Library packaging:** `install(TARGETS ... )` + `install(DIRECTORY include/ ...)`
- **CMake modules:** `find_package(Boost REQUIRED)` и т.д.
- **Modular projects:** каждый «компонент» = subdirectory с своим CMakeLists
- **CI builds:** out-of-source `mkdir build && cmake -B build && cmake --build build`

## Связь с другими модулями

- **M25.1:** header'ы и `#include`
- **M25.2:** базовый CMake (один-файловый)
- **M25.4 hwork:** наверняка multi-file проект с CMake
- **C++ best practices:** разделение interface/implementation — фундамент
