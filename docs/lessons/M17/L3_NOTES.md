# M17.3 — Указатели на строки (char*)

**Длительность:** ~11 минут
**Тема:** char* как указатель на строку, '\0' терминатор, итерация без знания длины

## Главная идея

> Строковый литерал `"Hello"` — это `const char*`, **указатель на массив char** с '\0' в конце.

## Создание строки через указатель

```cpp
const char* s = "Hello world";   // указатель на строковый литерал
char x[] = "Hello world";        // массив (компилятор посчитает размер)
```

Размер массива указывать НЕ нужно — компилятор сам посчитает по литералу +1 для '\0'.

## std::cout специально для char*

```cpp
int* p_int = ...;
std::cout << p_int;     // адрес (hex)

const char* p_str = "Hello";
std::cout << p_str;     // **строка целиком** (Hello), а не адрес!
```

`std::cout` перегружен для `char*` — печатает символы пока не встретит '\0'.

Чтобы получить адрес строкового указателя:
```cpp
std::cout << &s;       // адрес самого указателя
```

## Доступ через `[]` или арифметику указателей

```cpp
char x[] = "Hello world";

// Через скобки:
std::cout << x[4];     // 'o'
x[4] = 'a';
std::cout << x[4];     // 'a'

// Через указатели:
char* y = x;
std::cout << *(x + 4); // 'o' (то же самое)
*(x + 4) = 'k';
std::cout << *(x + 4); // 'k'
```

`x[i]` ≡ `*(x + i)` — синтаксический сахар.

## Размер char = 1 байт (всегда)

```cpp
sizeof(char) == 1;
```

Также можно проверить через арифметику указателей:
```cpp
char* y = &x[0];
std::cout << sizeof(char) << std::endl;  // 1
std::cout << (y - x);                    // 0 (y == x)
```

## Итерация без знания длины — '\0' sentinel

```cpp
const char* x = "Hello world";
int i = 0;
while (*(x + i) != '\0') {
    std::cout << *(x + i);
    i++;
}
```

Конец строки маркируется **null character '\0'** (байт со значением 0).
Это позволяет передавать строки в функции БЕЗ передачи длины:

```cpp
void bigA(char* s) {
    int i = 0;
    while (*(s + i) != '\0') {
        if (*(s + i) == 'a') *(s + i) = 'A';
        i++;
    }
}

int main() {
    char str[] = "haha";
    bigA(str);
    std::cout << str;  // "hAhA"
}
```

## Practical relevance для DevOps

- **Linux syscalls:** `open(const char* path, ...)`, `getenv(const char* name)` — везде C-strings
- **Buffer overflows:** missing '\0' = читаем чужую память (классика CVE)
- **strlen, strcpy, strcat:** все работают с null-terminated strings
- **`/proc/<pid>/cmdline`:** содержит '\0'-разделённые args
- **`gdb`:** `x/s $rdi` — печать строки начиная с указателя

## Связь с другими модулями

- **M17.1+M17.2:** базовые указатели + sizeof + арифметика
- **M16.3:** показал что char занимает 1 байт + ASCII
- **M17.4 (next):** hwork по char* (substring, swap, reverse)
