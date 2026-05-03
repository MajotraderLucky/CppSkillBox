# M16.4 — Преобразование базовых типов между собой

**Тип:** longread
**URL:** `longread/0a05895c-2c87-4dc9-869d-160613ee6e77`

## Зачем нужны преобразования

- Числа в памяти = биты. Пользователь видит десятичную систему → нужны преобразования
- Текстовые файлы хранят числа как строки → перед вычислениями преобразовать
- Большие данные → графики (графический интерфейс)

## C-style: atoi / atof

```cpp
int atoi(const char* str);     // string → int
double atof(const char* str);  // string → double
```

**Правила:**
- Если за числом мусор (после) — игнорируется: `atof("3.14abc")` = 3.14
- Если перед числом мусор — возвращается **0**: `atof("abc3.14")` = 0
- Знаки `+` и `-` допустимы
- Для double допустима экспоненциальная форма: `atof("1.5e3")` = 1500

```cpp
char pi[] = "3.14";
double value = atof(pi);  // 3.14
```

**Trap:** запятая вместо точки → парсинг останавливается на запятой:
`atof("3,14")` = 3 (запятая — посторонний символ)

## C++ style: stoi / stof / stod

```cpp
int stoi(const std::string& str);
float stof(const std::string& str);
double stod(const std::string& str);
```

Те же правила что atoi/atof, но для `std::string`.

**Quiz answers:**
- `std::stoi("2.15")` = **2** (точка — невалид для int, парсинг останавливается)
- `std::stof("3.14bg")` = **3.14** (мусор после числа игнорируется)

## Обратное преобразование (число → строка)

(Не показано в этом longread, но known C++ patterns:)

```cpp
std::to_string(int_value);    // → string
std::to_string(double_value); // → string

// Or via stringstream:
std::stringstream ss;
ss << int_value;
std::string str = ss.str();
```

## Practical relevance для DevOps

- **Парсинг конфигов:** значения из YAML/INI всегда строки → преобразовать
- **Парсинг логов:** числовые поля (status code, latency_ms) — стрингы → numeric
- **Sanitization input:** atoi() возвращает 0 при мусоре — нужно проверять stoi с try/catch (C++ throws на полном мусоре)
