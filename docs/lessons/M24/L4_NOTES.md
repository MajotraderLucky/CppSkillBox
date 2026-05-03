# M24.4 — Манипуляции с датами

**Длительность:** ~3 минуты
**Тема:** `std::difftime` — разница между метками времени, прибавление секунд

## Главная идея

> `std::difftime(t1, t0)` = `t1 - t0` в **секундах**, возвращает `double`.
> Прибавление секунд к `time_t` — простое арифметическое действие.

## std::difftime

```cpp
#include <ctime>

std::time_t a = std::time(nullptr);
// ... что-то долго делаем ...
std::time_t b = std::time(nullptr);

double seconds = std::difftime(b, a);   // = b - a (в секундах)
```

### Сигнатура

```cpp
double std::difftime(std::time_t end, std::time_t beginning);
```

- Возвращает `double` — секунды
- Семантика: **аргументы как (newer, older)** — то есть `end - beginning`
- Зачем не просто `b - a`? Стандарт не гарантирует что `time_t` арифметический
  (на практике это int, но difftime — портативный API)

## Прибавление секунд (move into future)

```cpp
std::time_t a = std::time(nullptr);
// ... ждём ...
std::time_t b = std::time(nullptr);

double delta = std::difftime(b, a);

std::time_t future = static_cast<std::time_t>(b + delta);
std::tm* lt = std::localtime(&future);
std::cout << std::asctime(lt);
```

**Принцип:** `time_t` хранит секунды → можно прибавить число секунд напрямую,
получив новую метку.

## Практический пример: бенчмарк

```cpp
std::time_t start = std::time(nullptr);

// долгое действие
heavyComputation();

std::time_t end = std::time(nullptr);
std::cout << "Заняло " << std::difftime(end, start) << " секунд\n";
```

> **Точность:** только секунды. Для миллисекунд/наносекунд используй `<chrono>`.

## Прямая модификация полей std::tm

```cpp
std::tm t = *std::localtime(&now);
t.tm_sec += 30;          // прибавить 30 секунд

// Но НЕ так просто:
//   tm_sec = 75 → невалидное значение!
//   tm_mon = 13 → 13-й месяц???
//   tm_mday = 32 → 32-е число???
```

**Решение: `std::mktime`** — нормализует структуру:

```cpp
std::tm t = *std::localtime(&now);
t.tm_sec += 3600 * 24;   // прибавить день (через секунды)
std::time_t normalized = std::mktime(&t);
// теперь t содержит корректную дату на сутки вперёд
```

**`mktime`** конвертирует `tm → time_t` И заодно «чинит» переполнения
(75 секунд = +1 минута + 15 секунд).

## Сводная таблица операций со временем

| Операция                    | Функция                |
|-----------------------------|------------------------|
| Текущая метка               | `std::time(nullptr)`   |
| time_t → tm (local)         | `std::localtime(&t)`   |
| time_t → tm (UTC)           | `std::gmtime(&t)`      |
| tm → time_t (нормализация)  | `std::mktime(&tm)`     |
| Готовая строка из tm        | `std::asctime(&tm)`    |
| Готовая строка из time_t    | `std::ctime(&t)`       |
| Разница (b - a)             | `std::difftime(b, a)`  |
| Форматный вывод             | `std::put_time`        |
| Форматный ввод              | `std::get_time`        |

## Practical relevance для DevOps

- **Timeouts:** `if (difftime(now, start) > 30) abort()` — простой timeout
- **Scheduling:** «через N секунд» = `now + N` → `mktime`
- **Cron-like логика:** «следующий запуск 03:00 завтра» через `tm`-манипуляции
- **Лог анализ:** разница между событиями для метрик latency
- **Cache TTL:** `difftime(now, cached_at) > ttl` → invalidate

## Современная альтернатива (`<chrono>`)

```cpp
#include <chrono>
auto t1 = std::chrono::steady_clock::now();
// ...
auto t2 = std::chrono::steady_clock::now();
auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1).count();
```

`<chrono>`:
- Поддержка наносекунд / миллисекунд (через типы)
- Type-safe: `seconds + minutes` работает корректно
- Steady_clock — монотонные часы (нет jumps от NTP)

В курсе ограничились `<ctime>`. В реальном коде C++14+ → используйте `<chrono>`.

## Связь с другими модулями

- **M24.1-3:** базовые операции (time, localtime, asctime, put/get_time)
- **M24.5 hwork:** наверняка задачи на разницу дат / интервалы
- **C++ chrono:** modern alternative
