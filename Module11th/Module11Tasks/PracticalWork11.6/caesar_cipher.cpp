#include <iostream>
#include <string>

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

int main() {
    string text;
    int shift;
    
    cout << "Enter text to encrypt: ";
    getline(cin, text);
    
    cout << "Enter shift value: ";
    cin >> shift;
    
    string encrypted = encrypt_caesar(text, shift);
    
    cout << "Original text: " << text << endl;
    cout << "Encrypted text: " << encrypted << endl;
    
    return 0;
}