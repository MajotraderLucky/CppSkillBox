# M19.2 — Чтение разных типов данных из файла

**Длительность:** ~5 минут
**Тема:** `>>` оператор работает с файлом так же как с std::cin

## Главная идея

> Чтение из ifstream — **тот же синтаксис** что и из `std::cin`, через `>>`.

## Базовый пример

```cpp
#include <iostream>
#include <fstream>

int main() {
    std::ifstream bank;
    bank.open("bank.txt", std::ios::binary);

    int money;
    bank >> money;          // считает первое целое
    std::cout << money;     // напр. 100

    int next;
    bank >> next;           // курсор продвинут — считает следующее
    std::cout << " " << next;  // 200

    bank.close();
    return 0;
}
```

## Курсор файла

После каждого `>>`:
- Курсор сдвигается вперёд на длину прочитанного слова
- Пробелы и переносы строк — разделители (как у `cin`)

## Чтение разных типов

Тип переменной определяет — что считывается:

```cpp
int x;        bank >> x;     // целое
double d;     bank >> d;     // дробное (3.14)
std::string s; bank >> s;    // строка (до пробела)
char c;       bank >> c;     // один символ (skips whitespace)
```

Можно смешивать в одном файле:

```
100.50 RUB
200.00 USD
50.25 EUR
```

```cpp
double sum;
std::string currency;
bank >> sum >> currency;     // 100.50 + "RUB"
```

## Обработка пробелов и переносов

`>>` оператор автоматически:
- Skips leading whitespace (spaces, tabs, newlines)
- Reads until next whitespace
- Stops without consuming trailing whitespace

Для **полной строки** (с пробелами) — `std::getline`:
```cpp
std::string line;
std::getline(bank, line);    // вся строка до '\n'
```

## Cstd::cin и ifstream — одно семейство

Оба — `std::istream` (input stream). Все операции:
- `>>` extraction
- `getline()`
- `peek()`, `get()`, `unget()`
- `eof()`, `fail()`, `good()`

Работают одинаково для всех потоков.

## Practical relevance для DevOps

- **Парсинг CSV/TSV:** читаем поле за полем
- **Конфиги:** ключ-значение пары
- **Логи:** parse timestamp, level, message
- **Test data fixtures:** load from file

## Связь с другими модулями

- **M19.1:** open/close файла (prerequisite)
- **M19.3+ (next):** запись в файл (`ofstream`), бинарный режим
- **M9 (strings):** для парсинга прочитанных строк
