# M32.3 — Десериализация из JSON (nlohmann/json API)

**Длительность:** ~12 минут
**Тема:** API библиотеки `nlohmann/json` — запись, чтение, парсинг строк, файловый I/O

## Главная идея

> **`nlohmann::json`** = объект-словарь, по семантике похож на `std::map`,
> но с поддержкой **любых JSON-типов** (string/int/bool/null/array/object/double).
>
> Сериализация: `out << j;`. Десериализация: `in >> j;`. Просто.

## Подключение

```cpp
#include <nlohmann/json.hpp>

using json = nlohmann::json;       // удобный alias для типа
```

Namespace: `nlohmann`.

## Создание объекта и заполнение полей

```cpp
json dict;
dict["name"]   = "Vladislav";
dict["family"] = "Petrov";
dict["age"]    = 25;
dict["merit"]  = true;             // bool — без кавычек в JSON

std::ofstream out("record.json");
out << dict;                       // сериализация
```

### Что увидим в файле

```json
{"age":25,"family":"Petrov","merit":true,"name":"Vladislav"}
```

### Замечания

- **Числа** → без кавычек (`25`, `3.14`)
- **bool** → `true` / `false` без кавычек
- **string** → в кавычках
- **Поля сортируются по алфавиту** — порядок добавления не сохраняется (т.к. внутри `std::map`)

> Это **корректно по стандарту JSON** — порядок ключей не имеет значения.

## Шорткат: literal initialization

```cpp
json dict = {
    {"name",   "Vladislav"},
    {"family", "Petrov"},
    {"age",    25},
    {"merit",  true}
};
```

Синтаксис **похож на сам JSON** → красиво и читабельно.

> Магия C++ initializer-list. После курса можно копать глубже.

## Парсинг строкового литерала

```cpp
json j = R"(
    {"name": "Vladislav", "age": 25}
)"_json;                           // ← user-defined literal _json
```

или

```cpp
auto j = json::parse(R"({"name": "Vladislav"})");
```

Доступ к полю:
```cpp
std::string name = j["name"];      // implicit conversion
int         age  = j["age"];
```

## Полный пример: десериализация из файла

```cpp
#include <nlohmann/json.hpp>
#include <fstream>
#include <iostream>

using json = nlohmann::json;

struct Record {
    std::string name;
    std::string family;
    int         age;
    bool        merit;
};

int main() {
    json dict;
    {
        std::ifstream in("record.json");
        in >> dict;                // парсит весь файл в JSON-объект
    }

    Record r;
    r.name   = dict["name"];
    r.family = dict["family"];
    r.age    = dict["age"];
    r.merit  = dict["merit"];

    std::cout << r.name << " " << r.family << " "
              << r.age  << " " << r.merit << std::endl;
    // Output: Vladislav Petrov 25 1
    //                              ↑ bool → 1/0 по умолчанию
}
```

> `std::cout << bool` выводит `1` или `0`. Чтобы получить `true`/`false`: `std::cout << std::boolalpha << r.merit;`

## API summary

| Операция                  | Код                                      |
|---------------------------|------------------------------------------|
| Создать пустой            | `json j;`                                |
| Установить поле           | `j["key"] = value;`                      |
| Прочитать поле            | `auto v = j["key"].get<T>();`            |
| Implicit cast             | `int x = j["age"];`                      |
| Initializer-list          | `json j = {{"k1", "v1"}, {"k2", 2}};`    |
| Из строки                 | `auto j = R"({...})"_json;`              |
| Парсинг                   | `json::parse(str_or_stream);`            |
| Запись в файл             | `out << j;`                              |
| Чтение из файла           | `in >> j;`                               |
| Pretty print (4 space)    | `out << j.dump(4);`                      |
| Проверка наличия ключа    | `if (j.contains("k")) { ... }`           |
| Тип значения              | `j["k"].is_string() / is_number() / ...` |
| Массив                    | `json arr = {1, "x", true};`             |
| Размер                    | `j.size()`                               |
| Итерация                  | `for (auto& [k, v] : j.items()) { ... }` |

## Сравнение с std::map

| Аспект           | `std::map<string, string>` | `nlohmann::json`            |
|------------------|----------------------------|-----------------------------|
| Тип значения     | Один (string)              | Любой JSON-тип              |
| Сериализация     | Вручную                    | `<<` из коробки             |
| Парсинг          | Нет                        | `parse()` / `>>`            |
| Вложенность      | Нет (плоский)              | Да (`j["a"]["b"]`)          |
| Массивы          | Нет                        | Да                          |

## Подводные камни

### 1. Доступ к несуществующему ключу
```cpp
auto v = j["missing"];          // создаёт пустой узел!
```
Лучше:
```cpp
if (j.contains("missing")) { ... }
auto v = j.value("missing", default_val);   // safe access с default
```

### 2. Type mismatch при чтении
```cpp
int x = j["name"];              // throws json::type_error если name — string!
```
Защита:
```cpp
if (j["name"].is_number_integer()) {
    int x = j["name"];
}
```

### 3. Pretty print
По умолчанию JSON пишется в **одну строку**. Для читаемости:
```cpp
out << j.dump(4);               // 4-space indent
```

## Practical relevance для DevOps

- **Конфиги:** `json cfg; std::ifstream("config.json") >> cfg;`
- **HTTP клиент:** `auto resp = json::parse(http_response);`
- **Schema валидация:** через json-schema-validator
- **Диагностика:** `std::cerr << j.dump(2);` — pretty print любого объекта
- **REST API:** клиент генерирует request bodies через json initializer-list
- **Logging:** structured logs — `json log; log["level"]="info"; log["msg"]=msg;`

## Что дальше

> «В следующем уроке мы познакомимся с протоколом **Buffers**» — Protocol Buffers (protobuf), бинарный аналог JSON от Google.

## Связь с другими модулями

- **M32.1, M32.2:** теория и подключение библиотеки → теперь активное использование
- **M22 std::map:** тот же ментальный паттерн, но более мощный
- **M30 HTTP CPR:** `json::parse(response.text)` — обработка REST ответов
- **M32.4+ (next):** Protocol Buffers (бинарный формат)
