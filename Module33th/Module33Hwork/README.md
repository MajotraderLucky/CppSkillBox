# Module 33.5 — Практическая работа (homework)

**Status:** code готов, 33/33 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M33/L5_HWORK.md`
**Solved:** 4/4 mandatory

## Структура

```text
Module33Hwork/
├── README.md, test_all.sh
├── Task1_Cart/         # CMake + src/main.cpp + test.sh
├── Task2_Fishing/      # CMake + src/main.cpp + test.sh
├── Task3_Registry/     # CMake + src/main.cpp + test.sh
└── Task4_Average/      # CMake + src/main.cpp + test.sh
```

## Tasks summary

### Task 1 — Корзина с покупками

| Параметр | Значение                                                                  |
|----------|---------------------------------------------------------------------------|
| Логика   | std::map склад + std::map корзина, валидация sku/qty                      |
| Errors   | std::invalid_argument (плохой ввод), std::runtime_error (мало товара)     |
| CLI      | stock/add/remove <sku> <qty>                                              | list | exit |
| Tests    | 9                                                                         |
| Status   | [+] PASS                                                                  |

### Task 2 — Игра ловли рыбы

| Параметр | Значение                                                                  |
|----------|---------------------------------------------------------------------------|
| Поле     | 9 секторов, 1 рыба + 3 сапога (random, не пересекаются)                   |
| Logic    | throw Fish* / throw Boot* (произвольный тип исключения)                   |
| CLI      | --seed=N --auto для детерминированного теста                              |
| Tests    | 6 (известные seed → известные исходы)                                     |
| Status   | [+] PASS                                                                  |

### Task 3 — Реестр на шаблонах Registry<K,V>

| Параметр | Значение                                                                  |
|----------|---------------------------------------------------------------------------|
| Storage  | std::vector<std::pair<K, V>>                                              |
| API      | add / remove / find / print (template member methods)                     |
| Types    | int/double/string в любых комбинациях через --types=K,V                   |
| CLI      | add/remove/find/print/exit + --types=                                     |
| Tests    | 10 (int-int, int-string, string-int, double-double, edge cases)           |
| Status   | [+] PASS                                                                  |

### Task 4 — Шаблонная средняя в массиве [8]

| Параметр | Значение                                                                  |
|----------|---------------------------------------------------------------------------|
| Sigs     | template<T> void input(T arr[8]) + template<T> double average(T arr[8])   |
| Types    | int/double/float/long через --type=                                       |
| Tests    | 8 (все типы + edge cases: zeros, balanced, negatives)                     |
| Status   | [+] PASS                                                                  |

## Submission

Архив: см. spec. Файлы:
- Task 1-4: `CMakeLists.txt` + `src/main.cpp` каждого

## Submission links

| Task | Replit URL                                                                                              |
|------|---------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module33th/Module33Hwork/Task1_Cart/src/main.cpp>      |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module33th/Module33Hwork/Task2_Fishing/src/main.cpp>   |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module33th/Module33Hwork/Task3_Registry/src/main.cpp>  |
| 4    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module33th/Module33Hwork/Task4_Average/src/main.cpp>   |

## Notes

- Task 2 использует `throw Fish*` / `throw Boot*` — спека прямо рекомендует «бросать сапог или рыбу как тип».
- Task 3 имеет один общий `runRepl<K,V>` под все 9 комбинаций типов — switch по `--types=` flag.
- Task 4 average возвращает double для precise результата на int массиве (1..8 → 4.5).
