// M27.4 Task 1 — Иерархия геометрических фигур
#include <cmath>
#include <iostream>
#include <string>

enum Color { ColorNone, Red, Green, Blue };

const char* colorName(Color c) {
    switch (c) {
        case Red:   return "Red";
        case Green: return "Green";
        case Blue:  return "Blue";
        default:    return "None";
    }
}

Color parseColor(const std::string& s) {
    if (s == "Red")   return Red;
    if (s == "Green") return Green;
    if (s == "Blue")  return Blue;
    return ColorNone;
}

class Shape {
protected:
    double x_ = 0, y_ = 0;
    Color  color_ = ColorNone;
public:
    Shape(double x, double y, Color c) : x_(x), y_(y), color_(c) {}
    virtual ~Shape() = default;

    virtual double area() const = 0;
    virtual void   bbox(double& w, double& h) const = 0;

    void print(const std::string& kind) const {
        double w, h;
        bbox(w, h);
        std::cout << kind << " color=" << colorName(color_)
                  << " area=" << area()
                  << " bbox=" << w << "x" << h << "\n";
    }
};

class Circle : public Shape {
    double radius_;
public:
    Circle(double x, double y, Color c, double r) : Shape(x, y, c), radius_(r) {}
    double area() const override { return std::atan(1) * 4 * radius_ * radius_; }
    void bbox(double& w, double& h) const override { w = h = 2 * radius_; }
};

class Square : public Shape {
    double side_;
public:
    Square(double x, double y, Color c, double s) : Shape(x, y, c), side_(s) {}
    double area() const override { return side_ * side_; }
    void bbox(double& w, double& h) const override { w = h = side_; }
};

class Triangle : public Shape {
    double side_;
public:
    Triangle(double x, double y, Color c, double s) : Shape(x, y, c), side_(s) {}
    double area() const override { return side_ * side_ * std::sqrt(3.0) / 4.0; }
    void bbox(double& w, double& h) const override {
        w = side_;
        h = side_ * std::sqrt(3.0) / 2.0;
    }
};

class Rectangle : public Shape {
    double w_, h_;
public:
    Rectangle(double x, double y, Color c, double w, double h)
        : Shape(x, y, c), w_(w), h_(h) {}
    double area() const override { return w_ * h_; }
    void bbox(double& w, double& h) const override { w = w_; h = h_; }
};

int main() {
    std::cout.setf(std::ios::fixed);
    std::cout.precision(2);

    std::string cmd;
    while (std::cin >> cmd) {
        if (cmd == "exit") { std::cout << "EXIT\n"; return 0; }

        double x, y, p1, p2;
        std::string colorStr;

        if (cmd == "circle") {
            std::cin >> x >> y >> colorStr >> p1;
            Circle s(x, y, parseColor(colorStr), p1);
            s.print("CIRCLE");
        } else if (cmd == "square") {
            std::cin >> x >> y >> colorStr >> p1;
            Square s(x, y, parseColor(colorStr), p1);
            s.print("SQUARE");
        } else if (cmd == "triangle") {
            std::cin >> x >> y >> colorStr >> p1;
            Triangle s(x, y, parseColor(colorStr), p1);
            s.print("TRIANGLE");
        } else if (cmd == "rectangle") {
            std::cin >> x >> y >> colorStr >> p1 >> p2;
            Rectangle s(x, y, parseColor(colorStr), p1, p2);
            s.print("RECTANGLE");
        } else {
            std::cerr << "Unknown: " << cmd << "\n";
        }
    }
    return 0;
}
