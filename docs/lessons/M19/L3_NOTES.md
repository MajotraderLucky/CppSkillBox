# M19.3 — Чтение бинарных файлов

**Длительность:** ~9 минут
**Тема:** binary mode, `read()` метод, `seekg()`/`tellg()` для cursor

## Главная идея

> **Текстовый режим = удобство для человека.** Бинарный = байты как есть, без парсинга текста.

## Текст vs Бинарный

- **Текст:** "100" = 3 байта `'1' '0' '0'` (49, 48, 48 в ASCII)
- **Бинарный (int):** 100 = 4 байта `0x64 0x00 0x00 0x00` (little-endian)

Один и тот же файл можно открыть текстом ИЛИ бинарно — другая интерпретация.

## read() метод

```cpp
#include <fstream>

std::ifstream f("data.bin", std::ios::binary);
char buffer[20];
f.read(buffer, sizeof(buffer));   // прочесть 20 байт
```

**Аргументы:**
1. Указатель на буфер (куда писать)
2. Количество байт для чтения (`sizeof(buffer)`)

## Вывод буфера в консоль

**Способ 1 — поэлементно:**
```cpp
for (int i = 0; i < 20; i++) std::cout << buffer[i];
```

**Способ 2 — добавить '\0' и вывести как строку:**
```cpp
buffer[19] = '\0';   // null-terminate
std::cout << buffer; // выводит как строку (теряем последний байт)
```

## Чтение в любой тип данных

```cpp
int value;
f.read(reinterpret_cast<char*>(&value), sizeof(int));
// читает 4 байта прямо в int — без парсинга!
```

**В видео используется:** `f.read((char*)&value, sizeof(int))` (C-style cast).

В реале текстовый файл прочитанный как int — даст «фарш» (mess).
Но если файл был **создан** бинарной записью int → читается обратно правильно.

## Cursor (head): seekg() и tellg()

После каждого `read()` курсор сдвигается на N байт вперёд.

### seekg(pos) — set cursor

```cpp
f.seekg(0);     // в начало
f.seekg(20);    // на байт #20
f.seekg(-10, std::ios::end);   // 10 байт от конца
f.seekg(5, std::ios::cur);     // +5 от текущей позиции
```

`g` = **g**et (для input). Для output — `seekp` (`p` = put).

### tellg() — get current cursor position

```cpp
std::streampos pos = f.tellg();   // текущая позиция в байтах
std::cout << pos;                  // напр. 20
```

## Зачем бинарные файлы?

- **Быстрее:** прямое копирование байт vs парсинг текста
- **Меньше:** число `1000000` = 7 байт текстом, 4 байта бинарно
- **PNG, JPEG, MP4, EXE, .so, .o** — все бинарные форматы
- **Network protocols:** TCP packets, msgpack, protobuf, gRPC

## Practical relevance для DevOps

- **Reading core dumps:** GDB, kdump
- **Network packet inspection:** tcpdump, wireshark
- **Disk imaging:** dd, hexdump
- **Container layers:** tarballs, OCI images
- **Database files:** SQLite, RocksDB

## Связь с другими модулями

- **M19.1+M19.2:** open + text reading (text mode)
- **M19.4+ (next):** скорее всего запись в файл
- **M16.3:** binary representation of types — pre-requisite knowledge
