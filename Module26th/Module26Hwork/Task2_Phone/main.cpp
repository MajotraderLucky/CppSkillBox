// M26.4 Task 2 — Mobile phone simulator
#include <iostream>
#include <string>
#include <vector>

class PhoneNumber {
    std::string num_;     // "+7XXXXXXXXXX"
public:
    PhoneNumber() = default;
    explicit PhoneNumber(const std::string& s) : num_(s) {}
    const std::string& str() const { return num_; }
    bool valid() const {
        if (num_.size() != 12) return false;
        if (num_[0] != '+' || num_[1] != '7') return false;
        for (size_t i = 2; i < num_.size(); ++i) {
            if (num_[i] < '0' || num_[i] > '9') return false;
        }
        return true;
    }
};

class Contact {
    std::string name_;
    PhoneNumber phone_;
public:
    Contact(std::string n, PhoneNumber p) : name_(std::move(n)), phone_(std::move(p)) {}
    const std::string& name() const  { return name_; }
    const PhoneNumber& phone() const { return phone_; }
};

class Phone {
    std::vector<Contact> book_;

    // Найти номер по имени или вернуть переданное значение если уже номер.
    PhoneNumber resolve(const std::string& s) const {
        if (!s.empty() && s[0] == '+') return PhoneNumber(s);
        for (const auto& c : book_) {
            if (c.name() == s) return c.phone();
        }
        return PhoneNumber();
    }

public:
    void add(const std::string& name, const std::string& phoneStr) {
        PhoneNumber p(phoneStr);
        if (!p.valid()) {
            std::cout << "INVALID PHONE: " << phoneStr << "\n";
            return;
        }
        book_.emplace_back(name, p);
        std::cout << "ADDED: " << name << " " << phoneStr << "\n";
    }

    void call(const std::string& target) {
        PhoneNumber p = resolve(target);
        if (!p.valid()) {
            std::cout << "NOT FOUND: " << target << "\n";
            return;
        }
        std::cout << "CALL " << p.str() << "\n";
    }

    void sms(const std::string& target, const std::string& msg) {
        PhoneNumber p = resolve(target);
        if (!p.valid()) {
            std::cout << "NOT FOUND: " << target << "\n";
            return;
        }
        std::cout << "SMS " << p.str() << ": " << msg << "\n";
    }
};

int main() {
    Phone phone;
    std::string cmd;
    while (std::cin >> cmd) {
        if (cmd == "add") {
            std::string name, num;
            std::cin >> name >> num;
            phone.add(name, num);
        } else if (cmd == "call") {
            std::string target;
            std::cin >> target;
            phone.call(target);
        } else if (cmd == "sms") {
            std::string target;
            std::cin >> target;
            std::string msg;
            std::getline(std::cin, msg);
            // strip ведущий пробел
            if (!msg.empty() && msg[0] == ' ') msg.erase(0, 1);
            phone.sms(target, msg);
        } else if (cmd == "exit") {
            std::cout << "EXIT\n";
            return 0;
        } else {
            std::cerr << "Unknown: " << cmd << "\n";
        }
    }
    return 0;
}
