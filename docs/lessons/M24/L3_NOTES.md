# M24.3 — Создание и ввод даты

**Длительность:** ~3 минуты
**Тема:** `std::get_time` — парсинг даты из stream, важность инициализации `std::tm`

## Главная идея

> `std::get_time(tm*, format)` — симметрично `put_time`, но для **ввода**.
> ⚠ Перед использованием инициализируй tm через `localtime` — иначе мусор!

## Синтаксис

```cpp
#include <iomanip>
#include <ctime>

std::tm t = {};   // ВСЁ В НУЛЯХ или инициализировать через localtime
std::cin >> std::get_time(&t, "%H:%M");
```

| Параметр  | Тип            | Назначение                |
|-----------|----------------|---------------------------|
| 1-й       | `std::tm*`     | сюда запишется результат  |
| 2-й       | `const char*`  | format-string             |

Format-спецификаторы те же, что у `put_time` (`%H`, `%M`, `%Y`, `%m`, `%d`...).

## Пример: ввод часов и минут

```cpp
std::tm local;
std::cin >> std::get_time(&local, "%H:%M");
std::cout << std::asctime(&local);
```

**Если просто объявить `std::tm local;`** — мусор в полях `tm_year`, `tm_mday`...
Программа выведет `Error` или невалидную дату.

## Правильная инициализация

```cpp
std::time_t now = std::time(nullptr);
std::tm     local = *std::localtime(&now);   // копия текущего времени

std::cin >> std::get_time(&local, "%H:%M");
// Поля, не упомянутые в формате (год, месяц, день), остаются текущими
std::cout << std::asctime(&local);
```

> **Причина:** `get_time` инициализирует **только** поля, упомянутые в формате.
> Остальные останутся такими, какими были перед вызовом.

## Сравнение get_time vs put_time

| Аспект       | put_time              | get_time              |
|--------------|-----------------------|-----------------------|
| Поток        | output (`cout`)       | input (`cin`)         |
| Аргумент 1   | `const std::tm*`      | `std::tm*` (mutable)  |
| Аргумент 2   | format string         | format string         |
| Header       | `<iomanip>`           | `<iomanip>`           |
| Возвращает   | manipulator           | manipulator           |

## Полный пример

```cpp
#include <ctime>
#include <iomanip>
#include <iostream>

int main() {
    std::time_t now = std::time(nullptr);
    std::tm     dt  = *std::localtime(&now);   // защита от мусора

    std::cerr << "Введите дату (YYYY-MM-DD): ";
    std::cin >> std::get_time(&dt, "%Y-%m-%d");

    if (std::cin.fail()) {
        std::cerr << "Не смог распарсить дату\n";
        return 1;
    }

    std::cout << std::put_time(&dt, "%A, %d %B %Y") << "\n";
    // Sunday, 03 May 2026
}
```

## Проверка успеха парсинга

После `cin >> get_time` проверяем:

```cpp
if (std::cin.fail()) {
    // парсинг не удался
}
```

Состояние потока становится `failbit` если формат не совпал.

## Идиоматичная пара put/get

```cpp
// Round-trip: распарсить и вывести в другом формате
std::tm t = *std::localtime(&now);
std::cin  >> std::get_time(&t, "%d.%m.%Y");      // ввод DD.MM.YYYY
std::cout << std::put_time(&t, "%Y-%m-%d");      // вывод YYYY-MM-DD
```

## Practical relevance для DevOps

- **Парсинг логов:** timestamps в разных форматах (Apache, nginx, syslog)
- **CLI-аргументы:** `--from-date 2026-05-03` → `std::tm`
- **Конфиги:** даты планировщика в YAML/JSON
- **Замена кустарных stoi+substr:** одна строка вместо ручной разборки

## Связь с другими модулями

- **M24.2:** put_time — симметрия input/output
- **M24.4 hwork:** наверняка задачи на ввод/вывод дат
- **M19/M20 file I/O:** get_time работает на любом istream, не только cin
- **C strptime:** аналогичный API в C
