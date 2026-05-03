# M30.4 — Практическая работа (homework)

**Источник:** `https://go.skillbox.ru/.../homework/58611711-99d8-434b-b201-b2d8cf9a8ec2`
**Цели:** HTTP клиент через CPR — GET/POST/PUT/DELETE/PATCH, заголовки, аргументы

## Что входит

3 обязательные задачи

---

## 1. Пользовательские запросы

### Что нужно

CLI с командами **`get`/`post`/`put`/`delete`/`patch`/`exit`**.
Каждая команда → запрос соответствующего типа на `httpbin.org/<method>`.
Тело ответа сервера выводится в stdout.

### Подсказки

- `cpr::Get`, `cpr::Post`, `cpr::Put`, `cpr::Delete`, `cpr::Patch`
- URL всегда `http://httpbin.org/<method>`

---

## 2. Захват заголовка HTML-страницы

### Что нужно

1. Запрос на `http://httpbin.org/html` (sample HTML page)
2. Заголовок `Accept: text/html`
3. Из ответа найти текст между `<h1>` и `</h1>`
4. Вывести найденный заголовок

### Подсказки

- `r.text` — тело ответа как `std::string`
- `std::string::find(...)` для поиска подстрок
- pattern: `pos1 = text.find("<h1>"); pos2 = text.find("</h1>"); substr(pos1+4, pos2-pos1-4)`

---

## 3. Запросы с аргументами

### Что нужно

1. Пользователь вводит **пары** "название значение" (имя=значение)
2. До тех пор пока имя не равно `"post"` или `"get"` — это сигнал finish
3. Если **`post`** → отправить POST с аргументами как form
4. Если **`get`** → отправить GET с args в URL (`?key1=val1&key2=val2`)
5. Вывести ответ — поле `form` (POST) или `args` (GET)

### Подсказки

- Хранить аргументы в `std::map<std::string, std::string>`
- Для POST: `cpr::Payload(pairs.begin(), pairs.end())`, элементы `cpr::Pair{key, value}`
- Для GET: построить URL с параметрами вручную (`?key=val&key=val`)
- URL-encoding обычно делает CPR (но есть `cpr::Parameters` объект)

---

## Submission

- Replit deep-link или .cpp + CMakeLists.txt (нужен FetchContent CPR)
- Проверка отключена (content-first phase)

## Подход к тестированию

- Сложно тестировать без реального сетевого доступа к httpbin.org
- В тестах мы можем:
  - **Mock httpbin** — поднять локальный mock-сервер на стандартной библиотеке
  - **Skip network tests** — проверить только что program не крашится с `--help` или `q`
  - **Integration test** — реально стучаться в httpbin.org (если есть сеть)
- Пойдём по пути локального mock-сервера для CI-friendly тестов
