# Module 20.5 — Практическая работа (homework)

**Status:** code готов, 21/21 tests pass, **submit blocked**
**Спецификация:** см. `../../docs/lessons/M20/L5_HWORK.md`
**Solved:** 4/4 mandatory tasks

## Структура

```text
Module20Hwork/
├── README.md, test_all.sh
├── Task1_VedomostWriter/    # ofstream::app + date validation via stoi/substr
├── Task2_RandomPicture/     # rand + srand(time) → W×H pic.txt
├── Task3_Fishing/           # river.txt read + basket.txt append
└── Task4_ATM/               # bin state + greedy withdrawal
```

## Tasks summary

### Task 1 — VedomostWriter

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Алгоритм   | append mode + flexible date format (D[D].M[M].YYYY)     |
| Edge cases | invalid date format/month, negative amount, append      |
| Tests      | 6                                                       |
| Status     | [+] PASS                                                |

### Task 2 — RandomPicture

| Параметр   | Значение                                              |
|------------|-------------------------------------------------------|
| Алгоритм   | std::rand() % 2 для каждого пикселя, srand(time)      |
| Edge cases | только 0/1, корректные размеры, deterministic с seed  |
| Tests      | 4                                                     |
| Status     | [+] PASS                                              |

### Task 3 — Fishing

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Алгоритм   | river >> fish + сравнение + append в basket             |
| Edge cases | spec example, missing fish, persistence across runs     |
| Tests      | 6                                                       |
| Status     | [+] PASS                                                |

### Task 4 — ATM

| Параметр   | Значение                                                                |
|------------|-------------------------------------------------------------------------|
| Алгоритм   | bin state + commands: + (random fill to MAX), - (greedy withdraw), q    |
| Edge cases | empty start, fill, withdraw, invalid amounts, persistence between runs  |
| Tests      | 7                                                                       |
| Status     | [+] PASS                                                                |

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module20th/Module20Hwork/Task1_VedomostWriter/main.cpp>  |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module20th/Module20Hwork/Task2_RandomPicture/main.cpp>   |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module20th/Module20Hwork/Task3_Fishing/main.cpp>         |
| 4    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module20th/Module20Hwork/Task4_ATM/main.cpp>             |
