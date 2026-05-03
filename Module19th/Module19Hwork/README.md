# Module 19.5 — Практическая работа (homework)

**Status:** code готов, 28/28 tests pass, **submit blocked**
**Спецификация:** см. `../../docs/lessons/M19/L5_HWORK.md`
**Solved:** 5/5 mandatory tasks

## Структура

```text
Module19Hwork/
├── README.md, test_all.sh
├── Task1_WordSearch/        # ifstream + count occurrences
├── Task2_TextViewer/        # binary read + gcount + chunks
├── Task3_Vedomost/          # parse "Name Surname amount date" + total + max
├── Task4_PngDetector/       # ext check + magic bytes [-119 P N G]
└── Task5_WhatWhereWhen/     # 13 sectors game + score to 6
```

## Tasks summary

### Task 1 — Word Search

| Параметр   | Значение                                       |
|------------|------------------------------------------------|
| Алгоритм   | f >> word, count if matches                    |
| Edge cases | missing word (0), case-sensitive, missing file |
| Tests      | 6                                              |
| Status     | [+] PASS                                       |

### Task 2 — Text Viewer

| Параметр   | Значение                                                   |
|------------|------------------------------------------------------------|
| Алгоритм   | f.read() chunks 4096B, write via gcount() actual bytes     |
| Edge cases | short, long (10K), empty, missing file                     |
| Tests      | 5                                                          |
| Status     | [+] PASS                                                   |

### Task 3 — Vedomost (выплаты)

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Алгоритм   | getline + stringstream parse, track running total + max |
| Edge cases | spec example (10 строк), single entry, empty file       |
| Tests      | 6                                                       |
| Status     | [+] PASS                                                |

### Task 4 — PNG Detector

| Параметр   | Значение                                            |
|------------|-----------------------------------------------------|
| Алгоритм   | ext check (.png case-insensitive) + first 4 bytes   |
| Edge cases | valid, wrong ext, wrong magic, empty .png, .PNG     |
| Tests      | 6                                                   |
| Status     | [+] PASS                                            |

### Task 5 — Что? Где? Когда?

| Параметр   | Значение                                                          |
|------------|-------------------------------------------------------------------|
| Алгоритм   | 13 sectors, played[] tracking, wrap-around offset, file per Q+A   |
| Edge cases | player wins 6-0, audience wins 6-0, mixed 6-2, wrap, repeat-skip  |
| Tests      | 5 (full game scenarios)                                           |
| Status     | [+] PASS                                                          |

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module19th/Module19Hwork/Task1_WordSearch/main.cpp>      |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module19th/Module19Hwork/Task2_TextViewer/main.cpp>      |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module19th/Module19Hwork/Task3_Vedomost/main.cpp>        |
| 4    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module19th/Module19Hwork/Task4_PngDetector/main.cpp>     |
| 5    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module19th/Module19Hwork/Task5_WhatWhereWhen/main.cpp>   |
