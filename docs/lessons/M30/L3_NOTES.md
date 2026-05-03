# M30.3 — Запросы с телом (POST)

**Длительность:** ~6 минут
**Тема:** `cpr::Post`, `cpr::Payload` для тела запроса, формы

## Главная идея

> **POST** — отправляет данные на сервер в теле запроса.
> `cpr::Payload{{key, value}, ...}` — payload в стиле формы (key=value пары).

## HTTP методы (методы запросов)

| Метод     | Назначение                               | Тело?  |
|-----------|------------------------------------------|--------|
| `GET`     | Получить ресурс                          | Нет    |
| `POST`    | Создать ресурс / отправить данные        | Да     |
| `PUT`     | Заменить ресурс целиком                  | Да     |
| `PATCH`   | Частично обновить ресурс                 | Да     |
| `DELETE`  | Удалить ресурс                           | Иногда |
| `HEAD`    | Только заголовки (без body ответа)       | Нет    |
| `OPTIONS` | Какие методы поддерживаются              | Нет    |

> **REST API** обычно использует все 4 основных: GET/POST/PUT/DELETE.

## Контекст: формы на сайтах

При оформлении заказа в онлайн-магазине:
1. Пользователь заполняет поля (имя, адрес)
2. Жмёт «Заказать»
3. Браузер собирает данные в **form-encoded** body
4. Отправляет POST на сервер
5. Сервер парсит и записывает в БД

## Базовый POST через CPR

```cpp
#include <cpr/cpr.h>
#include <iostream>
#include <string>

int main() {
    std::string name, city;
    std::cin >> name >> city;

    cpr::Response r = cpr::Post(
        cpr::Url{"http://httpbin.org/post"},
        cpr::Payload{
            {"name", name.c_str()},   // ← .c_str() обязательно (CPR требует C-string)
            {"city", city.c_str()}
        }
    );

    std::cout << "Status: " << r.status_code << "\n";
    std::cout << "Body:   " << r.text;
}
```

## КРИТИЧЕСКИ ВАЖНО: c_str()

`cpr::Payload` требует **C-string** (`const char*`), не `std::string`:

```cpp
std::string name = "Alice";
cpr::Payload{{"name", name}};         // COMPILE ERROR
cpr::Payload{{"name", name.c_str()}}; // OK
```

## Что отправляется в HTTP

POST-запрос с `Payload{{"name","Alice"},{"city","Moscow"}}` будет:

```text
POST /post HTTP/1.1
Host: httpbin.org
Content-Type: application/x-www-form-urlencoded
Content-Length: 22

name=Alice&city=Moscow
```

`form-encoded` — формат: `key1=value1&key2=value2`, спецсимволы URL-encoded.

## httpbin.org/post — что вернёт

JSON ответ с эхом:

```json
{
  "args": {},
  "data": "",
  "files": {},
  "form": {
    "name": "Alice",
    "city": "Moscow"
  },
  "headers": {...},
  ...
}
```

> Поле `form` содержит наши данные.

## Безопасность: HTTP без TLS

> **Внимание:** при использовании HTTP (а не HTTPS) данные передаются
> **в открытом виде**. Любой между клиентом и сервером может их прочитать —
> **man-in-the-middle attack**.

В production:
- Всегда HTTPS (`https://`)
- CPR с настройкой `CPR_USE_SYSTEM_CURL=ON` или `CMAKE_USE_OPENSSL=ON`
- Валидация TLS-сертификата

В курсе HTTP — иллюстрация. **Не делайте так в production.**

## Альтернативы Payload

### Multipart (для файлов)

```cpp
cpr::Multipart{
    {"name", "Alice"},
    {"avatar", cpr::File{"/path/to/photo.png"}}
}
```

### Body (произвольный raw payload, например JSON)

```cpp
cpr::Post(
    cpr::Url{"http://example.com/api"},
    cpr::Body{R"({"key":"value"})"},
    cpr::Header{{"Content-Type","application/json"}}
)
```

## Полный пример: корзина онлайн-магазина

```cpp
#include <cpr/cpr.h>
#include <iostream>

int main() {
    std::string name, city, email;
    std::cerr << "Имя: ";    std::cin >> name;
    std::cerr << "Город: ";  std::cin >> city;
    std::cerr << "Email: ";  std::cin >> email;

    auto r = cpr::Post(
        cpr::Url{"http://httpbin.org/post"},
        cpr::Payload{
            {"name",  name.c_str()},
            {"city",  city.c_str()},
            {"email", email.c_str()}
        }
    );

    if (r.status_code == 200) {
        std::cout << "OK!\n" << r.text;
    } else {
        std::cerr << "Error: " << r.status_code << "\n";
    }
}
```

## Practical relevance для DevOps

- **Webhooks:** POST к Slack/Telegram/PagerDuty с JSON payload
- **REST API создание:** POST `/users` создаёт нового пользователя
- **Form submission:** автоматизация заполнения форм
- **CI integrations:** триггеринг Jenkins/CircleCI через POST
- **Telemetry/metrics:** отправка батчей в Prometheus/Datadog

## Связь с другими модулями

- **M30.1, M30.2:** настройка CPR + GET-запросы
- **M30.4 hwork:** наверняка комбинирование GET + POST с реальным API
- **DevOps:** REST API сервисы — основа современной интеграции
