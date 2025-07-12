#include <iostream>
#include <string>
#include <cassert>

using namespace std;

string get_address_part(string ip_address, int part_number) {
    string current_part = "";
    int current_index = 0;
    
    for (int i = 0; i < ip_address.length(); i++) {
        if (ip_address[i] == '.') {
            if (current_index == part_number) {
                return current_part;
            }
            current_part = "";
            current_index++;
        } else {
            current_part += ip_address[i];
        }
    }
    
    if (current_index == part_number) {
        return current_part;
    }
    
    return "";
}

bool is_valid_octet_string(string octet_str) {
    if (octet_str.empty() || octet_str.length() > 3) {
        return false;
    }
    
    for (int i = 0; i < octet_str.length(); i++) {
        if (octet_str[i] < '0' || octet_str[i] > '9') {
            return false;
        }
    }
    
    if (octet_str.length() > 1 && octet_str[0] == '0') {
        return false;
    }
    
    int value = 0;
    for (int i = 0; i < octet_str.length(); i++) {
        value = value * 10 + (octet_str[i] - '0');
    }
    
    return value >= 0 && value <= 255;
}

bool is_valid_ip(string ip) {
    if (ip.empty()) {
        return false;
    }
    
    int dot_count = 0;
    for (int i = 0; i < ip.length(); i++) {
        if (ip[i] == '.') {
            dot_count++;
        }
    }
    
    if (dot_count != 3) {
        return false;
    }
    
    if (ip[0] == '.' || ip[ip.length() - 1] == '.') {
        return false;
    }
    
    for (int i = 0; i < ip.length() - 1; i++) {
        if (ip[i] == '.' && ip[i + 1] == '.') {
            return false;
        }
    }
    
    for (int part = 0; part < 4; part++) {
        string octet = get_address_part(ip, part);
        if (!is_valid_octet_string(octet)) {
            return false;
        }
    }
    
    return true;
}

void test_get_address_part() {
    cout << "=== Тестирование функции get_address_part ===" << endl;
    
    string test_ip = "192.168.1.1";
    
    string part0 = get_address_part(test_ip, 0);
    cout << "Тест 1 - часть 0: " << part0 << endl;
    assert(part0 == "192");
    cout << "✅ Пройден" << endl;
    
    string part1 = get_address_part(test_ip, 1);
    cout << "Тест 2 - часть 1: " << part1 << endl;
    assert(part1 == "168");
    cout << "✅ Пройден" << endl;
    
    string part2 = get_address_part(test_ip, 2);
    cout << "Тест 3 - часть 2: " << part2 << endl;
    assert(part2 == "1");
    cout << "✅ Пройден" << endl;
    
    string part3 = get_address_part(test_ip, 3);
    cout << "Тест 4 - часть 3: " << part3 << endl;
    assert(part3 == "1");
    cout << "✅ Пройден" << endl;
}

void test_valid_ips() {
    cout << "\n=== Тестирование корректных IP адресов ===" << endl;
    
    string valid_ips[] = {
        "127.0.0.1",
        "255.255.255.255", 
        "1.2.3.4",
        "55.77.213.101",
        "0.0.0.0",
        "192.168.1.1",
        "10.0.0.1"
    };
    
    for (int i = 0; i < 7; i++) {
        bool result = is_valid_ip(valid_ips[i]);
        cout << "Тест " << (i+1) << " - " << valid_ips[i] << ": " << (result ? "Valid" : "Invalid") << endl;
        assert(result == true);
        cout << "✅ Пройден" << endl;
    }
}

void test_invalid_ips() {
    cout << "\n=== Тестирование некорректных IP адресов ===" << endl;
    
    string invalid_ips[] = {
        "255.256.257.258",
        "0.55.33.22.",
        "10.00.000.0",
        "23.055.255.033", 
        "65.123..9",
        "a.b.c.d"
    };
    
    string descriptions[] = {
        "числа больше 255",
        "лишняя точка в конце",
        "лишние нули (00, 000)",
        "лишние нули (055, 033)",
        "две точки подряд",
        "буквы вместо чисел"
    };
    
    for (int i = 0; i < 6; i++) {
        bool result = is_valid_ip(invalid_ips[i]);
        cout << "Тест " << (i+1) << " - " << descriptions[i] << ": " << (result ? "Valid" : "Invalid") << endl;
        assert(result == false);
        cout << "✅ Пройден" << endl;
    }
}

void test_edge_cases() {
    cout << "\n=== Тестирование граничных случаев ===" << endl;
    
    // Тест 1: Пустая строка
    bool test1 = is_valid_ip("");
    cout << "Тест 1 - пустая строка: " << (test1 ? "Valid" : "Invalid") << endl;
    assert(test1 == false);
    cout << "✅ Пройден" << endl;
    
    // Тест 2: Только точки
    bool test2 = is_valid_ip("...");
    cout << "Тест 2 - только точки: " << (test2 ? "Valid" : "Invalid") << endl;
    assert(test2 == false);
    cout << "✅ Пройден" << endl;
    
    // Тест 3: Слишком много частей
    bool test3 = is_valid_ip("1.2.3.4.5");
    cout << "Тест 3 - слишком много частей: " << (test3 ? "Valid" : "Invalid") << endl;
    assert(test3 == false);
    cout << "✅ Пройден" << endl;
    
    // Тест 4: Слишком мало частей
    bool test4 = is_valid_ip("1.2.3");
    cout << "Тест 4 - слишком мало частей: " << (test4 ? "Valid" : "Invalid") << endl;
    assert(test4 == false);
    cout << "✅ Пройден" << endl;
    
    // Тест 5: Число 256 (граница)
    bool test5 = is_valid_ip("1.2.3.256");
    cout << "Тест 5 - число 256: " << (test5 ? "Valid" : "Invalid") << endl;
    assert(test5 == false);
    cout << "✅ Пройден" << endl;
    
    // Тест 6: Число 255 (максимальное валидное)
    bool test6 = is_valid_ip("255.255.255.255");
    cout << "Тест 6 - максимальные числа 255: " << (test6 ? "Valid" : "Invalid") << endl;
    assert(test6 == true);
    cout << "✅ Пройден" << endl;
    
    // Тест 7: Пустой октет
    bool test7 = is_valid_ip("1..3.4");
    cout << "Тест 7 - пустой октет: " << (test7 ? "Valid" : "Invalid") << endl;
    assert(test7 == false);
    cout << "✅ Пройден" << endl;
    
    // Тест 8: Длинный октет (больше 3 цифр)
    bool test8 = is_valid_ip("1234.5.6.7");
    cout << "Тест 8 - октет больше 3 цифр: " << (test8 ? "Valid" : "Invalid") << endl;
    assert(test8 == false);
    cout << "✅ Пройден" << endl;
}

void test_leading_zeros() {
    cout << "\n=== Тестирование ведущих нулей ===" << endl;
    
    // Тест 1: Одиночный ноль (валидный)
    bool test1 = is_valid_ip("0.0.0.0");
    cout << "Тест 1 - одиночные нули: " << (test1 ? "Valid" : "Invalid") << endl;
    assert(test1 == true);
    cout << "✅ Пройден" << endl;
    
    // Тест 2: Ведущий ноль в двузначном числе
    bool test2 = is_valid_ip("01.2.3.4");
    cout << "Тест 2 - ведущий ноль (01): " << (test2 ? "Valid" : "Invalid") << endl;
    assert(test2 == false);
    cout << "✅ Пройден" << endl;
    
    // Тест 3: Ведущие нули в трехзначном числе
    bool test3 = is_valid_ip("001.2.3.4");
    cout << "Тест 3 - ведущие нули (001): " << (test3 ? "Valid" : "Invalid") << endl;
    assert(test3 == false);
    cout << "✅ Пройден" << endl;
    
    // Тест 4: Нормальные числа без ведущих нулей
    bool test4 = is_valid_ip("192.168.1.100");
    cout << "Тест 4 - нормальные числа: " << (test4 ? "Valid" : "Invalid") << endl;
    assert(test4 == true);
    cout << "✅ Пройден" << endl;
}

int main() {
    cout << "🔧 ТЕСТИРОВАНИЕ IP ВАЛИДАТОРА 🔧" << endl;
    cout << "==================================" << endl;
    
    try {
        test_get_address_part();
        test_valid_ips();
        test_invalid_ips();
        test_edge_cases();
        test_leading_zeros();
        
        cout << "\n🎉 ВСЕ ТЕСТЫ ПРОЙДЕНЫ УСПЕШНО! 🎉" << endl;
        cout << "IP валидатор работает корректно согласно требованиям." << endl;
        
    } catch (const exception& e) {
        cout << "\n❌ ТЕСТ НЕ ПРОЙДЕН!" << endl;
        cout << "Ошибка: " << e.what() << endl;
        return 1;
    }
    
    return 0;
}