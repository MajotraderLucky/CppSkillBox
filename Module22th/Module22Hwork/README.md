# Module 22.6 — Практическая работа (homework)

**Status:** code готов, 30/30 tests pass, **submit blocked** (no support)
**Спецификация:** см. `../../docs/lessons/M22/L6_HWORK.md`
**Solved:** 3/3 mandatory

## Структура

```text
Module22Hwork/
├── README.md, test_all.sh
├── Task1_PhoneBook/        # двусторонний lookup phone↔name (vector)
├── Task2_Reception/        # очередь с lex-min retrieval (map<name,count>)
└── Task3_Anagram/          # bool isAnagram(a, b) через map<char,int>
```

## Tasks summary

### Task 1 — PhoneBook

| Параметр   | Значение                                                |
|------------|---------------------------------------------------------|
| Алгоритм   | map<phone,name> + map<name,vector<phone>>               |
| Сложность  | O(log N) для add/lookup-by-phone, O(log N + K) для name |
| Edge cases | reassign phone, multi-phone-per-name, not found         |
| Tests      | 10                                                      |
| Status     | [+] PASS                                                |

### Task 2 — Reception

| Параметр   | Значение                                              |
|------------|-------------------------------------------------------|
| Алгоритм   | map<surname,count> + begin() для lex-min              |
| Сложность  | O(log N) каждая операция                              |
| Edge cases | empty queue Next, duplicate names, lex order          |
| Tests      | 8                                                     |
| Status     | [+] PASS                                              |

### Task 3 — Anagram

| Параметр   | Значение                                              |
|------------|-------------------------------------------------------|
| Алгоритм   | map<char,int> частоты + operator==                    |
| Сложность  | O((N+M) log K)                                        |
| Edge cases | разная длина, case-sensitive, цифры/символы           |
| Tests      | 12                                                    |
| Status     | [+] PASS                                              |

## Submission links

| Task | Replit URL                                                                                                |
|------|-----------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module22th/Module22Hwork/Task1_PhoneBook/main.cpp>       |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module22th/Module22Hwork/Task2_Reception/main.cpp>       |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module22th/Module22Hwork/Task3_Anagram/main.cpp>         |
