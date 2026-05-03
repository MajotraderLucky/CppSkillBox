# Module 29.4 — Практическая работа (homework)

**Status:** code готов, 12/12 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M29/L4_HWORK.md`
**Solved:** 1/1 mandatory + 1/1 optional

## Структура

```text
Module29Hwork/
├── README.md, test_all.sh
├── Task1_SuperDog/        # Talent (abstract) + Swimming/Dancing/Counting + Dog
└── Task2_ShapeInterface/  # Shape (abstract) + Circle/Rectangle/Triangle + printParams
```

## Tasks summary

### Task 1 — SuperDog

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Иерархия   | Talent (abstract) → Swimming/Dancing/Counting           |
| Композиция | Dog содержит vector<Talent*>                            |
| Команды    | dance/swim/count/show/exit                              |
| Tests      | 6                                                       |
| Status     | [+] PASS                                                |

### Task 2 — Shape Interface

| Параметр   | Значение                                                 |
|------------|----------------------------------------------------------|
| Иерархия   | Shape (abstract) → Circle/Rectangle/Triangle             |
| Методы     | virtual square(), dimensions(), type()                   |
| Алгоритмы  | π·r² для Circle, w·h, Heron + circumscribed для Triangle |
| Команды    | circle <r> / rectangle <w h> / triangle <a b c> / exit   |
| Tests      | 6                                                        |
| Status     | [+] PASS                                                 |

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module29th/Module29Hwork/Task1_SuperDog/main.cpp>        |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module29th/Module29Hwork/Task2_ShapeInterface/main.cpp>  |
