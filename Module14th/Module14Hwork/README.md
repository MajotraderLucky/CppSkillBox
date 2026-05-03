# Module 14.6 — Практическая работа (homework)

**Status:** code готов, 70/70 tests pass, **submit blocked** (Skillbox support отключён → `access="read_only"`)
**Спецификация:** см. `../../docs/lessons/M14/L6_HWORK.md`
**Solved:** 5 mandatory tasks (минимум для зачёта)

## Структура

```text
Module14Hwork/
├── README.md (этот файл)
├── test_all.sh                          # batch runner (70 tests total)
├── Task1_Banquet/                       # массивы приборов/посуды/стульев
│   ├── main.cpp                         # 13 tests
│   └── test.sh
├── Task2_TicTacToe/                     # 3×3 game
│   ├── main.cpp                         # 13 tests
│   └── test.sh
├── Task3_Matrices/                      # compare 4×4 + diagonalize
│   ├── main.cpp                         # 15 tests
│   └── test.sh
├── Task4_MatVec/                        # matrix × vector
│   ├── main.cpp                         # 11 tests
│   └── test.sh
└── Task5_BubbleWrap/                    # 12×12 region pop
    ├── main.cpp                         # 18 tests
    └── test.sh
```

## Сборка и тестирование

```bash
# Все 5 задач
./test_all.sh

# Одна задача
./Task1_Banquet/test.sh

# Manual compile
cd Task1_Banquet && g++ -std=c++11 -Wall -Wextra main.cpp -o banquet
./banquet
```

## Tasks summary

### Task 1 — Банкетный стол

| Параметр       | Значение                                            |
|----------------|-----------------------------------------------------|
| Алгоритм       | 3 двумерных массива [2][6] + 4 сценарных события    |
| Edge cases     | invariant: total cutlery preserved, dimensions      |
| Tests          | 13 (initial state + 4 events + invariants + dims)   |
| Status         | [+] PASS                                            |

### Task 2 — Крестики-нолики

| Параметр       | Значение                                                             |
|----------------|----------------------------------------------------------------------|
| Алгоритм       | Game loop 9 ходов max + win check (rows + cols, без диагоналей)      |
| Edge cases     | OOB coords, taken cells, draw, players switch, errors не съедают ход |
| Tests          | 13 (3 row-wins + 3 col-wins + O wins + draw + 5 invalid)             |
| Status         | [+] PASS                                                             |

### Task 3 — Матрицы (compare + diagonalize)

| Параметр       | Значение                                                   |
|----------------|------------------------------------------------------------|
| Алгоритм       | Optimal early-break compare + zero-non-diag transformation |
| Edge cases     | mismatch на разных позициях, identity, zeros, negatives    |
| Tests          | 15 (4 equal + 3 not-equal + 7 diag + no-diag-when-unequal) |
| Status         | [+] PASS                                                   |

### Task 4 — Matrix × Vector

| Параметр       | Значение                                                                    |
|----------------|-----------------------------------------------------------------------------|
| Алгоритм       | Triple-nested-loop, аккумулятор reset перед каждой компонентой              |
| Edge cases     | identity, zero matrix, zero vector, negatives, fractional                   |
| Tests          | 11 (3 identity + 2 zero matrix + 1 zero vec + numeric + neg + frac + accum) |
| Status         | [+] PASS                                                                    |

### Task 5 — Пупырка (bubble wrap)

| Параметр       | Значение                                                                   |
|----------------|----------------------------------------------------------------------------|
| Алгоритм       | 3 функции (init, print, popRegion) + game loop                             |
| Edge cases     | OOB, reversed coords, double-pop idempotent, edge cells, single            |
| Tests          | 18 (full + single + partial + idempotent + reversed + 5 invalid + 4 edges) |
| Status         | [+] PASS                                                                   |

## Соответствие критериям hwork (из L6_HWORK.md)

| Критерий                                   | Status          |
|--------------------------------------------|-----------------|
| В циклах нет выхода за границы массивов    | [+]             |
| Повторяющиеся действия в функциях          | [+]             |
| Программы запускаются без syntax errors    | [+]             |
| Имена переменных корректные                | [+]             |
| Текстовый интерфейс (кроме Task 1)         | [+]             |
| Контроль ввода                             | [+] (Task2,3,5) |
| Выполнено минимум 5 заданий                | [+] (5/5)       |

## Submission links для преподавателя

Replit (тот же паттерн что использовался для M12 и M13.6 — `#<file_path>` deep-link):

| Task | Replit URL                                                                                                                |
|------|---------------------------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module14th/Module14Hwork/Task1_Banquet/main.cpp>                         |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module14th/Module14Hwork/Task2_TicTacToe/main.cpp>                       |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module14th/Module14Hwork/Task3_Matrices/main.cpp>                        |
| 4    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module14th/Module14Hwork/Task4_MatVec/main.cpp>                          |
| 5    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module14th/Module14Hwork/Task5_BubbleWrap/main.cpp>                      |

Backup (GitHub blob URLs):

| Task | GitHub URL                                                                                                                |
|------|---------------------------------------------------------------------------------------------------------------------------|
| 1    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module14th/Module14Hwork/Task1_Banquet/main.cpp>              |
| 2    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module14th/Module14Hwork/Task2_TicTacToe/main.cpp>            |
| 3    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module14th/Module14Hwork/Task3_Matrices/main.cpp>             |
| 4    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module14th/Module14Hwork/Task4_MatVec/main.cpp>               |
| 5    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module14th/Module14Hwork/Task5_BubbleWrap/main.cpp>           |

После git pull в Replit (как делалось для M13.6) — все файлы доступны по deep-link.

## Дополнительные задачи (не реализованы)

В hwork есть 3 опциональные задачи (для бонусных баллов или практики):

- Task 6 — Проход змейкой (без if-условий, formula-based)
- Task 7 — Почти Майнкрафт (3D массив + slice)
- Task 8 — Морской бой (10×10, ships, attacks)

Минимум для зачёта — **5 mandatory** (выполнено).
