# M18.4 — Рекурсия (recursion)

**Длительность:** ~9 минут
**Тема:** функции, вызывающие сами себя

## Главная идея

> Рекурсия = функция вызывает себя. **Обязательно** должны быть terminal cases (базовые значения).

## Пример 1 — Числа Фибоначчи

```
fib(0) = 1
fib(1) = 1
fib(n) = fib(n-1) + fib(n-2) для n > 1
```

```cpp
int fib(int n) {
    if (n == 0 || n == 1) return 1;
    return fib(n - 1) + fib(n - 2);
}

int main() {
    for (int i = 0; i < 20; i++) std::cout << fib(i) << " ";
    // 1 1 2 3 5 8 13 21 34 55 ...
}
```

**Ключ:** базовый случай `n == 0 || n == 1` → return 1 (без рекурсии).

## Без базового случая = stack overflow

```cpp
int fib(int n) {
    return fib(n - 1) + fib(n - 2);  // НИКОГДА НЕ ОСТАНАВЛИВАЕТСЯ
}
```

→ **Segmentation fault** (переполнение стека вызовов).

**Правило:** в любой рекурсивной функции должно быть условие выхода (terminal case).

## Пример 2 — НОД (Algorithm Euclid)

Найти **greatest common divider** двух чисел.

```
gcd(20, 30) = 10
gcd(2, 4) = 2
gcd(1320, 144) = 24
```

**Алгоритм Евклида:**
1. Если `a < b` — swap (чтобы `a >= b`)
2. Если `a % b == 0` — answer = `b`
3. Иначе — `gcd(b, a % b)` (рекурсивный вызов)

```cpp
void swap(int& a, int& b) {
    int t = a;
    a = b;
    b = t;
}

int gcd(int a, int b) {
    if (b > a) swap(a, b);
    if (a % b == 0) return b;
    return gcd(b, a % b);
}
```

**Notes:**
- swap нужен только в первом вызове (далее `b > a%b` всегда)
- Рекурсия гарантированно завершится: `a % b < b`, поэтому каждый шаг
  уменьшает второй аргумент. Когда он делится — return.

## Стек вызовов и stack overflow

Каждый вызов функции = новый stack frame. Default stack size — обычно 8 МБ.
При очень глубокой рекурсии (тысячи уровней) → переполнение.

```
fib(20) → fib(19) → fib(18) → ... → fib(1) → return
                  → fib(17) → ... → return
        → fib(18) → ... (повторно!)
```

**Без мемоизации fib(40)** делает миллиарды вызовов.

## Tail recursion (НЕ показано в видео)

Если рекурсивный вызов — последняя операция в функции, компилятор
может оптимизировать в цикл (tail call optimization, TCO).

```cpp
// Tail-recursive (compiler may optimize):
int gcd(int a, int b) {
    if (b == 0) return a;
    return gcd(b, a % b);   // tail call
}

// NOT tail-recursive:
int fib(int n) {
    if (n < 2) return 1;
    return fib(n - 1) + fib(n - 2);  // 2 вызова + сложение
}
```

GCC включает TCO с `-O2`. Для гарантии: использовать iteration вместо recursion для глубоких случаев.

## Когда рекурсия — лучший выбор

- **Tree traversal** (DFS, BFS реализуется через очередь)
- **Divide and conquer** (merge sort, quick sort)
- **Backtracking** (sudoku, n-queens, parsing)
- **Math** (factorial, fib, NOD/GCD)

## Когда лучше итерация

- Линейные циклы по массиву (overhead вызова не нужен)
- Tail-recursive (избегаем stack overhead)
- Очень глубокая рекурсия (>10000 уровней)
- Мемоизация лучше для overlapping subproblems (DP)

## Practical relevance для DevOps

- **Tree traversal** в filesystem operations: `find`, `ls -R`
- **JSON/YAML parsing:** рекурсивный descent parser
- **Dependency resolution:** apt/yum/cargo — рекурсивный graph traversal
- **Stack traces:** показывают активные рекурсивные вызовы

## Связь с другими модулями

- **M11 (functions):** базовые функции
- **M18.3 (prev):** свап через ссылки используется в gcd
- **M18.5 (hwork next):** ожидаемые задачи — рекурсия + ссылки + default args
