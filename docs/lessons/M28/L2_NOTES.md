# M28.2 — Несколько параллельных потоков

**Длительность:** ~11 минут
**Тема:** передача аргументов в поток, `get_id()`, `detach`, `joinable`

## Главная идея

> Аргументы функции потока передаются как **дополнительные параметры конструктора `std::thread`**.
> `detach` отвязывает поток от объекта; `joinable` проверяет можно ли join'ить.

## Передача аргументов

Если функция принимает параметры — добавляем их в конструктор `std::thread`:

```cpp
void waitForCall(int seconds) {
    std::this_thread::sleep_for(std::chrono::seconds(seconds));
    std::cout << "RING!\n";
}

int main() {
    int t;
    std::cin >> t;
    std::thread thread1(waitForCall, t);   // передали t как аргумент
    thread1.join();
}
```

### Несколько аргументов

```cpp
void waitForCall(std::string name, int seconds) {
    std::this_thread::sleep_for(std::chrono::seconds(seconds));
    std::cout << "RING from " << name << "\n";
}

std::thread t1(waitForCall, "Курьер", 10);
std::thread t2(waitForCall, "Друг",   5);
std::thread t3(waitForCall, "Skillbox", 4);
t1.join();
t2.join();
t3.join();
```

> **Не используй глобальные переменные** для shared state — синхронизация
> станет головной болью. Передавай аргументы явно.

## std::thread::get_id()

Каждый поток имеет **уникальный ID** — для отладки и логирования:

```cpp
void waitForCall(std::string name, int sec) {
    std::cout << "Thread ID: " << std::this_thread::get_id() << " " << name << "\n";
    std::this_thread::sleep_for(std::chrono::seconds(sec));
}

int main() {
    std::cout << "Main ID: " << std::this_thread::get_id() << "\n";

    std::thread t1(waitForCall, "Курьер", 10);
    std::thread t2(waitForCall, "Друг",   5);
    t1.join();
    t2.join();
}
```

**Вывод:**
```text
Main ID: 0x1
Thread ID: 0x2 Курьер
Thread ID: 0x3 Друг
```

| API                              | Что делает                               |
|----------------------------------|------------------------------------------|
| `std::this_thread::get_id()`     | ID текущего потока                       |
| `t.get_id()`                     | ID конкретного объекта thread            |
| `std::thread::id` (тип)          | Можно сравнивать (`==`/`!=`), хешировать |

## detach() — отвязать поток

`detach()` "отпускает" поток — он живёт сам по себе, без связи с объектом
`std::thread`:

```cpp
std::thread t(waitForCall, "Background", 10);
t.detach();    // ← объект t больше не управляет потоком
// поток продолжит работу, но мы его не контролируем
```

После `detach()`:
- Поток выполняется до естественного завершения
- Объект `t` больше с ним не связан (не нужен `join`)
- Если процесс упадёт раньше — поток умрёт (всё ок)

### Когда использовать detach

- **Fire-and-forget tasks:** запустил и забыл
- **Daemon threads:** фоновые потоки, переживающие main
- **Когда время жизни управляется иначе** (например через флаги/условия)

> **На практике:** `detach` опасен. Лучше всегда `join`.
> Detached потоки могут продолжать работать после уничтожения нужных им данных
> → undefined behavior.

## joinable() — проверка состояния

```cpp
std::thread t(func);

if (t.joinable()) {
    t.join();
}
```

`joinable()` возвращает `true` если:
- thread активен И ещё не был join'нут И не был detach'нут

`false` если:
- default-constructed (`std::thread{}`)
- уже был join'нут
- уже был detach'нут
- moved-from

### Защитный pattern

```cpp
std::thread t(func);
// ... что-то делаем ...
if (t.joinable()) t.join();   // безопасно даже если detach сделан где-то ещё
```

## Полный пример: ID + 3 потока

```cpp
#include <chrono>
#include <iostream>
#include <string>
#include <thread>

void notify(std::string who, int sec) {
    std::cout << "[" << std::this_thread::get_id() << "] start " << who << "\n";
    std::this_thread::sleep_for(std::chrono::seconds(sec));
    std::cout << "[" << std::this_thread::get_id() << "] " << who << " завершён\n";
}

int main() {
    std::cout << "[main: " << std::this_thread::get_id() << "]\n";

    std::thread t1(notify, "A", 3);
    std::thread t2(notify, "B", 1);
    std::thread t3(notify, "C", 2);

    if (t1.joinable()) t1.join();
    if (t2.joinable()) t2.join();
    if (t3.joinable()) t3.join();
}
```

## ВАЖНО: thread destructor

Если объект `std::thread` уничтожается с активным потоком (joinable=true)
без join/detach → **`std::terminate()` (программа крашится)**.

```cpp
{
    std::thread t(func);
}   // ← здесь УПАДЁТ если не сделать t.join() или t.detach()
```

## Сравнение thread API

| Метод                                 | Что делает                               |
|---------------------------------------|------------------------------------------|
| `t.join()`                            | блокирует, ждёт завершения               |
| `t.detach()`                          | отвязывает поток от объекта              |
| `t.joinable()`                        | можно ли join? (не joined и не detached) |
| `t.get_id()`                          | уникальный ID потока                     |
| `t.native_handle()`                   | OS-специфичный handle (pthread_t etc.)   |
| `std::thread::hardware_concurrency()` | сколько ядер у CPU                       |

## Practical relevance для DevOps

- **Logging с thread ID:** `[2026-05-03 18:00:00 tid=12345] message` — стандарт
- **htop/top:** `H` показывает потоки внутри процессов
- **gdb:** `info threads` + `thread N` для переключения
- **Тред-pool size:** обычно `std::thread::hardware_concurrency()` или x2
- **Detach осторожно:** в production daemon'ах — лучше явное управление

## Связь с другими модулями

- **M11+ функции:** аргументы потока — обычные аргументы функции
- **M28.1:** базовый thread API
- **M28.3+ (next):** скорее всего mutex / shared data синхронизация
- **C++ best practices:** modern → `std::async` или `std::jthread` (C++20)
