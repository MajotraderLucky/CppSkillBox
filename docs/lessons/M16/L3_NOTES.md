# M16.3 — Представление базовых типов данных в памяти

**Тип:** longread с встроенным видео + quizzes
**URL:** `longread/063e46dd-0a8f-4fd0-9e4d-7256233f077a`
**Видео:** `2020_11_21_profession-c-plus-plus М16_L2.mp4` (2:12)

## Структура longread

1. Что вас ждёт (intro)
2. Данные одни, а информация разная (file extensions, MIME)
3. Данные и C++ (статическая типизация)
4. Двоичные и десятичные числа (бит, байт, прямой код)
5. Целочисленный тип (char, short, int + unsigned)
6. Числа с плавающей точкой (IEEE 754, epsilon comparison)

## Ключевая техническая информация

### Целочисленные типы (signed, по умолчанию)

| Тип   | Диапазон                          | Размер (байт) |
|-------|-----------------------------------|---------------|
| char  | -128 до 127                       | 1             |
| short | -32768 до 32767                   | как правило 2 |
| int   | -2147483648 до 2147483647         | как правило 4 |
| long  | (зависит от платформы)            | 4 или 8       |

Также фиксированной длины: `int8_t`, `int16_t`, `int32_t`, `int64_t`.

### Беззнаковые

| Тип            | Диапазон                |
|----------------|-------------------------|
| unsigned char  | 0 до 255                |
| unsigned short | 0 до 65535              |
| size_t         | 0 до max адресов памяти |

`uint8_t`, `uint16_t`, `uint32_t`, `uint64_t` — фиксированной длины.

### Как хранятся signed

Старший бит = знак:
- `1000 0001` = -1 (signed) или 129 (unsigned)
- `0000 0001` = 1 (оба варианта)

В беззнаковых тот же бит идёт в число → диапазон в 2 раза больше.

### char и ASCII

`char c = 'A';` хранится как `0100 0001` (= 65 = ASCII 'A').

ASCII таблица сопоставляет символы с числами 0-255.

### Quiz: Char = 0010 0011 → ?

`0010 0011` = 32 + 2 + 1 = **35** = '#' в ASCII.

### Функция printBinary(value)

```cpp
#include <iostream>
#include <cmath>

std::string printBinary(int value) {
    std::string tmp;
    value = std::abs(value);
    while (value != 0) {
        tmp.push_back((value % 2) + '0');
        value /= 2;
    }
    std::string result;
    for (int i = tmp.length() - 1; i >= 0; --i) {
        result.push_back(tmp[i]);
    }
    return result;
}

int main() {
    std::cout << printBinary(65) << std::endl;  // 1000001
    return 0;
}
```

### Self-task: BinaryToDecimal

```cpp
int BinaryToDecimal(const std::string& binaryValue) {
    int result = 0;
    int factor = 1;
    for (int i = binaryValue.size() - 1; i >= 0; --i) {
        result += (binaryValue[i] - '0') * factor;
        factor *= 2;
    }
    return result;
}
```

### Числа с плавающей точкой (IEEE 754)

`float` (4 байта) и `double` (8 байт). Структура float (32 бит):

| Биты    | Значение                              |
|---------|---------------------------------------|
| 1 (lsb) | знак                                  |
| 8       | порядок (экспонента)                  |
| 23      | мантисса (число без учёта экспоненты) |

Пример: `1.2 × 10^-7 = (+1) × 0.12 × 10^-8` → знак=1, мантисса=12, экспонента=8.

### Quiz: float == ?

> Из-за **ограничений точности формата**.

Float хранит ограниченное число знаков. Два числа могут отличаться в 20-м знаке после запятой и считаться равными битами.

### Сравнение float через epsilon

```cpp
#include <iostream>
#include <cmath>

bool isRelativelyEqual(double lhs, double rhs, double epsilon) {
    return std::abs(lhs - rhs) < epsilon;
}

int main() {
    double lhs = 0., rhs = 0., epsilon = 0.;
    std::cin >> lhs >> rhs >> epsilon;
    std::cout << std::boolalpha << isRelativelyEqual(lhs, rhs, epsilon) << std::endl;
    return 0;
}
```

`<cfloat>` содержит `FLT_EPSILON` — минимально возможный epsilon для float.

## Practical relevance для DevOps

**HIGH:**
- Понимание overflow при работе с метриками (Prometheus counters)
- Float comparison в latency assertions (eps comparisons обязательны)
- ASCII → байт-парсинг логов
- Bit manipulation для Linux file modes (`stat -c '%a'`), permissions
- `size_t` для адресации больших файлов / memory mapping

## Связь с другими модулями

- **M2 (numeric types):** этот модуль расширяет с биты внутреннего представления
- **M16.4+:** скорее всего будет про преобразования (stoi, to_string)
- **C++17:** `std::optional` для type-safe conversions, `std::variant` для multi-type

## Status

Longread содержит встроенное видео (2:12) и 2 quiz'а — оба пройдены.
Видео запущено, ждёт фактического просмотра до конца для mark complete.
