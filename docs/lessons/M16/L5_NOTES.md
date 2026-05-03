# M16.5 — Работа с перечислениями (enum)

**Тип:** longread
**URL:** `longread/e2aa4e4e-59d8-4512-8b97-7691f00847c4`

## Базовый enum (C-style, унаследован C++)

```cpp
enum Rainbow { RED, ORANGE, YELLOW, GREEN, BLUE, INDIGO, VIOLET };
// По умолчанию: RED=0, ORANGE=1, YELLOW=2, ...
```

С явными значениями:

```cpp
enum Buttons { Button1 = 1, Button2 = 2, Button3 = 4 };  // bit flags
```

**Проблемы C-enum:**
1. Имена в общем scope → конфликты между разными enum
2. Неявное преобразование к int → можно случайно сравнить разные enum
3. Случайное равенство `RED == HEATERS` (если оба = 0) — компилятор молчит

## C++ enum class (scoped enum)

```cpp
enum class ProgrammerState { code, eat, sleep };

ProgrammerState s = ProgrammerState::code;  // обязательно с префиксом
if (s == ProgrammerState::eat) { ... }
```

**Преимущества:**
- Имена в собственном scope (нет конфликтов)
- НЕТ неявного преобразования к int → нельзя сравнить с другим типом
- Type safety: `s == 0` — compile error

**Quiz:** «Что изменил C++ при работе с перечислениями?» →
**Убрал возможность сравнения с целым числом** (для enum class).

## Bit flags (C-enum как маска)

Классический паттерн для конфигурации:

```cpp
enum WindowStyle {
    HasMaxButton = 1,    // 0001
    HasMinButton = 2,    // 0010
    HasCloseButton = 4   // 0100
};

int flags = HasMinButton | HasCloseButton;  // 0110 = 6

// Проверка:
if (flags & HasMinButton) { /* min button есть */ }

// Включить флаг:
flags |= HasMaxButton;  // shorthand for: flags = flags | HasMaxButton

// Выключить флаг (через инверсию):
flags &= ~HasMinButton;  // shorthand for: flags = flags & (~HasMinButton)
```

**Quiz:** `enum Buttons { Button1, Button2, Button3 }; int b = Button3 | Button2;`
- Button1=0, Button2=1, Button3=2
- 2 | 1 = 3
- Answer: **3**

## Enum size

По умолчанию C-enum хранится как `int` (4 байта). Можно указать underlying type:

```cpp
enum class Tiny : char { A, B, C };  // 1 байт
enum class Big : long long { ... };  // 8 байт
```

## Practical relevance для DevOps

- **Linux file modes:** S_IRUSR | S_IWUSR | S_IXUSR (bit flags)
- **Signal flags:** SIGTERM, SIGKILL — сами по себе ints, но groups через bitmask
- **Open() flags:** O_RDONLY | O_CREAT | O_EXCL — bit OR composition
- **systemd unit options:** часто bitmask flags
- **Network sockets:** SOCK_STREAM | SOCK_NONBLOCK
