// M28.4 Task 3 — Кухня онлайн-ресторана
#include <atomic>
#include <chrono>
#include <cstdlib>
#include <iostream>
#include <mutex>
#include <queue>
#include <string>
#include <thread>

constexpr int N_DELIVERIES = 10;
const std::string DISHES[] = { "Pizza", "Soup", "Steak", "Salad", "Sushi" };

std::mutex                g_outMutex;
std::mutex                g_kitchenMutex;
std::mutex                g_readyMutex;
std::queue<std::string>   g_ready;
std::atomic<int>          g_delivered{0};
std::atomic<bool>         g_done{false};

void log(const std::string& msg) {
    std::lock_guard<std::mutex> lock(g_outMutex);
    std::cout << msg << "\n";
}

void cookDish(std::string dish, int cookMs) {
    std::lock_guard<std::mutex> lock(g_kitchenMutex);
    log("COOK " + dish);
    std::this_thread::sleep_for(std::chrono::milliseconds(cookMs));
    log("READY " + dish);
    {
        std::lock_guard<std::mutex> lk(g_readyMutex);
        g_ready.push(dish);
    }
}

int main(int argc, char** argv) {
    int orderMs = 50, cookMs = 30, courierMs = 200;
    unsigned seed = 42;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--order-ms=",   0) == 0) orderMs   = std::stoi(a.substr(11));
        if (a.rfind("--cook-ms=",    0) == 0) cookMs    = std::stoi(a.substr(10));
        if (a.rfind("--courier-ms=", 0) == 0) courierMs = std::stoi(a.substr(13));
        if (a.rfind("--seed=",       0) == 0) seed      = std::stoul(a.substr(7));
    }
    std::srand(seed);

    // Поток заказов
    std::thread orderThread([&]{
        while (!g_done.load()) {
            std::this_thread::sleep_for(std::chrono::milliseconds(orderMs));
            std::string dish = DISHES[std::rand() % 5];
            log("ORDER " + dish);
            std::thread t(cookDish, dish, cookMs);
            t.detach();
        }
    });

    // Поток курьера
    std::thread courierThread([&]{
        while (!g_done.load()) {
            std::this_thread::sleep_for(std::chrono::milliseconds(courierMs));
            std::lock_guard<std::mutex> lk(g_readyMutex);
            while (!g_ready.empty()) {
                std::string dish = g_ready.front();
                g_ready.pop();
                ++g_delivered;
                log("DELIVER " + dish + " (#" + std::to_string(g_delivered.load()) + ")");
                if (g_delivered.load() >= N_DELIVERIES) {
                    g_done.store(true);
                    return;
                }
            }
        }
    });

    courierThread.join();
    g_done.store(true);
    orderThread.join();
    log("RESTAURANT CLOSED");
    return 0;
}
