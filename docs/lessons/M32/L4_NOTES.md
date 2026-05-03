# M32.4 — Знакомство с Protocol Buffers (protobuf)

**Длительность:** ~10 минут
**Тема:** schema-based **бинарная** сериализация, `.proto` IDL, `protoc` компилятор

## Главная идея

> **Protocol Buffers** (от Google) = **schema-first** формат сериализации:
> описываешь структуру в `.proto` файле → `protoc` генерирует код для C++ /
> Java / Python / ... → используешь типизированные классы.
>
> JSON = текстовый, человекочитаемый. Protobuf = **бинарный**, компактный, типизированный.

## Зачем protobuf, если есть JSON

Проблема JSON-сериализации в C++:
- Куча `j["field"] = value;` — повторяющийся код
- C++ **не имеет рефлексии** → не может сам перечислить поля класса
- Неявные конверсии типов → ошибки в runtime
- Текст → большой объём, медленный парсинг

> **Идея:** описать структуру **снаружи** (в `.proto` файле), а код генерации сериализации — пусть генерируется автоматически.

## Технология

| Компонент       | Назначение                                               |
|-----------------|----------------------------------------------------------|
| `.proto`        | IDL-файл, описывает схему сообщения                      |
| `protoc`        | Компилятор: `.proto` → `.cc` + `.h` (или другой язык)    |
| `libprotobuf`   | Runtime-библиотека (необходима для генерированного кода) |

> **Важно:** в этом уроке изучаем **только** компилятор и синтаксис `.proto`. Подключение `libprotobuf` к CLion проекту слишком сложно — оставлено за рамками курса.

## Установка

### protoc compiler

1. https://protobuf.dev/ → Downloads
2. Раздел Releases → протокомпилятор для своей платформы
3. Под Windows 64-бит → пакет `protoc-XX.X-win64.zip`
4. Распаковать в директорию проекта (или в PATH)

> Под Linux/macOS обычно ставится через пакетный менеджер: `apt install protobuf-compiler` или `brew install protobuf`.

### Плагин CLion (опционально)

`Settings → Plugins → "Protocol Buffers"` — даёт подсветку синтаксиса для `.proto` файлов.

## Синтаксис .proto

### Минимальный пример

```proto
syntax = "proto2";

message Record {
    required string name   = 1;
    required string family = 2;
    required int32  age    = 3;
    optional bool   merit  = 4;
}
```

### Разбор по строчкам

| Элемент                 | Значение                                                      |
|-------------------------|---------------------------------------------------------------|
| `syntax = "proto2";`    | Версия спецификации (есть и proto3, тут — 2)                  |
| `message Record {...}`  | Описание структуры. `message` = ключевое слово                |
| `required` / `optional` | **Обязательность** поля при десериализации                    |
| `string`, `int32`       | Типы полей (см. таблицу ниже)                                 |
| `= 1`, `= 2`, ...       | **Уникальный идентификатор поля** (НЕ значение по умолчанию!) |

### Ключевые отличия от C / C++

> `message` похоже на `struct` — но **синтаксис другой**. Это самостоятельный язык (proto), не C++.

#### required vs optional

| Спецификатор | При десериализации, если поля нет |
|--------------|-----------------------------------|
| `required`   | **Ошибка** парсинга               |
| `optional`   | Тихо, поле просто не установлено  |

> **Note:** в proto3 `required` убрали — все поля по умолчанию optional. В proto2 — оба варианта.

#### Численные типы (бинарные размеры)

| `.proto`    | C++              | Размер              |
|-------------|------------------|---------------------|
| `int32`     | `int32_t`        | 32 бит, varint      |
| `int64`     | `int64_t`        | 64 бит, varint      |
| `uint32`    | `uint32_t`       | 32 бит, unsigned    |
| `float`     | `float`          | 32 бит IEEE754      |
| `double`    | `double`         | 64 бит IEEE754      |
| `bool`      | `bool`           | 1 бит               |
| `string`    | `std::string`    | UTF-8               |
| `bytes`     | `std::string`    | сырые байты         |

> **Почему бинарные размеры в типе:** формат хранения protobuf **бинарный** → сериализатор должен знать ширину поля.

#### Идентификатор `= N`

```proto
required int32 age = 3;
//                  ^
//                  идентификатор, НЕ значение
```

- Уникален в пределах message
- **Никогда** не должен меняться после публикации схемы
- Используется в бинарном формате как **тег** поля
- Изменение → **поломанная** обратная совместимость

> Это — основа версионирования protobuf. Можно добавлять новые поля с новыми номерами, и старые клиенты их просто проигнорируют.

## Компиляция .proto → .cc / .h

```bash
protoc --cpp_out=. record.proto
```

Аргументы:
- `--cpp_out=.` — генерировать C++ в **текущую директорию** (`.` = pwd)
- `record.proto` — входной файл

### Что появляется

```text
record.proto       ← input
record.pb.h        ← header — class Record, getters/setters, ctor, op=
record.pb.cc       ← source — реализация
```

> Расширение `.cc` — альтернатива `.cpp` (Google convention).

### Что внутри generated `Record` класса

```cpp
class Record {
public:
    Record();                              // default ctor
    Record(const Record&);                 // copy ctor
    Record& operator=(const Record&);      // op=

    // Getters / setters для каждого поля:
    const std::string& name() const;
    void set_name(const std::string& v);
    int32_t age() const;
    void set_age(int32_t v);
    // ... + has_field, clear_field
    // ... + методы сериализации/парсинга
};
```

> Для **использования** генерированного кода нужно слинковать `libprotobuf` — но это уже задача проекта.

## Сравнение JSON vs Protobuf

| Аспект              | JSON (nlohmann)        | Protocol Buffers         |
|---------------------|------------------------|--------------------------|
| Schema              | Optional (free-form)   | **Обязательна** (.proto) |
| Формат              | Текст (UTF-8)          | **Бинарный**             |
| Размер              | Большой                | Маленький (компакт)      |
| Скорость            | Средняя                | Высокая                  |
| Human-readable      | Да                     | Нет                      |
| Версионирование     | Manual                 | Built-in (field IDs)     |
| Язык                | Любой со своей либой   | Polyglot (одна `.proto`) |
| Изучить             | Минут 10               | Часы                     |
| Где применяется     | API, конфиги, web      | gRPC, internal, метрики  |

## Workflow protobuf

```text
1. Описать .proto
2. protoc --cpp_out=... my.proto
3. Сгенерированные .pb.h/.pb.cc → в проект
4. Линковать с libprotobuf
5. Использовать generated класс с типизированным API
```

### Когда выбирать protobuf

- **Internal RPC** между сервисами (gRPC уже использует protobuf)
- **High throughput / low latency** систем (биржи, gaming, ad-tech)
- **Cross-language** контракты (C++ ↔ Go ↔ Python без переписывания)
- **Strict schema** требования (compile-time проверка типов)

### Когда выбирать JSON

- **Public API** для сторонних разработчиков
- **Конфиги**, которые нужно редактировать руками
- **Логи** для grep / jq / observability tools
- **Прототипирование**, эксперименты

## Practical relevance для DevOps

- **gRPC:** протокол на основе protobuf, стандарт для микросервисов в Google/Meta/Uber
- **Kubernetes API:** под капотом — protobuf (хотя пользователь видит YAML)
- **etcd / consul:** internal RPC через protobuf
- **OpenTelemetry:** один из стандартных wire-форматов — protobuf
- **Service mesh:** Envoy конфигурация — proto-based
- **Schema evolution:** field IDs гарантируют forward/backward compatibility

## Альтернативы protobuf

| Формат        | Особенность                          |
|---------------|--------------------------------------|
| FlatBuffers   | Zero-copy чтение (Google, gaming)    |
| Cap'n Proto   | Похож на FB, разработчик ex-Google   |
| MessagePack   | Бинарный JSON                        |
| Apache Avro   | Schema evolution, Hadoop ecosystem   |
| Apache Thrift | Facebook аналог protobuf             |

## Связь с другими модулями

- **M27 классы:** generated класс — обычный C++ class
- **M32.1-3 JSON:** альтернативный, текстовый подход
- **DevOps стек:** protobuf — фундамент modern microservices (gRPC, k8s, telemetry)
- **M32.5 (next):** скорее всего практическая работа модуля
