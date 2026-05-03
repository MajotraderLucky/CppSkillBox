# Module 31.5 — Практическая работа (homework)

**Status:** code готов, 21/21 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M31/L5_HWORK.md`
**Solved:** 2/2 mandatory

## Структура

```text
Module31Hwork/
├── README.md, test_all.sh
├── Task1_Toys/                 # CMake + src/main.cpp + test.sh
│   ├── CMakeLists.txt
│   ├── src/main.cpp
│   └── test.sh
└── Task2_SharedPtr/            # CMake + src/main.cpp + test.sh
    ├── CMakeLists.txt
    ├── src/main.cpp
    └── test.sh
```

## Tasks summary

### Task 1 — Dog с std::shared_ptr<Toy>

| Параметр    | Значение                                                                |
|-------------|-------------------------------------------------------------------------|
| Алгоритм    | команды `pickup <dog> <toy>` / `drop <dog>`; библиотека игрушек на map  |
| Логика      | "I already have", "Another dog is playing", "Nothing to drop"           |
| Особенность | use_count() > 1 → другая собака держит (библиотека всегда +1)           |
| Структура   | 1 CMakeLists, src/main.cpp, test.sh                                     |
| Tests       | 9                                                                       |
| Status      | [+] PASS                                                                |

### Task 2 — Custom shared_ptr_toy

| Параметр    | Значение                                                                   |
|-------------|----------------------------------------------------------------------------|
| Алгоритм    | свой `shared_ptr_toy` с refcount: ctor/copy/op=/dtor + reset/get/use_count |
| Helper      | `make_shared_toy(name)` — factory                                          |
| Особенность | self-assign + same-toy guards + nullptr-safe release()                     |
| Программа   | эталонный сценарий из спеки → exact match output                           |
| Tests       | 12 (1 reference + 11 unit-checks)                                          |
| Status      | [+] PASS                                                                   |

## Submission

Архив: см. spec. Файлы:
- Task 1: `CMakeLists.txt`, `src/main.cpp`
- Task 2: `CMakeLists.txt`, `src/main.cpp`

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module31th/Module31Hwork/Task1_Toys/src/main.cpp>        |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module31th/Module31Hwork/Task2_SharedPtr/src/main.cpp>   |

## Notes

- Toy::~Toy печатает `"Toy <name> was dropped "` с trailing space — это из спеки задания, тесты нормализуют.
- Task 1: использовали `std::map` как библиотеку; для проверки «другая собака держит» сравниваем `use_count() > 1` (библиотека = константный +1).
- Task 2: `release()` приватный helper для DRY между `~shared_ptr_toy()`, `reset()` и `operator=`.
