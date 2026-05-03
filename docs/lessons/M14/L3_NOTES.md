# M14.3 — Проход вложенным циклом, ввод и отображение 2D

**Дата урока:** 2026-05-03
**Длина:** 14:28
**Источник:** `L3_вложенные_циклы.{vtt,txt}`

Practical patterns для работы с 2D массивами через nested loops: traversal,
input/output, простая graphics (рамка, диагонали).

---

## Nested loop pattern

### Standard (row-major iteration)

```cpp
for (int i = 0; i < ROWS; i++) {       // outer = строки (этажи)
    for (int j = 0; j < COLS; j++) {    // inner = столбцы (подъезды)
        // process arr[i][j]
    }
}
```

**Total steps:** `ROWS × COLS` (50 в нашем примере).

**Терминология:**

- Внешний цикл (outer) — `i`
- Вложенный / внутренний (inner) — `j`

**Альтернатива** — поменять местами `i` и `j` (col-major). Тоже работает, но
менее привычно глазу.

### Performance note (не из урока)

Row-major iteration **быстрее** в C++ потому что элементы строки лежат подряд в памяти
→ cache-friendly. Col-major создаёт cache misses на каждой итерации.

---

## Подсчёт по 2D массиву (presence example)

Подсчитать процент заполненности дома:

```cpp
int count = 0;
for (int i = 0; i < FLOORS; i++) {
    for (int j = 0; j < ENTRANCES; j++) {
        if (presence[i][j] == true) {
            count++;
        }
    }
}

float percent = count * 100.0f / (FLOORS * ENTRANCES);
std::cout << "Percent occupied: " << percent << "%\n";
```

Уплотнённый вариант:

```cpp
if (presence[i][j]) count++;   // implicit bool check
```

---

## User input → 2D через nested loop

```cpp
int tenants[FLOORS][ENTRANCES];

for (int i = 0; i < FLOORS; i++) {
    for (int j = 0; j < ENTRANCES; j++) {
        std::cin >> tenants[i][j];
    }
}
```

Пользователь вводит `FLOORS × ENTRANCES = 50` чисел подряд.

---

## Output форматирование 2D

### Naive (всё в одну строку)

```cpp
for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
        std::cout << arr[i][j];
    }
}
// Output: 1234567...   ← слиплось, нечитаемо
```

### Add separator (пробелы между числами)

```cpp
for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
        std::cout << arr[i][j] << " ";
    }
}
// Output: 1 2 3 4 5 6 7...   ← всё ещё в одну строку
```

### Final (newlines между строками)

```cpp
for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
        std::cout << arr[i][j] << " ";
    }
    std::cout << std::endl;   // ← снаружи inner loop! внутри outer
}
// Output:
// 1 2 3 4 5
// 6 7 8 9 10
// ...
```

**Pitfall:** если `endl` написать **внутри** inner loop — каждое число будет на
своей строке, всё сольётся в один длинный столбец.

---

## Graphics pattern — рисование на 2D массиве

Урок: 10×10 mosaic с цветами 0=белый, 1=красный, 2=синий.

### Заливка одним цветом

```cpp
int mosaic[10][10];
for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
        mosaic[i][j] = 1;  // все красные
    }
}
```

### Border (рамка) — 4 прохода с одним const index

```cpp
// Top row (i=0)
for (int j = 0; j < 10; j++) mosaic[0][j] = 2;

// Bottom row (i=9)
for (int j = 0; j < 10; j++) mosaic[9][j] = 2;

// Left col (j=0)
for (int i = 0; i < 10; i++) mosaic[i][0] = 2;

// Right col (j=9)
for (int i = 0; i < 10; i++) mosaic[i][9] = 2;
```

**Pattern:** один index = константа (граница), второй пробегает.

### Диагональ (Андреевский крест ×)

```cpp
// Main diagonal: arr[0][0], arr[1][1], ..., arr[9][9]
for (int i = 0; i < 10; i++) {
    mosaic[i][i] = 0;     // i used twice → "натуральная" диагональ
}

// Anti-diagonal: arr[0][9], arr[1][8], ..., arr[9][0]
for (int i = 0; i < 10; i++) {
    mosaic[i][9 - i] = 0;   // inversion: max - i
}
```

**Inversion idiom** — `(MAX - i)` для перевернутого направления. Часто
встречается в графике / mirror operations.

> "Приблизительно так и рисуется графика на экране компьютера. Конечно, всё
> несколько интереснее, но принципы схожи."

Bridge к Computer Graphics — каждый pixel = (x,y) на 2D framebuffer.

---

## Take-aways

1. **Nested loop = standard** для 2D traversal. Outer = rows, inner = cols.
2. **Output формат:** separator внутри inner, newline ВНУТРИ outer но СНАРУЖИ inner.
3. **Граница (border)** — 4 цикла с одним const index.
4. **Диагональ** — `arr[i][i]` (single loop, var used twice).
5. **Anti-diagonal** — `arr[i][N-1-i]` (inversion idiom).
6. **2D == графика** — концептуальная связь с framebuffer / canvas.
7. **Cache locality** — row-major faster чем col-major (не упомянуто, но критично для перф).

---

## Анонс M14.4

> "Переходим к более абстрактным примерам."

M14.4 — Матрицы. Сложные алгоритмы на двумерных массивах.
