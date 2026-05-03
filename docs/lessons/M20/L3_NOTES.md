# M20.3 — Запись бинарных типов файлов

**Длительность:** ~10 минут
**Тема:** `write()` метод, бинарная запись `int`/`double`/массивов

## Главная идея

> `f.write(ptr, size)` — байт-в-байт запись, симметрия `read()`.

## Базовый pattern

```cpp
std::ofstream f("data.bin", std::ios::binary);
int x = 42;
f.write(reinterpret_cast<char*>(&x), sizeof(x));   // 4 bytes
double pi = 3.14;
f.write(reinterpret_cast<char*>(&pi), sizeof(pi)); // 8 bytes
f.close();
```

## Чтение обратно (симметрия)

```cpp
std::ifstream g("data.bin", std::ios::binary);
int x;
double pi;
g.read(reinterpret_cast<char*>(&x), sizeof(x));
g.read(reinterpret_cast<char*>(&pi), sizeof(pi));
```

Главное — **тот же порядок и размер** при чтении что при записи.

## Запись C-строки

```cpp
const char* s = "Hello";
f.write(s, 5);   // или strlen(s)
// Без '\0' терминатора (если хотим — добавить вручную)
```

## Запись массива целиком

```cpp
int arr[10] = {1,2,3,4,5,6,7,8,9,10};
f.write(reinterpret_cast<char*>(arr), sizeof(arr));  // 40 bytes
```

## Преимущества бинарной записи

- **Меньше:** число `1000000` = 7 байт текстом, 4 байта бинарно
- **Быстрее:** без форматирования
- **Точность:** double сохраняется без потерь

## Cons

- Не читается человеком в блокноте
- Не portable между архитектурами (endianness, alignment)
- Сложнее debugging

## Связь

- **M19.3:** read() — симметрия
- **M20.4:** запись массивов высокого уровня
