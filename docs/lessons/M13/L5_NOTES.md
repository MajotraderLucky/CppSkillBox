# M13.5 — Полезные функции std::vector (empty, front, back, clear)

**Дата урока:** 2026-05-03 (transcribed from Skillbox видео)
**Длина:** 10:16
**Источник:** `L5_полезные_функции.{vtt,txt}`

Заключительный урок по `std::vector`. Не добавляет новых концептов, но показывает
**4 идиоматических метода** которые делают код чище и читабельнее. Через 3 задачи
с растущим scope.

---

## Новые методы

| Метод           | Заменяет (наивно)             | Что возвращает / делает          |
|-----------------|-------------------------------|----------------------------------|
| `vec.empty()`   | `vec.size() == 0`             | bool: true если 0 элементов      |
| `vec.front()`   | `vec[0]`                      | reference на first element       |
| `vec.back()`    | `vec[vec.size() - 1]`         | reference на last element        |
| `vec.clear()`   | `vec.resize(0)`               | удаляет все элементы (size = 0)  |

> "Вызов front и back не добавляет особых новых возможностей, но делает ваш код
> более приятным для чтения и более лаконичным."

Все 4 — UB на пустом векторе (`front`, `back`) — всегда `if (!empty())` сначала.

---

## Task 1 — push/pop с empty check

### Условие

Команды:

- `1 n` — push n в конец
- `2` — pop последний (или error если empty)
- `-1` — exit

### Реализация (с `empty()`)

```cpp
#include <iostream>
#include <vector>

int main() {
    std::vector<int> vec;
    int q;
    std::cin >> q;
    while (q != -1) {
        if (q == 1) {
            int n;
            std::cin >> n;
            vec.push_back(n);
        } else if (q == 2) {
            if (!vec.empty()) {
                vec.pop_back();
            } else {
                std::cout << "Ошибка: вектор пуст\n";
            }
        }
        std::cin >> q;
    }
    return 0;
}
```

### Идиома

`if (!vec.empty())` читабельнее чем `if (vec.size() != 0)` — описывает **намерение**,
не реализацию.

---

## Task 2 — + show first/last

### Условие

Добавлен запрос `3` — вывести first + last элементы (или error если пусто).

### Изменение (вставка нового case)

```cpp
} else if (q == 3) {
    if (!vec.empty()) {
        std::cout << vec.front() << " " << vec.back() << "\n";
    } else {
        std::cout << "Ошибка: вектор пуст\n";
    }
}
```

### Edge case (важно)

Если в vec **один элемент** — `front()` и `back()` вернут **тот же** элемент. Не
edge case, естественное поведение.

---

## Task 3 — clear() + counter

### Условие

Меняется семантика:

- `1 n` — push n
- `2` — **clear vector** (не pop как раньше)
- `3` — вывести **total count** добавлений за все время (включая до clear)

### Реализация

```cpp
#include <iostream>
#include <vector>

int main() {
    std::vector<int> vec;
    int count = 0;  // total adds counter (independent of vec.size())
    int q;
    std::cin >> q;
    while (q != -1) {
        if (q == 1) {
            int n;
            std::cin >> n;
            vec.push_back(n);
            count++;  // increment ВСЕГДА на add
        } else if (q == 2) {
            vec.clear();  // vec.size() = 0, но count не сбрасывается
        } else if (q == 3) {
            std::cout << "Всего добавлено: " << count << "\n";
        }
        std::cin >> q;
    }
    return 0;
}
```

### Test (из видео)

```text
Inputs: 1 1, 1 2, 1 3, 2, 1 5, 1 6, 1 7, 3
Expected output for 3: "Всего добавлено: 6"
```

Переменная `count` — **независимый** счётчик, продолжает работать после `clear()`.

### `clear()` vs `resize(0)`

> "Такого же результата можно достичь, если вызвать `vec.resize(0)`. Но такое
> объявление не совсем показывает, что мы хотим с вектором сделать."

`clear()` явно говорит "удалить всё". `resize(0)` — изменение размера до 0
(побочный эффект: то же самое, но через другую семантику).

### Подвох с памятью

`clear()` **не освобождает capacity** — элементы удалены, но allocated память остаётся.
Если нужно вернуть память — `vec.shrink_to_fit()` (C++11+) или `swap` trick:

```cpp
std::vector<int>().swap(vec);  // эквивалент vec = {}; + free memory
```

В уроке этот аспект не упомянут, но полезно знать для оптимизации.

---

## Take-aways

1. **`empty()`** — идиома для "is empty". Чище чем `size() == 0`.
2. **`front()`** / **`back()`** — идиомы для first/last. Чище чем `vec[0]` / `vec[size-1]`.
3. **`clear()`** — идиома для "remove all". Чище чем `resize(0)`.
4. **UB на empty** — `front`/`back`/`pop_back` без проверки = неопределённое поведение.
5. **`clear()` не освобождает capacity** — `shrink_to_fit()` или swap-trick если надо.
6. **Идиоматичный код** — преподаватель явно: "явно показывают тот результат, который вы хотите получить".

---

## Полный список изученных методов std::vector (M13.1-M13.5)

| Метод                  | Урок    | Назначение                          |
|------------------------|---------|-------------------------------------|
| `vec[i]`               | M13.1?  | Доступ к элементу (no bounds check) |
| `vec.size()`           | M13.2   | Логический размер                   |
| `vec.resize(n)`        | M13.3   | Изменить размер (mutate in-place)   |
| `vec.push_back(v)`     | M13.4   | Add to end (амортизированно O(1))   |
| `vec.pop_back()`       | M13.4   | Remove last + return                |
| `vec.capacity()`       | M13.4   | Allocated размер                    |
| `vec.empty()`          | M13.5   | Bool: empty?                        |
| `vec.front()`          | M13.5   | First element                       |
| `vec.back()`           | M13.5   | Last element                        |
| `vec.clear()`          | M13.5   | Remove all                          |

**Не упомянуты в этом модуле, но полезны:**

- `vec.at(i)` — like `vec[i]` но с bounds check (бросает `std::out_of_range`)
- `vec.reserve(n)` — pre-allocate без size change
- `vec.shrink_to_fit()` — free unused capacity
- `vec.insert(pos, v)` — insert в любую позицию (O(n))
- `vec.erase(pos)` — remove в любой позиции (O(n))
- `std::sort(vec.begin(), vec.end())` — стандартная сортировка

Эти методы могут появиться в Module 14+ (двумерные массивы) или M15 (алгоритмы).

---

## Анонс M13.6 (hwork) и M14

M13.6 = practical work — закрепить empty/front/back/clear. На диске у тебя
6 tasks (Task1-6) — стоит проверить используются ли там эти методы.

M14 = "Двумерные массивы и алгоритмы над ними" — следующий модуль.
