# M15.5 — Сортировка пузырьком (Bubble Sort)

**Длительность:** 8:52
**Источник:** `L5_Сортировка_пузырьком.vtt` / `.txt`
**Тема:** второй sort алгоритм + оптимизация числа сравнений

## Главная идея

> «Сравниваем соседей, меняем местами если нарушен порядок. Самый большой всплывает в конец как пузырёк.»

Bubble sort — ещё один O(n²) алгоритм. Аналогия:
- солдаты в строю (могут меняться только с соседом)
- пузырьки в трубке (большой выталкивает маленькие наверх)

## Версия 1 — базовая

```cpp
#include <vector>
#include <iostream>

int main() {
    std::vector<int> v = {5, -3, 8, 2, -1, 7};
    for (int i = 0; i < v.size(); i++) {
        for (int j = 0; j < v.size() - 1; j++) {
            if (v[j] > v[j + 1]) {
                int temp = v[j];
                v[j] = v[j + 1];
                v[j + 1] = temp;
            }
        }
    }
    for (int x : v) std::cout << x << " ";
}
```

После каждого внешнего прохода **самый большой** из неразобранных элементов
оказывается в конце.

## Версия 2 — оптимизация по числу операций

```cpp
for (int i = 0; i < v.size(); i++) {
    for (int j = 0; j < v.size() - 1 - i; j++) {  // -i!
        if (v[j] > v[j + 1]) { /* swap */ }
    }
}
```

После i итераций последние `i` элементов уже на своих местах.
Не сравнивать их = экономим операции.

Total compares: `n + (n-1) + (n-2) + ... + 1 = n(n+1)/2 = O(n²)`,
но коэффициент в 2 раза меньше чем у базовой версии.

## Концепции, которые впервые вводятся

### 1. Bubble sort — pairwise compare-and-swap

Внутренний цикл сравнивает соседей. Это **локальная операция** —
никогда не «прыгаем» далеко. Это даёт некоторые свойства:
- **Stable** (равные сохраняют порядок — swap только при `>`, не `>=`)
- **In-place** (без extra array)
- **Worst-case всё равно O(n²)** — если массив обратный, каждый swap делается

### 2. «Сужение» границы — оптимизация на инвариант

После k проходов последние k элементов отсортированы.
Это **классический инвариант** для оптимизации.

Этот же приём в:
- Selection sort (M15.4) — `for j <= i`
- Bubble sort — `for j < n - 1 - i`
- В целом — любой алгоритм, который имеет «нарастающую готовую часть»

### 3. Возможные дальнейшие оптимизации (НЕ показаны)

```cpp
// Optimization 3: early exit
for (int i = 0; i < v.size(); i++) {
    bool swapped = false;
    for (int j = 0; j < v.size() - 1 - i; j++) {
        if (v[j] > v[j + 1]) {
            std::swap(v[j], v[j + 1]);
            swapped = true;
        }
    }
    if (!swapped) break;  // массив уже отсортирован
}
```

Это даёт **best case O(n)** для уже отсортированного массива.
Делает bubble sort **adaptive** — что выгодно отличает от selection sort.

Эту optimization стоит добавить в hwork — учитель её НЕ показал, но она
описана в любом учебнике алгоритмов.

## Сравнение с Selection Sort (M15.4)

| Аспект           | Selection      | Bubble (опт.)                |
|------------------|----------------|------------------------------|
| Time best        | O(n²)          | O(n²) (но с early-exit O(n)) |
| Time avg         | O(n²)          | O(n²)                        |
| Time worst       | O(n²)          | O(n²)                        |
| Swap count       | O(n)           | O(n²)                        |
| Compare count    | O(n²)          | O(n²)                        |
| Stable           | No             | Yes                          |
| Adaptive         | No             | Only with early-exit         |
| In-place         | Yes (v.2)      | Yes                          |

**Главная разница:** bubble делает много swaps, selection — мало.
Если swap дорогой (большие объекты), selection может быть быстрее на практике.

## Edge cases (не покрыто в видео)

- Пустой вектор → внешний цикл = 0 итераций, OK
- Один элемент → OK (внешний 1 раз, внутренний 0 раз)
- Два элемента в неправильном порядке → 1 swap, OK
- Все равные `{5,5,5}` → no swaps (`>` не срабатывает) — но всё равно n проходов в неоптимизированной
- Уже отсортированный → без early-exit O(n²), с early-exit O(n)
- Обратно отсортированный → worst case, n(n-1)/2 swaps

## Связь с другими уроками

- **M15.4 (prev):** selection sort — другая O(n²) сортировка с in-place оптимизацией.
- **M15.6 (next):** **homework по сортировкам** — теперь есть 2 алгоритма sort
  + 2 algorithm-задачи (search/optimization). Скорее всего hwork будет
  включать «реализуйте свой sort + примените к задаче».
- **stdlib:** `std::sort()` (Introsort) гораздо быстрее, но понимание
  bubble/selection нужно для алгоритмических собеседований.

## Что НЕ показано но стоит знать

1. **Early-exit optimization** (см. выше) — bubble становится adaptive
2. **Insertion sort** — другой O(n²), часто быстрее bubble на практике
3. **Cocktail sort** — двунаправленный bubble (туда-обратно за один проход)
4. **`std::stable_sort`** — даёт O(n log n) и stability (тот же класс что bubble)

## Подготовка к M15.6 hwork

После 4 уроков по алгоритмам мы имеем в арсенале:
- M15.2: вычёркивание (-1 sentinel)
- M15.3: single-pass с state-tracking (min_v, max_pr)
- M15.4: selection sort
- M15.5: bubble sort

Hwork по сортировкам **скорее всего** даст 1-3 задачи в стиле:
- Реализовать sort + apply к practical problem
- Sort + binary search?
- Sort + count duplicates / unique?
- Sort + group by

Готовим тесты на edge cases:
- empty, single, sorted-asc, sorted-desc, all-equal, with negatives,
  with duplicates, large random — для каждой реализации сортировки.
