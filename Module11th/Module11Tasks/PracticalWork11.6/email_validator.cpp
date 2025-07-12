#include <iostream>
#include <string>

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

int main() {
    string email;
    
    cout << "Enter email address: ";
    cin >> email;
    
    if (is_valid_email(email)) {
        cout << "Yes" << endl;
    } else {
        cout << "No" << endl;
    }
    
    return 0;
}