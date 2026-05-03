# M14.4 — Матрицы. Сложные алгоритмы на 2D массивах

**Дата урока:** 2026-05-03
**Длина:** 12:17
**Источник:** `L4_матрицы.{vtt,txt}`

Linear algebra базис: матрицы 4×4, transpose, multiply. Bridge к computer
graphics + AI.

> "Матричная математика — это основа компьютерной графики. И если вы планируете
> заниматься ею как программист, возможно как разработчик игр, обязательно надо
> её хорошенько изучить."

---

## Setup — матрица 4×4 float

```cpp
const int N = 4;
float matrix[N][N];
```

Почему 4×4: не trivial как 2×2 или 3×3, и **наиболее популярны в реальной разработке**
(в графике 4×4 = transformation matrices с homogeneous coords).

---

## Алгоритм 1 — Transpose (in-place)

### Идея

Транспонирование = swap `matrix[i][j]` ↔ `matrix[j][i]`. Диагональ остаётся
неизменной.

### Оптимальный pattern (только верхний треугольник)

```cpp
for (int i = 0; i < N - 1; i++) {        // i до N-1 (последняя строка = только diag)
    for (int j = i + 1; j < N; j++) {    // j от i+1 (выше диагонали)
        float temp = matrix[i][j];
        matrix[i][j] = matrix[j][i];
        matrix[j][i] = temp;
    }
}
```

### Почему такие границы

- `i < N - 1`: последняя строка (i=N-1) содержит только diagonal element [N-1][N-1] — нечего swap'ать
- `j > i`: только верхний треугольник (нижний отзеркалится автоматически через swap)

### Pattern visualization (4×4)

```text
    j=0 j=1 j=2 j=3
i=0 [.] [s] [s] [s]    ← s = swap кандидаты
i=1 [.] [.] [s] [s]       (j > i)
i=2 [.] [.] [.] [s]
i=3 [.] [.] [.] [.]    ← i=3 пропускаем (i < N-1)
```

### Pitfall (важно)

**Без temp переменной нельзя:** `matrix[i][j] = matrix[j][i]` сразу затрёт оригинал.
C++ не имеет atomic swap для array elements.

C++11+: можно использовать `std::swap(matrix[i][j], matrix[j][i])` (тот же
результат, но идиоматичнее).

---

## Алгоритм 2 — Matrix multiply (3 nested loops)

### Условие

C = A × B где элемент `C[i][j]` = сумма попарных произведений строки `i` из A
и столбца `j` из B:

```text
C[i][j] = Σ_k (A[i][k] * B[k][j])
```

Для 4×4 матриц: 4 умножения + 3 сложения per element, 16 elements = 64 ops total.

### Реализация (triple nested loop, O(N³))

```cpp
float A[N][N], B[N][N], C[N][N];

for (int i = 0; i < N; i++) {           // строки результата
    for (int j = 0; j < N; j++) {       // столбцы результата
        float sum = 0;
        for (int k = 0; k < N; k++) {   // dot product
            sum += A[i][k] * B[k][j];
        }
        C[i][j] = sum;
    }
}
```

### Index семантика

| Индекс | Что означает                                                           |
|--------|------------------------------------------------------------------------|
| i      | Текущая строка result (берём строку i из A)                            |
| j      | Текущий столбец result (берём столбец j из B)                          |
| k      | Pairwise iterator: проходит и по столбцу A, и по строке B одновременно |

### Mental model (важно понять)

```text
A row i:   [A[i][0]  A[i][1]  A[i][2]  A[i][3]]
                ↓        ↓        ↓        ↓
            multiply    multiply  multiply  multiply
                ↓        ↓        ↓        ↓
B col j:   [B[0][j]  B[1][j]  B[2][j]  B[3][j]]
                ↓
              SUM = C[i][j]
```

### Performance note (не из урока)

- O(N³) — для N=4 это 64 ops, для N=1000 = миллиард
- Для крупных матриц используют **Strassen's algorithm** (O(N^2.807))
- В реальных приложениях — **BLAS / Eigen / cuBLAS** (cache-blocked + SIMD + GPU)
- Для квадратных матриц **3 цикла оптимальны** для алгоритмически.

---

## Take-aways

1. **Matrix transpose** — only upper triangle (`j > i`), avoid double-swap
2. **Need `temp`** для swap'а — нет atomic swap для array
3. **Matrix multiply** — triple nested loop, индекс `k` = pairwise iterator
4. **`A[i][k] * B[k][j]`** — это **dot product** строки на столбец
5. **O(N³) — норма** для quadratic matrices в наивной реализации
6. **Bridge к real applications:**
   - Computer graphics (3D rendering, transformations)
   - Machine Learning (neural network weights)
   - Linear algebra (eigenvalues, decompositions)
   - Production: используй `Eigen`, `BLAS`, `cuBLAS` вместо своих циклов

---

## Анонс M14.5

> "Идём вперёд!"

M14.5 — Функции над двумерными массивами + многомерные / vector<vector>.
