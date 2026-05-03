// M26.4 Task 3 — Window manager (80x50 screen)
#include <iostream>
#include <string>

class Window {
    static constexpr int SCREEN_W = 80;
    static constexpr int SCREEN_H = 50;

    int x_ = 0, y_ = 0;
    int w_ = 10, h_ = 5;
    bool open_ = true;

    int clampX(int v) const {
        if (v < 0) return 0;
        if (v >= SCREEN_W) return SCREEN_W - 1;
        return v;
    }
    int clampY(int v) const {
        if (v < 0) return 0;
        if (v >= SCREEN_H) return SCREEN_H - 1;
        return v;
    }

public:
    int x() const { return x_; }
    int y() const { return y_; }
    int width()  const { return w_; }
    int height() const { return h_; }
    bool isOpen() const { return open_; }
    static int screenW() { return SCREEN_W; }
    static int screenH() { return SCREEN_H; }

    void move(int dx, int dy) {
        x_ = clampX(x_ + dx);
        y_ = clampY(y_ + dy);
        // Также подрезать размер если выходит за границу
        if (x_ + w_ > SCREEN_W) w_ = SCREEN_W - x_;
        if (y_ + h_ > SCREEN_H) h_ = SCREEN_H - y_;
        std::cout << "MOVED to (" << x_ << "," << y_ << ")\n";
    }

    void resize(int nw, int nh) {
        if (nw < 0) nw = 0;
        if (nh < 0) nh = 0;
        if (x_ + nw > SCREEN_W) nw = SCREEN_W - x_;
        if (y_ + nh > SCREEN_H) nh = SCREEN_H - y_;
        w_ = nw;
        h_ = nh;
        std::cout << "RESIZED to " << w_ << "x" << h_ << "\n";
    }

    void display() const {
        for (int row = 0; row < SCREEN_H; ++row) {
            for (int col = 0; col < SCREEN_W; ++col) {
                bool inside = (col >= x_ && col < x_ + w_ &&
                               row >= y_ && row < y_ + h_);
                std::cout << (inside ? '1' : '0');
            }
            std::cout << "\n";
        }
    }

    void close() {
        open_ = false;
        std::cout << "CLOSED\n";
    }
};

int main() {
    Window win;
    std::string cmd;
    while (std::cin >> cmd) {
        if (cmd == "move") {
            int dx, dy;
            std::cin >> dx >> dy;
            win.move(dx, dy);
        } else if (cmd == "resize") {
            int nw, nh;
            std::cin >> nw >> nh;
            win.resize(nw, nh);
        } else if (cmd == "display") {
            win.display();
        } else if (cmd == "close") {
            win.close();
            return 0;
        } else {
            std::cerr << "Unknown: " << cmd << "\n";
        }
    }
    return 0;
}
