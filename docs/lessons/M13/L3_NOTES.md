# M13.3 — Удаление элемента со сдвигом (про vector resize)

**Дата урока:** 2026-05-03 (transcribed from Skillbox видео)
**Длина:** 15:06
**Источник:** `L3_удаление_со_сдвигом.{vtt,txt}`

Несмотря на title, урок в первую очередь — про **`vec.resize()`**, который
заменяет ручное копирование. Также — про **амортизированный grow pattern**
(привет к будущему `push_back()` в M13.4).

---

## Часть 1 — наивный removeLast (без resize)

### Задача

Написать функцию которая принимает vector и возвращает vector с удалённым последним.

### Наивная реализация

```cpp
std::vector<int> removeLast(std::vector<int> vec) {
    std::vector<int> result(vec.size() - 1);
    for (size_t i = 0; i < vec.size() - 1; i++) {
        result[i] = vec[i];
    }
    return result;
}

// Use:
std::vector<int> v = {3, 4, 35, 19, 1};  // size 5
v = removeLast(v);                        // size 4: {3, 4, 35, 19}
```

**Pattern (parallel с `add` из предыдущего урока):** create new vector нужного size →
скопировать elements → return.

---

## Часть 2 — `vec.resize(n)` — built-in метод

### Что делает

- Уменьшение: trim из конца (без копирования всего вектора)
- Увеличение: дополняет нулями
- **Не копирует** в новый объект — модифицирует существующий

### removeLast через resize

```cpp
vec.resize(vec.size() - 1);  // одна строка вместо функции
```

### Multi-element trim

```cpp
vec.resize(vec.size() - 3);  // удалить 3 последних
```

### Pitfall (важно)

> "Если вы хотели использовать вектор после удаления, оставив исходный — **не делайте resize**,
> потому что вы потеряете последний элемент."

`resize` модифицирует in-place. Если нужен `original_vec` неизменным — копировать заранее.

---

## Часть 3 — `add` через resize

### Замена наивного add

```cpp
// Было (с копированием):
std::vector<int> add(std::vector<int> vec, int value) {
    std::vector<int> result(vec.size() + 1);
    for (size_t i = 0; i < vec.size(); i++) result[i] = vec[i];
    result[vec.size()] = value;
    return result;
}

// Стало (через resize):
void add(std::vector<int>& vec, int value) {
    vec.resize(vec.size() + 1);
    vec[vec.size() - 1] = value;  // НЕ vec.size(), а size-1!
}
```

### Pitfall (индексы)

> "Сначала мы увеличиваем вектор до vec.size + 1, но потом size увеличивается на 1.
> И для того, чтобы обратиться к последнему элементу, нам необходимо записывать
> в индекс vec.size минус 1."

После `resize`, `vec.size()` уже **новое** значение. Last index = `vec.size() - 1`.

---

## Часть 4 — почему "просто и неэффективно"

### Демо-программа

User вводит positive integers, при `-1` — show среднее + reverse, при `-2` — exit.

```cpp
#include <iostream>
#include <vector>

int main() {
    std::vector<int> vec;
    int input;
    std::cin >> input;
    while (input != -2) {
        if (input == -1) {
            float sum = 0;
            for (int v : vec) sum += v;
            float avg = sum / vec.size();
            std::cout << "Avg: " << avg << "\n";
            for (int i = (int)vec.size() - 1; i >= 0; i--) {
                std::cout << vec[i] << " ";
            }
            std::cout << "\n";
        } else {
            // Add element using resize
            vec.resize(vec.size() + 1);
            vec[vec.size() - 1] = input;
        }
        std::cin >> input;
    }
    return 0;
}
```

### Проблема

`resize(+1)` каждый раз = **O(n) на одну операцию** (потому что resize может перевыделить
память и скопировать все элементы). N добавлений → **O(n²)** total.

> "Хорошо работает когда элементов мало. Но когда хотим добавить к вектору в котором уже
> 1000 или 10000 элементов, это будет работать очень медленно."

Это именно та проблема которую решает `std::vector::push_back()` через
**амортизированный constant time**.

---

## Часть 5 — оптимизация через batch grow + realSize tracker

### Идея

Вместо `resize(+1)` каждый раз, делаем `resize(+10)` (или `×2`) когда место кончается.
И трекаем настоящее количество элементов отдельно через `realSize`.

```cpp
#include <iostream>
#include <vector>

int main() {
    std::vector<int> vec;
    size_t realSize = 0;
    int input;
    std::cin >> input;
    while (input != -2) {
        if (input == -1) {
            float sum = 0;
            for (size_t i = 0; i < realSize; i++) sum += vec[i];
            float avg = sum / realSize;
            std::cout << "Avg: " << avg << "\n";
            std::cout << "realSize: " << realSize 
                      << ", capacity (vec.size): " << vec.size() << "\n";
            for (int i = (int)realSize - 1; i >= 0; i--) {
                std::cout << vec[i] << " ";
            }
            std::cout << "\n";
        } else {
            // Grow когда место кончается — на 10 за раз
            if (realSize == vec.size()) {
                vec.resize(vec.size() + 10);
            }
            vec[realSize] = input;
            realSize++;
        }
        std::cin >> input;
    }
    return 0;
}
```

### Stats из видео-демо

| Inputs                          | realSize | vec.size (capacity) |
|---------------------------------|----------|---------------------|
| 1, 2, 10, 11, 14, 23, 25        | 7        | 10                  |
| + 3, 5, 6, 7                    | 11       | 20                  |

Capacity растёт **batch'ами** по 10 (или другой policy: ×2, ×1.5).

### Trade-offs grow factor

| Factor    | Allocations | Memory waste     | Use case                |
|-----------|-------------|------------------|-------------------------|
| +1 each   | O(n)        | none             | known small N (плохо)   |
| +K linear | O(n/K)      | up to K-1        | predictable growth      |
| ×2        | O(log n)    | up to N (50%)    | std::vector default     |
| ×1.5      | O(log n)    | up to N/2 (33%)  | компромисс (gcc, MSVC)  |

> "Это всё зависит от того, сколько всего элементов вы планируете использовать."

---

## Связь с домашним заданием M13.6 (на твоём диске)

Tasks M13.4 (Robot queue), M13.5 (Hospital), M13.6 (Robot corruption) — все
работают с vector + dynamic add/remove. Преподаватель явно говорит:

> "В домашнем задании попробуйте не просто выполнить задание, чтобы оно работало правильно,
> но и чтобы выделение ресурсов и памяти у вашего вектора было немного оптимальным."

### Файлы которые трогают `resize/push_back/reserve` в репо

- `Module13th/Module13Tasks/Task4_RobotQueue/main.cpp`
- `Module13th/Module13Tasks/Task5_Hospital/main.cpp`
- `Module13th/Module13Tasks/Task6_RobotCorruption/main.cpp`

Стоит проверить их с этой точки зрения — используется ли batch grow / `reserve()`,
или каждое добавление = `push_back` (которое уже `O(1)` амортизированно, что лучше
ручного `resize(+1)`).

---

## Take-aways

1. **`vec.resize(n)`** — built-in: **trim** из конца (без copy) или **fill nulls** при увеличении
2. **resize мутирует in-place** — если нужна копия, `auto copy = vec; copy.resize(...)`
3. **Index pitfall** — после `resize(+1)`, last element это `vec[size-1]`, не `vec[size]`
4. **`resize(+1)` на каждый add = O(n²)** — потому что capacity может пересоздаваться каждый раз
5. **Batch grow + realSize tracker** — манипуляция руками тем что `vector::push_back` делает автоматически
6. **`std::vector::push_back`** (тема следующего урока M13.4) — амортизированный `O(1)` как раз через batch grow

---

## Анонс M13.4

> Следующий урок — `push_back()` (использование готового метода вместо ручного resize).
> В нашем kanban это следующий video в M13 backlog.
