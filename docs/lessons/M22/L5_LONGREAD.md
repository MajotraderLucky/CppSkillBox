# M22.5 — Операции с map (longread, не видео)

**Тип:** текстовый урок (longread)
**Тема:** три способа поиска в map (`find`, `at`, `[]`) и их подводные камни

## Что узнаете

> Как осуществлять поиск значений в map и какие ошибки можно при этом совершить.

## 3 способа доступа по ключу

```cpp
std::map<std::string, int> dict;
dict.insert({"Hello", 1});

// 1) find — возвращает итератор
dict.find("Hello");

// 2) at — возвращает значение по ссылке (бросает out_of_range)
dict.at("Hello");

// 3) [] — оператор доступа (создаёт элемент если ключа нет!)
dict["Hello"];
```

## Способ 1: find

**Возвращает:** итератор (или `end()` если не найдено).

```cpp
std::map<std::string, std::string> dict;
dict.insert({"First", "One"});

if (dict.find("First") != dict.end()) {
    std::cout << "Key = "   << dict.find("First")->first  << "\n";
    std::cout << "Value = " << dict.find("First")->second << "\n";
}
```

**Свойства:**
- НЕ модифицирует map
- Безопасно для проверки существования
- Доступ через `->first` / `->second`

## Способ 2: at

**Возвращает:** ссылку на значение. Бросает `std::out_of_range` если ключа нет.

```cpp
std::map<std::string, int> dict;
dict.insert({"Hello", 1});

std::cout << dict.at("world");   // CRASH! out_of_range exception
```

### Защита через count

`count(key)` возвращает количество элементов с этим ключом (для map: 0 или 1).

```cpp
if (dict.count("world") > 0) {
    std::cout << dict.at("world");
}
```

**Заметка:** для `multimap` count может быть >1 (там разрешены дубликаты ключей).

## Способ 3: оператор []

**Возвращает:** ссылку на значение.
**Опасность:** если ключа НЕТ — **создаёт** новую запись с дефолтным value!

```cpp
std::map<std::string, int> dict;
dict.insert({"Hello", 1});

std::cout << dict["world"];   // выведет 0 (создалась запись world → 0)
```

### Дефолтные значения для разных типов

| Тип значения      | Дефолт              |
|-------------------|---------------------|
| `int`, `double`   | 0                   |
| `std::string`     | "" (пустая)         |
| `bool`            | false               |
| указатель         | nullptr             |
| struct/class      | default-конструктор |

### Запись через []

```cpp
dict["First"] = "One";   // создать или обновить
```

## ОПАСНОСТЬ: проверка через [] в условии

```cpp
std::map<std::string, std::string> dict;

if (dict["First"] == "one") {                 // ← проверяет, но и СОЗДАЁТ!
    std::cout << "Record found\n";
}

std::cout << dict.count("First");              // 1, а не 0!
```

**Что произошло:** условие `dict["First"]` создало запись `"First" → ""`,
сравнение `"" == "one"` дало false, но **запись осталась**.

### Правильно

```cpp
if (auto it = dict.find("First"); it != dict.end() && it->second == "one") {
    std::cout << "Record found\n";
}
// Или через count перед at:
if (dict.count("First") > 0 && dict.at("First") == "one") {
    std::cout << "Record found\n";
}
```

## Сравнительная таблица

| Метод           | Если ключа нет        | Возвращает         | Модифицирует map? |
|-----------------|-----------------------|--------------------|-------------------|
| `find(k)`       | возвращает `end()`    | iterator           | нет               |
| `at(k)`         | бросает out_of_range  | reference to value | нет               |
| `m[k]` (read)   | создаёт `K → V{}`     | reference to value | **ДА**            |
| `m[k] = v`      | создаёт `K → v`       | reference to value | да (намеренно)    |
| `count(k)`      | 0                     | size_t (0 или 1)   | нет               |

## Когда что использовать

| Задача                                    | Метод                                     |
|-------------------------------------------|-------------------------------------------|
| Просто проверить наличие ключа            | `count(k) > 0` или `find != end()`        |
| Получить value, точно знаем что ключ есть | `at(k)` или `m[k]`                        |
| Получить итератор для erase               | `find(k)`                                 |
| Создать или обновить запись               | `m[k] = v` или `insert_or_assign` (C++17) |
| Вставить только если нет                  | `insert({k, v})`                          |
| Безопасно прочитать с дефолтом            | `find` + проверка                         |

## Practical relevance для DevOps

- **Counter (логи событий):** `++m[event_type]` — `[]` намеренно создаёт `0`
- **Config lookup:** `if (auto it = cfg.find("port"); it != cfg.end())` — без побочных эффектов
- **Cache invalidation bug:** случайный `m[key]` в read-path растит map бесконечно
- **at() для production assert:** «этот ключ ОБЯЗАН быть» — лучше упасть чем работать с мусором

## Внешние ссылки

- <https://ru.cppreference.com/w/cpp/container/map>
- <https://en.cppreference.com/w/cpp/container/map>

## Связь с другими модулями

- **M22.1-4:** теперь полная картина API map
- **M22.6 hwork:** практика find/at/`[]`/count
- **«Использование исключений»** (далее в курсе): обработка `out_of_range`
- **C++17 `insert_or_assign`:** более явная версия `m[k] = v`
