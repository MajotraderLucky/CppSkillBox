#include <iostream>
#include <string>
#include <cassert>

using namespace std;

string encrypt_caesar(string text, int shift) {
    string result = "";
    
    for (int i = 0; i < text.length(); i++) {
        char ch = text[i];
        
        if (ch >= 'A' && ch <= 'Z') {
            int shifted = (ch - 'A' + shift % 26 + 26) % 26;
            result += (char)('A' + shifted);
        }
        else if (ch >= 'a' && ch <= 'z') {
            int shifted = (ch - 'a' + shift % 26 + 26) % 26;
            result += (char)('a' + shifted);
        }
        else {
            result += ch;
        }
    }
    
    return result;
}

void test_basic_functionality() {
    cout << "=== Тестирование базовой функциональности ===" << endl;
    
    // Тест 1: Пример из задания
    string test1 = encrypt_caesar("aBxZ*", 67);
    cout << "Тест 1 - aBxZ* с кодом 67: " << test1 << endl;
    assert(test1 == "pQmO*");
    cout << "✅ Пройден" << endl;
    
    // Тест 2: Второй пример из задания  
    string test2 = encrypt_caesar("The quick brown fox jumps over the lazy dog", 3);
    cout << "Тест 2 - фраза с кодом 3: " << test2 << endl;
    assert(test2 == "Wkh txlfn eurzq ira mxpsv ryhu wkh odcb grj");
    cout << "✅ Пройден" << endl;
}

void test_edge_cases() {
    cout << "\n=== Тестирование граничных случаев ===" << endl;
    
    // Тест 3: Пустая строка
    string test3 = encrypt_caesar("", 5);
    cout << "Тест 3 - пустая строка: '" << test3 << "'" << endl;
    assert(test3 == "");
    cout << "✅ Пройден" << endl;
    
    // Тест 4: Только специальные символы
    string test4 = encrypt_caesar("!@#$%^&*()", 10);
    cout << "Тест 4 - только спецсимволы: " << test4 << endl;
    assert(test4 == "!@#$%^&*()");
    cout << "✅ Пройден" << endl;
    
    // Тест 5: Сдвиг 0
    string test5 = encrypt_caesar("Hello World", 0);
    cout << "Тест 5 - сдвиг 0: " << test5 << endl;
    assert(test5 == "Hello World");
    cout << "✅ Пройден" << endl;
}

void test_alphabet_wrapping() {
    cout << "\n=== Тестирование зацикливания алфавита ===" << endl;
    
    // Тест 6: Зацикливание с конца алфавита
    string test6 = encrypt_caesar("xyz", 3);
    cout << "Тест 6 - xyz с кодом 3: " << test6 << endl;
    assert(test6 == "abc");
    cout << "✅ Пройден" << endl;
    
    // Тест 7: Зацикливание заглавных букв
    string test7 = encrypt_caesar("XYZ", 3);
    cout << "Тест 7 - XYZ с кодом 3: " << test7 << endl;
    assert(test7 == "ABC");
    cout << "✅ Пройден" << endl;
    
    // Тест 8: Большой сдвиг (больше 26)
    string test8 = encrypt_caesar("abc", 29); // 29 % 26 = 3
    cout << "Тест 8 - abc с кодом 29: " << test8 << endl;
    assert(test8 == "def");
    cout << "✅ Пройден" << endl;
}

void test_case_preservation() {
    cout << "\n=== Тестирование сохранения регистра ===" << endl;
    
    // Тест 9: Смешанный регистр
    string test9 = encrypt_caesar("AbCdEf", 1);
    cout << "Тест 9 - AbCdEf с кодом 1: " << test9 << endl;
    assert(test9 == "BcDeFg");
    cout << "✅ Пройден" << endl;
    
    // Тест 10: Только заглавные
    string test10 = encrypt_caesar("HELLO", 13);
    cout << "Тест 10 - HELLO с кодом 13: " << test10 << endl;
    assert(test10 == "URYYB");
    cout << "✅ Пройден" << endl;
    
    // Тест 11: Только строчные
    string test11 = encrypt_caesar("world", 13);
    cout << "Тест 11 - world с кодом 13: " << test11 << endl;
    assert(test11 == "jbeyq");
    cout << "✅ Пройден" << endl;
}

void test_numbers_and_spaces() {
    cout << "\n=== Тестирование цифр и пробелов ===" << endl;
    
    // Тест 12: Цифры должны остаться неизменными
    string test12 = encrypt_caesar("abc123def", 3);
    cout << "Тест 12 - abc123def с кодом 3: " << test12 << endl;
    assert(test12 == "def123ghi");
    cout << "✅ Пройден" << endl;
    
    // Тест 13: Пробелы и знаки препинания
    string test13 = encrypt_caesar("Hello, World! 123", 5);
    cout << "Тест 13 - 'Hello, World! 123' с кодом 5: " << test13 << endl;
    assert(test13 == "Mjqqt, Btwqi! 123");
    cout << "✅ Пройден" << endl;
}

void test_negative_shifts() {
    cout << "\n=== Тестирование отрицательных сдвигов ===" << endl;
    
    // Тест 14: Отрицательный сдвиг -3
    string test14 = encrypt_caesar("ddd", -3);
    cout << "Тест 14 - ddd с кодом -3: " << test14 << endl;
    assert(test14 == "aaa");
    cout << "✅ Пройден" << endl;
    
    // Тест 15: Отрицательный сдвиг с зацикливанием
    string test15 = encrypt_caesar("abc", -3);
    cout << "Тест 15 - abc с кодом -3: " << test15 << endl;
    assert(test15 == "xyz");
    cout << "✅ Пройден" << endl;
    
    // Тест 16: Большой отрицательный сдвиг
    string test16 = encrypt_caesar("def", -29); // -29 % 26 = -3
    cout << "Тест 16 - def с кодом -29: " << test16 << endl;
    assert(test16 == "abc");
    cout << "✅ Пройден" << endl;
    
    // Тест 17: Смешанный регистр с отрицательным сдвигом
    string test17 = encrypt_caesar("DEF", -3);
    cout << "Тест 17 - DEF с кодом -3: " << test17 << endl;
    assert(test17 == "ABC");
    cout << "✅ Пройден" << endl;
}

int main() {
    cout << "🔧 ТЕСТИРОВАНИЕ ШИФРА ЦЕЗАРЯ 🔧" << endl;
    cout << "=================================" << endl;
    
    try {
        test_basic_functionality();
        test_edge_cases();
        test_alphabet_wrapping();
        test_case_preservation();
        test_numbers_and_spaces();
        test_negative_shifts();
        
        cout << "\n🎉 ВСЕ ТЕСТЫ ПРОЙДЕНЫ УСПЕШНО! 🎉" << endl;
        cout << "Функция encrypt_caesar работает корректно с положительными и отрицательными сдвигами." << endl;
        
    } catch (const exception& e) {
        cout << "\n❌ ТЕСТ НЕ ПРОЙДЕН!" << endl;
        cout << "Ошибка: " << e.what() << endl;
        return 1;
    }
    
    return 0;
}