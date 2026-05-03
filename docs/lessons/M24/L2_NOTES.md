# M24.2 — Форматирование дат

**Длительность:** ~4 минуты
**Тема:** `std::put_time`, format-spec символы для даты/времени

## Главная идея

> `std::put_time(tm*, format)` — форматный вывод даты как `cout << put_time(...)`.
> Format-спецификаторы похожи на `printf` — но для полей структуры `std::tm`.

## Импорт

```cpp
#include <iomanip>      // <-- здесь put_time, setprecision, setw
#include <ctime>        // std::tm, std::time, std::localtime
```

`iomanip` = «io manipulation» — настройка ввода-вывода.

## Базовое использование

```cpp
std::time_t now = std::time(nullptr);
std::tm* lt = std::localtime(&now);

std::cout << std::put_time(lt, "%Y-%m-%d");
// 2026-05-03
```

## Аргументы put_time

```cpp
std::put_time(const std::tm* time, const char* format);
//             ^^^^^^^^^^^^^^^^    ^^^^^^^^^^^^^^^^^
//             указатель на tm     format-string
```

`put_time` возвращает не строку, а **специальный manipulator-объект**.
Используется только в потоке: `cout << put_time(...)`.

## Format-спецификаторы

| Спец  | Значение                 | Пример вывода |
|-------|--------------------------|---------------|
| `%Y`  | год 4-значный            | 2026          |
| `%y`  | год 2-значный            | 26            |
| `%m`  | месяц (01-12)            | 05            |
| `%d`  | день месяца (01-31)      | 03            |
| `%H`  | час 24h (00-23)          | 16            |
| `%I`  | час 12h (01-12)          | 04            |
| `%M`  | минута (00-59)           | 30            |
| `%S`  | секунда (00-59)          | 12            |
| `%A`  | день недели полностью    | Sunday        |
| `%a`  | день недели сокращ.      | Sun           |
| `%B`  | месяц словом             | May           |
| `%b`  | месяц сокращ.            | May           |
| `%p`  | AM/PM                    | PM            |
| `%j`  | день года (001-366)      | 123           |
| `%Z`  | часовой пояс             | MSK           |

## Примеры

### Дата YYYY-MM-DD

```cpp
std::cout << std::put_time(lt, "%Y-%m-%d");
// 2026-05-03
```

### Дата + время

```cpp
std::cout << std::put_time(lt, "%Y-%m-%d %H:%M:%S");
// 2026-05-03 16:30:45
```

### Локализованный

```cpp
std::cout << std::put_time(lt, "%A, %d %B %Y");
// Sunday, 03 May 2026
```

### ISO 8601

```cpp
std::cout << std::put_time(lt, "%Y-%m-%dT%H:%M:%S");
// 2026-05-03T16:30:45
```

## Сравнение трёх способов вывода

```cpp
std::tm* lt = std::localtime(&now);

// 1) Готовая строка (фиксированный формат)
std::cout << std::asctime(lt);
// "Sun May  3 16:30:45 2026\n"

// 2) Поле за полем (вручную)
std::cout << (lt->tm_year + 1900) << "-"
          << (lt->tm_mon + 1) << "-"
          << lt->tm_mday;

// 3) put_time (рекомендуется)
std::cout << std::put_time(lt, "%Y-%m-%d");
```

## Аналогия с printf

| `printf`         | `put_time`           |
|------------------|----------------------|
| `%d` → int       | `%d` → день месяца   |
| `%s` → строка    | `%S` → секунда       |
| `%f` → float     | (нет)                |
| строка-формат    | строка-формат        |

В printf `%d` — целое число, в put_time — день. Контекст разный.

## Practical relevance для DevOps

- **Логи с timestamp:** `[2026-05-03 16:30:45] message`
- **Файлы по дате:** `logs/app-%Y-%m-%d.log`
- **ISO 8601 для API:** `2026-05-03T16:30:45Z`
- **Cron-файлы:** дата в имени для ротации
- **HTTP Date headers:** `%a, %d %b %Y %H:%M:%S GMT`

## Связь с другими модулями

- **M24.1:** базовый API `time/localtime/asctime`
- **M24.3 (next):** ввод дат (parsing) — `std::get_time`
- **M2.x setprecision/setw:** другие манипуляторы из `<iomanip>`
- **printf (старый C):** концептуально схожий формат-string подход
