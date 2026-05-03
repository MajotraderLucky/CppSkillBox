# M33.1 — Об исключениях (введение в exceptions)

**Длительность:** ~13 минут
**Тема:** аппаратные vs C++ исключения, `throw` / `try` / `catch`, `std::exception`

## Главная идея

> Где есть **правила** алгоритма, там есть и **исключения** из правил.
>
> **C++ исключения** — это механизм языка для **передачи нештатной ситуации
> наверх по стеку вызовов**, минуя обычный return. Альтернатива: коды ошибок,
> которые легко проигнорировать.

## Постановка задачи

Делим 10 яблок на N человек, N вводит пользователь:

```cpp
int apples = 10;
int people;
std::cin >> people;
int per_person = apples / people;
std::cout << per_person;
```

Запуск с `people = 5` → `2`. С `people = 0` → **аппаратное исключение**.

## Аппаратное исключение

```text
Program received signal SIGFPE, Arithmetic exception.
```

> **SIGFPE** = Floating-Point Exception. Срабатывает на уровне **процессора** (целочисленное деление на ноль).
>
> **Не ловится** обычным C++ `try/catch`. Программа просто крашится.

### Защита: проверка через `if`

```cpp
if (people == 0) {
    std::cerr << "Cannot divide by zero\n";
    return 1;
}
int per_person = apples / people;
```

> Это **safe programming practice** — заранее проверять опасные значения. Либо явно документировать, что функция падает на специфичных аргументах.

## Выделим логику в функцию `divide()`

```cpp
int divide(int dividend, int divisor) {
    return dividend / divisor;     // упадёт при divisor == 0
}
```

### Попытка №1: вернуть 0 при ошибке

```cpp
int divide(int dividend, int divisor) {
    if (divisor == 0) return 0;    // ← но 0 — валидный результат!
    return dividend / divisor;
}
```

**Проблема:** `divide(0, 5)` тоже вернёт 0 → пользователь не отличит ошибку от валидного результата.

### Попытка №2: `assert`

```cpp
#include <cassert>
int divide(int dividend, int divisor) {
    assert(divisor != 0);
    return dividend / divisor;
}
```

**Проблемы:**
- Срабатывает только в **debug** сборках (отключается в release)
- **Жёстко** убивает программу — пользователь не может восстановить работу

### Решение: исключение C++

## std::exception

```cpp
#include <exception>     // заголовочный файл

int divide(int dividend, int divisor) {
    if (divisor == 0) {
        throw std::exception();    // ← бросаем исключение
    }
    return dividend / divisor;
}
```

> `throw` — ключевое слово «бросить». Создаём объект исключения и кидаем его наверх.

> Бросать можно **что угодно**: `throw 42;`, `throw "err";`, `throw MyClass();`.
> Но best practice — **классы-наследники `std::exception`**.

## try / catch

```cpp
try {
    int per_person = divide(apples, people);
    std::cout << per_person;       // выполнится только если divide не бросил
} catch (const std::exception& e) {
    std::cerr << "Caught exception: " << e.what() << "\n";
}
```

### Разбор

| Конструкция                  | Назначение                                          |
|------------------------------|-----------------------------------------------------|
| `try { ... }`                | «Попробовать» выполнить код                         |
| `catch (const T& e)`         | Поймать исключение типа T (или его наследника)      |
| `e.what()`                   | Метод `std::exception` — сообщение об ошибке        |

### Почему `const T&`

- **`const`** — внутри обработчика менять смысла нет
- **`&`** — без копирования (полиморфизм)

> Это **стандартная практика**. `catch (T)` (по value) — антипаттерн.

## Логика выполнения try/catch

```cpp
try {
    A();           // выполнится
    B();           // если A не бросит — выполнится
    C();           // если B не бросит — выполнится
} catch (...) {
    handle();      // выполнится, если кто-то выше бросил
}
D();               // выполнится после catch (или после try если без исключения)
```

### Важная фишка

> Если внутри `try` бросилось исключение — **остаток try-блока пропускается**.
> Управление прыгает в `catch`. После `catch` — продолжается код после try/catch.

### Пример из урока: где разместить вывод

**Неправильно (вывод снаружи):**
```cpp
try { divide(apples, people); }
catch (const std::exception& e) { ... }
std::cout << result;        // ← выведется даже при ошибке (но result undefined)
```

**Правильно (внутри try):**
```cpp
try {
    int per_person = divide(apples, people);
    std::cout << per_person;     // ← выведется только если divide не бросил
} catch (const std::exception& e) {
    std::cerr << e.what();
}
```

## Полный пример

```cpp
#include <iostream>
#include <exception>

int divide(int dividend, int divisor) {
    if (divisor == 0) {
        throw std::exception();
    }
    return dividend / divisor;
}

int main() {
    int apples = 10;
    int people;
    std::cin >> people;

    try {
        int per_person = divide(apples, people);
        std::cout << per_person << std::endl;
    } catch (const std::exception& e) {
        std::cerr << "Caught exception: " << e.what() << std::endl;
    }
    return 0;
}
```

## Сравнение подходов

| Подход            | Плюсы                           | Минусы                                    |
|-------------------|---------------------------------|-------------------------------------------|
| Return code       | Простой, явный                  | Можно проигнорировать, пожирает return    |
| Output param      | Можно вернуть и значение, и код | Грязный API, ручное освобождение памяти   |
| `assert`          | Минимум кода                    | Только debug, жёстко убивает              |
| C++ exception     | Прозрачно, нельзя пропустить    | Overhead в throw, не ловит SIGFPE         |

## Аппаратные vs C++ исключения

| Тип             | Источник            | Можно ловить через try/catch   | Примеры                           |
|-----------------|---------------------|--------------------------------|-----------------------------------|
| **Аппаратное**  | CPU / OS (SIGFPE)   | НЕТ (только OS-signal handler) | Деление на ноль int, segfault     |
| **C++**         | `throw` в коде      | ДА                             | `std::runtime_error`, `bad_alloc` |

> Урок: чтобы из «деления на 0» получилось **C++** исключение — мы добавили **`if + throw`** вручную.

## Practical relevance для DevOps

- **API design:** `parse()` бросает `parse_error`, не возвращает sentinel
- **Resource management:** RAII + exception → автоматическое освобождение через деструкторы
- **Логирование инцидентов:** `catch (const std::exception& e) { log(e.what()); }`
- **Sentry-like:** unhandled exception → uncaught_exception → stacktrace
- **Best practice:** выкидывать **typed** exceptions, ловить **specific** types

## Что дальше

> «Не слишком информативно. Как выяснить, какой именно произошёл?» — об этом в **следующем** уроке (различение исключений).

## Связь с другими модулями

- **M27 классы:** `std::exception` — обычный класс, можно наследовать
- **M31 деструкторы:** RAII + exceptions гарантируют cleanup
- **M33.2+ (next):** иерархия исключений, custom exception classes
- **C++ best practices:** `noexcept`, exception safety guarantees (basic/strong/no-throw)
