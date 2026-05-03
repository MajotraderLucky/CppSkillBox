# M18.1 — Значения аргументов по умолчанию (default arguments)

**Длительность:** ~7 минут
**Тема:** default function arguments в C++

## Главная идея

> Можно задать значения аргументов «по умолчанию», чтобы при вызове их можно было опустить.

## Базовый пример

```cpp
int power(int num, int dec = 2) {
    int result = 1;
    for (int i = 0; i < dec; i++) result *= num;
    return result;
}

int main() {
    std::cout << power(6);     // 36 (6^2 — used default dec=2)
    std::cout << power(6, 3);  // 216 (6^3)
}
```

## Несколько default-параметров

```cpp
void foo(int i = 1, float j = 2.5, std::string s = "hello world") {
    std::cout << i << " " << j << " " << s << std::endl;
}

foo();             // 1 2.5 hello world
foo(2, 3.4, "X");  // 2 3.4 X
```

## Два важных правила

### 1. Default args только в **конце** списка аргументов

```cpp
// OK
void f(int a, int b = 0, int c = 0);

// COMPILE ERROR — default-аргумент перед required
void g(int a = 0, int b);
```

Если хочешь сделать `s` обязательным, его нужно поставить ПЕРВЫМ:

```cpp
void foo(std::string s, int i = 1, float j = 2.5);
```

### 2. Передача аргументов **по порядку** (positional only)

```cpp
void foo(int i = 1, float j = 2.5, std::string s = "hello");

foo("banana");           // ERROR — нельзя skip i и j
foo(10);                 // OK — i=10, j=2.5, s="hello"
foo(10, 3.0);            // OK — s по умолчанию
foo(10, 3.0, "banana");  // OK — все 3
```

В C++ нет именованных аргументов как в Python (`foo(s="banana")` НЕ работает).

## Альтернативы (НЕ показано в видео)

### Function overloading вместо default args

```cpp
// Вместо default arg:
int power(int num) { return power(num, 2); }
int power(int num, int dec) { ... }
```

### Designated initializers (C++20)

```cpp
struct Args { int i = 1; float j = 2.5; std::string s = "hello"; };
foo({.s = "banana"});  // C++20
```

## Practical relevance для DevOps

- **Logging libraries:** `log(message, level=INFO)`
- **Config defaults:** `connect(host, port = 5432, timeout = 30)`
- **API wrappers:** дефолты для optional parameters
- **Class constructors:** часто используются для разумных defaults

## Связь с другими модулями

- **M11 (functions):** базовые функции
- **M18.2+:** скорее всего перегрузка функций / function overloading
- **M22+:** конструкторы классов (default args + member initialization)
