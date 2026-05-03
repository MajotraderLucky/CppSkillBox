# M32.2 — Сериализация в JSON (ручная и через библиотеку)

**Длительность:** ~10 минут
**Тема:** ручная запись JSON в файл, подключение `nlohmann/json`

## Главная идея

> **Ручная сериализация JSON через `<<` → ад из escape-кавычек.**
>
> Решение — библиотека **JSON for Modern C++** (`nlohmann/json`),
> header-only, через **CMake FetchContent / embedded**.

## Задача урока

Сериализовать пользовательскую запись (Record):

```cpp
struct Record {
    std::string name;
    std::string family;
    int         age;
};
```

→ Сохранить в файл `record.json`.

## Шаг 1: Ручная сериализация (без библиотеки)

```cpp
#include <fstream>
#include <iostream>
#include <string>

struct Record {
    std::string name;
    std::string family;
};

int main() {
    Record r;
    std::cout << "Name: ";   std::cin >> r.name;
    std::cout << "Family: "; std::cin >> r.family;

    std::ofstream out("record.json");

    out << "{ ";
    out << "\"name\": \""   << r.name   << "\", ";
    out << "\"family\": \"" << r.family << "\"";
    out << " }";

    return 0;
}
```

### Результат

```json
{ "name": "John", "family": "Doe" }
```

> JSON **не чувствителен** к переводам строк — можно писать в одну строку.

### Проблемы ручного подхода

- **Escape-ад:** каждое `"` нужно экранировать как `\"` → `\"name\": \"`
- Запятые между полями нужно расставлять **правильно** (после последнего поля **нельзя**)
- Добавление одного поля → переписывать всю строку вывода
- Типы кроме `string` — нужно конвертировать вручную

> Добавим `int age;` — строка вывода становится в полтора раза длиннее, и нужно решить как форматировать число (без кавычек).

## Шаг 2: Подключаем библиотеку nlohmann/json

> **Автор:** Niels Lohmann
> **Репо:** `https://github.com/nlohmann/json`
> **Полное имя:** «JSON for Modern C++»
> **Особенности:** header-only, идиоматичный C++ API, поддержка CMake

### Способы подключения

| Способ                | Описание                                         |
|-----------------------|--------------------------------------------------|
| Embedded              | Скачать ZIP с GitHub → положить в дерево проекта |
| FetchContent          | CMake качает автоматически (как M30 CPR)         |
| System package        | apt/brew/vcpkg                                   |
| Single header         | `json.hpp` напрямую — самый простой              |

### Способ из урока: Embedded ZIP

1. На GitHub → `Code` → `Download ZIP`
2. Распаковать в корень проекта
3. **Переименовать** папку в `nlohmann_json` (с подчёркиванием!)
   > **Errata от преподавателя:** в видео папка называется `nlohmann json` (с пробелом), но правильно — `nlohmann_json`. Документация требует именно с подчёркиванием.

### CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.15)
project(JsonDemo CXX)
set(CMAKE_CXX_STANDARD 17)

# === Подключение nlohmann_json ===
set(JSON_BuildTests OFF)            # отключить unit-тесты библиотеки
add_subdirectory(nlohmann_json)

# === Сборка ===
add_executable(json_demo main.cpp)
target_link_libraries(json_demo PRIVATE nlohmann_json::nlohmann_json)
```

> **Аналогия с M30 (CPR):** там был `FetchContent`, здесь — `add_subdirectory`. Принцип тот же: библиотека интегрируется как модуль CMake, target-name `nlohmann_json::nlohmann_json`.

### Использование в коде

```cpp
#include <nlohmann/json.hpp>

using json = nlohmann::json;
```

## Сравнение подходов

| Аспект                | Ручной `<<`                  | nlohmann_json                |
|-----------------------|------------------------------|------------------------------|
| Escape кавычек        | Вручную: `\"`                | Автоматически                |
| Запятые между полями  | Вручную                      | Автоматически                |
| Типы                  | Конвертация в строку         | Авто (int/string/bool)       |
| Добавление поля       | Дописать `<<` строку         | `j["age"] = 42;`             |
| Парсинг (десериал.)   | Парсер с нуля                | `json::parse(stream)`        |
| Размер кода           | Много строк                  | Несколько строк              |

## Practical relevance для DevOps

- **API responses:** `json j = json::parse(http_response);`
- **Конфиги:** загрузка config.json в C++ daemon
- **Logging:** `json log_entry; log_entry["ts"] = now; ...`
- **Schema validation:** через `json-schema-validator`
- **Best practice:** не парсь JSON regex'ами и не пиши вручную — используй библиотеку

## Связь с другими модулями

- **M19-M20 file I/O:** теперь умеем структурированно писать
- **M22 std::map:** json объект ≈ map<string, json>
- **M30 CPR + FetchContent:** аналогичный pattern подключения библиотеки
- **M32.3+ (next):** использование nlohmann/json API (авторозыгрыш `j["k"] = v`)
