// M26.4 Task 1 — Audio player
#include <ctime>
#include <cstdlib>
#include <iostream>
#include <string>
#include <vector>

class Track {
    std::string name_;
    std::tm     date_{};
    int         duration_;
public:
    Track(std::string n, int year, int mon, int day, int dur)
        : name_(std::move(n)), duration_(dur) {
        date_.tm_year = year - 1900;
        date_.tm_mon  = mon - 1;
        date_.tm_mday = day;
    }
    const std::string& name() const { return name_; }
    int duration() const { return duration_; }
    void printInfo() const {
        std::cout << "TRACK: " << name_
                  << " (" << (date_.tm_year + 1900) << "-"
                  << (date_.tm_mon + 1) << "-" << date_.tm_mday
                  << ", " << duration_ << "s)\n";
    }
};

class Player {
    std::vector<Track> tracks_;
    int  current_  = -1;          // индекс текущего трека (-1 если нет)
    bool playing_  = false;
    bool paused_   = false;
public:
    void addTrack(const Track& t) { tracks_.push_back(t); }
    int  size() const { return static_cast<int>(tracks_.size()); }

    void play(const std::string& name) {
        if (playing_ && !paused_) return;     // уже играет
        for (size_t i = 0; i < tracks_.size(); ++i) {
            if (tracks_[i].name() == name) {
                current_ = static_cast<int>(i);
                playing_ = true;
                paused_  = false;
                tracks_[i].printInfo();
                return;
            }
        }
        std::cout << "NOT FOUND: " << name << "\n";
    }

    void pause() {
        if (!playing_ || paused_) return;
        paused_ = true;
        std::cout << "PAUSED: " << tracks_[current_].name() << "\n";
    }

    void next() {
        if (tracks_.empty()) return;
        current_ = std::rand() % static_cast<int>(tracks_.size());
        playing_ = true;
        paused_  = false;
        std::cout << "NEXT (shuffle): ";
        tracks_[current_].printInfo();
    }

    void stop() {
        if (!playing_) return;
        std::cout << "STOPPED: " << tracks_[current_].name() << "\n";
        playing_ = false;
        paused_  = false;
        current_ = -1;
    }
};

int main(int argc, char** argv) {
    unsigned seed = 42;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--seed=", 0) == 0) seed = std::stoul(a.substr(7));
    }
    std::srand(seed);

    Player p;
    p.addTrack(Track("Song1", 2024, 1, 15, 180));
    p.addTrack(Track("Song2", 2024, 5, 20, 240));
    p.addTrack(Track("Song3", 2025, 3, 10, 200));

    std::string cmd;
    while (std::cin >> cmd) {
        if (cmd == "play") {
            std::string name;
            std::cin >> name;
            p.play(name);
        } else if (cmd == "pause") {
            p.pause();
        } else if (cmd == "next") {
            p.next();
        } else if (cmd == "stop") {
            p.stop();
        } else if (cmd == "exit") {
            std::cout << "EXIT\n";
            return 0;
        } else {
            std::cerr << "Unknown: " << cmd << "\n";
        }
    }
    return 0;
}
