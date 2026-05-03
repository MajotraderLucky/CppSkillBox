# Module 21.5 — Практическая работа (homework)

**Status:** code готов, 45/45 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M21/L5_HWORK.md`
**Solved:** 3/3 mandatory + 1/1 optional

## Структура

```text
Module21Hwork/
├── README.md, test_all.sh
├── Task1_VedomostStruct/   # struct + vector + list/add commands
├── Task2_VillageModel/     # nested structs + enums + coverage %
├── Task3_MathVector/       # Vec2 + add/subtract/scale/length/normalize
└── Task4_TurnBasedRPG/     # 20×20 grid + save/load (binary)
```

## Tasks summary

### Task 1 — VedomostStruct

| Параметр   | Значение                                              |
|------------|-------------------------------------------------------|
| Алгоритм   | struct + vector<VedomostEntry> + list/add commands    |
| Edge cases | empty file, append, invalid date/amount, leading zero |
| Tests      | 10                                                    |
| Status     | [+] PASS                                              |

### Task 2 — VillageModel

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Алгоритм   | Иерархия struct + enum RoomType + coverage %            |
| Edge cases | empty village, no buildings, all 4 types, 3 этажа       |
| Tests      | 8                                                       |
| Status     | [+] PASS                                                |

### Task 3 — MathVector

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Алгоритм   | Vec2 + 5 функций (add/subtract/scale/length/normalize)  |
| Edge cases | zero vector normalize, negative components, unit vec    |
| Tests      | 16                                                      |
| Status     | [+] PASS                                                |

### Task 4 — TurnBasedRPG (доп.)

| Параметр   | Значение                                                                      |
|------------|-------------------------------------------------------------------------------|
| Алгоритм   | 20×20 grid, 5 enemies + player, бинарный save/load, симметричная сериализация |
| Edge cases | bounds check, save/load round-trip, missing file, deterministic seeds         |
| Tests      | 11                                                                            |
| Status     | [+] PASS                                                                      |

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module21th/Module21Hwork/Task1_VedomostStruct/main.cpp>  |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module21th/Module21Hwork/Task2_VillageModel/main.cpp>    |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module21th/Module21Hwork/Task3_MathVector/main.cpp>      |
| 4    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module21th/Module21Hwork/Task4_TurnBasedRPG/main.cpp>    |
