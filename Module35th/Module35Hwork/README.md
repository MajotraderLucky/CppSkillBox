# Module 35.6 — Практическая работа (homework)

**Status:** code готов, 25/25 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M35/L6_HWORK.md`
**Solved:** 3/3 mandatory

## Структура

```text
Module35Hwork/
├── README.md, test_all.sh
├── Task1_PrintNumbers/     # range-for + auto + initializer_list
├── Task2_Dedup/            # lambda + unordered_set + unique_ptr
└── Task3_FilesByExt/       # std::filesystem::recursive_directory_iterator
```

## Tasks summary

### Task 1 — Print 1..5

| Параметр | Значение                                                      |
|----------|---------------------------------------------------------------|
| Урок     | M35.3 (range-for + auto + initializer_list)                   |
| Code     | `for (auto n : {1, 2, 3, 4, 5}) std::cout << n << std::endl;` |
| Tests    | 4 (output + 3 source-pattern checks)                          |
| Status   | [+] PASS                                                      |

### Task 2 — Dedup vector через lambda

| Параметр   | Значение                                                                      |
|------------|-------------------------------------------------------------------------------|
| Урок       | M35.4 (unordered_set + unique_ptr)                                            |
| Возврат    | `std::unique_ptr<std::vector<int>>`                                           |
| Алгоритм   | unordered_set отслеживает виденные, vector сохраняет first-occurrence order   |
| CLI        | `--input="1 2 1 3"` для тестов; без аргументов — stdin                        |
| Tests      | 10 (simple/no-dups/all-same/empty/order/negative + 4 source checks)           |
| Status     | [+] PASS                                                                      |

### Task 3 — Поиск файлов по расширению

| Параметр     | Значение                                                           |
|--------------|--------------------------------------------------------------------|
| Урок         | M35.5 (std::filesystem)                                            |
| Структура    | lambda(`fs::path`, `std::string ext`) → `std::vector<std::string>` |
| Алгоритм     | recursive_directory_iterator + is_regular_file + extension.compare |
| CLI          | `./files_by_ext <path> <ext>`                                      |
| Tests        | 11 (txt/cpp/h/no-matches/missing-path/usage + 5 source checks)     |
| Status       | [+] PASS                                                           |

## Submission

| Task | Replit URL                                                                                                  |
|------|-------------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module35th/Module35Hwork/Task1_PrintNumbers/src/main.cpp>  |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module35th/Module35Hwork/Task2_Dedup/src/main.cpp>         |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module35th/Module35Hwork/Task3_FilesByExt/src/main.cpp>    |

## Notes

- C++17 стандарт обязателен (для filesystem). Все CMakeLists.txt ставят `CMAKE_CXX_STANDARD 17`.
- Task 2 алгоритм сохраняет порядок первого появления (unordered_set только для проверки, vector копит).
- Task 3 в lambda передаём `fs::path` + `std::string` как в спеке (не const&) — соответствует образцу из задания.
