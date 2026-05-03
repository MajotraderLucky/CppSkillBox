# M34.3 — Иерархия окон и компоненты Qt

**Длительность:** ~12 минут
**Тема:** иерархия окон, **Qt** фреймворк, лицензии, компоненты (Creator/Designer/QML/Widgets/GUI/Core)

## Главная идея

> **Оконная система** — иерархическая. Окна вложены друг в друга, события пробрасываются по дереву.
>
> **Qt** = **фреймворк** (не просто библиотека) для кросс-платформенных GUI.
> Произносится как **«cute»** ("милый"), хотя в России часто говорят «Кью-Ти».

## Иерархия окон

```text
Screen (root)
└── Window (program A)
│   ├── Toolbar
│   │   └── Button "Save"
│   └── Editor area
│       ├── ScrollBar
│       └── TextWidget
└── Window (program B)
    └── ...
```

### Свойства иерархии

| Свойство              | Эффект                                                 |
|-----------------------|--------------------------------------------------------|
| Перетаскивание parent | Все children двигаются вместе                          |
| Видимость             | Children **не видны** за границами parent → ScrollBars |
| События               | Передаются вниз по дереву (parent → children)          |
| Фокус                 | Только один widget активен в каждый момент             |

> Это позволяет писать **обобщённые** обработчики (parent ловит, если child не обработал).

## Qt — больше чем библиотека

| Что               | Что это значит                                        |
|-------------------|-------------------------------------------------------|
| Library           | Просто набор функций/классов/типов                    |
| **Framework**     | Library + tools + IDE + design philosophy + ecosystem |

> Qt = **Framework**. Включает не только код, но и инструменты, инфраструктуру, своё IDE, свой язык (QML).

## Возможности Qt

- **GUI**: главное назначение
- **Networking**: свои сокеты / HTTP / WebSocket
- **Threading**: своя многопоточность (`QThread`)
- **Database**: SQL абстракции
- **JSON / XML**: парсеры
- **Multimedia**: видео/аудио
- **Cross-platform**: Windows / Linux / macOS / iOS / Android / embedded

## Лицензии Qt

> **Disclaimer:** информация ознакомительная, не юридическая консультация.

| Лицензия            | Что разрешает                                                              | Когда выбирать                  |
|---------------------|----------------------------------------------------------------------------|---------------------------------|
| Commercial          | Полный доступ, изменение Qt без публикации, поддержка от Qt Company        | Enterprise, закрытый код        |
| GPL                 | Можно использовать, но изменения Qt **должны** быть опубликованы           | Open-source проекты с GPL       |
| LGPL v3             | Только основные компоненты (без 3D, charts, animations); линковка ОК       | Open-source / некоммерческий    |

### LGPL v3 ограничения

Не входит в LGPL версию (требует commercial):
- Charts / графики
- 3D-визуализация
- Animations по ключевым кадрам
- Ряд специализированных модулей

> Большинству **не-enterprise** проектов LGPL **достаточно**.

## Компоненты фреймворка

### Qt Creator (IDE)

> Интегрированная среда разработки от Qt Company, аналог CLion для Qt-проектов.

- Редактирование кода
- Сборка проекта
- Отладка
- **Qt Designer** интеграция (визуальный редактор интерфейсов)

### Qt Designer (WYSIWYG-редактор интерфейсов)

> **WYSIWYG** = "What You See Is What You Get"

- Drag-and-drop компонентов на холст
- Визуальная компоновка кнопок, полей, layouts
- Сохранение в `.ui` файлы (XML)
- Использовать **необязательно** — можно писать UI прямо в коде

### Qt QML (declarative language)

> **QML** = свой декларативный язык, похож на **JSON** + JavaScript.

```qml
Rectangle {
    width: 200
    height: 100
    color: "blue"
    Text {
        anchors.centerIn: parent
        text: "Hello"
    }
}
```

| Аналог HTML | QML                                       |
|-------------|-------------------------------------------|
| Tags        | Elements (Rectangle, Button, Text)        |
| CSS         | Properties прямо в элементе               |
| JavaScript  | Внутри QML — для логики (callbacks)       |
| DOM tree    | QML tree of elements                      |

> Иерархическая структура (matrёshka) — хорошо подходит для UI.

### Qt Widgets (классический C++ API)

> **Альтернатива QML** — создавать UI прямо из C++ кода.

```cpp
QPushButton* btn = new QPushButton("Click me");
QVBoxLayout* layout = new QVBoxLayout;
layout->addWidget(btn);
```

- Кнопки, чекбоксы, списки, таблицы
- Прямые C++ классы и методы
- Подходит для **desktop** приложений

### Qt GUI (низкоуровневая отрисовка)

> Базовый слой для **компонентов и виджетов**: растеризация, шрифты, кейспам ввод.

- Линии, прямоугольники, фигуры
- Шрифты, текст
- Координация с framebuffer
- Обработка raw input events

### Qt Core (фундамент)

> «Стандартная библиотека Qt». Не зависит от GUI.

- **Контейнеры:** `QString`, `QList`, `QMap`, `QHash`
- **Threading:** `QThread`, `QMutex`, `QFuture`
- **Events:** signal/slot mechanism
- **I/O:** `QFile`, `QDir`
- **Time:** `QTimer`, `QDateTime`

> Можно использовать **только** Qt Core (без GUI) — для headless приложений.

## Иерархия модулей

```text
Qt Creator       (IDE для разработки)
    └── uses
Qt Widgets       (high-level UI)         Qt QML        (declarative UI)
    └── built on                              └── built on
Qt GUI           (низкоуровневый рендер + input)
    └── built on
Qt Core          (контейнеры, threads, events)
```

## Зачем Qt дублирует STL

Вопрос: «Почему `QString`, `QList`, если есть `std::string`, `std::vector`?»

| Причина                          | Объяснение                                      |
|----------------------------------|-------------------------------------------------|
| Cross-platform консистентность   | Свой контейнер ведёт себя одинаково везде       |
| Интеграция с Qt event system     | `QString` нативно работает с QML / signals      |
| Implicit sharing (copy-on-write) | `QString` копируется быстро (refcount)          |
| Unicode-first                    | `QString` — UTF-16 встроен, `std::string` сырой |
| Историческая инерция             | До C++11/17 STL не имел многих фич              |

> **Best practice в Qt-проекте**: использовать `Q*` аналоги. Можно `std::*`, но возможны несовместимости.

## Кросс-платформенность

```text
Application code (один и тот же)
        │
        ▼
Qt API (QPushButton, QString, QFile, ...)
        │
        ├── Windows backend  (Win32, GDI)
        ├── macOS backend    (Cocoa, Core Graphics)
        ├── Linux backend    (X11 / Wayland)
        ├── Android backend  (Java JNI)
        └── iOS backend      (UIKit)
```

> Один код → работает везде. **Qt сам** разбирается с платформой.

## Practical relevance для DevOps

- **Cross-platform desktop tools:** мониторинг, deployment helpers (admin GUIs)
- **Embedded:** Qt for Embedded Linux — кисок интерфейсы (industrial, automotive)
- **System utilities:** виртуальная клавиатура, control panels
- **Internal tooling:** GUI обёртки над CLI — для не-разработчиков
- **Альтернативы:** Electron (web-стек), wxWidgets, GTK

## Связь с другими модулями

- **M34.1 пиксели:** Qt GUI оперирует ими через QPainter
- **M34.2 event loop:** Qt event system через signal/slot
- **M28 threads:** Qt Concurrent + QThread
- **M22 std::map:** QMap + QHash
- **M34.4+ (next):** **установка** Qt + интеграция в CLion проект
