# M35.5 — Работа с файловой системой (std::filesystem, C++17)

**Длительность:** ~10 минут
**Тема:** `<filesystem>`, `path`, `exists`, `is_regular_file`, `space`, symlinks

## Главная идея

> До **C++17** в стандарте были только **файловые потоки** (`fstream`), но
> **не было** работы с самими файлами/каталогами. C++17 добавил
> **`std::filesystem`** — кросс-платформенный API.
>
> До этого приходилось использовать **Boost** или **Qt** или вызовы ОС напрямую.

## Зачем filesystem отдельный

Каждая ОС хранит пути по-своему:

| Платформа  | Разделитель путей | Структура                | Кодировка |
|------------|-------------------|--------------------------|-----------|
| Windows    | `\` (backslash)   | Отдельные диски (C:, D:) | UTF-16    |
| Linux/Unix | `/` (forward)     | Единое дерево от `/`     | UTF-8     |
| macOS      | `/`               | Единое дерево            | UTF-8     |

> Разные ограничения на длину пути. Разные специальные символы.

> До C++17: **все** эти отличия — на программисте. Cross-platform требовал макросов или Boost.

## Подключение

```cpp
#include <filesystem>

namespace fs = std::filesystem;
```

> Header без `.h` (как в modern C++). Часто делают `namespace fs = std::filesystem;` для краткости.

## std::filesystem::path — главный класс

### Создание

```cpp
fs::path p("/home/user/file.txt");        // Linux
fs::path p2("C:\\Users\\Public\\f.txt");  // Windows (escape \\)
fs::path p3 = R"(C:\Users\Public\f.txt)"; // Raw string, не нужно escape
```

### Доступ к компонентам

```cpp
fs::path p("/home/user/file.txt");

p.filename();       // file.txt
p.stem();           // file
p.extension();      // .txt
p.parent_path();    // /home/user
p.root_path();      // /
```

### path как контейнер с iterators

```cpp
for (auto& part : p) {
    std::cout << part << " ";
}
// Output: / home user file.txt
```

> У `path` есть `begin()` / `end()` — каждая итерация даёт **компонент пути** (имя каталога / файла).

## Готовые функции пространства filesystem

### exists / is_regular_file / is_directory

```cpp
fs::path p("/home/user/file.txt");

if (fs::exists(p)) {
    if (fs::is_regular_file(p)) {
        std::cout << "Regular file\n";
    } else if (fs::is_directory(p)) {
        std::cout << "Directory\n";
    }
}
```

> До C++17 — нужны были `stat()` (Unix), `GetFileAttributes` (Windows) с `#ifdef`.

### Размер файла и свободное место

```cpp
auto size = fs::file_size(p);          // размер файла в байтах

fs::space_info info = fs::space(p);
std::cout << "Capacity:  " << info.capacity  << "\n";
std::cout << "Free:      " << info.free      << "\n";
std::cout << "Available: " << info.available << "\n";
```

| Поле `space_info` | Что значит                                  |
|-------------------|---------------------------------------------|
| `capacity`        | Полная ёмкость диска                        |
| `free`            | Свободное место (физически)                 |
| `available`       | Доступно непривилегированному процессу      |

### Создание / удаление

```cpp
fs::create_directory("new_dir");           // создать каталог
fs::create_directories("a/b/c");           // создать с родителями
fs::remove("file.txt");                    // удалить файл / пустой каталог
fs::remove_all("dir_with_content");        // удалить рекурсивно
fs::rename("old.txt", "new.txt");          // переименовать
fs::copy("src.txt", "dst.txt");            // скопировать
```

### Symlinks (символические ссылки)

```cpp
fs::create_symlink("/path/to/big_file", "shortcut");        // soft link
fs::create_hard_link("/path/to/file", "another_name");      // hard link
fs::create_directory_symlink("/path/to/dir", "dir_alias"); // dir symlink
```

> **Symlink** = файл-ярлык, маленький, ссылается на оригинал.
> **Hard link** = ещё одна запись в таблице файловой системы для того же inode.

> На **Windows** symlinks требуют admin прав или Developer Mode.

### Итерация по каталогу

```cpp
for (const auto& entry : fs::directory_iterator("/home/user")) {
    std::cout << entry.path() << "\n";
}

// Рекурсивно:
for (const auto& entry : fs::recursive_directory_iterator("/home/user")) {
    std::cout << entry.path() << " (" << entry.file_size() << ")\n";
}
```

## Альтернативы до C++17

| Альтернатива           | Особенности                                 |
|------------------------|---------------------------------------------|
| **Boost.Filesystem**   | Тот же API, был прообразом std::            |
| **Qt::QFile** + QDir   | Cross-platform от Qt                        |
| **POSIX api** + WinAPI | Прямые вызовы ОС, нужен `#ifdef`            |
| **C stdio** (`fopen`)  | Самые базовые операции (не каталоги)        |

> Поэтому важна цитата урока:
> «**Стало неприлично** не иметь в 2017 году таких базовых возможностей.»

## Особенность modern C++

> «Не столько новшеств **языка**, сколько новшеств **стандартной библиотеки**.»

Сравнение с Python:

| Подход            | Python                  | C++ до C++17           | C++ с C++17              |
|-------------------|-------------------------|------------------------|--------------------------|
| Слоган            | "Batteries Included"    | DIY / сторонние либы   | Догоняет Python          |
| Файлы             | `os`, `pathlib`         | Boost / Qt             | `<filesystem>`           |
| JSON              | `json`                  | nlohmann (3rd party)   | (не в std до сих пор)    |
| Networking        | `socket`, `urllib`      | Boost.Asio, libcurl    | Networking TS (не в std) |
| Threads           | `threading`             | Boost.Thread           | `<thread>` C++11         |
| Optional          | `Optional` (typing)     | Boost.Optional         | `std::optional` C++17    |
| Filesystem        | `pathlib` (3.4+)        | -                      | `std::filesystem`        |

> Modern C++ всё больше **догоняет** Python по «батарейкам в коробке», но в **типизированном** виде.

## Полный пример

```cpp
#include <filesystem>
#include <iostream>

namespace fs = std::filesystem;

int main() {
    fs::path p = "/home/user/data";

    if (!fs::exists(p)) {
        fs::create_directories(p);
        std::cout << "Created " << p << "\n";
    }

    auto info = fs::space(p);
    std::cout << "Free space: " << info.available / (1024*1024) << " MB\n";

    for (const auto& entry : fs::directory_iterator(p)) {
        if (fs::is_regular_file(entry)) {
            std::cout << entry.path().filename()
                      << " " << fs::file_size(entry) << "\n";
        }
    }
    return 0;
}
```

## Practical relevance для DevOps

- **Build systems:** заменить shell-скрипты на C++ инструменты
- **Log rotation:** список файлов, размеры, удаление старых — без shell
- **Config discovery:** обход каталогов поиск `.yaml` / `.json`
- **Disk space monitoring:** `fs::space()` для мониторинга
- **Cleanup utilities:** `fs::remove_all` для temp каталогов
- **Cross-platform tools:** один код для Linux / Windows / macOS

## Подводные камни

### 1. Linker flag (старые GCC)

GCC < 9 требует `-lstdc++fs`:

```cmake
target_link_libraries(my_app PRIVATE stdc++fs)
```

С GCC 9+ — встроено в стандартную lib.

### 2. Исключения

Большинство функций имеют **2 версии**: бросает исключение или принимает `error_code`:

```cpp
auto size = fs::file_size(p);                   // throws on error
std::error_code ec;
auto size = fs::file_size(p, ec);               // ec будет non-zero на ошибке
```

> В hot path / library code лучше **error_code** — без exception overhead.

### 3. Symbolic vs canonical paths

```cpp
fs::path p = "../foo/./bar/";
fs::canonical(p);    // приводит к абсолютному, без `..`, `.`
fs::weakly_canonical(p);  // если путь не существует
```

## Заключение модуля M35

> Modern C++ — это в основном **новшества стандартной библиотеки**. Язык меняется не так сильно, как объём встроенных «батареек».
>
> Раньше критика: «у Python всё в коробке, у C++ ничего». Теперь это меняется.

## Связь с другими модулями

- **M19 / M20 file I/O:** `fstream` + `<filesystem>` = полный стек работы с файлами
- **M22 std::map:** `std::filesystem` использует `path` как ключи
- **M30 CPR / M32 nlohmann:** альтернативы стандарту, до того как фичи попадут в std
- **DevOps best practice:** знать оба пути — std (cross-platform) и POSIX (Unix-specific)
