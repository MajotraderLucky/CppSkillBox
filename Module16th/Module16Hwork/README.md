# Module 16.6 — Практическая работа (homework)

**Status:** code готов, 50/50 tests pass, **submit blocked** (Skillbox support отключён)
**Спецификация:** см. `../../docs/lessons/M16/L6_HWORK.md`
**Solved:** 5/5 mandatory tasks

## Структура

```text
Module16Hwork/
├── README.md
├── test_all.sh                          # batch runner (50 tests total)
├── Task1_Speedometer/                   # do/while + sprintf %.1f
├── Task2_DoubleStitcher/                # std::stod композиция
├── Task3_Calculator/                    # stringstream parsing
├── Task4_Piano/                         # bit mask enum (7 нот)
└── Task5_SmartHome/                     # bit mask switches + simulation
```

## Сборка и тестирование

```bash
./test_all.sh                            # все 5 задач
./Task1_Speedometer/test.sh              # одна задача

cd Task1_Speedometer && g++ -std=c++11 -Wall -Wextra main.cpp -o speedometer
./speedometer
```

## Tasks summary

### Task 1 — Спидометр

| Параметр       | Значение                                                     |
|----------------|--------------------------------------------------------------|
| Алгоритм       | do/while + sprintf %.1f, clamp 0..150                        |
| Edge cases     | delta=0, negative clamp, 150 cap, 0.01 threshold, precision  |
| Tests          | 9 (spec + clamps + sequence + precision + threshold)         |
| Status         | [+] PASS                                                     |

### Task 2 — Сшиватель дробных чисел

| Параметр       | Значение                                                     |
|----------------|--------------------------------------------------------------|
| Алгоритм       | concatenate + std::stod, try/catch для invalid input         |
| Edge cases     | zero, negative, large parts, single digits, precision        |
| Tests          | 6 (spec + variations + edge values)                          |
| Status         | [+] PASS                                                     |

### Task 3 — Калькулятор

| Параметр       | Значение                                                     |
|----------------|--------------------------------------------------------------|
| Алгоритм       | std::stringstream parsing «num1 op num2», switch по op       |
| Edge cases     | div-by-zero, unknown op, decimals, negative, fractional      |
| Tests          | 12 (4 ops + decimals + neg + div0 + unknown op + precision)  |
| Status         | [+] PASS                                                     |

### Task 4 — Механическое пианино

| Параметр       | Значение                                                      |
|----------------|---------------------------------------------------------------|
| Алгоритм       | enum bit mask + (1 << index), iter chord chars, дубли OR-ятся |
| Edge cases     | duplicates, all 7 notes, reverse order, invalid (0/8/letter)  |
| Tests          | 12 (spec + single + all + duplicates + 3 invalid)             |
| Status         | [+] PASS                                                      |

### Task 5 — Умный дом

| Параметр       | Значение                                                                                    |
|----------------|---------------------------------------------------------------------------------------------|
| Алгоритм       | enum switches + setFlag helper (only print on state change), 48-hour loop                   |
| Правила        | water pipe (<0/>5°), heaters (<22/≥25°), conditioner (≥30/≤25°), outdoor lights, color temp |
| Edge cases     | state change vs idempotent, color temp transitions 16:00..19:00, motion+evening             |
| Tests          | 11 (each rule + state-change-only + color temp interpolation + motion/evening)              |
| Status         | [+] PASS                                                                                    |

## Соответствие критериям hwork

| Критерий                                   | Status                          |
|--------------------------------------------|---------------------------------|
| В циклах нет выхода за границы массивов    | [+]                             |
| Действия вынесены в функции                | [+] (setFlag, colorTemperature) |
| Программы запускаются без syntax errors    | [+] g++ -Wall -Wextra           |
| Имена переменных корректные                | [+]                             |
| Текстовый интерфейс для всех программ      | [+] (stderr prompts)            |
| Контроль ввода                             | [+] (validation everywhere)     |
| Использован оптимальный алгоритм           | [+]                             |
| Выполнены все 5 заданий                    | [+] (5/5)                       |

## Submission links для преподавателя

Replit (тот же паттерн что M14.6/M15.6):

| Task | Replit URL                                                                                               |
|------|----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module16th/Module16Hwork/Task1_Speedometer/main.cpp>    |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module16th/Module16Hwork/Task2_DoubleStitcher/main.cpp> |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module16th/Module16Hwork/Task3_Calculator/main.cpp>     |
| 4    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module16th/Module16Hwork/Task4_Piano/main.cpp>          |
| 5    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module16th/Module16Hwork/Task5_SmartHome/main.cpp>      |

GitHub backup:

| Task | GitHub URL                                                                                                          |
|------|---------------------------------------------------------------------------------------------------------------------|
| 1    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module16th/Module16Hwork/Task1_Speedometer/main.cpp>    |
| 2    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module16th/Module16Hwork/Task2_DoubleStitcher/main.cpp> |
| 3    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module16th/Module16Hwork/Task3_Calculator/main.cpp>     |
| 4    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module16th/Module16Hwork/Task4_Piano/main.cpp>          |
| 5    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module16th/Module16Hwork/Task5_SmartHome/main.cpp>      |
