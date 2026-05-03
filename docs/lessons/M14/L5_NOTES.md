# M14.5 — Функции над 2D + многомерные + vector<vector>

**Дата урока:** 2026-05-03
**Длина:** 8:39
**Источник:** `L5_функции_многомерные.{vtt,txt}`

Финальный урок M14: передача 2D в функции (by-value vs by-pointer), многомерные
массивы (Minecraft пример), `std::vector<std::vector<T>>` (jagged 2D).

---

## Часть 1 — Функции с 2D массивами

### By-value (плохо для матриц)

```cpp
float[N][N] multiplyMatrices(float A[N][N], float B[N][N]) {
    // ... возвращает новую матрицу C
}
```

**Проблемы:**

1. Под аргументы выделяется память на **stack** → 2 матрицы 4×4 × float = 128 байт + return value = ещё 64 байт
2. **Копирование** аргументов и return value: ~3 копии × 16 элементов = 48 ops
3. Большие матрицы → **stack overflow** ("крах, бум, бах")

> "Если память на стеке иссякнет, в программе кранты. Будет crash, бум, бах,
> а не программа."

### By-pointer (правильный способ)

```cpp
void multiplyMatrices(float A[][N], float B[][N], float C[][N]) {
    // ... записывает в C напрямую (in/out parameter)
}

// Use:
float A[N][N], B[N][N], C[N][N];
multiplyMatrices(A, B, C);
```

### Что изменилось

1. **`void`** возврат — нет return value на stack
2. **Out-параметр C** — добавлен в список аргументов, заполняется в функции
3. **`A[][N]` вместо `A[N][N]`** — первая константа исчезла → С++ передаёт по указателю (decay)

> "Это и является гарантией того, что матрицы передаются не по значению, а по
> указателю. Ссылки. Подробнее о ссылках будет позже в этом курсе."

### Why `A[][N]` works

В C++ массивы decay в pointers при передаче в функцию. Для 2D — нужно
указать **все размеры кроме первого**, чтобы компилятор знал stride
(сколько элементов в строке).

---

## Часть 2 — Многомерные массивы (3D+)

### Пример — Minecraft world

```cpp
const int W = 100, H = 100, D = 100;
bool world[W][H][D];   // 1,000,000 boolean = ~1 MB

// Индексация
world[x][y][z] = true;   // блок присутствует на координатах (x, y, z)
```

> "Это и будет одним из домашних заданий этого урока. Шутка!"

### Когда оправдано

- 3D voxel grids (Minecraft, voxel raytracing)
- Tensor data (ML, computer vision RGB volumes)
- Time series над 2D данными (`[time][row][col]`)
- Physics simulations (3D fields)

В большинстве случаев — `vector<vector<vector<T>>>` или dedicated tensor
libraries (Eigen, xtensor) предпочтительнее raw arrays.

---

## Часть 3 — `std::vector<std::vector<T>>` (jagged 2D)

### Концепт

Динамический 2D, где **каждая строка может иметь разную длину** ("jagged array").

```cpp
std::vector<std::vector<int>> buildings = {
    {3, 5, 1},                              // офис: 3 этажа
    {12, 8, 5, 7, 4, 9, 2, 6},              // жилой дом: 8 этажей
    {3}                                      // автомойка: 1 этаж
};
```

**Семантика:** массив зданий, каждое здание = vector с количеством людей
на этажах.

**Visualization:**

```text
buildings[0]: [3, 5, 1]                     ← короткое здание
buildings[1]: [12, 8, 5, 7, 4, 9, 2, 6]     ← высокое
buildings[2]: [3]                           ← одноэтажное
```

### Index access — same as 2D arr

```cpp
int people = buildings[1][4];   // 5й этаж 2-го здания (0-indexed)
buildings[2][0] = 0;             // автомойка опустела
```

### Полный набор vector методов работает

```cpp
buildings.pop_back();             // убрать автомойку (закрылась)
buildings[0].push_back(2);        // надстроить этаж в офисе
buildings[1].size();              // 8 (этажей в жилом доме)
buildings.size();                 // количество зданий
```

### Pitfall — bounds check

> "Единственное, что требуется, это дополнительно следить за границами индексов,
> так как они могут разниться от столбца к столбцу."

```cpp
// Безопасный доступ
if (i < buildings.size() && j < buildings[i].size()) {
    int v = buildings[i][j];
}

// Или через .at() — бросает std::out_of_range
int v = buildings.at(i).at(j);
```

---

## Сравнение: 2D array vs vector<vector>

| Параметр                  | `int arr[N][M]`             | `vector<vector<int>>`            |
|---------------------------|-----------------------------|----------------------------------|
| Размер                    | Fixed at compile-time       | Dynamic                          |
| Размер строк              | Все одинаковые (N×M)        | **Могут быть разные** (jagged)   |
| Memory layout             | Contiguous (cache-friendly) | Pointer indirection (slower)     |
| Allocation                | Stack (или global)          | Heap                             |
| Resize                    | НЕТ                         | Да через push_back/resize        |
| Передача в функцию        | Decay в pointer             | By const-reference               |

**Правило:** если размер известен и неизменен → 2D array. Если динамический
или jagged → vector<vector>.

---

## Take-aways

1. **Matrices в функциях** — by-pointer (`A[][N]` syntax), in/out параметр для
   результата. Никогда by-value для больших.
2. **Multi-D arrays** существуют (`arr[X][Y][Z]`), но редко нужны без библиотек
3. **`vector<vector<T>>`** — для **jagged** 2D (разные длины строк)
4. **Vector methods работают** на каждом уровне — `.push_back()`, `.size()`, etc
5. **Bounds checking важен** для jagged — каждая строка свой size
6. **Memory:** stack для arrays (limited), heap для vectors (unlimited)

---

## Module 14 — completion summary

После M14.5 — Module 14 видео часть **100% complete**:

| Lesson | Тема                                     | Длина  | NOTES.md   |
|--------|------------------------------------------|--------|------------|
| 14.1   | Интро + разбор M13.6 Task3 (ring buffer) | 4:19   | [+]        |
| 14.2   | Знакомство, объявление, индексация       | 14:06  | [+]        |
| 14.3   | Вложенные циклы, ввод/вывод              | 14:28  | [+]        |
| 14.4   | Матрицы (transpose, multiply)            | 12:17  | [+]        |
| 14.5   | Функции, многомерные, vector<vector>     | 8:39   | [+] (этот) |

Total: **53:49 видео + 5 NOTES.md** = comprehensive coverage 2D massiv'ов.

**Остаётся:** 14.6 Практическая работа (read_only, hwork — будем решать как M13.6).
