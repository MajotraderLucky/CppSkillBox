// M28.4 Task 2 — Симуляция работы вокзала
#include <chrono>
#include <condition_variable>
#include <iostream>
#include <mutex>
#include <queue>
#include <string>
#include <thread>
#include <vector>

std::mutex                g_outMutex;
std::mutex                g_stationMutex;
std::queue<std::string>   g_departQueue;     // полученные команды depart
std::mutex                g_departMutex;
std::condition_variable   g_departCv;
bool                      g_inputDone = false;

void log(const std::string& msg) {
    std::lock_guard<std::mutex> lock(g_outMutex);
    std::cout << msg << "\n";
}

void train(std::string code, int travelMs) {
    log(code + " EN ROUTE");
    std::this_thread::sleep_for(std::chrono::milliseconds(travelMs));
    log(code + " ARRIVED (waiting station)");

    g_stationMutex.lock();
    log(code + " AT STATION");

    // Ждать команду depart для этого поезда
    {
        std::unique_lock<std::mutex> lk(g_departMutex);
        g_departCv.wait(lk, [&]{
            // Поищем нашу команду в очереди
            std::queue<std::string> tmp;
            bool found = false;
            while (!g_departQueue.empty()) {
                std::string cmd = g_departQueue.front();
                g_departQueue.pop();
                if (!found && cmd == code) {
                    found = true;
                } else {
                    tmp.push(cmd);
                }
            }
            g_departQueue = tmp;
            return found || g_inputDone;
        });
    }

    log(code + " DEPARTED");
    g_stationMutex.unlock();
}

int main(int argc, char** argv) {
    int travelScale = 1000;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--travel-ms=", 0) == 0) travelScale = std::stoi(a.substr(12));
    }

    int tA, tB, tC;
    std::cin >> tA >> tB >> tC;

    std::vector<std::thread> threads;
    threads.emplace_back(train, "A", tA * travelScale);
    threads.emplace_back(train, "B", tB * travelScale);
    threads.emplace_back(train, "C", tC * travelScale);

    // Цикл получения команд depart от пользователя
    std::string cmd;
    while (std::cin >> cmd) {
        if (cmd == "depart") {
            std::string trainId;
            std::cin >> trainId;
            {
                std::lock_guard<std::mutex> lk(g_departMutex);
                g_departQueue.push(trainId);
            }
            g_departCv.notify_all();
        }
    }
    {
        std::lock_guard<std::mutex> lk(g_departMutex);
        g_inputDone = true;
    }
    g_departCv.notify_all();

    for (auto& t : threads) t.join();
    log("ALL DONE");
    return 0;
}
