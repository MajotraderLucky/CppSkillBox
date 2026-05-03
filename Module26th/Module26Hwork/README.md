# Module 26.4 — Практическая работа (homework)

**Status:** code готов, 26/26 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M26/L4_HWORK.md`
**Solved:** 3/3 mandatory

## Структура

```text
Module26Hwork/
├── README.md, test_all.sh
├── Task1_Player/    # Track + Player (state машина: playing/paused/stopped)
├── Task2_Phone/     # PhoneNumber + Contact + Phone (валидация +7XXX...)
└── Task3_Window/    # Window 80x50 (move/resize/display/close)
```

## Tasks summary

### Task 1 — Player

| Параметр   | Значение                                              |
|------------|-------------------------------------------------------|
| Классы     | Track (name/date/duration), Player (state)            |
| Команды    | play/pause/next (shuffle)/stop/exit                   |
| Edge cases | play already playing, double stop, pause без play     |
| Tests      | 8                                                     |
| Status     | [+] PASS                                              |

### Task 2 — Phone

| Параметр   | Значение                                              |
|------------|-------------------------------------------------------|
| Классы     | PhoneNumber (валидация), Contact, Phone (адр.книга)   |
| Команды    | add/call/sms/exit                                     |
| Validation | Format +7 + 10 digits = 12 chars                      |
| Lookup     | По имени или прямому номеру                           |
| Tests      | 8                                                     |
| Status     | [+] PASS                                              |

### Task 3 — Window

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Классы     | Window (80x50 экран, x/y/w/h, clamping)                 |
| Команды    | move/resize/display/close                               |
| Invariants | coords in screen, w/h non-negative, не выходит за edges |
| Display    | 50 строк × 80 символов '0'/'1'                          |
| Tests      | 10                                                      |
| Status     | [+] PASS                                                |

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module26th/Module26Hwork/Task1_Player/main.cpp>          |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module26th/Module26Hwork/Task2_Phone/main.cpp>           |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module26th/Module26Hwork/Task3_Window/main.cpp>          |
