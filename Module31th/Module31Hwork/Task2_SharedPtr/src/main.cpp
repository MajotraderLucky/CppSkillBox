// M31.5 Task 2 — собственный shared_ptr_toy (упрощённый аналог std::shared_ptr<Toy>).
// Запуск без аргументов = тест-сценарий из спецификации с эталонным выводом.

#include <iostream>
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

class shared_ptr_toy {
    Toy* toy_;
    int* counter_;

    void release() {
        if (counter_ == nullptr) return;
        *counter_ -= 1;
        if (*counter_ == 0) {
            delete toy_;
            delete counter_;
        }
        toy_     = nullptr;
        counter_ = nullptr;
    }

public:
    shared_ptr_toy() : toy_(nullptr), counter_(nullptr) {}

    shared_ptr_toy(const std::string& name)
        : toy_(new Toy(name)), counter_(new int(1)) {}

    shared_ptr_toy(const shared_ptr_toy& other)
        : toy_(other.toy_), counter_(other.counter_) {
        if (counter_ != nullptr) *counter_ += 1;
    }

    shared_ptr_toy& operator=(const shared_ptr_toy& other) {
        if (this == &other)        return *this;
        if (toy_ == other.toy_)    return *this;   // одна и та же игрушка
        release();
        toy_     = other.toy_;
        counter_ = other.counter_;
        if (counter_ != nullptr) *counter_ += 1;
        return *this;
    }

    ~shared_ptr_toy() { release(); }

    void reset() { release(); }

    Toy* get() const { return toy_; }

    int use_count() const { return counter_ ? *counter_ : 0; }

    std::string getToyName() {
        if (toy_ == nullptr) return "Nothing";
        return toy_->getNmae();
    }
};

shared_ptr_toy make_shared_toy(const std::string& name) {
    return shared_ptr_toy(name);
}

int main() {
    shared_ptr_toy toy_01 = make_shared_toy("ball");
    shared_ptr_toy toy_02(toy_01);
    shared_ptr_toy toy_03("duck");

    std::cout << "=================================================" << std::endl;
    std::cout << toy_01.getToyName() << " links:" << toy_01.use_count() << "  "
              << toy_02.getToyName() << " links:" << toy_02.use_count() << "  "
              << toy_03.getToyName() << " links:" << toy_03.use_count() << std::endl;
    std::cout << "=================================================" << std::endl;

    toy_02 = toy_03;
    std::cout << toy_01.getToyName() << " links:" << toy_01.use_count() << "  "
              << toy_02.getToyName() << " links:" << toy_02.use_count() << "  "
              << toy_03.getToyName() << " links:" << toy_03.use_count() << std::endl;
    std::cout << "=================================================" << std::endl;

    toy_01.reset();
    std::cout << toy_01.getToyName() << " links:" << toy_01.use_count() << "  "
              << toy_02.getToyName() << " links:" << toy_02.use_count() << "  "
              << toy_03.getToyName() << " links:" << toy_03.use_count() << std::endl;
    std::cout << "=================================================" << std::endl;

    return 0;
}
