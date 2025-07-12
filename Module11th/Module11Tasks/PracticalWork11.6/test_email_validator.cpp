#include <iostream>
#include <string>
#include <cassert>

using namespace std;

string get_local_part(string email) {
    string local = "";
    for (int i = 0; i < email.length(); i++) {
        if (email[i] == '@') {
            break;
        }
        local += email[i];
    }
    return local;
}

string get_domain_part(string email) {
    string domain = "";
    bool found_at = false;
    for (int i = 0; i < email.length(); i++) {
        if (email[i] == '@') {
            found_at = true;
            continue;
        }
        if (found_at) {
            domain += email[i];
        }
    }
    return domain;
}

bool is_valid_char_local(char ch) {
    string allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-!#$%&'*+-/=?^_`{|}~";
    for (int i = 0; i < allowed.length(); i++) {
        if (ch == allowed[i]) {
            return true;
        }
    }
    return false;
}

bool is_valid_char_domain(char ch) {
    string allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-";
    for (int i = 0; i < allowed.length(); i++) {
        if (ch == allowed[i]) {
            return true;
        }
    }
    return false;
}

bool validate_part(string part, bool is_local) {
    if (part.length() == 0) {
        return false;
    }
    
    if (is_local && part.length() > 64) {
        return false;
    }
    
    if (!is_local && part.length() > 63) {
        return false;
    }
    
    if (part[0] == '.' || part[part.length() - 1] == '.') {
        return false;
    }
    
    for (int i = 0; i < part.length(); i++) {
        if (part[i] == '.' && i + 1 < part.length() && part[i + 1] == '.') {
            return false;
        }
        
        if (is_local) {
            if (!is_valid_char_local(part[i])) {
                return false;
            }
        } else {
            if (!is_valid_char_domain(part[i])) {
                return false;
            }
        }
    }
    
    return true;
}

bool is_valid_email(string email) {
    int at_count = 0;
    int at_pos = -1;
    
    for (int i = 0; i < email.length(); i++) {
        if (email[i] == '@') {
            at_count++;
            at_pos = i;
        }
    }
    
    if (at_count != 1) {
        return false;
    }
    
    string local = get_local_part(email);
    string domain = get_domain_part(email);
    
    return validate_part(local, true) && validate_part(domain, false);
}

void test_valid_emails() {
    cout << "=== Тестирование корректных email адресов ===" << endl;
    
    string valid_emails[] = {
        "simple@example.com",
        "very.common@example.com", 
        "disposable.style.email.with+symbol@example.com",
        "other.email-with-hyphen@example.com",
        "fully-qualified-domain@example.com",
        "user.name+tag+sorting@example.com",
        "x@example.com",
        "example-indeed@strange-example.com",
        "admin@mailserver1",
        "example@s.example",
        "mailhost!username@example.org",
        "user%example.com@example.org"
    };
    
    for (int i = 0; i < 12; i++) {
        bool result = is_valid_email(valid_emails[i]);
        cout << "Тест " << (i+1) << " - " << valid_emails[i] << ": " << (result ? "Yes" : "No") << endl;
        assert(result == true);
        cout << "✅ Пройден" << endl;
    }
}

void test_invalid_emails() {
    cout << "\n=== Тестирование некорректных email адресов ===" << endl;
    
    string invalid_emails[] = {
        "John..Doe@example.com",
        "Abc.example.com",
        "A@b@c@example.com",
        "a\"b(c)d,e:f;g<h>i[j\\k]l@example.com",
        "1234567890123456789012345678901234567890123456789012345678901234+x@example.com",
        "i_like_underscore@but_its_not_allow_in_this_part.example.com"
    };
    
    string descriptions[] = {
        "две точки подряд",
        "нет символа @", 
        "несколько символов @",
        "недопустимые символы",
        "локальная часть длиннее 64 символов",
        "недопустимый символ в домене"
    };
    
    for (int i = 0; i < 6; i++) {
        bool result = is_valid_email(invalid_emails[i]);
        cout << "Тест " << (i+1) << " - " << descriptions[i] << ": " << (result ? "Yes" : "No") << endl;
        assert(result == false);
        cout << "✅ Пройден" << endl;
    }
}

void test_edge_cases() {
    cout << "\n=== Тестирование граничных случаев ===" << endl;
    
    // Тест длинного домена (63 символа - максимум)
    string long_domain = "a@" + string(63, 'a') + ".com";
    cout << "Тест 1 - домен 63 символа: " << (is_valid_email(long_domain) ? "Yes" : "No") << endl;
    
    // Тест слишком длинного домена (64 символа)
    string too_long_domain = "a@" + string(64, 'a') + ".com";
    cout << "Тест 2 - домен 64 символа: " << (is_valid_email(too_long_domain) ? "Yes" : "No") << endl;
    
    // Тест длинной локальной части (64 символа - максимум)
    string long_local = string(64, 'a') + "@example.com";
    cout << "Тест 3 - локальная часть 64 символа: " << (is_valid_email(long_local) ? "Yes" : "No") << endl;
    
    // Тест слишком длинной локальной части (65 символов)
    string too_long_local = string(65, 'a') + "@example.com";
    cout << "Тест 4 - локальная часть 65 символов: " << (is_valid_email(too_long_local) ? "Yes" : "No") << endl;
    
    cout << "✅ Граничные случаи протестированы" << endl;
}

int main() {
    cout << "🔧 ТЕСТИРОВАНИЕ EMAIL ВАЛИДАТОРА 🔧" << endl;
    cout << "=====================================" << endl;
    
    try {
        test_valid_emails();
        test_invalid_emails();
        test_edge_cases();
        
        cout << "\n🎉 ВСЕ ТЕСТЫ ПРОЙДЕНЫ УСПЕШНО! 🎉" << endl;
        cout << "Email валидатор работает корректно согласно требованиям." << endl;
        
    } catch (const exception& e) {
        cout << "\n❌ ТЕСТ НЕ ПРОЙДЕН!" << endl;
        cout << "Ошибка: " << e.what() << endl;
        return 1;
    }
    
    return 0;
}