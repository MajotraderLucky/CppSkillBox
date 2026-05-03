# Module 18.5 — Практическая работа (homework)

**Status:** code готов, 25/25 tests pass, **submit blocked**
**Спецификация:** см. `../../docs/lessons/M18/L5_HWORK.md`
**Solved:** 3/3 mandatory tasks

## Структура

```text
Module18Hwork/
├── README.md
├── test_all.sh                      # batch runner (25 tests)
├── Task1_SwapVec/                   # void swapvec(vec&, int*)
├── Task2_Rabbit/                    # int rabbit(int n, int k=3) recursive
└── Task3_EvenDigits/                # void evendigits(long long, int&)
```

## Tasks summary

### Task 1 — SwapVec

| Параметр   | Значение                                                  |
|------------|-----------------------------------------------------------|
| Алгоритм   | iterate i, swap(a[i], b[i]) через temp                    |
| Edge cases | single element, negatives, zeros, same arrays             |
| Tests      | 5                                                         |
| Status     | [+] PASS                                                  |

### Task 2 — Rabbit on Staircase (recursive + default arg)

| Параметр   | Значение                                                  |
|------------|-----------------------------------------------------------|
| Алгоритм   | recursive: sum rabbit(n-i, k) для i in 1..k; base n==0    |
| Edge cases | n=0 (1), n<0 (0), k=1 (always 1), Fibonacci при k=2       |
| Tests      | 9 (spec + edge n + various k + default arg)               |
| Status     | [+] PASS                                                  |

### Task 3 — EvenDigits (recursive + by-ref output)

| Параметр   | Значение                                                  |
|------------|-----------------------------------------------------------|
| Алгоритм   | recursive digit extraction (n % 10), check, ans++ via ref |
| Edge cases | 0 (1 even), single odd, large LL, negatives, mixed        |
| Tests      | 11 (spec MAX_LL + various)                                |
| Status     | [+] PASS                                                  |

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module18th/Module18Hwork/Task1_SwapVec/main.cpp>         |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module18th/Module18Hwork/Task2_Rabbit/main.cpp>          |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module18th/Module18Hwork/Task3_EvenDigits/main.cpp>      |

| Task | GitHub URL                                                                                                       |
|------|------------------------------------------------------------------------------------------------------------------|
| 1    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module18th/Module18Hwork/Task1_SwapVec/main.cpp>     |
| 2    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module18th/Module18Hwork/Task2_Rabbit/main.cpp>      |
| 3    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module18th/Module18Hwork/Task3_EvenDigits/main.cpp>  |
