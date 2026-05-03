# M21.4 — Структуры и файлы (сериализация)

**Длительность:** ~10 минут
**Тема:** бинарная запись/чтение struct, проблема с std::string и указателями

## Главная идея

> Структуры нельзя писать в файл «как есть» если они содержат указатели или
> std::string — нужна **сериализация** field-by-field.

## Контекст: система сохранений в игре

Save/load файл хранит состояние игры (массив `Character[10]`).
Бинарный формат:
- **Компактнее** текстового
- **Сложнее модифицировать** в блокноте (защита от cheating)
- Симметрия read/write — как сохранили, так и читаем

## Наивная попытка — write всего массива целиком

```cpp
Character people[10];
std::ofstream f("save.bin", std::ios::binary);
f.write(reinterpret_cast<char*>(people), sizeof(people));
// sizeof(Character) * 10 байт
```

**Проблема:** если `name` это `std::string` — внутри лежит указатель на heap-буфер.
Сохранится сам указатель (число), но **не содержимое строки**.
При следующем запуске: указатель указывает на мусор → undefined behavior.

### То же самое для `const char*`

```cpp
struct Character { const char* name; ... };
Character p = {"Сибиль", ...};
// p.name — указатель на строковый литерал в .rodata
```

При следующей сборке/запуске адрес может быть другим.
**Память файла ≠ память программы.** Указатели в файле бессмысленны.

## Правильный подход: сериализация имени как массива

Строка = массив `char`. Записываем по схеме «length + data»:

```cpp
void writeCharacter(std::ofstream& f, const Character& c) {
    int len = std::strlen(c.name);                          // 1) длина
    f.write(reinterpret_cast<char*>(&len), sizeof(len));    // 2) счётчик
    f.write(c.name, len);                                    // 3) данные
    f.write(reinterpret_cast<const char*>(&c.health), sizeof(c.health));
    f.write(reinterpret_cast<const char*>(&c.armor),  sizeof(c.armor));
}
```

**Почему по ссылке `Character&` и `ofstream&`:**
- Избегаем копирования больших объектов
- `ofstream` нельзя копировать (он управляет ресурсом — файлом)
- Состояние файла после функции остаётся консистентным с её началом

## Версия с std::string

```cpp
struct Character {
    std::string name;
    int health = 0;
    int armor = 0;
};

void writeCharacter(std::ofstream& f, const Character& c) {
    int len = c.name.length();                           // вместо strlen
    f.write(reinterpret_cast<char*>(&len), sizeof(len));
    f.write(c.name.c_str(), len);                        // c_str() даёт const char*
    f.write(reinterpret_cast<const char*>(&c.health), sizeof(c.health));
    f.write(reinterpret_cast<const char*>(&c.armor),  sizeof(c.armor));
}
```

`std::string::c_str()` возвращает классическую null-terminated C-строку.

## Симметричное чтение (десериализация)

```cpp
void readCharacter(std::ifstream& f, Character& c) {
    int len = 0;
    f.read(reinterpret_cast<char*>(&len), sizeof(len));      // 1) длина

    c.name.resize(len);                                       // 2) выделить буфер
    f.read(const_cast<char*>(c.name.c_str()), len);           // 3) считать данные

    f.read(reinterpret_cast<char*>(&c.health), sizeof(c.health));
    f.read(reinterpret_cast<char*>(&c.armor),  sizeof(c.armor));
}
```

**Почему `resize(len)`:**
- `c_str()` возвращает указатель на внутренний буфер строки
- Этот буфер должен быть **достаточного размера**
- `resize` расширяет строку до нужной длины, заполняя символами `\0`

**`const_cast`:** `c_str()` возвращает `const char*`, но мы хотим записать в этот
буфер. Учитель упоминает что это компромисс (тема const будет позже).

В современном C++ безопаснее: `f.read(c.name.data(), len);` (since C++17 `data()` non-const).

## Save/Load цикл

```cpp
// SAVE
std::ofstream out("save.bin", std::ios::binary);
for (int i = 0; i < 10; ++i) {
    writeCharacter(out, people[i]);
}
out.close();

// LOAD
std::ifstream in("save.bin", std::ios::binary);
Character loaded[10];
for (int i = 0; i < 10; ++i) {
    readCharacter(in, loaded[i]);
}
in.close();
```

**Замечание учителя:** мы не сохраняем количество персонажей (фиксировано 10).
В реальной игре их число динамично — нужно сохранять и читать `count` первым полем.

## Сериализация / десериализация

> Сериализация = превращение объекта в байты для хранения/передачи.
> Десериализация = обратный процесс.

Эти функции **симметричны**: порядок и размер полей при чтении должны
точно соответствовать записи.

## Опасности и подводные камни

| Проблема                | Причина                            | Решение                                  |
|-------------------------|------------------------------------|------------------------------------------|
| `f.write(&str, ...)`    | std::string содержит heap-ptr      | Сериализовать как `len + data`           |
| Указатели в struct      | Адрес валиден только в этой сессии | Сохранять *содержимое*, не указатель     |
| Padding в struct        | Компилятор добавляет выравнивание  | Сериализовать поле-за-полем              |
| Endianness              | Разные платформы по-разному        | Задать формат явно (например little-end) |
| Версионирование         | Старые сейвы при изменении struct  | Хранить версию первым полем              |

## Practical relevance для DevOps

- **State persistence:** конфиги, snapshots, journals
- **IPC / network:** сериализация для передачи между процессами/хостами
- **Database BLOB:** struct → bytes → BLOB column
- **Стандартные форматы:** Protobuf, MessagePack, Cap'n Proto — сериализация на стероидах
- **Логи бинарные:** binlog MySQL, journald, eBPF perf events

## Связь с другими модулями

- **M19.4 (read binary):** `f.read()` бинарное чтение — сейчас применили к struct
- **M20.4 (write binary):** `f.write()` бинарная запись — применили к struct
- **M21.2/3 (struct intro):** теперь умеем сохранять struct в файл
- **M21.5 hwork:** наверное будет реализовать save/load с struct
- **M22+ classes:** сериализация методами класса (`save()`, `load()`)
- **C++ современный:** Boost.Serialization, Cereal, Protobuf для type-safe серилизации

## Итог модуля 21

> Структуры — фундамент работы с составными данными.
> Без них невозможно писать сколько-нибудь сложный код.

В модуле прошли:
- M21.2: что такое struct, объявление, доступ
- M21.3: массивы struct, передача по значению/указателю/ссылке
- M21.4: сериализация в файл (тонкости с указателями и std::string)
- M21.5 (next): практическая работа
