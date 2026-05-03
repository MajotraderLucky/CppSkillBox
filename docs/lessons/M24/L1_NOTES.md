# M24.1 — Подходы к работе с датами

**Длительность:** ~5 минут
**Тема:** `std::time`, `std::localtime`, `std::asctime` — POSIX time API в C++

## Главная идея

> Время в C/C++ → POSIX timestamp (секунды с 1970-01-01 UTC).
> Конвертация в человеческий формат: `time → localtime → asctime`.

## Контекст: srand(time(nullptr))

Уже знакомая конструкция:

```cpp
#include <ctime>
std::srand(std::time(nullptr));
```

- `std::time(...)` возвращает «зерно» — текущее время в секундах
- `srand` инициализирует генератор разным значением при каждом запуске

## std::time — POSIX timestamp

```cpp
#include <ctime>
#include <iostream>

std::time_t now = std::time(nullptr);
std::cout << now;   // например 1714745912
```

### Формат

- **Стандарт C++:** тип `std::time_t`, формат не специфицирован
- **На практике:** Unix epoch — секунды с **1970-01-01 00:00:00 UTC**
- Часовой пояс: **UTC** (не локальный!)

### Параметр функции

```cpp
std::time_t std::time(std::time_t* arg);
```

- `arg = nullptr` — игнорировать, просто вернуть значение
- `arg = указатель` — записать туда же что вернётся (исторический legacy)

> **Используем `nullptr` всегда.** Альтернатива — наследие старого C-API.

## std::localtime — конвертация в локальное время

```cpp
std::time_t now = std::time(nullptr);
std::tm* lt = std::localtime(&now);

std::cout << lt->tm_hour;   // часы (0-23) в местном поясе
```

### struct std::tm — поля

```cpp
struct tm {
    int tm_sec;    // секунды (0-60, leap-second)
    int tm_min;    // минуты (0-59)
    int tm_hour;   // часы (0-23)
    int tm_mday;   // день месяца (1-31)
    int tm_mon;    // месяц (0-11, ! не 1-12)
    int tm_year;   // год от 1900 (т.е. 124 = 2024)
    int tm_wday;   // день недели (0=воскресенье)
    int tm_yday;   // день года (0-365)
    int tm_isdst;  // летнее время (1/0/-1)
};
```

### ВАЖНО: ловушки std::tm

- `tm_mon` от **0** (январь = 0, а не 1)
- `tm_year` от **1900** (для 2024 → значение 124)
- Значения часто путают → bugs

## std::asctime — готовая строка

Если не хочется вручную форматировать:

```cpp
std::time_t now = std::time(nullptr);
std::tm* lt = std::localtime(&now);
std::cout << std::asctime(lt);
// вывод: "Sun May  3 16:30:00 2026\n"
```

`asctime` возвращает `char*` на статический буфер с фиксированным форматом
+ `\n` в конце.

## Конвейер «человеческое время»

```text
std::time(nullptr)         std::localtime(&t)         std::asctime(tm)
       ↓                            ↓                          ↓
 std::time_t              std::tm*                    char*
 (секунды UTC)            (struct, локальное)         "Sun May 3 ..."
```

## Полный пример

```cpp
#include <ctime>
#include <iostream>

int main() {
    std::time_t now = std::time(nullptr);
    std::cout << "Unix:    " << now << "\n";

    std::tm* lt = std::localtime(&now);
    std::cout << "Час:     " << lt->tm_hour << "\n";
    std::cout << "Год:     " << (lt->tm_year + 1900) << "\n";
    std::cout << "Месяц:   " << (lt->tm_mon + 1) << "\n";

    std::cout << std::asctime(lt);
}
```

## Свойства старого API (`<ctime>`)

- **Не thread-safe:** `localtime` возвращает указатель на статический буфер
- **Год от 1900:** легко забыть и получить 124 вместо 2024
- **Месяц от 0:** аналогично
- **Глобальное состояние:** taking address of returned pointer бессмысленно

## Современная альтернатива (C++11/20)

```cpp
#include <chrono>
auto now = std::chrono::system_clock::now();
auto t   = std::chrono::system_clock::to_time_t(now);
```

C++20: `std::chrono::zoned_time`, `std::format` — type-safe и thread-safe.

В курсе будет стандартный `<ctime>` — он есть везде и достаточен для базовых задач.

## Practical relevance для DevOps

- **Логирование с timestamps:** epoch in logs, отличный grep/sort
- **Cron-задачи:** проверка времени запуска
- **Metrics:** Unix epoch — стандарт в Prometheus/Grafana
- **TLS certificates:** срок действия в Unix time
- **HTTP headers:** `Date:` всегда GMT/UTC

## Связь с другими модулями

- **M2 srand:** теперь понимаем что значит `time(nullptr)` как seed
- **M24.2 (next):** более продвинутое форматирование времени
- **M24.5 hwork:** практика работы с датами
