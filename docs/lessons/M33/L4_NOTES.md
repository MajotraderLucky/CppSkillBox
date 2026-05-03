# M33.4 — Знакомство с библиотекой Boost

**Длительность:** ~11 минут
**Тема:** обзорное знакомство с Boost, сборка из исходников, Boost.Asio (timer)

## Главная идея

> **Boost** = коллекция C++ библиотек **полу-стандартного** статуса.
> Многие фичи Boost позже **попадают в стандарт C++**.
>
> Активно используется в индустрии. Альтернатива STL для всего, чего в STL нет.

## Контекст

| Аспект              | Значение                                                                       |
|---------------------|--------------------------------------------------------------------------------|
| Сайт                | boost.org                                                                      |
| История             | С 90-х годов                                                                   |
| Размер              | Огромный (десятки мегабайт)                                                    |
| Содержание          | Сборник библиотек (algorithms / asio / json / regex / ...)                     |
| Лицензия            | Boost Software License (permissive)                                            |
| Связь со стандартом | Многие фичи (smart_ptr, optional, filesystem, thread) — изначально из Boost    |

> **Boost — нянька C++ стандарта.** Что хорошо обкаталось в Boost — попадает в `std::`.

## Установка из исходников

### Скачивание

1. boost.org → Downloads
2. Выбрать архив для своей платформы
3. Распаковать (например, в `C:\boost`)

### Подготовка окружения (Windows + MinGW)

1. Добавить MinGW `bin` в **PATH** (Environment Variables)
2. Открыть cmd → проверить: `gcc` → должна быть info
3. Перейти в директорию Boost: `cd C:\boost`

### Сборка

```bash
# 1. Bootstrap — генерирует b2 builder
bootstrap.bat gcc

# 2. b2 — собирает все библиотеки Boost
.\b2
```

> Сборка занимает много времени («заваривайте чай»). После успеха выводятся **пути к include и lib директориям** — их нужно скопировать в CMake.

## Подключение в CMake

```cmake
# Указываем CMake, где искать Boost
set(BOOST_INCLUDEDIR "C:/boost/boost_1_85_0")
set(BOOST_LIBRARYDIR "C:/boost/boost_1_85_0/stage/lib")

# Активируем CMake-поисковик Boost
find_package(Boost REQUIRED)

# Подключаем пути к header'ам и библиотекам
include_directories(${Boost_INCLUDE_DIRS})
link_directories(${Boost_LIBRARY_DIRS})

add_executable(my_app main.cpp)

# Линкуем найденную Boost к таргету
target_link_libraries(my_app PRIVATE ${Boost_LIBRARIES})

# Только для Windows + MinGW: добавить ws2_32 для Boost.Asio (sockets)
if (WIN32)
    target_link_libraries(my_app PRIVATE ws2_32)
endif()
```

> **Важно:** имена переменных `BOOST_INCLUDEDIR` / `BOOST_LIBRARYDIR` **должны** быть **именно такими** — это требует CMake-поисковика `find_package(Boost)`.

## Boost.Asio — пример с таймером

### Задача

> Подождать 5 секунд, потом вывести `Hello, Skillbox`.

```cpp
#include <iostream>
#include <boost/asio.hpp>

int main() {
    boost::asio::io_context  io;
    boost::asio::steady_timer timer(io, std::chrono::seconds(5));

    timer.wait();    // блокируется на 5 секунд

    std::cout << "Hello, Skillbox\n";
    return 0;
}
```

### Разбор

| Конструкция                                 | Назначение                                  |
|---------------------------------------------|---------------------------------------------|
| `boost::asio::io_context io`                | Контекст операций ввода-вывода (event loop) |
| `boost::asio::steady_timer t(io, duration)` | Таймер, привязанный к контексту             |
| `t.wait()`                                  | Блокирующее ожидание срабатывания           |

> Asio = **Asynchronous I/O**. Изначально библиотека для асинхронных сетевых операций; таймер — простейшая её часть.

> Многое в Boost.Asio дублирует современный `std::chrono` / `<thread>`, но Asio появилась **раньше** стандартизации этих фич.

## Почему многое в Boost дублирует STL

> Boost создавался **до** того, как многие фичи попали в стандарт.
>
> После C++11/14/17/20 — некоторые Boost-фичи **переехали в `std::`**:

| Из Boost            | Стало в std (версия)        |
|---------------------|-----------------------------|
| `boost::shared_ptr` | `std::shared_ptr` (C++11)   |
| `boost::thread`     | `std::thread` (C++11)       |
| `boost::function`   | `std::function` (C++11)     |
| `boost::optional`   | `std::optional` (C++17)     |
| `boost::filesystem` | `std::filesystem` (C++17)   |
| `boost::any`        | `std::any` (C++17)          |
| `boost::variant`    | `std::variant` (C++17)      |
| `boost::array`      | `std::array` (C++11)        |

## Что есть в Boost (краткий обзор)

| Категория           | Примеры компонентов                                |
|---------------------|----------------------------------------------------|
| Algorithms          | `boost::algorithm::string` (split, trim, replace)  |
| Generic Programming | `boost::mpl`, `boost::hana` (метапрограммирование) |
| I/O                 | Asio (network), Iostreams                          |
| Memory              | `pool`, `interprocess`                             |
| Concurrency         | `thread`, `lockfree`, `fiber`                      |
| Imaging             | GIL (image processing)                             |
| Math                | `multiprecision`, `numeric`                        |
| Networking          | Asio, Beast (HTTP/WebSocket)                       |
| Serialization       | binary/XML/text serialization                      |
| Strings             | regex, format, lexical_cast                        |
| JSON                | `boost::json` (новая, ~2020)                       |
| DateTime            | `boost::date_time`                                 |
| Filesystem          | `boost::filesystem` (теперь в std)                 |
| Test framework      | Boost.Test                                         |

> Полный список — `boost.org/doc/libs/`.

## Когда выбирать Boost vs STL

### Выбирать Boost
- Нужная фича **отсутствует** в STL (Asio, GIL, MPL, Spirit, ...)
- Целевая платформа использует старый стандарт (C++03, C++11) — а нужны фичи C++17+
- Много специализированного функционала под one task (image processing, parsing)

### Выбирать STL
- Фича уже есть в стандарте (smart_ptr, optional, filesystem, thread)
- Минимизация зависимостей
- Embedded / restricted environment
- Скорость сборки важна (Boost тяжёлый)

## Альтернативные варианты подключения

| Способ                | Описание                                                |
|-----------------------|---------------------------------------------------------|
| Из исходников + cmake | Урок (вручную скачать → b2 → CMake)                     |
| Package manager       | apt / brew / pacman (`apt install libboost-all-dev`)    |
| vcpkg / Conan         | C++ package managers (декларативно)                     |
| FetchContent          | CMake качает с GitHub (медленно)                        |

> Для **Linux** проще всего: `sudo apt install libboost-all-dev` → `find_package(Boost ...)` сам найдёт.

## Practical relevance для DevOps

- **Network programming:** Boost.Asio = стандарт для C++ network в pre-C++20 эпоху
- **HTTP/WebSocket:** Boost.Beast (на основе Asio)
- **Сериализация:** Boost.Serialization для бинарных дампов
- **Filesystem:** до C++17 — единственный кросс-платформенный способ работы с FS
- **Logging:** Boost.Log — гибкий логгер
- **Test framework:** Boost.Test — конкурент Catch2/GoogleTest
- **Где встречается:** OpenCV (image), Cisco/Bloomberg/financial — sockets/asio, Mongo C++ driver

## Связь с другими модулями

- **M25 CMake:** включение библиотек через `find_package`
- **M28 threads:** `std::thread` ↔ `boost::thread` (раньше)
- **M30 CPR:** альтернативой могла быть Boost.Beast
- **M32 nlohmann_json:** альтернатива — boost::json
- **M33.5 (next):** наверняка hwork модуля
- **C++ best practices:** «sometimes Boost is the only option, sometimes it's overkill»
