# Module 23.4 — Практическая работа (homework)

**Status:** code готов, 20/20 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M23/L4_HWORK.md`
**Solved:** 2/2 mandatory + 1/1 optional

## Структура

```text
Module23Hwork/
├── README.md, test_all.sh
├── Task1_Weekday/    # token-pasting ## + раскрытие через DAY_NAME(n)
├── Task2_Season/     # #if defined() — выбор сезона compile-time
└── Task3_Train/      # FOR_EACH / READ_ALL макросы вместо явных for
```

## Tasks summary

### Task 1 — Weekday

| Параметр    | Значение                                                |
|-------------|---------------------------------------------------------|
| Алгоритм    | DAY_##n + двухступенчатое раскрытие DAY_NAME_PASTE      |
| Ограничения | Только макросы для всех строк                           |
| Tests       | 9 (7 дней + 2 invalid)                                  |
| Status      | [+] PASS                                                |

### Task 2 — Season

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Алгоритм   | #if defined(SPRING/SUMMER/AUTUMN/WINTER)                |
| Сборка     | g++ -DSEASON_NAME main.cpp                              |
| Tests      | 5 (4 сезона + no-season)                                |
| Status     | [+] PASS                                                |

### Task 3 — Train (доп.)

| Параметр    | Значение                                                |
|-------------|---------------------------------------------------------|
| Алгоритм    | FOR_EACH(arr, n, func) + READ_ALL(arr, n)               |
| Ограничения | Без явных for — только через макросы                    |
| Tests       | 6 (optimal/over/under/mixed/empty/order)                |
| Status      | [+] PASS                                                |

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module23th/Module23Hwork/Task1_Weekday/main.cpp>         |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module23th/Module23Hwork/Task2_Season/main.cpp>          |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module23th/Module23Hwork/Task3_Train/main.cpp>           |
