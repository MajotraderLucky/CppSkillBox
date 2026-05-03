# M28.1 — Многопоточность: быстрый старт

**Длительность:** ~16 минут
**Тема:** `std::thread`, `sleep_for`, `join`, основы параллелизма

## Главная идея

> **Поток (thread)** = независимая последовательность выполнения.
> `std::thread t(func);` запускает `func()` в отдельном потоке.
> `t.join()` ждёт завершения.

## Зачем параллелизм

- **Современные CPU** — больше ядер, не выше частоты
- **Отзывчивость UI** — отделить тяжёлую работу от main thread
- **Утилизация железа** — иначе `N-1` ядер простаивает
- **I/O ожидание** — пока ждём диск/сеть, делаем другую работу

### Аналогия: однополосная vs многополосная дорога

Однополосная — все машины (потоки команд) едут со скоростью самой медленной.
Двухполосная — параллельные потоки, обгон, скорость суммируется.

## Проблема: блокирующее ожидание (busy-wait)

```cpp
std::time_t start = std::time(nullptr);
while (std::difftime(std::time(nullptr), start) < 10) {
    // занимает CPU 100%, ничего больше не делает!
}
```

CPU крутит цикл впустую. Параллельно выполнять что-то нельзя.

## Решение: `sleep_for`

```cpp
#include <thread>
#include <chrono>

std::this_thread::sleep_for(std::chrono::seconds(10));
// ↑ освобождает CPU на 10 сек, нет нагрузки
```

| Компонент                 | Что делает                              |
|---------------------------|-----------------------------------------|
| `std::this_thread`        | объект текущего потока                  |
| `sleep_for(duration)`     | приостановить поток на интервал         |
| `std::chrono::seconds(N)` | создать длительность в N секунд         |

## std::chrono — duration API

```cpp
#include <chrono>

std::chrono::seconds(10)        // 10 секунд
std::chrono::milliseconds(500)  // 500 мс
std::chrono::microseconds(100)  // 100 мкс
std::chrono::minutes(1)         // 1 минута
```

## Создание потока

```cpp
#include <thread>
#include <iostream>
#include <chrono>

void waitForCall() {
    std::this_thread::sleep_for(std::chrono::seconds(10));
    std::cout << "RING! Курьер!\n";
}

int main() {
    std::thread t(waitForCall);   // ← запуск функции в новом потоке

    // main делает что-то ещё параллельно...
    std::this_thread::sleep_for(std::chrono::seconds(5));
    std::cout << "RING! Друг!\n";

    t.join();                      // ← ждать завершения t
    return 0;
}
```

### std::thread конструктор

```cpp
std::thread t(func);              // запуск func()
std::thread t(func, arg1, arg2);  // запуск func(arg1, arg2)
std::thread t([]{ ... });          // запуск лямбды
```

Поток **запускается сразу** при создании объекта.

## КРИТИЧЕСКИ ВАЖНО: `join()`

> **Каждый `std::thread` должен быть либо `join`-нут, либо `detach`-нут до уничтожения.**

```cpp
std::thread t(func);
// ... что-то делаем ...
t.join();   // ждём завершения
// или:
// t.detach();   // отвязать (поток будет жить сам по себе)
```

Если объект `std::thread` уничтожается без `join`/`detach` — `std::terminate()`,
программа упадёт.

## Полный пример: 2 параллельных события

```cpp
#include <chrono>
#include <iostream>
#include <thread>

void waitForCall() {
    std::this_thread::sleep_for(std::chrono::seconds(10));
    std::cout << "RING! Курьер позвонил\n";
}

int main() {
    std::thread t(waitForCall);   // фоновый поток

    // main thread делает свою работу:
    std::this_thread::sleep_for(std::chrono::seconds(5));
    std::cout << "RING! Друг позвонил (5 сек)\n";

    t.join();                      // дожидаемся курьера
    std::cout << "Закончили\n";
}
```

Вывод (при запуске):
```text
[5 сек] RING! Друг позвонил (5 сек)
[10 сек] RING! Курьер позвонил
Закончили
```

## Терминология

| Термин          | Значение                                      |
|-----------------|-----------------------------------------------|
| Thread / Нить   | Параллельный поток выполнения                 |
| Main thread     | Поток, в котором запускается `main()`         |
| Worker thread   | Дополнительный поток для фоновой работы       |
| Concurrency     | Параллельные задачи (могут чередоваться)      |
| Parallelism     | Реально одновременно (нужно ≥2 ядра)          |
| Race condition  | Bug: 2 потока меняют общее состояние без sync |
| Deadlock        | 2 потока блокируют друг друга                 |

## Проблемы многопоточности (далее в курсе)

- **Race conditions:** доступ к shared data → нужны мьютексы
- **Deadlocks:** взаимная блокировка
- **Starvation:** один поток никогда не получает CPU
- **Memory ordering:** компилятор/CPU могут переупорядочивать инструкции
- **Cache coherency:** общие данные требуют синхронизации между ядрами

## Practical relevance для DevOps

- **Веб-серверы:** thread per connection (классический pattern)
- **Worker pools:** N потоков обрабатывают очередь задач
- **Background tasks:** logging, metrics, cleanup в фоновых потоках
- **Async I/O:** комбинация с epoll/kqueue для масштабирования
- **Profiling:** htop показывает потоки одного процесса

## Альтернативы std::thread

- **std::async** — высокоуровневая обёртка, возвращает `future`
- **std::jthread** (C++20) — auto-join при destroy
- **OpenMP** — `#pragma omp parallel for` для data parallelism
- **TBB** (Intel) — task-based concurrency
- **Coroutines** (C++20) — кооперативная многозадачность

## Связь с другими модулями

- **M24 даты:** `std::chrono` — теперь полностью используется
- **M27 классы:** `std::thread` — это класс с конструктором/деструктором
- **M28.2+ (next):** передача аргументов в потоки, синхронизация
- **C++ best practices:** в современном коде — `std::async` или `jthread`
