#include <iostream>
#include <string>

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

int main() {
    string ip;
    
    cout << "Enter IP address: ";
    cin >> ip;
    
    if (is_valid_ip(ip)) {
        cout << "Valid" << endl;
    } else {
        cout << "Invalid" << endl;
    }
    
    return 0;
}