# M33.2 — Стандартные и пользовательские исключения

**Длительность:** ~15 минут
**Тема:** custom exception class, `std::invalid_argument`, multiple `catch`, `catch (...)`, `noexcept`

## Главная идея

> Чтобы **различать** причины ошибок, создаём **типизированные** исключения
> (наследники `std::exception`) и пишем для них **отдельные `catch` блоки**.
>
> Чем точнее тип — тем точнее логика обработки.

## Постановка задачи

Расширяем M33.1: вводим `apples` И `people`. Считываем оба, делим.

```cpp
int distribute(int apples, int people) {
    if (apples < 0 || people < 0) {
        throw std::exception();          // отрицательные — некорректно
    }
    return divide(apples, people);
}
```

**Проблема:** при ловле — выводим `e.what()` → "std::exception". Невозможно понять, что именно случилось: деление на 0 или отрицательное число.

## Custom exception class

```cpp
class DivisionByZeroException : public std::exception {
public:
    const char* what() const noexcept override {
        return "Division by zero";
    }
};
```

### Разбор сигнатуры `what()`

```cpp
const char* what() const noexcept override;
```

| Часть         | Значение                                               |
|---------------|--------------------------------------------------------|
| `const char*` | Возвращает указатель на C-string (immutable)           |
| `what()`      | Без аргументов                                         |
| `const`       | Не меняет состояние объекта (`this` — const)           |
| `noexcept`    | **Гарантирует**, что метод не бросит исключения        |
| `override`    | Явно указывает: переопределяем виртуальный метод базы  |

### Зачем `noexcept`

> Если бы `what()` сам бросил исключение **внутри** обработчика → нужен **обработчик обработчика**. Бесконечная рекурсия. Поэтому `what()` обязан быть `noexcept`.

> Convention naming: имя класса с **`Exception`** или **`Error`** в конце — `DivisionByZeroException`, `ParseError`.

## Стандартные exception типы

В заголовочном `<stdexcept>` уже есть готовые:

| Тип                       | Назначение                                 |
|---------------------------|--------------------------------------------|
| `std::logic_error`        | Программная логическая ошибка              |
| `std::invalid_argument`   | Невалидный аргумент функции                |
| `std::out_of_range`       | Индекс за границами                        |
| `std::length_error`       | Превышение допустимого размера             |
| `std::domain_error`       | Аргумент вне области определения           |
| `std::runtime_error`      | Runtime-ошибка (произошло во время работы) |
| `std::overflow_error`     | Арифметическое переполнение                |
| `std::underflow_error`    | Underflow                                  |
| `std::range_error`        | Результат вне диапазона                    |
| `std::bad_alloc`          | `new` не смог выделить память              |

> Все наследники `std::exception` → один обработчик `catch (const std::exception&)` поймает их всех.

### Пример использования std::invalid_argument

```cpp
#include <stdexcept>

if (apples < 0) {
    throw std::invalid_argument("apples cannot be negative");
}
if (people < 0) {
    throw std::invalid_argument("people cannot be negative");
}
```

Сообщение можно прочитать через `e.what()`.

## Множественные catch блоки

```cpp
bool input = true;
while (input) {
    int apples, people;
    std::cin >> apples >> people;
    try {
        int per_person = distribute(apples, people);
        std::cout << per_person << std::endl;
        input = false;                              // успех — выходим
    } catch (const DivisionByZeroException& e) {
        std::cerr << e.what() << "\n";
        input = false;                              // фатал — тоже выходим
    } catch (const std::invalid_argument& e) {
        std::cerr << e.what() << "\n";
        // input = true → повторим ввод
    }
}
```

### Правила

- `catch` блоки проверяются **сверху вниз**
- Срабатывает **первый подходящий** по типу
- Дальнейшие — пропускаются
- Ловится тип, **точно равный** или **наследник** указанного

> **Anti-pattern:** ловить `std::exception&` **раньше** специфичных — оно поймает всё, и специфичные блоки никогда не запустятся.

### Правильный порядок

```cpp
try { ... }
catch (const DivisionByZeroException& e)  { ... }   // narrow type first
catch (const std::invalid_argument& e)    { ... }   // wider
catch (const std::exception& e)           { ... }   // widest std type
catch (...)                               { ... }   // catch-all (any type)
```

## catch (...) — поймать что угодно

```cpp
try {
    third_party_function();
} catch (...) {
    std::cerr << "Unknown exception caught\n";
}
```

- Ловит **любое** исключение, даже не наследующее `std::exception`
- Аргумент **недоступен** (нельзя узнать тип/сообщение)
- Полезно для **defensive programming** на boundaries (main, callbacks, threads)

> «Что если автор библиотеки бросает `int` или свой тип, не наследник `std::exception`?» → `catch (...)` спасёт от crash.

### Можно бросить **что угодно**

```cpp
if (apples > 100) {
    throw apples;        // throw int! не объект — просто число
}
```

Поймать:
```cpp
catch (int n) { std::cerr << "too many apples: " << n; }
catch (...)   { std::cerr << "other"; }
```

> Best practice — **всегда наследоваться от `std::exception`**, чтобы единый интерфейс `what()` работал.

## Если исключение не поймано

> Если `throw` происходит и **нет подходящего catch** на пути вверх по стеку — программа **аварийно завершается** через `std::terminate()` (по умолчанию вызывает `abort()`).

Симптом: «программа просто взяла и вышла. Да ещё и с ошибкой.»

> Поэтому **обязательно** ловить хотя бы `std::exception&` или `(...)` в `main` для production-кода.

## Полный пример

```cpp
#include <iostream>
#include <stdexcept>

class DivisionByZeroException : public std::exception {
public:
    const char* what() const noexcept override {
        return "Division by zero";
    }
};

int divide(int dividend, int divisor) {
    if (divisor == 0) throw DivisionByZeroException();
    return dividend / divisor;
}

int distribute(int apples, int people) {
    if (apples < 0) throw std::invalid_argument("apples cannot be negative");
    if (people < 0) throw std::invalid_argument("people cannot be negative");
    if (apples > 100) throw apples;       // эксперимент — бросим int
    return divide(apples, people);
}

int main() {
    bool input = true;
    while (input) {
        int apples, people;
        std::cin >> apples >> people;
        try {
            std::cout << distribute(apples, people) << std::endl;
            input = false;
        } catch (const DivisionByZeroException& e) {
            std::cerr << e.what() << "\n";
            input = false;
        } catch (const std::invalid_argument& e) {
            std::cerr << e.what() << "\n";              // повтор ввода
        } catch (...) {
            std::cerr << "Unknown problem, try again\n";
        }
    }
    return 0;
}
```

## Антипаттерн: проверка через `e.what()`

```cpp
catch (const std::exception& e) {
    if (std::string(e.what()) == "Division by zero") { ... }   // BAD
}
```

**Почему плохо:**
- **Magic string:** автор библиотеки переведёт сообщение → код сломается
- **Производительность:** сравнение строк дороже, чем type dispatch
- **Хрупкость:** зависит от формулировки

> **Правильно:** ловить **по типу** через отдельные `catch` блоки.

## Когда стоит использовать exceptions

### Использовать
- Программная ошибка, которую вызывающий должен знать (parse error, network failure)
- Конструкторы (нет другого способа сообщить о провале)
- RAII / smart pointers (cleanup на throw)

### Не использовать
- Hot path / performance-critical (throw имеет overhead)
- Embedded / real-time (некоторые системы запрещают exceptions)
- API простой и очевидный — `bool open(file)` лучше чем `throw open_error`
- Альтернатива: **enum status code** — лёгкий, явный

## Practical relevance для DevOps

- **Custom exception hierarchy:** `class NetworkError`, `class ParseError`, `class ConfigError` — typed catch
- **Boundary catching:** в `main`, в RPC handler — `catch (...)` для предотвращения crash
- **Sentry/Crashlytics:** stacktrace из uncaught exception → автоматический отчёт
- **Logging:** `catch (const std::exception& e) { LOG_ERROR(e.what()); }`
- **Some C++ codebases (Google) запрещают exceptions** — используют status codes (`absl::Status`)

## Связь с другими модулями

- **M29 наследование:** `class MyException : public std::exception` — обычное наследование
- **M29.3 virtual:** `what()` — виртуальный метод
- **M31.2 override:** обязательная hygienic для override
- **M33.1:** базовый syntax try/catch/throw
- **M33.3+ (next):** скорее всего exception safety / advanced patterns
