# M20.1 — Введение в запись файлов

**Длительность:** ~10 минут
**Тема:** ofstream, открыть на запись, append mode

## Главная идея

> Запись = симметрия чтения. `ofstream` + `<<` оператор — как `std::cout`.

## Базовый pattern

```cpp
#include <fstream>

int main() {
    std::ofstream f;
    f.open("phrase.txt");
    f << "It's never too late to learn";
    f.close();
    return 0;
}
```

`ofstream` = **o**utput **f**ile **stream** (запись).

## Сокращенная форма (constructor + path)

```cpp
std::ofstream f("phrase.txt");   // open в конструкторе
f << "Hello";
f.close();
```

Под капотом — это constructor type `std::ofstream` (тема ООП дальше в курсе).

## Режимы открытия

`open()` второй аргумент — режим (по умолчанию `std::ios::out`):

- **`std::ios::out`** — запись (default для ofstream)
- **`std::ios::app`** — append: курсор в конец, не стирает существующее
- **`std::ios::trunc`** — truncate (стереть всё, default если просто out)
- **`std::ios::binary`** — бинарный режим
- **`std::ios::ate`** — at end (курсор в конец, но существующее не стирается)

### Append example

```cpp
std::ofstream f("phrase.txt", std::ios::app);
f << "\nNo pain, no gain";   // дописывает в конец
f.close();
```

## Default behavior — overwrite

Без `std::ios::app` — открытие файла **стирает** существующее содержимое:

```cpp
std::ofstream f("phrase.txt");   // файл становится пустым!
f << "new content";              // теперь только это
```

## Зачем close()

- Гарантия записи буфера на диск
- Освобождение FD
- Деструктор закроет автоматически — но лучше явно для большой надёжности

## Practical relevance для DevOps

- **Логирование:** `ofstream log("/var/log/app.log", std::ios::app);` — append mode
- **Конфиги:** generation/serialization
- **CSV/JSON output:** report generators
- **Системные logs:** rotation, time-based filenames

## Связь с другими модулями

- **M19:** ifstream — чтение (parallel concept)
- **M20.2+ (next):** запись разных типов, форматирование
