# M19.4 — Чтение из файла массивов данных

**Длительность:** ~7 минут
**Тема:** циклическое чтение, eof(), std::vector для динамических данных

## Главная идея

> Чтение в цикле через `>>` + проверка `eof()` для неизвестного количества данных.

## Способ 1 — Известное количество (массив)

```cpp
double wallet[4];
for (int i = 0; i < 4; i++) {
    bank >> wallet[i];
}
```

## Способ 2 — Известная верхняя граница (буфер)

```cpp
double wallet[50];
int count = 0;
while (!bank.eof()) {
    bank >> wallet[count];
    count++;
}
```

`eof()` = end-of-file, возвращает `true` когда больше нечего читать.

**Trap:** забыть `bank >> ...` внутри цикла = бесконечный цикл!

## Способ 3 — Неизвестное количество (std::vector)

```cpp
std::vector<double> wallet;
double money;
while (!bank.eof()) {
    bank >> money;
    wallet.push_back(money);
}
```

## Подсчёт суммы

```cpp
double sum = 0;
for (size_t i = 0; i < wallet.size(); i++) {
    sum += wallet[i];
}
std::cout << "Total: " << sum;
```

Или через range-for:
```cpp
for (double m : wallet) sum += m;
```

## Trap с eof() — лишний последний элемент

`eof()` становится `true` **после** неудачной попытки чтения. Поэтому:

```cpp
while (!bank.eof()) {
    bank >> money;        // последняя попытка может не прочесть, но money не меняется
    wallet.push_back(money);  // добавляем дубль последнего!
}
```

**Правильный pattern:**
```cpp
while (bank >> money) {   // короткая запись
    wallet.push_back(money);
}
```

`bank >> money` возвращает stream который в bool контексте = `false` при eof или error.

## Practical relevance для DevOps

- **Читать большие логи line-by-line** — не загружая всё в память:
  ```cpp
  std::string line;
  while (std::getline(file, line)) { /* process line */ }
  ```
- **CSV parsing:** читать N полей в цикле
- **Streaming processing:** обрабатывать файл по chunks

## Связь с другими модулями

- **M13 (vector):** push_back, size — fundamental
- **M19.1-3:** open/close/binary mode — pre-requisites
- **M19.5+ (next):** скорее всего запись файлов (ofstream)
