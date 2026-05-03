# M34.4 — Установка и подключение Qt (CLion + CMake)

**Длительность:** ~9 минут
**Тема:** инсталляция Qt 5, регистрация, выбор компонентов, подключение в CMakeLists.txt

## Главная идея

> Установка **Qt 5** через **онлайн-инсталлятор** (требует регистрации).
> Подключение к **CLion** через **`CMAKE_PREFIX_PATH`** + `find_package(Qt5Widgets)`.

## Версия Qt

> Используем **Qt 5** (а не 6).

| Аргумент          | Почему 5, а не 6                                              |
|-------------------|---------------------------------------------------------------|
| Стабильность      | Длительный battle-tested LTS                                  |
| Компоненты        | В 6 убраны / переработаны некоторые модули                    |
| Совместимость     | Большинство туториалов / Stack Overflow на 5                  |
| LTS до 2025       | Поддержка по подписке (commercial), 5.15.x — последняя версия |

> Конкретно урок использует **Qt 5.15.2** (последний минорный релиз 5.x).

## Предварительные требования

> **~60 ГБ** места на диске. Фреймворк действительно гигантский.

## Установка

### 1. Скачать online-инсталлятор

1. Перейти на `qt.io`
2. Кнопка `Download Try` в правом верхнем углу
3. Выбрать **"Go open source"** (LGPL/GPL)
4. Прокрутить вниз → `Download Qt Online Installer`

### 2. Запустить инсталлятор

- **Регистрация обязательна** (с 2021 года)
- Sign Up → email + password → подтверждение по email
- Войти → принять условия LGPL

### 3. Выбор компонентов

| Шаг                      | Действие                                                      |
|--------------------------|---------------------------------------------------------------|
| File associations        | Снять галочку (чтобы CLion не потерял .cpp)                   |
| Компоненты (Custom)      | Развернуть «Qt 5.15.2» (или последний 5.x)                    |
| Версия                   | Поставить галку на конкретный релиз                           |
| Архитектура              | MinGW 64-bit (для CLion) или MSVC, в зависимости от toolchain |
| Лицензии                 | Принять                                                       |

### 4. Online-загрузка

> Установщик качает пакеты в реальном времени. **Долго**. Не занимать сеть.

## Подключение к CLion-проекту (вариант 1: вручную)

### Шаг 1: Найти путь к CMake-модулям Qt

```text
<Qt root>/<version>/<arch>/lib/cmake/

Например: C:/Qt/5.15.2/mingw64_64/lib/cmake/
```

### Шаг 2: Прописать в CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.15)
project(MyQtApp CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# === Qt5 setup ===
set(CMAKE_PREFIX_PATH "C:/Qt/5.15.2/mingw64_64/lib/cmake")
find_package(Qt5Widgets REQUIRED)

# Auto-generation для Qt
set(CMAKE_AUTOMOC ON)              # обработка Q_OBJECT
set(CMAKE_AUTORCC ON)              # обработка ресурсов .qrc
set(CMAKE_AUTOUIC ON)              # обработка .ui файлов от Designer

# === Сборка ===
add_executable(my_app main.cpp)
target_link_libraries(my_app PRIVATE Qt5::Widgets)
```

### Разбор

| Директива                                 | Назначение                                                   |
|-------------------------------------------|--------------------------------------------------------------|
| `CMAKE_PREFIX_PATH`                       | Где искать `Qt5WidgetsConfig.cmake` (find_package)           |
| `find_package(Qt5Widgets ...)`            | Находит библиотеки и headers, expose target Qt5::Widgets     |
| `CMAKE_AUTOMOC`                           | Запуск **moc** (meta-object compiler) для классов с Q_OBJECT |
| `CMAKE_AUTORCC`                           | Запуск **rcc** для бинарных ресурсов                         |
| `CMAKE_AUTOUIC`                           | Запуск **uic** для UI файлов из Designer                     |
| `target_link_libraries(... Qt5::Widgets)` | Подключение библиотеки виджетов                              |

## Подключение к CLion-проекту (вариант 2: шаблон)

> В свежих CLion есть **шаблон Qt Widgets Executable**.

1. `File → New Project → Qt Widgets Executable`
2. Указать путь к Qt установке
3. CLion сам сгенерирует `CMakeLists.txt`

> **Caveat урока:** автогенерируемый `CMakeLists.txt` сложный и **не запустится сразу** — нужно удалить лишние условия (преподаватель показывает на экране какое именно).

## Минимальная программа Qt

```cpp
#include <QApplication>
#include <QPushButton>

int main(int argc, char** argv) {
    QApplication app(argc, argv);
    QPushButton button("Hello, World");
    button.show();
    return app.exec();          // ← запуск event loop
}
```

| Элемент                   | Назначение                                   |
|---------------------------|----------------------------------------------|
| `QApplication app(...)`   | Главный объект приложения, инициализирует Qt |
| `QPushButton button(...)` | Виджет с надписью                            |
| `button.show()`           | Показать widget                              |
| `app.exec()`              | Запустить **event loop** (M34.2)             |

> `exec()` — блокирующий вызов. Возвращается, когда окно закрыто. Внутри — тот самый event loop.

## moc / rcc / uic — что это

> Qt **расширяет C++** препроцессорным шагом. Перед сборкой идут **дополнительные** утилиты.

| Утилита | Что делает                                                           |
|---------|----------------------------------------------------------------------|
| moc     | Парсит `Q_OBJECT` классы → генерирует C++ код для signals/slots/RTTI |
| rcc     | Упаковывает ресурсы (`.qrc`) в C++ массивы байт                      |
| uic     | Генерирует C++ из `.ui` файлов Qt Designer                           |

> `CMAKE_AUTOMOC=ON` etc. в CMakeLists.txt — чтобы CMake сам запускал эти утилиты.

## Linux альтернатива установке

Под Linux обычно проще:

```bash
sudo apt install qtbase5-dev qttools5-dev qttools5-dev-tools
```

→ Qt установится в `/usr/lib/x86_64-linux-gnu/cmake/Qt5/` → `find_package(Qt5Widgets)` найдёт без `CMAKE_PREFIX_PATH`.

## Подводные камни

### 1. Регистрация

> Без аккаунта Qt установить **нельзя** (с 2021 г.).

### 2. Архитектура matching

> Должна совпадать с тулчейном CLion: MinGW build → mingw64_64 пакет Qt.

### 3. Размер на диске

> Полная установка Qt с Qt Creator + примерами — десятки ГБ. Можно ставить выборочно.

### 4. Сложный CMakeLists из шаблона

> Лучше начать с **минимального** руками, чем разбираться в template.

## Practical relevance для DevOps

- **CI/CD для Qt:** docker images типа `aflaxa/qt5-builder` ускоряют сборку
- **Dependency management:** vcpkg, conan имеют пакеты Qt
- **Cross-compile:** Qt for embedded — нужен sysroot целевой платформы
- **License audit:** при коммерческом продукте — проверить, какая лицензия Qt используется
- **Static vs dynamic build:** статика жирнее но без зависимости от Qt-DLL у клиента

## Связь с другими модулями

- **M25 CMake:** `find_package`, `target_link_libraries` — базовые конструкции
- **M34.3:** Qt Widgets — теперь подключаем
- **M30 CPR / M32 nlohmann:** аналогичный pattern — find_package + link
- **M34.5 (next):** скорее всего практическая работа модуля
