# Module 25.4 — Практическая работа (homework)

**Status:** code готов, 13/13 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M25/L4_HWORK.md`
**Solved:** 2/2 mandatory

## Структура

```text
Module25Hwork/
├── README.md, test_all.sh
├── Task1_Surgery/         # 1 CMakeLists, src+include, инструменты
│   ├── CMakeLists.txt
│   ├── include/tools.h
│   └── src/{main,tools}.cpp
└── Task2_Computer/        # 2 CMakeLists (root + src), 5 modules
    ├── CMakeLists.txt
    ├── include/{cpu,ram,disk,gpu,kbd}.h
    └── src/
        ├── CMakeLists.txt
        └── {main,cpu,ram,disk,gpu,kbd}.cpp
```

## Tasks summary

### Task 1 — Surgery

| Параметр   | Значение                                                             |
|------------|----------------------------------------------------------------------|
| Алгоритм   | scalpel/hemostat/tweezers/suture, Point2D struct                     |
| Структура  | include/tools.h + src/{main,tools}.cpp + CMakeLists                  |
| Edge cases | suture с одинаковыми точками = exit, hemostat-before-scalpel ignored |
| Tests      | 6                                                                    |
| Status     | [+] PASS                                                             |

### Task 2 — Computer (multi-module)

| Параметр    | Значение                                                |
|-------------|---------------------------------------------------------|
| Алгоритм    | 5 модулей: cpu/ram/disk/gpu/kbd + main                  |
| Структура   | 2 CMakeLists.txt + include/ + src/                      |
| Особенность | RAM buffer изолирован в namespace { } внутри ram.cpp    |
| Команды     | input/sum/save/load/display/exit                        |
| Tests       | 7                                                       |
| Status      | [+] PASS                                                |

## Submission

Архив: см. spec. Файлы:
- Task 1: `CMakeLists.txt`, `include/tools.h`, `src/main.cpp`, `src/tools.cpp`
- Task 2: `CMakeLists.txt`, 5 .h, `src/CMakeLists.txt`, 6 .cpp

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module25th/Module25Hwork/Task1_Surgery/src/main.cpp>     |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module25th/Module25Hwork/Task2_Computer/src/main.cpp>    |
