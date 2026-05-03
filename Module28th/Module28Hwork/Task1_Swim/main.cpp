// M28.4 Task 1 — Заплыв на 100 метров
#include <algorithm>
#include <chrono>
#include <iostream>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

constexpr int    DISTANCE = 100;
constexpr int    LANES    = 6;

struct Result {
    std::string name;
    int         seconds;
};

std::mutex             g_outMutex;
std::mutex             g_resultsMutex;
std::vector<Result>    g_results;

void swim(std::string name, double speed, int tickMs) {
    int t = 0;
    double covered = 0.0;
    while (covered < DISTANCE) {
        ++t;
        covered += speed;
        if (covered > DISTANCE) covered = DISTANCE;
        {
            std::lock_guard<std::mutex> lock(g_outMutex);
            std::cout << "T=" << t << "s " << name << " " << covered << "m\n";
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(tickMs));
    }
    {
        std::lock_guard<std::mutex> lock(g_resultsMutex);
        g_results.push_back({name, t});
    }
}

int main(int argc, char** argv) {
    int tickMs = 1000;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--tick-ms=", 0) == 0) tickMs = std::stoi(a.substr(10));
    }

    std::vector<std::string> names(LANES);
    std::vector<double>      speeds(LANES);
    for (int i = 0; i < LANES; ++i) std::cin >> names[i];
    for (int i = 0; i < LANES; ++i) std::cin >> speeds[i];

    std::vector<std::thread> threads;
    for (int i = 0; i < LANES; ++i) {
        threads.emplace_back(swim, names[i], speeds[i], tickMs);
    }
    for (auto& t : threads) t.join();

    std::sort(g_results.begin(), g_results.end(),
              [](const Result& a, const Result& b) { return a.seconds < b.seconds; });

    std::cout << "RESULTS\n";
    for (const auto& r : g_results) {
        std::cout << r.name << " " << r.seconds << "s\n";
    }
    return 0;
}
