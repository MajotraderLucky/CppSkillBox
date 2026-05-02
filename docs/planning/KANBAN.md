# CppSkillBox — Kanban / Course Progress

**Updated:** 2026-05-03 01:00 MSK
**Repo:** [github.com:MajotraderLucky/CppSkillBox](https://github.com/MajotraderLucky/CppSkillBox)
**Branch:** master (clean, synced с origin)
**Course:** [SkillBox — Профессия C++](https://go.skillbox.ru/profession/paket-c-plus-plus/profession-c-plus-plus/)
**Progress:** 57/166 видео (~34%), 12/39 практ работ (~31%)
**Support status:** **OFFLINE** — проверка hwork отключена с ~M13.6

---

## STRATEGY (decided 2026-05-03)

**Two-phase approach** — экономим на support:

1. **Phase NOW (free):** прокачать максимум видео + longreads (доступ к контенту forever)
   - Извлекать VTT для каждого видео в `docs/lessons/M{N}/L{X}_*.{vtt,txt}`
   - Создавать `L{X}_NOTES.md` с конспектом по полезному содержанию
   - Marking как watched через chrome-devtools (seek to 90% + play remainder)
2. **Phase LATER (paid):** продлить поддержку с минимальным остатком
   - Сабмитить hwork + получить teacher review (M13.6 → M40 + final work)
   - Цена продления зависит от объёма работ — чем меньше остаётся, тем дешевле негоциация
   - Final work открывается после Module 39

**Why:** Контент остаётся forever, но teacher review требует active support. Цена
продления не публичная (через chat support), индивидуальная. Меньший remaining scope
= меньше продление = лучшая negoциация.

---

## DONE — модули с code

### Module 8 — Основы ООП

- [+] Elevator (симулятор лифта)
- [+] FinalTasksModule8 (комплексные ООП задачи)
- [+] Pitchcontrol (управление высотой звука)
- [+] knightsmove (ход коня на шахматной доске)
- [+] photokiller (обработка фото)

36 src files, 9 task dirs.

### Module 9 — Работа со строками

- [+] ChessMoves (queen/rook/knight/bishop валидация ходов)
- [+] PlayingCards (игральные карты)
- [+] TestNumbers (валидация чисел / float validator)
- [+] Roman numerals converter
- [+] Word counter, bulls & cows

15 src files, 3 task dirs.

### Module 10 — Компиляция и отладка

- [+] Quadratic Equation Solver
- [+] Examples (стадии компиляции)
- [+] Teacher feedback: одобрено (особенно проверка `a == 0`)

3 src files.

### Module 11 — Функции в C++

- [+] Practical Work 11.6 (Caesar cipher)
- [+] Negative shifts handled (после teacher feedback)
- [+] README с учительскими комментариями

6 src files, 1 task dir, README с teacher feedback.

### Module 12 — Одномерные массивы

- [+] Apartment House (массив строк + проверка границ)
- [+] Sorting (пузырёк по убыванию + HeapSort после teacher feedback)
- [+] test_*.sh для каждой задачи
- [+] README с темами модуля

5 src files, README.

### Module 13 — Векторы

- [+] Task1_Average
- [+] Task2_Reverse
- [+] Task3_SecondMax
- [+] Task4_RobotQueue
- [+] Task5_Hospital
- [+] Task6_RobotCorruption
- [+] test_all.sh (44 теста, проходят все)

6 src files, 6 task dirs, comprehensive test runner.

---

## IN PROGRESS — Phase NOW: video sweep

### Closed today (2026-05-03)

- [+] M9.1 "Разбор практической работы" (16:34) → DONE через seek-to-90%+play
- [+] VTT + plain text + NOTES для M9.1 (`docs/lessons/M9/`)
- [+] Validated: workflow закрытия видео через chrome-devtools

### Backlog of incomplete videos (priority order)

**P0 — finish modules с code on disk (M1, M9, M11, M13):**

| Lesson  | Title                                  | Type     | Длина | Status              |
|---------|----------------------------------------|----------|-------|---------------------|
| 1.5     | Итоги                                  | video    | 2:39  | started (partial)   |
| 1.6     | Начало работы и настройка реплит       | video    | 5 мин | none                |
| 1.7     | Итоги пройденных тем. Проверь себя     | longread | -     | none                |
| 11.1    | Разбор практической работы M10         | video    | TBD   | started (partial)   |
| 13.3    | Удаление элемента со сдвигом           | video    | TBD   | started (partial)   |
| 13.4    | Использование push_back()              | video    | TBD   | none                |
| 13.5    | Полезные функции std::vector           | video    | TBD   | none                |
| 13.6    | Практическая работа                    | hwork    | -     | **read_only**       |

7 videos + 1 longread + 1 read_only hwork = ~30-90 мин ручной работы (если bulk).

**P1 — Module 14+ (новый материал, never opened):**

- M14 (Двумерные массивы): 5 видео + 1 hwork
- M15 (Сортировки): 5 видео + 1 hwork
- M16 (Типы данных): 5 longread + 1 hwork
- M17-M40: ~120 lessons total

### Repo hygiene (P0)

- [ ] **Add compiled binaries to .gitignore** (untracked сейчас)
  - `Module13th/Module13Tasks/Task{1..6}_*/{average,reverse,second_max,robot_queue,hospital,robot_corruption}`
  - Pattern: `Module*/**/Task*/[a-z_]*` без extension
- [ ] Текущий .gitignore содержит **8 байт** (минимальный) — расширить

---

## NEXT / BACKLOG

### Module 14 (?) — следующий модуль курса

- [ ] Узнать тему Module 14 (likely: указатели / dynamic memory / file I/O / classes)
- [ ] Создать `Module14th/` структуру
- [ ] Установить acceptance pattern: `MainTaskDir/test_*.sh` + README

### Documentation backfill

- [ ] README для Module 8 (нет)
- [ ] README для Module 9 (нет)
- [ ] README для Module 10 (нет)
- [ ] README для Module 13 (нет — недавний)

Pattern from M11/M12:

- Topic / module focus
- Teacher feedback (если есть)
- Practical tasks list
- Test runner usage

### Lesson notes (новая фича из VTT extraction)

- [ ] Extract VTT для всех просмотренных уроков
- [ ] Folder pattern: `docs/lessons/M{N}/L{X}_<title>.{vtt,txt}`
- [ ] (Optional) summarize в `docs/lessons/M{N}/SUMMARY.md`

---

## Tooling — Skillbox lesson VTT extraction (validated 2026-05-03)

### Workflow

```
1. Open Skillbox lesson page в Chrome (already logged in)
2. Click "Субтитры" → "Русский (Автоматические)"
3. mcp__chrome-devtools__list_network_requests
   → ищем kinescope.io/.../subtitles/<id>.vtt
4. mcp__chrome-devtools__get_network_request reqid=N responseFilePath=...
5. Save в docs/lessons/M{N}/L{X}_<title>.vtt
6. (Optional) awk-strip timestamps → .txt для чтения
```

### Validation: Module 1 Lesson 5 "Итоги" (2026-05-03 00:22)

- Video: 2:39 (159 sec), Kinescope embed
- VTT: 43 cues
- Plain text: 89 lines / 3.6 KB
- Source: auto-captioning (Russian)
- Topic: разбор 5 ошибок в первых программах + хоумворк (текстовый интерфейс)

Качество auto-cap: pass ("see out" → "сы аут" — слабые места на английских терминах, но контекст ясен).

### Limitations

- Auto-cap иногда путает английские термины (e.g. "cout" → "count" в одном месте)
- DRM token (`drmauthtoken`) обновляется — VTT URL короткоживущий
- Subtitle button нужно нажать руками (UI-driven)

---

## Strong sides

- Test-driven submissions: `test_*.sh` или `test_all.sh` для большинства модулей
- Teacher feedback зафиксирован в README (M11, M12)
- Чистый git history с conventional commits в новых модулях (`feat(module11):`, `fix(module11):`)

## Weak sides

- README отсутствует для половины модулей (M8, M9, M10, M13)
- Compiled binaries попадают в untracked / иногда в commits (`sorting` после HeapSort recompile)
- Модули в `cppskillbox/CppSkillBox/` (двойная вложенность) — outer git is empty
- Outer `cppskillbox/README.md` устарел (не упоминает M13)

---

## Quick reference — модули и их фокус

| Module | Тема                           | Status | Tasks count            |
|--------|--------------------------------|--------|------------------------|
| M1-M7  | (intro / лекции, нет code)     | ?      | (только видео)         |
| M8     | Основы ООП                     | DONE   | 5 проектов             |
| M9     | Работа со строками             | DONE   | 3 task dirs            |
| M10    | Компиляция и отладка           | DONE   | 1 final                |
| M11    | Функции                        | DONE   | 1 (Caesar)             |
| M12    | Одномерные массивы             | DONE   | 2 (apartment, sorting) |
| M13    | Векторы                        | DONE   | 6 (Tasks 1-6)          |
| M14+   | TBD                            | NEXT   | -                      |

---

## Reference

- VTT extraction validation: `docs/lessons/M1/L5_итоги.{vtt,txt}`
- Tooling guide (live-assist L1): `~/Development/audio-summary-rs/docs/planning/KANBAN.md` (related project)
- Git remote: `git@github.com:MajotraderLucky/CppSkillBox.git`
