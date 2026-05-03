# M30.1 — Подключение и настройка CPR

**Длительность:** ~10 минут
**Тема:** HTTP, libcurl, CPR (C++ обёртка), CMake FetchContent

## Главная идея

> **CPR** = "C++ Requests" — современная C++ обёртка над **libcurl**.
> Подключается через CMake `FetchContent` (скачивание из GitHub).

## Контекст: HTTP и libcurl

- **HTTP** = Hypertext Transfer Protocol — протокол всемирной сети
- **libcurl** = C-библиотека, стандарт индустрии для HTTP/HTTPS/FTP/...
- **CPR** = C++ обёртка над libcurl, "curl for humans"
- **GitHub:** `https://github.com/libcpr/cpr`

## Подключение через CMake FetchContent

`CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.15)
project(MyApp VERSION 1.0)
set(CMAKE_CXX_STANDARD 17)

# === Настройки до FetchContent ===
# Отключить автоматизированные тесты CPR (могут не собраться на Windows)
set(BUILD_CPR_TESTS OFF)

# Отключить шифрование (HTTPS) — простая HTTP-only сборка
set(CPR_USE_SYSTEM_CURL OFF)
set(CMAKE_USE_OPENSSL OFF)

# Все библиотеки в одну директорию с .exe
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

# === Подключение CPR ===
include(FetchContent)
FetchContent_Declare(
    cpr
    GIT_REPOSITORY https://github.com/libcpr/cpr.git
    GIT_TAG       1.10.5   # или другая стабильная версия
)
FetchContent_MakeAvailable(cpr)

# === Сборка ===
add_executable(my_app main.cpp)
target_link_libraries(my_app PRIVATE cpr::cpr)
```

## Разбор по строчкам

### `include(FetchContent)`

Аналог `#include` для CMake — подключает функционал автоматического скачивания.

### `FetchContent_Declare(...)`

Объявление: имя, репозиторий, тег/коммит. CMake скачает библиотеку при первой сборке.

### `FetchContent_MakeAvailable(cpr)`

Делает модуль доступным под именем `cpr` (используем в `target_link_libraries`).

### Output directories

```cmake
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
```

`.exe` и `.dll` (или `.so`) должны быть в одной папке — иначе runtime не найдёт библиотеку.

> **Эти переменные ОБЯЗАТЕЛЬНО задавать ДО `FetchContent`** — иначе CPR соберётся с другими настройками.

### `target_link_libraries(my_app PRIVATE cpr::cpr)`

Привязывает библиотеку к программе:
- `PRIVATE` — только для самого app (не транзитивно)
- `cpr::cpr` — CMake namespace (стандартная конвенция)

## Использование в коде

```cpp
#include <iostream>      // стандартные сначала

#include <cpr/cpr.h>     // потом внешние

int main() {
    cpr::Response r = cpr::Get(cpr::Url{"http://example.com"});
    std::cout << "Status: " << r.status_code << "\n";
    std::cout << "Body: "   << r.text;
}
```

> **Convention:** стандартные `#include <...>` ДО внешних библиотек.

## CMake настройки CPR (важные флаги)

| Переменная                | Что отключает                             |
|---------------------------|-------------------------------------------|
| `BUILD_CPR_TESTS=OFF`     | Внутренние тесты CPR (могут не собраться) |
| `CPR_USE_SYSTEM_CURL=OFF` | Качать свой curl, не системный            |
| `CMAKE_USE_OPENSSL=OFF`   | Без HTTPS (только HTTP)                   |

> **Документация:** `https://docs.libcpr.org/` — полный список настроек.

## CLion-specific: Toolchain

> **Учитель:** убедитесь что **MinGW** активен в Toolchains.
> Если нужно — перетащить MinGW наверх в списке.

В Linux/macOS — обычно gcc/clang работают из коробки.

## Workflow

1. Открыть `CMakeLists.txt` в редакторе
2. Скопировать FetchContent-блок из README CPR
3. Настроить: отключить тесты, шифрование, output directories
4. **Перенести `set(...)` ДО `FetchContent`**
5. Reload CMake configuration в IDE
6. `Build` → собирается весь проект + CPR
7. Использовать `cpr::Get/Post/...` в коде

## Practical relevance для DevOps

- **HTTP-клиенты в C++:** обращение к REST API, microservices
- **Health checks:** простой curl-вызов из C++ daemon'а
- **Webhooks:** отправка POST на Slack/Telegram/PagerDuty
- **Скачивание ресурсов:** конфиги, обновления, sсhemas
- **CMake FetchContent:** альтернатива git submodules / vcpkg / conan
- **Альтернативы CPR:** Boost.Beast, cpp-httplib, drogon (header-only вариант)

## Связь с другими модулями

- **M25 CMake:** базовые `add_executable`, `target_include_directories`
- **M30.2+ (next):** GET/POST запросы через CPR
- **M30.5 hwork:** наверняка интеграция с реальным API
- **DevOps grammar:** HTTP-клиент в C++ для системных утилит — must-know
