# Module 34.5 — Практическая работа (homework)

**Status:** code готов, 13/13 tests pass, **submission не требуется** (по заданию)
**Спецификация:** см. `../../docs/lessons/M34/L5_HWORK.md`
**Solved:** 1/1 mandatory

## Структура

```text
Module34Hwork/
├── README.md, test_all.sh
└── Task1_QtSetup/          # CMake + minimal Qt5 widgets app
    ├── CMakeLists.txt
    ├── src/main.cpp
    └── test.sh
```

## Tasks summary

### Task 1 — Установка и настройка Qt

| Параметр  | Значение                                                                        |
|-----------|---------------------------------------------------------------------------------|
| Версия Qt | 5.15.2 (gcc_64) — последний минорный 5.x                                        |
| Установка | aqtinstall в venv: `aqt install-qt linux desktop 5.15.2 gcc_64 --outputdir ...` |
| Размер    | ~593 MB (минимальная installation, не 60 GB)                                    |
| App       | QApplication + QWidget + QLabel + QPushButton в QVBoxLayout                     |
| CI mode   | --no-loop флаг для проверки без display (offscreen platform)                    |
| Tests     | 13 (configure / build / binary / automoc / smoke / qversion / API checks)       |
| Status    | [+] PASS                                                                        |

## Toolchain (sandbox)

| Компонент       | Путь / способ                                                 |
|-----------------|---------------------------------------------------------------|
| Qt5 5.15.2      | `~/.local/qt5/5.15.2/gcc_64` (через aqt в `~/.local/qt-venv`) |
| GL/gl.h stub    | `~/.local/include/GL/gl.h` (1-line stub для cmake-чека)       |
| QT5_PREFIX      | env var указывает на Qt root (см. CMakeLists.txt)             |
| QT_QPA_PLATFORM | `offscreen` для запуска без X11/Wayland                       |

### Установка с нуля

```bash
# 1. aqtinstall в venv (без sudo)
python3 -m venv ~/.local/qt-venv
~/.local/qt-venv/bin/pip install aqtinstall

# 2. Скачать минимальный Qt5 base (~600 MB)
~/.local/qt-venv/bin/aqt install-qt linux desktop 5.15.2 gcc_64 \
    --outputdir ~/.local/qt5

# 3. Stub GL header (для cmake configure без libgl-dev)
mkdir -p ~/.local/include/GL && touch ~/.local/include/GL/gl.h

# 4. Test build
export QT5_PREFIX=$HOME/.local/qt5/5.15.2/gcc_64
export QT5_GL_INCLUDE_DIR=$HOME/.local/include
export LD_LIBRARY_PATH=$QT5_PREFIX/lib:${LD_LIBRARY_PATH:-}
export QT_QPA_PLATFORM=offscreen
./test_all.sh
```

## Submission

> Per spec: **отправлять задание на проверку не требуется**.
> Достаточно настроить фреймворк и проверить успешную сборку.

## Notes

- В видео курса упоминается «60 GB места» — это для **полного** online-installer (все платформы / docs / examples). **Минимальная** установка под одну платформу — ~600 MB.
- В sandbox без `sudo` использовали **aqtinstall** (Python tool в venv) вместо apt.
- `CMAKE_AUTOMOC=ON` обязателен — Qt использует препроцессорный шаг `moc` для signals/slots.
- Run-time нужен либо display, либо `QT_QPA_PLATFORM=offscreen`. Тесты используют offscreen + `--no-loop`.
- Stub `GL/gl.h` пустой — наш widgets-only код OpenGL не использует, но Qt5GuiConfigExtras проверяет наличие хедера в configure-time.
