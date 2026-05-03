#include <iostream>
#include <fstream>
#include <cstdlib>
#include <ctime>

// Task 4 — ATM simulation (M20.5)
// Купюры: 100/200/500/1000/2000/5000. Max 1000 купюр.
// State в .bin file (массив счётчиков по номиналам).
// Команды: + (заполнить случайно), - (снять кратно 100), q (выход).

const int N_DENOMS = 6;
const int DENOMS[N_DENOMS] = {100, 200, 500, 1000, 2000, 5000};
const int MAX_BILLS = 1000;

struct State {
    int counts[N_DENOMS] = {0, 0, 0, 0, 0, 0};
};

bool loadState(const std::string& path, State& s) {
    std::ifstream f(path, std::ios::binary);
    if (!f.is_open()) return false;
    f.read(reinterpret_cast<char*>(s.counts), sizeof(s.counts));
    return f.gcount() == sizeof(s.counts);
}

void saveState(const std::string& path, const State& s) {
    std::ofstream f(path, std::ios::binary);
    f.write(reinterpret_cast<const char*>(s.counts), sizeof(s.counts));
}

int totalBills(const State& s) {
    int sum = 0;
    for (int i = 0; i < N_DENOMS; i++) sum += s.counts[i];
    return sum;
}

long long totalAmount(const State& s) {
    long long sum = 0;
    for (int i = 0; i < N_DENOMS; i++) sum += (long long)s.counts[i] * DENOMS[i];
    return sum;
}

void printState(const State& s) {
    for (int i = 0; i < N_DENOMS; i++) {
        std::cout << DENOMS[i] << ":" << s.counts[i] << " ";
    }
    std::cout << "Total: " << totalAmount(s) << std::endl;
}

void fill(State& s) {
    int remaining = MAX_BILLS - totalBills(s);
    for (int i = 0; i < remaining; i++) {
        int idx = std::rand() % N_DENOMS;
        s.counts[idx]++;
    }
}

bool withdraw(State& s, long long amount) {
    if (amount % 100 != 0 || amount <= 0) return false;
    // Greedy: брать с купюр большего номинала
    int needed[N_DENOMS] = {0, 0, 0, 0, 0, 0};
    long long left = amount;
    for (int i = N_DENOMS - 1; i >= 0; i--) {
        int can = std::min((long long)s.counts[i], left / DENOMS[i]);
        needed[i] = can;
        left -= (long long)can * DENOMS[i];
    }
    if (left != 0) return false;
    for (int i = 0; i < N_DENOMS; i++) s.counts[i] -= needed[i];
    return true;
}

int main(int argc, char* argv[]) {
    std::string path = "atm.bin";
    int seed = 0;
    if (argc > 1) path = argv[1];
    if (argc > 2) seed = std::atoi(argv[2]);

    State s;
    if (loadState(path, s)) {
        std::cout << "Loaded state. ";
        printState(s);
    } else {
        std::cout << "Empty ATM" << std::endl;
    }

    if (seed == 0) std::srand(std::time(nullptr));
    else std::srand(seed);

    std::string cmd;
    while (std::cin >> cmd) {
        if (cmd == "q") break;
        if (cmd == "+") {
            fill(s);
            std::cout << "Filled. ";
            printState(s);
        } else if (cmd == "-") {
            long long amount;
            if (!(std::cin >> amount)) {
                std::cout << "Invalid amount" << std::endl;
                continue;
            }
            if (withdraw(s, amount)) {
                std::cout << "Withdrew " << amount << ". ";
                printState(s);
            } else {
                std::cout << "Cannot withdraw " << amount << std::endl;
            }
        } else {
            std::cout << "Unknown command" << std::endl;
        }
    }
    saveState(path, s);
    std::cout << "State saved" << std::endl;
    return 0;
}
