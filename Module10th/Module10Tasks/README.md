# Модуль 10: Знакомство с компилятором - Практические задачи

## 📝 Отзыв преподавателя по Module 9

**Результат:** ✅ **Работа выполнена на отлично!**

**Пожелание для Module 10:** 
> "Для следующего модуля советую вспомнить формулу дискриминанта."

## 📚 Математическая подготовка

### Формула дискриминанта
Для квадратного уравнения вида: **ax² + bx + c = 0**

**Дискриминант:** `D = b² - 4ac`

**Корни уравнения:**
- При `D > 0`: два различных корня
  - `x₁ = (-b + √D) / (2a)`
  - `x₂ = (-b - √D) / (2a)`
- При `D = 0`: один корень
  - `x = -b / (2a)`
- При `D < 0`: нет вещественных корней

### Примеры
1. **x² - 5x + 6 = 0**
   - a=1, b=-5, c=6
   - D = (-5)² - 4(1)(6) = 25 - 24 = 1
   - x₁ = (5 + 1)/2 = 3, x₂ = (5 - 1)/2 = 2

2. **x² - 4x + 4 = 0**
   - a=1, b=-4, c=4
   - D = (-4)² - 4(1)(4) = 16 - 16 = 0
   - x = 4/2 = 2

3. **x² + x + 1 = 0**
   - a=1, b=1, c=1
   - D = 1² - 4(1)(1) = 1 - 4 = -3 < 0
   - Нет вещественных корней

---

## 🎯 Практическая работа: Решение квадратных уравнений

### Задача

Исправить ошибки в программе для решения квадратных уравнений вида **ax² + bx + c = 0**.

### Описание программы

Программа вычисляет корни квадратного уравнения используя дискриминант:
- **D = b² - 4ac**

Логика работы:
- Если **a = 0**: "Это не квадратное уравнение"
- Если **D > 0**: два корня x₁ = (-b + √D) / (2a), x₂ = (-b - √D) / (2a)
- Если **D = 0**: один корень x = -b / (2a)
- Если **D < 0**: "Комплексные корни не поддерживаются"

### Найденные и исправленные ошибки

#### Ошибки компиляции:
1. **Отсутствовал ввод переменной c**
   ```cpp
   // Было: std::cin >> a >> b;
   // Стало: std::cin >> a >> b >> c;
   ```

2. **Неправильное имя переменной**
   ```cpp
   // Было: std::sqrt(discriminand)
   // Стало: std::sqrt(discriminant)
   ```

3. **Синтаксическая ошибка - отсутствие точки с запятой**
   ```cpp
   // Было: float x2 = (-b + std::sqrt(discriminant)) / (2 * a),
   // Стало: float x2 = (-b - std::sqrt(discriminant)) / (2 * a);
   ```

#### Логические ошибки:
1. **Неправильная формула дискриминанта**
   ```cpp
   // Было: float discriminant = b * c - 4 * a * b;
   // Стало: float discriminant = b * b - 4 * a * c;
   ```

2. **Неверное условие для проверки квадратного уравнения**
   ```cpp
   // Было: if (a < 0)
   // Стало: if (a == 0)
   ```

3. **Неправильная логика ветвления**
   ```cpp
   // Было: else if (b > 0)
   // Стало: else
   ```

4. **Преждевременное завершение программы**
   ```cpp
   // Удален: return 0; (блокировал выполнение остального кода)
   ```

5. **Неправильное условие для дискриминанта**
   ```cpp
   // Было: if (discriminant > 1)
   // Стало: if (discriminant > 0)
   ```

6. **Неправильная формула для второго корня**
   ```cpp
   // Было: float x2 = (-b + std::sqrt(discriminant)) / (2 * a);
   // Стало: float x2 = (-b - std::sqrt(discriminant)) / (2 * a);
   ```

7. **Неправильная формула для одного корня**
   ```cpp
   // Было: float x = b + std::sqrt(discriminant * discriminant) / (2 * a);
   // Стало: float x = -b / (2 * a);
   ```

8. **Неправильный вывод результата**
   ```cpp
   // Было: std::cout << "Root 1, 2: " << x1 << ", " << x1 << std::endl;
   // Стало: std::cout << "Root 1, 2: " << x1 << ", " << x2 << std::endl;
   
   // Было: std::cout << "Root: " << discriminant << std::endl;
   // Стало: std::cout << "Root: " << x << std::endl;
   ```

### Файлы

- **quadratic_solver.cpp** - Исправленный исходный код программы
- **quadratic_solver** - Скомпилированная программа

### Сборка и запуск

```bash
# Компиляция
g++ -o quadratic_solver quadratic_solver.cpp

# Запуск
./quadratic_solver
```

### Примеры работы

1. **Два корня (D > 0):**
   ```
   a, b, c: 1 -5 6
   Root 1, 2: 3, 2
   ```

2. **Один корень (D = 0):**
   ```
   a, b, c: 1 -4 4
   Root: 2
   ```

3. **Комплексные корни (D < 0):**
   ```
   a, b, c: 1 2 5
   Complex scenario is not supported!
   ```

4. **Не квадратное уравнение (a = 0):**
   ```
   a, b, c: 0 3 2
   Not a quadratic equation!
   ```

### Изученные концепции

- Стадии компиляции: препроцессинг, компиляция, компоновка
- Типы ошибок: синтаксические, логические, ошибки времени выполнения
- Отладка кода в IDE VSCode
- Тестирование программы на различных входных данных

---

## 🎯 Результат Module 10
- ✅ Математическая база применена
- ✅ Программа исправлена и протестирована
- ✅ Изучен процесс компиляции
- ✅ Освоена отладка в IDE

**Предыдущие достижения:**
- Module 8: Завершен
- Module 9: 7/7 задач (отлично)
- Module 10: Практическая работа выполнена

---
*Дата обновления: 2025-01-06*
*Статус: Практическая работа завершена*