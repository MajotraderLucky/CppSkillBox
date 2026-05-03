# M30.2 — Запросы и их заголовки

**Длительность:** ~16 минут
**Тема:** GET-запросы через `cpr::Get`, `cpr::Response`, заголовки запроса (`cpr::Header`)

## Главная идея

> `cpr::Get(cpr::Url{...})` → `cpr::Response{status_code, text, ...}`.
> **Заголовки** через `cpr::Header{{key, value}, ...}` — модификация поведения сервера.

## httpbin.org — тестовая площадка

> **httpbin.org** — публичный API для тестирования HTTP-клиентов.
> Endpoints возвращают информацию о запросе.

| URL                  | Что возвращает                           |
|----------------------|------------------------------------------|
| `/get`               | данные GET-запроса                       |
| `/post`              | данные POST-запроса                      |
| `/headers`           | переданные клиентом заголовки            |
| `/status/<code>`     | возвращает указанный HTTP-код            |
| `/delay/<n>`         | задержка n секунд (тест timeout)         |

## Базовый GET-запрос

```cpp
#include <cpr/cpr.h>
#include <iostream>

int main() {
    cpr::Response r = cpr::Get(cpr::Url{"http://httpbin.org/get"});
    std::cout << "Status: " << r.status_code << "\n";
    std::cout << "Body: "   << r.text;
}
```

## cpr::Response — что внутри

| Поле               | Тип               | Назначение                      |
|--------------------|-------------------|---------------------------------|
| `status_code`      | `long`            | HTTP код (200, 404, 500, ...)   |
| `text`             | `std::string`     | Тело ответа                     |
| `header`           | `cpr::Header`     | Заголовки ответа                |
| `url`              | `cpr::Url`        | Финальный URL (после redirects) |
| `elapsed`          | `double`          | Время в секундах                |
| `error`            | `cpr::Error`      | Ошибка если была                |

## HTTP коды статуса

| Код | Категория         | Пример                              |
|-----|-------------------|-------------------------------------|
| 1xx | Информационный    | 100 Continue                        |
| 2xx | Успех             | 200 OK, 201 Created                 |
| 3xx | Перенаправление   | 301 Moved, 302 Found                |
| 4xx | Ошибка клиента    | 404 Not Found, 401 Unauthorized     |
| 5xx | Ошибка сервера    | 500 Internal Error, 503 Unavailable |

> **HTTP коды НЕ как exit-codes!** В HTTP **0 = нет ответа**, а `200 OK`.

## Заголовки HTTP

> **Заголовки** — пары ключ-значение, дающие контекст запроса/ответа.
> Не путать с заголовочными файлами C++!

**Не чувствительны к регистру:** `User-Agent` == `user-agent` == `USER-AGENT`.

### Часто используемые

| Заголовок          | Назначение                                    |
|--------------------|-----------------------------------------------|
| `User-Agent`       | Тип клиента (браузер, версия, ОС)             |
| `Accept`           | Какие типы контента клиент принимает          |
| `Accept-Language`  | Предпочитаемый язык ответа                    |
| `Authorization`    | Учётные данные / токен                        |
| `Content-Type`     | Тип тела запроса (для POST/PUT)               |
| `Cookie`           | HTTP-куки                                     |
| `Referer`          | С какой страницы пришли                       |

## Передача заголовков через CPR

```cpp
cpr::Response r = cpr::Get(
    cpr::Url{"http://httpbin.org/headers"},
    cpr::Header{
        {"User-Agent", "Mozilla/5.0 (X11; Linux x86_64) Chrome/120"},
        {"Accept",     "text/html"}
    }
);
std::cout << r.text;
```

## User-Agent: маскировка под браузер

По умолчанию CPR отправляет `User-Agent: curl/7.x.x` — сервер видит что это **программа**.

Можно подделать строку UA → сервер думает что это **браузер**:

```cpp
cpr::Header{
    {"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                   "AppleWebKit/537.36 (KHTML, like Gecko) "
                   "Chrome/120.0.0.0 Safari/537.36"}
}
```

> **Зачем:** некоторые сервисы блокируют curl/wget, но пропускают браузеры.

## Accept: что хотим получить

```cpp
cpr::Header{ {"Accept", "text/html"} }      // HTML-страница
cpr::Header{ {"Accept", "application/json"} } // JSON
cpr::Header{ {"Accept", "image/png"} }      // PNG-картинка
cpr::Header{ {"Accept", "*/*"} }            // что угодно (default curl)
```

### Типы (MIME)

| MIME               | Что           |
|--------------------|---------------|
| `text/html`        | HTML страница |
| `text/css`         | стили         |
| `text/plain`       | plain text    |
| `application/json` | JSON данные   |
| `application/xml`  | XML           |
| `image/png`        | PNG           |
| `image/jpeg`       | JPEG          |

Сервер может вернуть **разный** контент в зависимости от Accept.

## Полный пример с заголовками

```cpp
#include <cpr/cpr.h>
#include <iostream>

int main() {
    auto r = cpr::Get(
        cpr::Url{"http://httpbin.org/headers"},
        cpr::Header{
            {"User-Agent", "MyBot/1.0"},
            {"Accept",     "application/json"}
        }
    );

    if (r.status_code == 200) {
        std::cout << "OK!\n" << r.text;
    } else {
        std::cerr << "FAIL: " << r.status_code << "\n";
    }
}
```

## Practical relevance для DevOps

- **REST API consumption:** GET запросы к microservices
- **Маскировка под браузер:** скрейпинг сайтов с anti-bot защитой
- **Auth tokens:** `Authorization: Bearer <token>` — стандарт OAuth2
- **JSON APIs:** Accept + Content-Type для контракта с сервисом
- **Health checks:** простой GET + проверка status_code
- **Прокси/VPN:** через дополнительные заголовки `X-Forwarded-For`, `X-Real-IP`

## Связь с другими модулями

- **M30.1:** настройка CPR через CMake FetchContent
- **M30.3 (next):** наверняка POST + параметры
- **M30.5 hwork:** интеграция с реальным API (httpbin/JSONPlaceholder)
- **DevOps grammar:** HTTP API — основа большинства современных систем
