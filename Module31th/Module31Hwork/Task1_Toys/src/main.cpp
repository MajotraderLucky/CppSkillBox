// M31.5 Task 1 — Dog с std::shared_ptr<Toy>
// Команды (по одной на строку):
//   pickup <dog> <toy>     — собака пытается подобрать игрушку
//   drop   <dog>           — собака бросает свою игрушку
//   exit                   — выход
//
// Игрушки создаются автоматически при первом упоминании имени и хранятся
// в общей «библиотеке». Учёт «другая собака уже играет» = use_count() > 1
// (библиотека = 1, плюс держит ≥1 собака → ≥ 2).

#include <iostream>
#include <map>
#include <memory>
#include <sstream>
#include <string>

class Toy {
public:
    Toy(const std::string& name) { name_ = name; }
    std::string getNmae() { return name_; }
    ~Toy() {
        std::cout << "Toy " << name_ << " was dropped " << std::endl;
    }
private:
    std::string name_;
};

class Dog {
    std::string             name_;
    std::shared_ptr<Toy>    toy_;

public:
    Dog(const std::string& n) : name_(n) {}

    void getToy(const std::shared_ptr<Toy>& toy) {
        if (toy_ && toy_.get() == toy.get()) {
            std::cout << "I already have this toy" << std::endl;
            return;
        }
        if (toy.use_count() > 1) {
            std::cout << "Another dog is playing with this toy" << std::endl;
            return;
        }
        toy_ = toy;
        std::cout << name_ << " picks up " << toy_->getNmae() << std::endl;
    }

    void dropToy() {
        if (!toy_) {
            std::cout << "Nothing to drop" << std::endl;
            return;
        }
        std::cout << name_ << " drops " << toy_->getNmae() << std::endl;
        toy_.reset();
    }
};

int main() {
    std::map<std::string, std::shared_ptr<Dog>> dogs;
    std::map<std::string, std::shared_ptr<Toy>> toys;

    auto getOrMakeDog = [&](const std::string& name) -> std::shared_ptr<Dog>& {
        auto it = dogs.find(name);
        if (it == dogs.end()) {
            it = dogs.emplace(name, std::make_shared<Dog>(name)).first;
        }
        return it->second;
    };
    auto getOrMakeToy = [&](const std::string& name) -> std::shared_ptr<Toy>& {
        auto it = toys.find(name);
        if (it == toys.end()) {
            it = toys.emplace(name, std::make_shared<Toy>(name)).first;
        }
        return it->second;
    };

    std::cerr << "Commands: pickup <dog> <toy> | drop <dog> | exit\n";

    std::string line;
    while (std::getline(std::cin, line)) {
        std::istringstream iss(line);
        std::string cmd;
        if (!(iss >> cmd)) continue;

        if (cmd == "exit") break;

        if (cmd == "pickup") {
            std::string dogName, toyName;
            if (!(iss >> dogName >> toyName)) {
                std::cout << "Usage: pickup <dog> <toy>" << std::endl;
                continue;
            }
            auto& dog = getOrMakeDog(dogName);
            auto& toy = getOrMakeToy(toyName);   // reference into library, не копия
            dog->getToy(toy);
        } else if (cmd == "drop") {
            std::string dogName;
            if (!(iss >> dogName)) {
                std::cout << "Usage: drop <dog>" << std::endl;
                continue;
            }
            auto& dog = getOrMakeDog(dogName);
            dog->dropToy();
        } else {
            std::cout << "Unknown command: " << cmd << std::endl;
        }
    }
    return 0;
}
