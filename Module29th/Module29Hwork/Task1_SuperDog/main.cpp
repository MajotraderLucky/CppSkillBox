// M29.4 Task 1 — Суперпёс с динамическими талантами
#include <iostream>
#include <string>
#include <vector>

// Абстрактный класс способности.
class Talent {
public:
    virtual ~Talent() = default;
    virtual std::string name() const = 0;     // pure virtual
};

class Swimming : public Talent {
public:
    std::string name() const override { return "Swim"; }
};

class Dancing : public Talent {
public:
    std::string name() const override { return "Dance"; }
};

class Counting : public Talent {
public:
    std::string name() const override { return "Count"; }
};

class Dog {
    std::string          name_;
    std::vector<Talent*> talents_;
public:
    explicit Dog(std::string name) : name_(std::move(name)) {}
    ~Dog() {
        for (Talent* t : talents_) delete t;
    }

    void addTalent(Talent* t) { talents_.push_back(t); }

    void show_talents() const {
        std::cout << "This is " << name_ << " and it has some talents:\n";
        for (const Talent* t : talents_) {
            std::cout << "   It can \"" << t->name() << "\"\n";
        }
    }
};

int main() {
    std::string name;
    std::cerr << "Имя собаки: ";
    if (!(std::cin >> name)) return 1;
    Dog dog(name);

    std::string cmd;
    std::cerr << "Команды: dance/swim/count/show/exit\n";
    while (std::cin >> cmd) {
        if (cmd == "dance")      dog.addTalent(new Dancing());
        else if (cmd == "swim")  dog.addTalent(new Swimming());
        else if (cmd == "count") dog.addTalent(new Counting());
        else if (cmd == "show")  dog.show_talents();
        else if (cmd == "exit")  break;
        else std::cerr << "Unknown: " << cmd << "\n";
    }
    return 0;
}
