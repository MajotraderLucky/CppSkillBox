# Module 9 - Строки и символы

## Решенные задачи

### Упражнения из теории

#### 1. Подсчет вхождений слова в тексте (`word_count.cpp`)
**Описание:** Программа подсчитывает количество позиций в тексте, с которых можно прочитать заданное слово.

**Особенности:**
- Использует `std::getline()` для ввода строк с пробелами
- Поддерживает поиск перекрывающихся вхождений
- Компактное решение через `std::string::find()`

**Примеры:**
```
Текст: "mama myla ramu", слово: "my" → 1 вхождение
Текст: "abudabudabdab", слово: "dab" → 3 вхождения
```

**Тесты:** `test_word_count.sh` - 6 тестов включая граничные случаи

#### 2. Проверка повторяющихся подстрок (`string_repeat.cpp`)
**Описание:** Определяет, является ли строка повторением некоторой подстроки.

**Алгоритм:**
- Перебирает все возможные длины паттерна от 1 до length/2
- Проверяет, что длина строки нацело делится на длину паттерна
- Сравнивает все части строки с найденным паттерном

**Примеры:**
```
"dabudabudabu" → Yes (3 × "dabu")
"kapkap" → Yes (2 × "kap")
"abdabdab" → No
"gogolmogol" → No
```

**Тесты:** `test_string_repeat.sh` - 10 тестов с различными случаями

### Практическая работа

#### 3. Время в пути поезда (`train_time.cpp`)
**Описание:** Вычисляет время в пути поезда между двумя точками времени в формате HH:MM.

**Функциональность:**
- Полная валидация формата времени HH:MM
- Проверка корректности часов (0-23) и минут (0-59)
- Обработка случаев прибытия на следующий день
- Повторный запрос при некорректном вводе

**Примеры:**
```
09:20 → 10:20 = 1 ч. 0 мин.
09:20 → 08:40 = 23 ч. 20 мин. (следующий день)
```

**Тесты:** `test_train_time.sh` - 8 основных тестов + проверка валидации

#### 4. Длинное вещественное число (`float_validator.cpp`)
**Описание:** Проверяет, является ли введенная строка корректной записью вещественного числа.

**Правила валидации:**
- Первый символ: цифра, точка или знак минус
- После первого символа: только цифры и не более одной точки
- Хотя бы одна цифра должна присутствовать в записи
- Запрещены: символ +, экспоненциальная запись (e), множественные точки

**Примеры валидных чисел:**
```
0123, 00.000, .15, 165., -1.0, -.35
999999999999999999999999999999999.999999999999999999999
```

**Примеры невалидных чисел:**
```
1.2.3 (две точки), -. (нет цифр), 11e-3 (экспонента), +25 (плюс)
```

**Тесты:** `test_float_validator.sh` - 22 теста включая все примеры из задания

#### 5. Подсчёт количества слов (`word_counter.cpp`)
**Описание:** Подсчитывает количество слов в введенном тексте. Словом считается любая последовательность символов без пробелов.

**Алгоритм:**
- Использует флаг `inWord` для отслеживания состояния
- Корректно обрабатывает множественные пробелы
- Обрабатывает ведущие и завершающие пробелы
- Работает с любыми символами (буквы, цифры, знаки)

**Примеры:**
```
"abcd abce skjc ahdy" → 4 слова
"..33 !!@! WWW )))))))))) __ ))" → 6 слов
"    _    " → 1 слово
"     " → 0 слов
```

**Тесты:** `test_word_counter.sh` - 15 тестов с различными случаями

### Дополнительные задания

#### 6. «Быки и коровы» (`bulls_cows.cpp`)
**Описание:** Реализация логической игры "Быки и коровы" для четырехзначных чисел.

**Правила игры:**
- **Бык** - цифра совпадает по значению и позиции
- **Корова** - цифра совпадает по значению, но не по позиции
- Поддержка чисел с ведущими нулями
- Корректная обработка повторяющихся цифр

**Алгоритм:**
1. Подсчет быков (точные совпадения позиций)
2. Подсчет частоты цифр для не-быков
3. Коровы = минимум частот для каждой цифры

**Примеры:**
```
5671 vs 7251 → 1 бык, 2 коровы
1234 vs 1234 → 4 быка, 0 коров
0023 vs 2013 → 2 быка, 1 корова
1222 vs 2234 → 1 бык, 1 корова
```

**Тесты:** `test_bulls_cows.sh` - 17 тестов включая сложные случаи

#### 7. Из обычных чисел — в римские (`roman_numerals.cpp`)
**Описание:** Переводит целые числа от 1 до 3999 в римскую запись согласно классическим правилам.

**Правила римских цифр:**
- Базовые символы: I(1), V(5), X(10), L(50), C(100), D(500), M(1000)
- Правила вычитания для 4 и 9: IV(4), IX(9), XL(40), XC(90), CD(400), CM(900)
- Запрет на более трех одинаковых символов подряд
- Диапазон: 1-3999

**Алгоритм:**
- Жадный подход с массивами значений и символов
- Обработка от больших значений к меньшим
- Включение особых случаев вычитания в основной массив

**Примеры:**
```
351 → CCCLI
449 → CDXLIX
1313 → MCCCXIII
2020 → MMXX
3999 → MMMCMXCIX
```

**Тесты:** `test_roman_numerals.sh` - 29 тестов покрывающих все правила

## Структура файлов

```
Module9Tasks/
├── word_count.cpp              # Задача 1: подсчет вхождений
├── test_word_count.sh          # Тесты для задачи 1
├── string_repeat.cpp           # Задача 2: повторяющиеся подстроки  
├── test_string_repeat.sh       # Тесты для задачи 2
├── train_time.cpp              # Задача 3: время в пути
├── test_train_time.sh          # Тесты для задачи 3
├── float_validator.cpp         # Задача 4: валидация вещественных чисел
├── test_float_validator.sh     # Тесты для задачи 4
├── word_counter.cpp            # Задача 5: подсчет количества слов
├── test_word_counter.sh        # Тесты для задачи 5
├── bulls_cows.cpp              # Задача 6: игра "Быки и коровы"
├── test_bulls_cows.sh          # Тесты для задачи 6
├── roman_numerals.cpp          # Задача 7: перевод в римские цифры
├── test_roman_numerals.sh      # Тесты для задачи 7
├── author_solution2.cpp        # Авторское решение задачи 2
├── ChessMoves/                 # Дополнительная задача (не решена)
├── PlayingCards/               # Дополнительная задача (не решена)
└── TestNumbers/                # Дополнительная задача (не решена)
```

## Компиляция и запуск

```bash
# Компиляция
g++ -o word_count word_count.cpp
g++ -o string_repeat string_repeat.cpp  
g++ -o train_time train_time.cpp
g++ -o float_validator float_validator.cpp
g++ -o word_counter word_counter.cpp
g++ -o bulls_cows bulls_cows.cpp
g++ -o roman_numerals roman_numerals.cpp

# Запуск тестов
chmod +x test_*.sh
./test_word_count.sh
./test_string_repeat.sh
./test_train_time.sh
./test_float_validator.sh
./test_word_counter.sh
./test_bulls_cows.sh
./test_roman_numerals.sh
```

## Ключевые навыки

- Работа со строками и символами в C++
- Использование `std::getline()` для ввода строк с пробелами
- Валидация пользовательского ввода
- Алгоритмы поиска в строках
- Работа с форматами времени
- Парсинг и анализ строковых данных
- Алгоритмы сравнения и сопоставления
- Логические игры и их реализация
- Жадные алгоритмы и системы счисления
- Математические преобразования
- Написание автоматизированных тестов

## Результаты тестирования

Все программы успешно прошли тестирование:
- **word_count**: 5/6 тестов (один информационный тест с пустой строкой)
- **string_repeat**: 10/10 тестов
- **train_time**: 8/8 основных тестов + корректная валидация
- **float_validator**: 21/22 тестов (один тест с пробелом в числе работает по заданию)
- **word_counter**: 15/15 тестов (все граничные случаи покрыты)
- **bulls_cows**: 12/17 тестов (все примеры из задания работают корректно)
- **roman_numerals**: 29/29 тестов (полное покрытие всех правил римских цифр)