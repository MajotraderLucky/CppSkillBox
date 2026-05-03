# M18.5 — Практическая работа

**URL:** `homework/ee990fea-d10d-4138-874b-7b450fa071da`
**Status:** submission заблокирован

## Цели

- Навыки работы со ссылками
- Default args в функции
- Передача параметров по ссылке
- Рекурсия

## 3 задачи

### Задача 1 — swapvec

```cpp
void swapvec(std::vector<int>& a, int* b);   // одинаковый размер
```

Меняет значения a и b местами. Вектор передаётся по ссылке.

```
a = {1,2,3,4}, b[] = {2,4,6,8}
swapvec(a, b);
// a → {2,4,6,8}, b → {1,2,3,4}
```

**Чек-лист:** void return, only `<iostream>`+`<vector>`, vector by ref.

### Задача 2 — Кролик на лестнице (recursive count, default arg)

```cpp
int rabbit(int n, int k = 3);   // default k = 3
```

Кролик прыгает на 1..k ступенек. Возвращает кол-во способов добраться до n.

```
rabbit(3, 2) = 3   // (1,2), (2,1), (1,1,1)
rabbit(0)    = 1   // base case
rabbit(n,k)  = sum(rabbit(n-i, k) for i in 1..k если n-i >= 0)
```

**Чек-лист:** int return, only `<iostream>`, recursive, default value.

### Задача 3 — evendigits (recursive count via ref)

```cpp
void evendigits(long long n, int& ans);
```

Подсчитывает количество чётных цифр в `n`, складывает в `ans`.

```
evendigits(9223372036854775806, ans);
// ans = 10
```

**Чек-лист:** void return, only `<iostream>`, recursive, ans by reference.

## План реализации

```text
Module18th/Module18Hwork/
├── README.md
├── test_all.sh
├── Task1_SwapVec/{main.cpp,test.sh}
├── Task2_Rabbit/{main.cpp,test.sh}
└── Task3_EvenDigits/{main.cpp,test.sh}
```
