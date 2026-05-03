# M19.1 — Введение в открытие файлов

**Длительность:** ~10 минут
**Тема:** концепция файлов, ifstream, open(), close(), пути

## Главная идея

> Файл = данные на диске. В C++ работа с файлами идёт через **потоки** (`<fstream>`).

## Концепции

- **Файл:** имя + расширение (e.g. `readme.txt`)
- **Расширение** — как «фамилия», говорит тип содержимого
- **Атрибуты:** размер (байты), даты создания/изменения/чтения, owner, permissions
- **Путь:** последовательность папок до файла
  - **Абсолютный (Windows):** `C:\Program Files\Skillbox\readme.txt`
  - **Относительный:** `readme.txt` (если cwd = папка с файлом)

## Базовый pattern: открыть и закрыть

```cpp
#include <fstream>

int main() {
    std::ifstream bank;
    bank.open("C:\\TutorialData\\bank.txt", std::ios::binary);
    // ... работа с файлом ...
    bank.close();
    return 0;
}
```

**`ifstream`** = **i**nput **f**ile **stream** (чтение).
Есть и `ofstream` (вывод), `fstream` (вход+выход) — будут позже.

### Двойной обратный слэш `\\`

В C++ строках `\` используется для escape-последовательностей (`\n`, `\t`, `\\`).
Чтобы получить один `\` в пути — пишем `\\`:

```cpp
"C:\\TutorialData\\bank.txt"  // путь "C:\TutorialData\bank.txt"
```

Альтернативно — Linux/Mac пути с `/`:
```cpp
"/home/user/data/bank.txt"
```

### Флаги `std::ios::*`

`open()` принимает второй аргумент — режим (битовая маска):
- **`std::ios::binary`** — бинарный режим
- **`std::ios::in`** — открыт для чтения (для `ifstream` дефолт, можно опустить)
- **`std::ios::out`** — открыт для записи
- **`std::ios::app`** — append (запись в конец)
- **`std::ios::trunc`** — truncate (стереть существующее)
- **`std::ios::ate`** — at end (cursor в конец)

Комбинируются через `|`:
```cpp
std::ios::out | std::ios::app
```

### Зачем `close()`

- **Сохранение буфера на диск** — без close данные могут не записаться
- **Освобождение FD** (file descriptor — limited resource в OS)
- **Деструктор закроет автоматически** — но лучше явно

## RAII pattern (НЕ показано в видео но критично)

C++ автоматически закрывает файл когда `ifstream` выходит из scope:

```cpp
{
    std::ifstream f("data.txt");
    // работа
}  // здесь f.close() вызывается автоматически (деструктор)
```

Это **RAII** (Resource Acquisition Is Initialization) — фундаментальный C++ pattern.

## Practical relevance для DevOps

- **Парсинг логов:** `/var/log/syslog`, `/var/log/nginx/access.log`
- **Конфиги:** `.ini`, `.yaml`, `.env`
- **Filesystem watchers:** monitoring file changes
- **Linux paths:** `/home/`, `/etc/`, `/var/log/` (slash as separator)
- **File descriptors limit:** `ulimit -n` — закрывайте файлы!

## Связь с другими модулями

- **M19.2+:** скорее всего чтение/запись из файла
- **C-style:** `<cstdio>` с `FILE* f = fopen("path", "r")` — старый способ
- **C++17:** `std::filesystem` для манипуляций с путями
