# M13.4 — Использование push_back() и pop_back()

**Дата урока:** 2026-05-03 (transcribed from Skillbox видео)
**Длина:** 10:27
**Источник:** `L4_push_back.{vtt,txt}`

Урок продолжает M13.3 — теперь вместо ручного `resize + realSize` показывает
встроенные методы `std::vector::push_back()` и `pop_back()`. Главный новый концепт —
**`size()` vs `capacity()`** (логический размер vs зарезервированная память).

---

## Часть 1 — `push_back()` базовое использование

### Что делает

`vec.push_back(value)`:

1. Если `size < capacity` — просто положить value в `vec[size]`, увеличить size
2. Если `size == capacity` — выделить **больше** памяти (внутренний grow factor),
   скопировать всё, затем как в (1)

Полностью заменяет ручную работу из M13.3 (`resize(+1) + realSize` tracker).

```cpp
#include <iostream>
#include <vector>

int main() {
    std::vector<int> v = {1, 2, 3};  // size=3, capacity≥3
    v.push_back(10);                  // size=4, capacity≥4
    
    for (int x : v) std::cout << x << " ";  // 1 2 3 10
    return 0;
}
```

---

## Часть 2 — `size()` vs `capacity()`

| Метод            | Что возвращает                          |
|------------------|-----------------------------------------|
| `vec.size()`     | Логическое количество элементов         |
| `vec.capacity()` | Сколько зарезервировано (size + резерв) |

`capacity()` — то самое о чём в M13.3 был `realSize` (только наоборот: там size был capacity, а realSize — size).

### Демо grow pattern (1000 push_back)

```cpp
std::vector<int> v;
for (int i = 0; i < 1000; i++) {
    v.push_back(i);
    if (i % 100 == 1) {
        std::cout << "size=" << v.size() 
                  << " capacity=" << v.capacity() << "\n";
    }
}
```

### Output (наблюдённое в видео)

| size | capacity | grow от пред | growth factor |
|------|----------|--------------|---------------|
| 5    | 6        | -            | -             |
| 100  | 140      | +40          | ~1.4×         |
| 500  | 711      | +200 (рост)  | ~1.4×         |

> "Вектор устроен очень хитро. Чем больше элементов мы кладем в него, тем больше
> элементов ему надо в дальнейшем резервировать."

Это и есть **амортизированный `O(1)`** push_back.

---

## Часть 3 — `pop_back()` удаление последнего

### Что делает

`vec.pop_back()`:

1. `resize(size - 1)` — фактически
2. Также **возвращает удалённый элемент** (полезный bonus)
3. Не меняет capacity (память не освобождается, только size)

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};
v.pop_back();   // v = {1, 2, 3, 4}, return = 5
```

### Pitfall

`pop_back` на пустом векторе — **undefined behavior**. Всегда проверять `!v.empty()` сначала.

---

## Часть 4 — Практическая задача "Голос"

### Условие

На кастинг "Голос" приходят 10 человек. Каждый получает оценку 0-100.

Жюри ведёт список:

- Если новая оценка `> last_in_list` → удалить с конца все меньшие, добавить новую
- Если новая `<= last` → добавить в конец без удаления

Вывести финальный список.

### Пример

```text
Inputs: 99, 70, 60, 80
Step 1: [99]
Step 2: [99, 70]      (70 < 99, просто add)
Step 3: [99, 70, 60]  (60 < 70, просто add)
Step 4: [99, 80]      (80 > 60 → pop, 80 > 70 → pop, 80 < 99 → stop, add 80)
```

### Реализация

```cpp
#include <iostream>
#include <vector>

int main() {
    std::vector<int> scores;
    int input;
    
    while (std::cin >> input) {
        // Удалить с конца все меньшие
        while (!scores.empty() && scores.back() < input) {
            scores.pop_back();
        }
        // Добавить новую
        scores.push_back(input);
    }
    
    // Output
    for (int s : scores) std::cout << s << " ";
    std::cout << "\n";
    return 0;
}
```

**Альтернативно** — `scores[scores.size() - 1]` вместо `scores.back()`. `back()` чище и идиоматичнее.

### Тест-кейсы из видео

| Inputs                                            | Output                  |
|---------------------------------------------------|-------------------------|
| 1, 3, 4, 5, 6, 10, 11, 20, 30, 40 (по возр.)      | `40`                    |
| 99, 90, 80, 78, 70, 69, 60, 55, 50, 45 (по убыв.) | `99 90 80 ... 45` (все) |
| 10, 60, 40, 73, 13, 29, 89, 63, 42, 13            | `89 63 42 13`           |

### Ассимптотика

Amortized total: каждый элемент push_back-ится 1 раз и pop_back-ится максимум 1 раз → **O(N)** по N inputs.

Это классическая задача на **monotonic stack** — паттерн часто встречается на собесах
(трудность от LeetCode "Easy" до "Hard"). Запомни идею.

---

## Take-aways

1. **`push_back(v)`** — встроенная замена `resize(+1) + assign`. Амортизированно O(1).
2. **`pop_back()`** — встроенная замена `resize(-1)`. Возвращает удалённый элемент. UB на empty.
3. **`size()` vs `capacity()`** — логический размер vs выделено. `capacity > size` — норма.
4. **Grow factor** реализации: ~1.4-1.5× у gcc/MSVC, у других может быть ×2.
5. **`v.back()`** / `v.front()` — идиомы для last/first. Лучше чем `v[v.size()-1]` / `v[0]`.
6. **Monotonic stack pattern** — задача "Голос" = классический шаблон для задач "найти previous greater" / "stock span" / "histogram максимальный прямоугольник".
7. **`reserve(n)`** (упоминается в M13.5?) — pre-allocate если знаешь N заранее → даже одна копирования не будет.

---

## Связь с Module 13 hwork (твой код на диске)

Tasks с push_back / pop_back на диске:

- `Module13th/Module13Tasks/Task4_RobotQueue/main.cpp`
- `Module13th/Module13Tasks/Task5_Hospital/main.cpp`
- `Module13th/Module13Tasks/Task6_RobotCorruption/main.cpp`

После этого урока имеет смысл проверить — используют ли они push_back/pop_back
правильно, проверяют ли empty() перед pop_back.

---

## Анонс M13.5

Следующий урок — "Полезные функции std::vector". Вероятно: `reserve()`, `clear()`,
`insert()`, `erase()`, `front()`, `back()`, `empty()`, итераторы.
