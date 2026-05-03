# Module 30.4 — Практическая работа (homework)

**Status:** code готов, 21/21 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M30/L4_HWORK.md`
**Solved:** 3/3 mandatory

## Структура

```text
Module30Hwork/
├── README.md, test_all.sh
├── Task1_HttpCommands/   # CLI: get/post/put/delete/patch/exit
├── Task2_HtmlTitle/      # Парсинг <h1> из HTML страницы
└── Task3_HttpArgs/       # POST form / GET query string из stdin
```

## Архитектурное замечание

Spec рекомендует **CPR** (C++ Requests) обёртку над libcurl.
В реализации использован **`popen("curl ...")`** — функционально эквивалентный
подход, без heavyweight FetchContent-сборки CPR (~5 мин, ~100 MB).

Контракт идентичен:
- HTTP-запросы тех же типов
- Те же параметры (заголовки, body, query)
- Парсинг ответа

**Для submission:** заменить функцию `httpRequest` / `runCurl` на соответствующий
`cpr::Get/Post/...` вызов. Логика остального кода не меняется.

## Tasks summary

### Task 1 — HttpCommands

| Параметр   | Значение                                              |
|------------|-------------------------------------------------------|
| Команды    | get/post/put/delete/patch/exit                        |
| Endpoint   | http://httpbin.org/<method>                           |
| Тестир.    | mock-сервер на python3 (8765 порт)                    |
| Tests      | 8                                                     |
| Status     | [+] PASS                                              |

### Task 2 — HtmlTitle

| Параметр   | Значение                                              |
|------------|-------------------------------------------------------|
| Запрос     | GET /html с Accept: text/html                         |
| Парсинг    | std::string::find для <h1> и </h1>                    |
| --url=     | конфигурируемый endpoint для тестов                   |
| Tests      | 6                                                     |
| Status     | [+] PASS                                              |

### Task 3 — HttpArgs

| Параметр   | Значение                                              |
|------------|-------------------------------------------------------|
| Ввод       | пары "key value" пока key != "post"/"get"             |
| POST       | -d 'k=v' для каждого                                  |
| GET        | URL?k=v&k=v c URL-encoding                            |
| Хранилище  | std::map (сортирует ключи alphabetically)             |
| --base=    | конфигурируемая base URL для тестов                   |
| Tests      | 7                                                     |
| Status     | [+] PASS                                              |

## Тестирование

Все тесты используют **локальный mock-сервер** на Python3 (`http.server`).
Не требуется доступ к реальному httpbin.org. CI-friendly.

Запуск: `./test_all.sh`

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module30th/Module30Hwork/Task1_HttpCommands/main.cpp>    |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module30th/Module30Hwork/Task2_HtmlTitle/main.cpp>       |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module30th/Module30Hwork/Task3_HttpArgs/main.cpp>        |
