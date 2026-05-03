# M19.5 — Практическая работа

**URL:** `homework/700844e0-d809-4320-9de8-4c8e0e49e0b7`
**Status:** submission заблокирован

## 5 задач

### Задача 1 — Word search

Прочитать `words.txt`, посчитать сколько раз встречается заданное пользователем слово.

### Задача 2 — Text viewer

Принять путь к txt файлу, вывести его содержимое в stdout.
Подсказки: `is_open()`, `read()` chunk-wise, `gcount()`.

### Задача 3 — Ведомость по выплатам

Парсить строки `"Name Surname amount DD.MM.YYYY"`. Output: total + max recipient.

### Задача 4 — PNG detector

Чтение первых 4 байт. Валидный PNG: `[-119, 'P', 'N', 'G']`.
Также проверить расширение (`.png`).

### Задача 5 — Что? Где? Когда?

Игра 13 секторов. Каждый сектор — пара файлов (вопрос, ответ).
Шаг: ввести offset → новый сектор. Вопрос → ответ → проверить.
Победа когда 6 баллов у игрока ИЛИ зрителей.

## План реализации

```text
Module19th/Module19Hwork/
├── README.md, test_all.sh
├── Task1_WordSearch/
├── Task2_TextViewer/
├── Task3_Vedomost/
├── Task4_PngDetector/
└── Task5_WhatWhereWhen/
```
