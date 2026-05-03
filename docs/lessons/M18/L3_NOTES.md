# M18.3 — Передача параметров по ссылке и указателю

**Длительность:** ~10 минут
**Тема:** три способа передачи параметров: by-value, by-pointer, by-reference

## Главная идея

> Передача по ссылке — золотая середина: меняет оригинал (как pointer), но без `*` синтаксиса.

## 1. По значению (by-value) — DEFAULT

```cpp
void foo(int i) {
    std::cout << i + 10 * 2;  // 70 для foo(25)
}

int a = 10;
foo(a);                       // a НЕ меняется (foo получает копию)
```

**Свойства:**
- Создаётся копия объекта
- Изменения внутри функции НЕ влияют на оригинал
- Дорого для больших объектов (vector, string, struct)

## 2. По указателю (by-pointer) — M17

```cpp
void foo(int* i) {
    std::cout << *i + 10 * 2;
}

int a = 10;
foo(&a);                      // передаём адрес
int* pb = &b;
foo(pb);                      // или существующий указатель
```

**Свойства:**
- Внутри — копия указателя, но указывает на тот же объект
- Можно менять оригинал через `*i = ...`
- Нужен `*` для дереференса
- Можно передать `nullptr` (доп. проверка нужна)

## 3. По ссылке (by-reference) — M18.3 fresh

```cpp
void foo(int& i) {
    i = i + 10 * 2;           // меняет оригинал!
}

int a = 10;
foo(a);                       // напрямую — без &
std::cout << a;               // 30
```

**Свойства:**
- НЕТ копирования объекта
- Меняет оригинал
- Синтаксис как у by-value (без `*`)
- Нельзя передать `nullptr` — гарантированно валидно
- НЕЛЬЗЯ передать литерал: `foo(25)` — error

## const-ссылка — read-only без копирования

```cpp
void foo(const int& i) {
    // i = 5;  // ERROR: cannot modify const
    std::cout << i;  // OK: read
}
```

**Идиома для больших объектов:**
```cpp
void process(const std::vector<int>& vec) { ... }
void process(const std::string& str) { ... }
```

## Доказательство — адреса совпадают

```cpp
void foo1(int i)  { std::cout << &i; }   // отличается от &a
void foo2(int& i) { std::cout << &i; }   // совпадает с &a

int a = 10;
foo1(a);    // адрес копии
foo2(a);    // адрес a
std::cout << &a;
```

## Vector пример (показывает выгоду)

```cpp
void foo(std::vector<int>& vec) {
    for (int i = 0; i < vec.size(); i++) {
        std::cout << vec[i] << " ";
        vec[i] *= 2;          // меняет оригинал
    }
}

std::vector<int> v = {1, 2, 3, 4, 5, 6, 7};
foo(v);                       // печатает 1 2 3 4 5 6 7
// после: v = {2, 4, 6, 8, 10, 12, 14}
```

Без `&` — копировался бы весь vector (дорого!).

## Гайдлайны (best practice)

- **int / char / bool / float** — by-value (дёшево)
- **vector / string / map / большой struct** — `const T&` если read-only, `T&` если modify
- **Опциональный параметр** — `T*` (можно nullptr) или `optional<T>`

## Practical relevance для DevOps

- **Avoid copy for performance:** parsing logs (string ref), processing batches (vec ref)
- **API design:** `bool process(const Config& cfg)` — clear, no copies
- **Error returns:** `bool parse(const string& input, Result& out)` — out-param ref pattern

## Связь с другими модулями

- **M18.2:** что такое ссылки (pre-requisite)
- **M17 (pointers):** альтернативный способ
- **M18.4 (next):** возможно lvalue/rvalue references (move semantics)
- **M22+ (classes):** const member functions, return by reference
