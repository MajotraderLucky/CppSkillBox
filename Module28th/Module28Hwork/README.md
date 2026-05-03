# Module 28.4 — Практическая работа (homework)

**Status:** code готов, 19/19 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M28/L4_HWORK.md`
**Solved:** 3/3 mandatory

## Структура

```text
Module28Hwork/
├── README.md, test_all.sh
├── Task1_Swim/      # 6 пловцов в потоках, sort by time
├── Task2_Station/   # 1 mutex для вокзала, condition_variable для depart
└── Task3_Kitchen/   # detached cooking, atomic counter, condition done
```

## Tasks summary

### Task 1 — Swim (6 swimmers race)

| Параметр   | Значение                                              |
|------------|-------------------------------------------------------|
| Threads    | 6 параллельных пловцов                                |
| Sync       | mutex для общего вывода + результатов                 |
| --tick-ms= | конфигурируемый интервал (default 1000ms)             |
| Tests      | 7                                                     |
| Status     | [+] PASS                                              |

### Task 2 — Station (1 platform, 3 trains)

| Параметр     | Значение                                              |
|--------------|-------------------------------------------------------|
| Threads      | 3 поезда + main для команд depart                     |
| Sync         | g_stationMutex (1 поезд = 1 захват)                   |
| Сигналинг    | condition_variable для команд depart                  |
| --travel-ms= | конфигурируемый коэффициент времени                   |
| Tests        | 6                                                     |
| Status       | [+] PASS                                              |

### Task 3 — Kitchen (online restaurant)

| Параметр                                       | Значение                                              |
|------------------------------------------------|-------------------------------------------------------|
| Threads                                        | order-thread + courier-thread + N detached cooking    |
| Sync                                           | mutex для готовки + atomic для завершения             |
| --order-ms / --cook-ms / --courier-ms / --seed | детерминизм                                           |
| Завершение                                     | после 10 deliveries → RESTAURANT CLOSED               |
| Tests                                          | 6                                                     |
| Status                                         | [+] PASS                                              |

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module28th/Module28Hwork/Task1_Swim/main.cpp>            |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module28th/Module28Hwork/Task2_Station/main.cpp>         |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module28th/Module28Hwork/Task3_Kitchen/main.cpp>         |
