# M17.4 — Практическая работа

**URL:** `homework/7b84ad6b-5cf7-43f5-a2b6-8e96d2fc5c49`
**Status:** submission заблокирован (та же ситуация)

## Цели

- Навыки работы с указателями на разные типы
- Работа с char* как со строкой

## 3 задачи (все обязательные)

### Задача 1 — swap через указатели

```cpp
void swap(int* a, int* b);

int a = 10, b = 20;
swap(&a, &b);
std::cout << a << " " << b;  // 20 10
```

**Чек-лист:**
- void return type
- Только `<iostream>` (без `<algorithm>`)
- Меняет значения по указателям

### Задача 2 — Reverse 10 ints in-place

```cpp
void reverseTen(int* arr);   // arr указывает на 10 элементов
```

После вызова — те же 10 элементов в обратном порядке.

**Чек-лист:**
- void return type
- Только `<iostream>`
- In-place reverse (по тому же указателю)

### Задача 3 — substr (is substring?)

```cpp
bool substr(const char* a, const char* b);

const char* a = "Hello world";
const char* b = "wor";
const char* c = "banana";
std::cout << substr(a, b) << " " << substr(a, c);  // true false
```

**Чек-лист:**
- bool return type
- Может использовать `strlen` из `<cstring>` ИЛИ определять длину через '\0'
- Корректно определяет подстроку

## План реализации

```text
Module17th/Module17Hwork/
├── README.md
├── test_all.sh
├── Task1_Swap/{main.cpp,test.sh}
├── Task2_Reverse/{main.cpp,test.sh}
└── Task3_Substr/{main.cpp,test.sh}
```
