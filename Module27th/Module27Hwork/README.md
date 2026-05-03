# Module 27.4 — Практическая работа (homework)

**Status:** code готов, 20/20 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M27/L4_HWORK.md`
**Solved:** 3/3 mandatory

## Структура

```text
Module27Hwork/
├── README.md, test_all.sh
├── Task1_Shapes/    # Shape (abstract) + Circle/Square/Triangle/Rectangle
├── Task2_Company/   # CEO + Manager + Worker, srand-based task assignment
└── Task3_Elves/     # Branch (унифицированный для дерева/большой/средней)
```

## Tasks summary

### Task 1 — Shapes

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Иерархия   | Shape (abstract) → Circle/Square/Triangle/Rectangle     |
| enum       | Color { None, Red, Green, Blue }                        |
| Методы     | virtual area(), virtual bbox(w,h)                       |
| Команды    | circle/square/triangle/rectangle/exit                   |
| Tests      | 6                                                       |
| Status     | [+] PASS                                                |

### Task 2 — Company

| Параметр   | Значение                                                   |
|------------|------------------------------------------------------------|
| Иерархия   | CEO → Manager → Worker (без OOP-наследования, composition) |
| Random     | srand(cmd + manager_id), tasksCount = rand() % (size+1)    |
| Tasks      | A/B/C типы, выбираются случайно                            |
| Завершение | когда все workers заняты → ALL WORKERS BUSY                |
| Tests      | 6                                                          |
| Status     | [+] PASS                                                   |

### Task 3 — Elves

| Параметр   | Значение                                                 |
|------------|----------------------------------------------------------|
| Класс      | Branch (унифицированный): parent + children + elfName    |
| Лес        | 5 деревьев, 3-5 больших ветвей, 2-3 средних              |
| Поиск      | findElf() рекурсивный + getTopBranch() для большой ветви |
| Тесты      | --target= для CLI override (избегаем stdin overflow)     |
| Tests      | 8                                                        |
| Status     | [+] PASS                                                 |

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module27th/Module27Hwork/Task1_Shapes/main.cpp>          |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module27th/Module27Hwork/Task2_Company/main.cpp>         |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module27th/Module27Hwork/Task3_Elves/main.cpp>           |
