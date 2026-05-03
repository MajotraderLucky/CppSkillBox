# Module 24.5 — Практическая работа (homework)

**Status:** code готов, 24/24 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M24/L5_HWORK.md`
**Solved:** 3/3 mandatory

## Структура

```text
Module24Hwork/
├── README.md, test_all.sh
├── Task1_TimeTracker/   # begin/end/status/exit + difftime
├── Task2_Birthday/      # ближайший DR + сегодняшние
└── Task3_Timer/         # get_time MM:SS → countdown → DING
```

## Tasks summary

### Task 1 — TimeTracker

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Алгоритм   | std::time + difftime + auto-end предыдущей задачи       |
| Тестир.    | --fake-time = инкрементальный счётчик для детерминизма  |
| Tests      | 8                                                       |
| Status     | [+] PASS                                                |

### Task 2 — Birthday

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Алгоритм   | парсинг YYYY/MM/DD + сравнение month/day с today        |
| Тестир.    | --today=MM:DD = фиксированный «сегодня»                 |
| Tests      | 9                                                       |
| Status     | [+] PASS                                                |

### Task 3 — Timer

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Алгоритм   | get_time %M:%S + countdown loop + sleep_for             |
| Тестир.    | --no-sleep = пропуск задержек для тестов                |
| Tests      | 7                                                       |
| Status     | [+] PASS                                                |

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module24th/Module24Hwork/Task1_TimeTracker/main.cpp>     |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module24th/Module24Hwork/Task2_Birthday/main.cpp>        |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module24th/Module24Hwork/Task3_Timer/main.cpp>           |
