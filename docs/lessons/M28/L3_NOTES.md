# M28.3 — Синхронизация потоков и типичные ошибки

**Длительность:** ~9 минут
**Тема:** `std::mutex`, lock/unlock, race condition, deadlock

## Главная идея

> **Mutex** = «светофор» — гарантирует что только **один поток** может работать
> с ресурсом в момент времени. Без mutex — race condition.

## Проблема: общий ресурс из нескольких потоков

```cpp
std::vector<std::string> history;     // глобальный shared state

void waitForCall(std::string name, int sec) {
    std::this_thread::sleep_for(std::chrono::seconds(sec));
    history.push_back(name);          // ← ОПАСНО! несколько потоков
}
```

**Что может пойти не так:**
- Поток A читает size = 5, готовится записать в `[5]`
- Поток B одновременно читает size = 5, готовится записать в `[5]`
- Один затирает другого → потеря данных
- Vector переалоцирует buffer → invalid pointer
- Программа падает или даёт некорректный результат

> Это **race condition** (гонка данных). Один из самых сложных багов:
> воспроизводится непредсказуемо, зависит от шедулера.

## Решение: `std::mutex`

```cpp
#include <mutex>

std::mutex historyAccess;
std::vector<std::string> history;

void waitForCall(std::string name, int sec) {
    std::this_thread::sleep_for(std::chrono::seconds(sec));

    historyAccess.lock();             // ← заблокировать
    history.push_back(name);          // ← теперь безопасно
    historyAccess.unlock();           // ← отпустить
}
```

### Принцип работы

| Метод               | Что делает                                           |
|---------------------|------------------------------------------------------|
| `mutex.lock()`      | Если свободен — захватить. Если занят — **ждать**.   |
| `mutex.unlock()`    | Освободить — другие потоки могут получить            |
| `mutex.try_lock()`  | Не ждёт: вернёт `false` если занят                   |

> **Только один поток** одновременно владеет mutex. Остальные блокируются на `lock()`.

## Полный пример

```cpp
#include <chrono>
#include <iostream>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

std::mutex                historyAccess;
std::vector<std::string>  history;

void waitForCall(std::string name, int sec) {
    std::this_thread::sleep_for(std::chrono::seconds(sec));

    historyAccess.lock();
    history.push_back(name);
    historyAccess.unlock();
}

int main() {
    std::thread t1(waitForCall, "Курьер",   4);
    std::thread t2(waitForCall, "Skillbox", 4);
    t1.join();
    t2.join();

    historyAccess.lock();
    std::cout << "Пропущенные звонки:\n";
    for (const auto& name : history) std::cout << "  " << name << "\n";
    historyAccess.unlock();
}
```

## ВСЕГДА читать данные тоже под mutex

Не только запись, но и **чтение**:

```cpp
historyAccess.lock();
for (const auto& name : history) std::cout << name;   // ← read под lock
historyAccess.unlock();
```

Если один поток пишет, а другой читает — может прочитать половинное значение.

## Современный pattern: `std::lock_guard`

`lock` + `unlock` в одной паре — легко забыть `unlock`. Особенно при exception.
RAII-обёртка решает:

```cpp
#include <mutex>

void safeFunction() {
    std::lock_guard<std::mutex> lock(historyAccess);
    // ↑ конструктор делает lock(), деструктор делает unlock()
    history.push_back(name);
}   // ← здесь auto unlock даже если throw
```

> **Best practice:** в современном C++ почти **всегда** использовать `lock_guard`
> или `unique_lock` вместо ручного `lock/unlock`.

## Deadlock — двойной мёртвый захват

Если **2 mutex** и каждый поток захватывает их в **разном порядке**:

```cpp
std::mutex mA, mB;

void thread1() {
    mA.lock();   // 1) захватили mA
    mB.lock();   // 3) ждём mB (его держит thread2)
    // ...
    mB.unlock();
    mA.unlock();
}

void thread2() {
    mB.lock();   // 2) захватили mB
    mA.lock();   // 4) ждём mA (его держит thread1)
    // ...
    mA.unlock();
    mB.unlock();
}
```

**Результат:** оба потока ждут друг друга **бесконечно**. Программа висит.

### Профилактика deadlock

| Подход                  | Идея                                                |
|-------------------------|-----------------------------------------------------|
| **Единый порядок lock** | Все потоки лочат mutex'ы в одном порядке            |
| **`std::lock(m1, m2)`** | Атомарно лочит несколько mutex                      |
| **Иерархия locks**      | mutex имеют уровни, можно лочить только сверху вниз |
| **Один большой lock**   | Меньше параллелизма, но безопасно                   |
| **Lock-free структуры** | Атомарные операции вместо mutex                     |

## Виды mutex

| Тип                         | Особенность                                  |
|-----------------------------|----------------------------------------------|
| `std::mutex`                | Базовый                                      |
| `std::recursive_mutex`      | Один поток может lock'ать несколько раз      |
| `std::timed_mutex`          | `try_lock_for(timeout)`                      |
| `std::shared_mutex` (C++17) | Многим читать, одному писать (RW lock)       |

## Race conditions vs другие баги

| Баг            | Симптом                            | Решение                       |
|----------------|------------------------------------|-------------------------------|
| Race condition | Непредсказуемые результаты         | mutex / atomic                |
| Deadlock       | Программа висит                    | единый порядок lock           |
| Livelock       | Потоки активны но не прогрессируют | backoff, лучшие алгоритмы     |
| Starvation     | Один поток никогда не получает CPU | fair scheduling, очереди      |

## Альтернативы mutex

- **`std::atomic<T>`** — атомарные операции для простых типов (int, ptr)
- **Lock-free queue** — boost::lockfree, очереди без mutex
- **Message passing** — потоки общаются через channels (Go, Erlang style)
- **Immutable data** — общая read-only структура без блокировок

## Practical relevance для DevOps

- **Logging:** общий лог-файл из multi-thread → mutex/atomic, или per-thread queue
- **Counters/metrics:** `std::atomic<int>` дешевле mutex
- **Cache:** RW-lock для read-heavy access pattern
- **Connection pool:** mutex вокруг queue свободных connections
- **Профилирование:** `perf` показывает lock contention; ThreadSanitizer находит races

## Связь с другими модулями

- **M28.1, M28.2:** thread API — теперь добавили синхронизацию
- **M28.4 hwork:** наверняка задачи с mutex / shared state
- **C++ best practices:** `lock_guard`/`unique_lock`, `atomic`, никогда не lock/unlock вручную
- **Современный C++:** futures, promises, async — высокоуровневые альтернативы
