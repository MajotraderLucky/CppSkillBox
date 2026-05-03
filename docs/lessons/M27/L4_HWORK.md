# M27.4 — Практическая работа (homework)

**Источник:** `https://go.skillbox.ru/.../homework/8831e8c5-d620-4d60-ac1f-38b82bfb31c4`
**Цели:** конструкторы + this + иерархии классов

## Что входит

3 задачи (все обязательные)

---

## 1. Иерархия геометрических фигур

### Что нужно

Базовый класс **`Shape`** с общими полями:
- координаты центра (double x, y)
- цвет (`enum Color { None, Red, Green, Blue }`)

Дочерние классы:
| Фигура         | Уникальные поля   |
|----------------|-------------------|
| `Circle`       | radius            |
| `Square`       | side              |
| `Triangle`     | side (равностор.) |
| `Rectangle`    | width, height     |

Каждая фигура должна реализовывать:
- **`area()`** — площадь
- **`bbox()`** — описывающий прямоугольник (width, height)

### Команды

`circle <x> <y> <color> <radius>` → площадь + bbox

(Аналогично для square/triangle/rectangle.)

### Формулы

- Circle: π·r² (`atan(1)*4 * r * r`), bbox = `2r × 2r`
- Square: `s²`, bbox = `s × s`
- Triangle (equilateral): `s² · √3 / 4`, bbox = `s × (s·√3/2)`
- Rectangle: `w · h`, bbox = `w × h`

---

## 2. Симуляция работы компании

### Что нужно

Иерархия:
- **`Worker`** — имя, тип задачи (A/B/C), занят/свободен
- **`Manager`** — порядковый номер, команда из Workers
- **`CEO`** — список Managers

Workflow:
1. Пользователь → CEO команда (int)
2. CEO передаёт каждому Manager
3. Каждый Manager делает `srand(cmd + manager_id)` и выбирает `rand() % (workers.size() + 1)` задач
4. Распределяет задачи (A/B/C) случайно среди свободных workers
5. Программа завершается когда все workers заняты

### Подсказки

- Используй наследование (Worker base?)
- Указатель `this` если нужно

---

## 3. Деревня эльфов

### Что нужно

Лес из 5 деревьев. Один класс **`Branch`** для всего:
- ствол / большая ветвь / средняя ветвь
- `Branch* parent` (nullptr для дерева)
- `vector<Branch*> children`
- `Elf* elf` (или `string elfName`)

### Структура

- 5 деревьев
- На каждом дереве 3-5 больших ветвей
- На каждой большой 2-3 средних

### Workflow

1. Обход всех больших + средних ветвей, ввод имени эльфа
2. `None` → пропустить
3. Запрос имени для поиска
4. Найти большую ветвь с этим эльфом → подсчитать всех эльфов на этой ветви + поддереве

### Подсказки

```cpp
Branch* getTopBranch() {
    if (parent == nullptr) return nullptr;        // дерево
    if (parent->parent == nullptr) return this;   // большая ветвь
    return parent->getTopBranch();                 // подняться
}
```

Рекурсивный поиск эльфа по имени в Branch.

---

## Submission

- Replit deep-link или .cpp
- Проверка отключена (content-first phase)
