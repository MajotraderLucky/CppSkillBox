// M27.4 Task 2 — Симуляция работы компании
#include <cstdlib>
#include <iostream>
#include <string>
#include <vector>

class Worker {
    std::string name_;
    bool busy_ = false;
    char task_ = ' ';
public:
    Worker(std::string n) : name_(std::move(n)) {}
    bool isBusy() const { return busy_; }
    const std::string& name() const { return name_; }
    void assign(char taskType) {
        busy_ = true;
        task_ = taskType;
        std::cout << "Worker " << name_ << " assigned task " << taskType << "\n";
    }
};

class Manager {
    std::string name_;
    int          id_;
    std::vector<Worker> workers_;
public:
    Manager(std::string n, int id) : name_(std::move(n)), id_(id) {}
    void hireWorkers(int count, const std::string& prefix) {
        for (int i = 0; i < count; ++i) {
            workers_.emplace_back(prefix + "-" + std::to_string(i + 1));
        }
    }
    int unassignedCount() const {
        int n = 0;
        for (const auto& w : workers_) if (!w.isBusy()) ++n;
        return n;
    }
    void allDone() {
        std::cout << "Manager " << name_ << " — все workers заняты\n";
    }
    bool process(int command) {
        std::cout << "Manager " << name_ << " получил команду " << command << "\n";
        std::srand(static_cast<unsigned>(command + id_));
        int tasksCount = std::rand() % (static_cast<int>(workers_.size()) + 1);
        for (int i = 0; i < tasksCount; ++i) {
            for (auto& w : workers_) {
                if (!w.isBusy()) {
                    char t = "ABC"[std::rand() % 3];
                    w.assign(t);
                    break;
                }
            }
        }
        return unassignedCount() == 0;
    }
};

class CEO {
    std::string name_;
    std::vector<Manager> managers_;
public:
    CEO(std::string n) : name_(std::move(n)) {}
    void hireManagers(int n, int workersPerTeam) {
        for (int i = 0; i < n; ++i) {
            Manager m("Mgr" + std::to_string(i + 1), i + 1);
            m.hireWorkers(workersPerTeam, "W" + std::to_string(i + 1));
            managers_.push_back(std::move(m));
        }
    }
    bool issueCommand(int cmd) {
        std::cout << "CEO " << name_ << " issues command " << cmd << "\n";
        bool allBusy = true;
        for (auto& m : managers_) {
            if (!m.process(cmd)) allBusy = false;
        }
        return allBusy;
    }
};

int main() {
    int teams, perTeam;
    std::cin >> teams >> perTeam;
    CEO ceo("Boss");
    ceo.hireManagers(teams, perTeam);

    int cmd;
    while (std::cin >> cmd) {
        if (ceo.issueCommand(cmd)) {
            std::cout << "ALL WORKERS BUSY\n";
            return 0;
        }
    }
    return 0;
}
