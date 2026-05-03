# Module 32.5 — Практическая работа (homework)

**Status:** code готов, 34/34 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M32/L5_HWORK.md`
**Solved:** 3/3 mandatory

## Структура

```text
Module32Hwork/
├── README.md, test_all.sh
├── Task1_FilmJson/             # JSON-документ + python-валидация
│   ├── film.json
│   └── test.sh
├── Task2_FilmDb/               # JSON БД 5 фильмов + C++ поиск актёра
│   ├── CMakeLists.txt
│   ├── films.json
│   ├── src/main.cpp
│   └── test.sh
└── Task3_CompanyProto/         # .proto + protoc-генерация
    ├── .gitignore              # gen/ не коммитим (пересобирается)
    ├── src/company.proto
    └── test.sh
```

## Tasks summary

### Task 1 — Информация о фильме

| Параметр | Значение                                                     |
|----------|--------------------------------------------------------------|
| Формат   | JSON-документ (Inception, 2010)                              |
| Поля     | title/country/release_date/studio/screenwriter/director/...  |
| cast     | array of `{actor, role}` — 8 главных лиц                     |
| Tests    | 11 (валидность + наличие всех ключей)                        |
| Status   | [+] PASS                                                     |

### Task 2 — Анализ JSON-базы

| Параметр    | Значение                                                           |
|-------------|--------------------------------------------------------------------|
| База        | 5 фильмов (Inception/Dark Knight/Interstellar/Pulp Fiction/Django) |
| API         | nlohmann/json (single header)                                      |
| Поиск       | подстрока имени (case-insensitive) → film + role                   |
| CLI         | `--db=<path>` `--query=<str>` для тестов                           |
| Tests       | 8 (DiCaprio в 2 фильмах, Caine в 2, no-matches, и т.д.)            |
| Status      | [+] PASS                                                           |

### Task 3 — Protobuf компания

| Параметр   | Значение                                                            |
|------------|---------------------------------------------------------------------|
| Schema     | `Company` message в `skillbox.m32` package                          |
| Required   | founded_year (int32), legal_address (string), name (string)         |
| Optional   | activity (string), foreign_economic (bool)                          |
| Syntax     | proto2                                                              |
| Compile    | `protoc --cpp_out=gen src/company.proto` → `company.pb.{h,cc}`      |
| Tests      | 15 (compile success + class + всех 5 setter'ов + структурные)       |
| Status     | [+] PASS                                                            |

## Toolchain

- **g++** 17 (стандартный)
- **nlohmann/json v3.11.3** — single header в `~/.local/include/nlohmann/json.hpp`
- **protoc 25.3** — в `~/.local/protoc/bin/protoc` (загружен с GitHub release)

> При сабмите через replit nlohmann/json подключается через FetchContent (как CPR в M30).

## Submission

Архив: см. spec. Файлы:
- Task 1: `film.json`
- Task 2: `CMakeLists.txt`, `films.json`, `src/main.cpp`
- Task 3: `src/company.proto`

## Submission links

| Task | Replit URL                                                                                                      |
|------|-----------------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module32th/Module32Hwork/Task1_FilmJson/film.json>             |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module32th/Module32Hwork/Task2_FilmDb/src/main.cpp>            |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module32th/Module32Hwork/Task3_CompanyProto/src/company.proto> |

## Notes

- Task 2 сортирует выходные строки в test через `sort` — порядок iteration по `nlohmann::json` детерминирован (alpha по ключам), но для устойчивости теста против изменений порядка добавления — sort.
- Task 3 не линкуется с libprotobuf — задача формулирует только генерацию C++ кода. Тест проверяет, что `.pb.h` содержит ожидаемый API (5 setter'ов + Company class).
