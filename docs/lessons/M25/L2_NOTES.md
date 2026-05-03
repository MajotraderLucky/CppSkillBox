# M25.2 — Сборка проекта (CMake)

**Длительность:** ~10 минут
**Тема:** компилятор + линкер, build systems, базовый `CMakeLists.txt`

## Главная идея

> Программа = compile (множество `.cpp` → `.o`) + link (`.o` + libs → executable).
> CMake — **build-конфигурация** (де-факто стандарт C++).

## Pipeline сборки

```text
*.cpp + *.h
    ↓ компилятор
*.o (object files, бинарники с кодом)
    ↓ линкер
исполняемый файл (или библиотека)
```

- **Compiler** (gcc/clang/MSVC) — компилирует каждый `.cpp` в `.o`
- **Linker** — объединяет `.o` файлы и библиотеки в финальный binary

## Что такое build system

Когда файлов много — нужен **сборщик**:
- Знает зависимости (`main.cpp` зависит от `my_math.h`)
- Перекомпилирует **только изменившиеся** файлы
- Запускает компилятор + линкер с правильными флагами

**Популярные build systems:** make, CMake, Bazel, Meson, Ninja, MSBuild.

> **CMake** — де-факто стандарт для C/C++ open source.
> Сам написан на C. Используется по умолчанию в CLion.

## Базовый CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.17)
project("My Project" VERSION 1.0 DESCRIPTION "Sample C++ app")

set(CMAKE_CXX_STANDARD 14)

add_executable(my_project main.cpp my_math.h)
```

## Разбор директив

### `cmake_minimum_required(VERSION 3.17)`

> Указывает **минимальную версию CMake**, требуемую для сборки.

- Если у пользователя младше — CMake остановится с ошибкой
- CMake обратно совместим: новая версия может собрать старый проект
- Важно для воспроизводимости

### `project(...)`

```cmake
project("My Project" VERSION 1.0 DESCRIPTION "Sample C++ app")
```

- **Имя** проекта (в кавычках если есть пробелы)
- **VERSION** — semver: `MAJOR.MINOR.PATCH`
  - MAJOR — несовместимые изменения
  - MINOR — новые фичи (совместимо)
  - PATCH — багфиксы
- **DESCRIPTION** — для документации (опционально)

### `set(CMAKE_CXX_STANDARD 14)`

> Версия стандарта C++ (11/14/17/20/23).

Чем выше:
- Больше возможностей языка (auto, lambda, concepts, ...)
- Меньше совместимость со старыми компиляторами
- Современные компиляторы (GCC ≥ 11, Clang ≥ 12) поддерживают C++20

### `add_executable(...)`

```cmake
add_executable(my_project main.cpp my_math.h)
#               ^^^^^^^^^^ ^^^^^^^^^^^^^^^^^
#               имя exe    исходники + headers
```

- **Имя** исполняемого файла (без `.exe` — добавится автоматически на Windows)
- **Файлы**: все `.cpp` (компилируются) + все `.h` (отслеживаются для перекомпиляции)
- **Без пробелов в имени** — иначе проблемы в shell

> **Headers тоже добавляем** — иначе CMake не отследит их изменения,
> и не пересоберёт зависимый код.

## Полный пример проекта

```text
my_project/
├── CMakeLists.txt
├── main.cpp
└── my_math.h
```

**CMakeLists.txt:**
```cmake
cmake_minimum_required(VERSION 3.17)
project("MyMath Demo" VERSION 1.0)
set(CMAKE_CXX_STANDARD 17)
add_executable(my_math_demo main.cpp my_math.h)
```

**Сборка из терминала:**
```bash
mkdir build && cd build
cmake ..              # генерация Makefile
cmake --build .       # компиляция + линковка
./my_math_demo        # запуск
```

## Почему CMake умный

```text
1) Изменили main.cpp → перекомпиляция main.cpp + линковка
2) Изменили my_math.h → перекомпиляция main.cpp (зависит) + линковка
3) Ничего не меняли → "Nothing to do" — за 0.1 секунды
```

CMake создаёт граф зависимостей и **минимизирует работу**.

## Уровни абстракции

| Уровень       | Инструмент        | Что делает                    |
|---------------|-------------------|-------------------------------|
| Описание      | `CMakeLists.txt`  | декларативная конфигурация    |
| Генерация     | `cmake ..`        | создаёт Makefile / Ninja      |
| Сборка        | `make` / `ninja`  | компилирует + линкует         |
| Компиляция    | `g++` / `clang++` | .cpp → .o                     |
| Линковка      | `ld` / `gold`     | .o + libs → executable        |

## Practical relevance для DevOps

- **CI/CD pipelines:** `cmake .. && cmake --build . && ctest` — стандарт
- **Cross-compilation:** CMake toolchains для ARM/embedded
- **Docker:** copy исходники, `RUN cmake -B build && cmake --build build`
- **Library packaging:** `add_library` + `install` для своих .so/.a
- **Find packages:** `find_package(Boost REQUIRED)` — интеграция с системными libs

## Альтернативы CMake

- **Make** — проще, но без cross-platform
- **Bazel** (Google) — для очень больших проектов
- **Meson** — проще CMake, набирает популярность
- **Ninja** — быстрый builder (CMake может генерировать Ninja вместо Make)
- **xmake**, **Conan**, **vcpkg** — пакетные менеджеры C++

## Связь с другими модулями

- **M25.1:** header'ы — теперь видим, как они учитываются в CMake
- **M25.3 (next):** структура проекта на много файлов, разделение .h / .cpp
- **DevOps:** базовая грамотность по CMake — must-have для C++ инженера
- **Open source contributions:** все большие C++ проекты используют CMake
