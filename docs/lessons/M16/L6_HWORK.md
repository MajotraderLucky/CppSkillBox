# M16.6 — Практическая работа

**URL:** `homework/388e596f-18f5-47c6-aec0-37ae28f2f15d`
**Status:** submission заблокирован (та же ситуация что M14.6, M15.6)

## Цели

- Вспомнить изученные типы переменных
- Внутреннее представление чисел (биты)
- Перевод данных string ↔ numeric
- Знакомство с enum (включая bit flags)

## 5 задач

### Задача 1 — Спидометр

Цифровой спидометр автомобиля.
- Начальная скорость 0 км/ч, диапазон 0..150
- Пользователь вводит дельту, программа выводит новое значение
- Выход когда скорость <= 0 (с точностью 0.01)
- Точность вывода до 0.1 км/ч (через `sprintf` с `%.1f`)
- Использовать `do/while` для цикла

```
Speed delta: 30
Speed: 30.0
Speed delta: 20.2
Speed: 50.2
```

### Задача 2 — Сшиватель дробных чисел

Read 2 строки (целая часть, дробная часть) → собрать double через `std::stod`:

```
"3" + "14" → "3.14" → stod → 3.14 (double)
```

### Задача 3 — Калькулятор

Парсит строку формата `"<num1><op><num2>"` (без пробелов), выполняет op:

```cpp
std::string buffer;
std::cin >> buffer;
std::stringstream ss(buffer);
double a, b;
char op;
ss >> a >> op >> b;
```

Op: `+`, `-`, `*`, `/`.

### Задача 4 — Механическое пианино (bit mask enum)

Enum с битовыми масками для 7 нот:

```cpp
enum note {
    DO = 1, RE = 2, MI = 4, FA = 8, SOL = 16, LA = 32, SI = 64
};
```

Ввод: строка цифр от 1 до 7 (например "1234" или "63").
Выход: bit mask из всех уникальных нот, печать имён нот.

Подсказка: `1 << index` для получения битового флага.

### Задача 5 — Умный дом (simulation)

Switches как bit mask:

```cpp
enum switches {
    LIGHTS_INSIDE = 1, LIGHTS_OUTSIDE = 2, HEATERS = 4,
    WATER_PIPE_HEATING = 8, CONDITIONER = 16
};
```

Симуляция за 2 дня. Каждый час пользователь вводит:
`temp_inside temp_outside motion(yes/no) lights(on/off)`

Правила переключения:
- temp_outside < 0 → WATER_PIPE_HEATING ON; > 5 → OFF
- 16:00 ≤ time или time < 5:00 + motion=yes → LIGHTS_OUTSIDE ON; иначе OFF
- temp_inside < 22 → HEATERS ON; ≥ 25 → HEATERS OFF
- temp_inside ≥ 30 → CONDITIONER ON; = 25 → OFF
- 16:00 → 20:00 цвет 5000K → 2700K (linear); 00:00 reset 5000K
- Только print **изменения состояния** (если стало вкл/выкл)

## План реализации

```text
Module16Hwork/
├── README.md
├── test_all.sh
├── Task1_Speedometer/{main.cpp,test.sh}
├── Task2_DoubleStitcher/{main.cpp,test.sh}
├── Task3_Calculator/{main.cpp,test.sh}
├── Task4_Piano/{main.cpp,test.sh}
└── Task5_SmartHome/{main.cpp,test.sh}
```
