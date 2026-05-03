# M20.2 — Запись разных типов данных

**Длительность:** ~10 минут
**Тема:** запись int/float/double/bool через `<<`, формат через `setf`

## Главная идея

> `ofstream << value` работает как `cout << value` — поддерживает все типы.

## Базовые примеры

```cpp
std::ofstream f("data.txt");
int x = 42;
double pi = 3.14159;
bool flag = true;
std::string name = "Alice";

f << x << " " << pi << " " << flag << " " << name << "\n";
// "42 3.14159 1 Alice"
```

## Форматирование bool как text

По умолчанию bool пишется как `0` или `1`. Чтобы писать `true`/`false`:

```cpp
f.setf(std::ios::boolalpha);
f << true;   // "true"

// Или:
f << std::boolalpha << true;
```

## Точность вещественных чисел

```cpp
double pi = 3.14159265358979;
f << pi;                          // "3.14159" (default 6 цифр)
f << std::setprecision(10) << pi; // "3.141592654" (требует <iomanip>)
f << std::fixed << std::setprecision(2) << pi;  // "3.14"
```

## setf с флагами форматирования

```cpp
f.setf(std::ios::fixed);                      // фиксированная точность
f.setf(std::ios::showpoint);                  // всегда показывать точку
f.setf(std::ios::left, std::ios::adjustfield); // выравнивание влево
```

## Practical relevance для DevOps

- **CSV/TSV генерация:** правильное форматирование чисел
- **Logging:** time stamps, structured data
- **Reports:** табличные данные с фиксированной шириной полей

## Связь

- **M19.2:** чтение типов через `>>`
- **M20.3+ (next):** запись массивов, бинарная запись
