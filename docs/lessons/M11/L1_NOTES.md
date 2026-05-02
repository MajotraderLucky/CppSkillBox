# M11.1 — Разбор практической работы (Module 10 → "функции" intro)

**Дата урока:** 2026-05-03 (transcribed from Skillbox видео)
**Длина:** 18:53
**Преподаватель:** Илья Мещерин
**Source:** `L1_разбор_практической.{vtt,txt}`

Преподаватель разбирает 3 задачи из домашнего задания **Module 9** (строки):
**word counter**, **long real number validator**, **arabic → roman**.

В конце — намёк на следующую тему модуля: **функции** ("очень скоро мы научимся
избавляться от повторяющихся кусков кода в программах").

---

## Task 1 — Word counter

### Условие

Пользователь вводит строку (могут быть пробелы и любые символы). Посчитать
количество слов = непрерывных последовательностей не-пробелов.

### Алгоритм урока (count starts of words)

> "Количество слов = количество позиций, где символ — не пробел, а предыдущий — пробел."

```cpp
#include <iostream>
#include <string>

int main() {
    std::string str;
    std::getline(std::cin, str);  // важно: getline, не cin >> (cin режет на пробелах)

    int count = 0;
    // Edge case: первый символ — начало слова если не пробел
    if (!str.empty() && str[0] != ' ') count++;
    
    // Основной проход — с i=1, чтобы не уйти за границу при str[i-1]
    for (int i = 1; i < (int)str.length(); i++) {
        if (str[i] != ' ' && str[i-1] == ' ') count++;
    }
    
    std::cout << count << std::endl;
    return 0;
}
```

### Тест-кейсы

| Input                        | Expected | Note                                |
|------------------------------|----------|-------------------------------------|
| "abcd abce cdjs ahdu"        | 4        | классические 4 слова через 1 space  |
| (другой пример)              | 6        |                                     |
| "    _    "                  | 1        | один символ среди пробелов          |
| "       " (только пробелы)   | 0        |                                     |

### Edge case (важно)

- `i=0` нельзя — `str[i-1]` уйдёт за границу
- Решение: проверить `str[0]` отдельно, цикл начинать с `i=1`

### На диске

`Module9th/Module9Tasks/word_counter.cpp` + `word_count.cpp` — две версии. Тест: `test_word_counter.sh`, `test_word_count.sh`.

---

## Task 2 — Long real number validator

### Условие

По введённой строке определить — является ли она корректной записью
вещественного числа.

Допускается: опциональный `-` в начале, цифры, **одна** точка `.`. Минимум 1 цифра.

### Алгоритм урока (по кусочкам с `bool ok`)

Стратегия: разбить задачу на независимые проверки, итог — `bool ok`. При нарушении
любой проверки → `ok = false`. Это альтернатива длинному `if-else`.

Шаги:

1. Определить есть ли минус в начале → `bool minus`
2. Найти **первую** точку → `bool dot`, `int dotPosition`
3. Определить границы integer part `intStart..intEnd` и fractional part `fragStart..end`
4. Проверить что в каждой части **только цифры** → set `ok = false` если нет
5. Проверить что суммарная длина частей > 0 (хоть одна цифра есть)
6. Output `yes` / `no`

```cpp
#include <iostream>
#include <string>

int main() {
    std::string number;
    std::cin >> number;  // OK потому что не ожидаем пробелов
    
    // 1. Minus check
    bool minus = !number.empty() && number[0] == '-';
    
    // 2. Find first dot
    bool dot = false;
    int dotPosition = -1;
    for (int i = 0; i < (int)number.length() && !dot; i++) {
        if (number[i] == '.') {
            dot = true;
            dotPosition = i;
        }
    }
    
    bool ok = true;
    
    // 3. Integer part bounds
    int intStart = minus ? 1 : 0;
    int intEnd   = dot ? dotPosition : (int)number.length();
    
    // 4. Validate integer part — only digits
    for (int i = intStart; i < intEnd; i++) {
        if (number[i] < '0' || number[i] > '9') ok = false;
    }
    
    // 5. Fractional part bounds
    int fragStart = dot ? dotPosition + 1 : (int)number.length();
    
    // 6. Validate fractional part
    for (int i = fragStart; i < (int)number.length(); i++) {
        if (number[i] < '0' || number[i] > '9') ok = false;
    }
    
    // 7. At least one digit overall
    if ((intEnd - intStart) + ((int)number.length() - fragStart) == 0) {
        ok = false;
    }
    
    std::cout << (ok ? "yes" : "no") << std::endl;
    return 0;
}
```

### Тест-кейсы

| Input          | Expected | Why                                    |
|----------------|----------|----------------------------------------|
| `0.123`        | yes      |                                        |
| `0.000`        | yes      |                                        |
| `0.15`         | yes      |                                        |
| `165`          | yes      | без точки тоже OK                      |
| `999999.99999` | yes      | длинные ОК                             |
| `-1.0`         | yes      | минус OK                               |
| `-.35`         | yes      | минус + дробная часть OK               |
| `1.2.3`        | no       | вторая точка → не цифра справа         |
| `-.`           | no       | сумма длин частей = 0                  |
| `11e-3`        | no       | `e` запрещён                           |
| `+25`          | no       | `+` запрещён                           |

### Pattern: "проверки по кусочкам через bool ok"

> "Один из хороших способов решения таких задач — пытаться решать проблему по кусочкам.
> Мы по очереди будем выяснять про строку разные свойства одно за другим, а потом
> как-нибудь соотнесем их между собой."

Это альтернатива монолитному `if (cond1 && cond2 && cond3 ...)` — лучше читается,
проще debug, легче добавлять новые проверки.

### На диске

`Module9th/Module9Tasks/float_validator.cpp` — есть. Тест: `test_float_validator.sh`.

---

## Task 3 — Arabic → Roman (1-3999)

### Условие

Пользователь вводит число от 1 до 3999. Вывести римскую запись.

### Алгоритм урока (split по разрядам)

Римская запись:

- Тысячи (1000): M
- Сотни (100, 500, 1000): C, D, M
- Десятки (10, 50, 100): X, L, C
- Единицы (1, 5, 10): I, V, X

В каждом разряде — одни и те же правила (1-3: повторяем нижнюю букву; 4: нижняя+средняя; 5: средняя; 6-8: средняя + повтор нижней; 9: нижняя+верхняя).

```cpp
#include <iostream>
#include <string>

int main() {
    int number;
    std::cin >> number;
    
    int thousands = number / 1000;
    int hundreds  = (number % 1000) / 100;
    int tens      = (number % 100) / 10;
    int units     =  number % 10;
    
    std::string result = "";
    
    // Thousands: M repeat
    for (int i = 0; i < thousands; i++) result += 'M';
    
    // Hundreds: C / D / M pattern
    if (hundreds == 4 || hundreds == 9) result += 'C';
    if (hundreds >= 4 && hundreds <= 8) result += 'D';
    if (hundreds == 9) result += 'M';
    if (hundreds % 5 < 4) {
        for (int i = 0; i < hundreds % 5; i++) result += 'C';
    }
    
    // Tens: X / L / C pattern (just replace H/D/M with X/L/C)
    if (tens == 4 || tens == 9) result += 'X';
    if (tens >= 4 && tens <= 8) result += 'L';
    if (tens == 9) result += 'C';
    if (tens % 5 < 4) {
        for (int i = 0; i < tens % 5; i++) result += 'X';
    }
    
    // Units: I / V / X pattern
    if (units == 4 || units == 9) result += 'I';
    if (units >= 4 && units <= 8) result += 'V';
    if (units == 9) result += 'X';
    if (units % 5 < 4) {
        for (int i = 0; i < units % 5; i++) result += 'I';
    }
    
    std::cout << result << std::endl;
    return 0;
}
```

### Тест-кейсы

| Input  | Expected      |
|--------|---------------|
| 351    | CCCLI         |
| 449    | CDXLIX        |
| 1313   | MCCCXIII      |
| 2020   | MMXX          |

### Эстетика урока

> "Логику этих условий можно просто скопировать. И сделать аналогично для десятков,
> только заменив hundreds на tens и буквы c, d, m на x, l, c."

DRY pattern — повторяющийся блок. Преподаватель намекает что это **подготовка к функциям**:

> "Очень скоро мы с вами научимся избавляться от таких повторяющихся кусков кода
> в программах, тем самым делая наши программы проще и короче."

То есть в Module 11 introducing functions — этот же код можно будет переписать как:

```cpp
std::string romanDigit(int digit, char one, char five, char ten) {
    std::string r = "";
    if (digit == 4 || digit == 9) r += one;
    if (digit >= 4 && digit <= 8) r += five;
    if (digit == 9) r += ten;
    if (digit % 5 < 4) {
        for (int i = 0; i < digit % 5; i++) r += one;
    }
    return r;
}
```

### На диске

`Module9th/Module9Tasks/roman_numerals.cpp` — реализация есть. Тест: `test_roman_numerals.sh`.

Также есть `author_solution2.cpp` (вероятно эталонное решение). Полезно сравнить с лекционным подходом.

---

## Take-aways

1. **`std::getline(cin, str)` vs `cin >> str`** — getline сохраняет пробелы, cin режет на пробелах. Для строк с пробелами обязательно getline.
2. **Edge case index 0** — при цикле с `arr[i-1]` начинать с `i=1`, edge case `i=0` обработать отдельно.
3. **Pattern "по кусочкам через `bool ok`"** — лучше монолитного `if (cond1 && cond2 && ...)`. Альтернатива — early `return false`, но это упирается в стиль.
4. **Тернарный оператор** `cond ? then : else` — компактен для assignment (`int x = cond ? a : b;`).
5. **Repeated structure → DRY → functions** — анонс Module 11. Roman digit conversion — идеальный кандидат для функции.
6. **Тестирование критично** — преподаватель явно: "поиск ошибок занимает чуть ли не больше половины рабочего времени". Тест-кейсы для positive + negative ВАЖНЫ.

---

## Анонс M11.2+

> "В следующем уроке... научимся избавляться от повторяющихся кусков кода в программах
> с помощью функций."

Ожидаем: функции, параметры, возвращаемые значения, scope переменных. См. также
существующий `Module11th/README.md` с teacher feedback из M10 review.
