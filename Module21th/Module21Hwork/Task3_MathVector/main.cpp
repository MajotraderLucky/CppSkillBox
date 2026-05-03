// M21.5 Task 3 — 2D математический вектор.
// Команды: add, subtract, scale, length, normalize.

#include <cmath>
#include <iomanip>
#include <iostream>
#include <string>

struct Vec2 {
    double x = 0.0;
    double y = 0.0;
};

Vec2 add(Vec2 a, Vec2 b)        { return {a.x + b.x, a.y + b.y}; }
Vec2 subtract(Vec2 a, Vec2 b)   { return {a.x - b.x, a.y - b.y}; }
Vec2 scale(Vec2 a, double s)    { return {a.x * s, a.y * s}; }
double length(Vec2 a)           { return std::sqrt(a.x * a.x + a.y * a.y); }

Vec2 normalize(Vec2 a) {
    double L = length(a);
    if (L == 0.0) return {0.0, 0.0};
    return {a.x / L, a.y / L};
}

void printVec(Vec2 v) {
    std::cout << std::fixed << std::setprecision(4) << v.x << " " << v.y << "\n";
}

void printScalar(double s) {
    std::cout << std::fixed << std::setprecision(4) << s << "\n";
}

int main() {
    std::string cmd;
    std::cerr << "Команда (add/subtract/scale/length/normalize): ";
    if (!(std::cin >> cmd)) return 1;

    if (cmd == "add" || cmd == "subtract") {
        Vec2 a, b;
        std::cerr << "vec1 (x y): "; std::cin >> a.x >> a.y;
        std::cerr << "vec2 (x y): "; std::cin >> b.x >> b.y;
        Vec2 r = (cmd == "add") ? add(a, b) : subtract(a, b);
        printVec(r);
    } else if (cmd == "scale") {
        Vec2 a;
        double s;
        std::cerr << "vec (x y): "; std::cin >> a.x >> a.y;
        std::cerr << "scalar: ";    std::cin >> s;
        printVec(scale(a, s));
    } else if (cmd == "length") {
        Vec2 a;
        std::cerr << "vec (x y): "; std::cin >> a.x >> a.y;
        printScalar(length(a));
    } else if (cmd == "normalize") {
        Vec2 a;
        std::cerr << "vec (x y): "; std::cin >> a.x >> a.y;
        printVec(normalize(a));
    } else {
        std::cerr << "Неизвестная команда\n";
        return 1;
    }
    return 0;
}
