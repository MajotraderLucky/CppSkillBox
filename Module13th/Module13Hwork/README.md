# Module 13.6 — Практическая работа (homework)

**Status:** code готов, **не сабмичено** (Skillbox support отключён → `access="read_only"`)

**Спецификация:** см. `../../docs/lessons/M13/L6_HWORK.md` (полный текст hwork со Skillbox)

## Структура

```text
Module13Hwork/
├── README.md (этот файл)
├── test_all.sh                      # batch test runner для всех 3 задач
├── Task1_RemoveX/
│   ├── main.cpp                     # two-pointer + pop_back
│   └── test.sh                      # 11 тестов
├── Task2_PricesItems/
│   ├── main.cpp                     # one-loop sum prices[items[i]]
│   └── test.sh                      # 1 тест (deterministic input)
└── Task3_RingBuffer/
    ├── main.cpp                     # ring buffer 20 элементов
    └── test.sh                      # 9 тестов (overflow scenarios)
```

## Сборка и тестирование

```bash
# Запустить все тесты
./test_all.sh

# Или для одной задачи
./Task1_RemoveX/test.sh

# Compile один таск вручную
cd Task1_RemoveX && g++ -std=c++11 -Wall -Wextra main.cpp -o remove_x
```

## Tasks summary

### Task 1 — RemoveX (in-place delete value)

| Параметр       | Значение                                                       |
|----------------|----------------------------------------------------------------|
| Алгоритм       | two-pointer compaction + pop_back trim                         |
| Complexity     | O(n) time, O(1) space                                          |
| Tests          | 11 (empty / single / all-match / no-match / order / negatives) |
| Status         | [+] PASS                                                       |

### Task 2 — PricesItems (sum)

| Параметр       | Значение                                      |
|----------------|-----------------------------------------------|
| Алгоритм       | for(idx: items) total += prices[idx]          |
| Complexity     | O(n) where n = items.size()                   |
| Tests          | 1 (spec example, deterministic input)         |
| Status         | [+] PASS                                      |
| Note           | Bounds check на items[i] (по критерию)        |

### Task 3 — RingBuffer (capacity 20)

| Параметр       | Значение                                                      |
|----------------|---------------------------------------------------------------|
| Алгоритм       | Fixed-size vector + writePos % CAPACITY                       |
| Complexity     | O(1) per add (без resize)                                     |
| Tests          | 9 (empty / 19/20/21 boundaries / 40-element wrap / negatives) |
| Status         | [+] PASS                                                      |
| Note           | size() === 20 always, no resize calls                         |

## Соответствие критериям hwork (из L6_HWORK.md)

| Критерий                                | Status                                                          |
|-----------------------------------------|-----------------------------------------------------------------|
| Все 3 задания выполнены                 | [+]                                                             |
| Программы запускаются без syntax errors | [+]                                                             |
| Имена переменных корректны              | [+]                                                             |
| Текстовый интерфейс (input/output)      | [+]                                                             |
| Контроль ввода (validation)             | [+] (Task1: n<0; Task2: bounds check; Task3: -1 sentinel + EOF) |
| Циклы без выхода за границы             | [+]                                                             |

## Когда поддержку продлят

Каждая задача — единый `main.cpp`, можно сабмитить через Replit (по условию).
Просто скопировать содержимое каждого `main.cpp` в отдельный repl.it project.
