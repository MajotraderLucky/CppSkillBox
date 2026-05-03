// M29.4 Task 2 — Интерфейс Shape с virtual методами
#include <cmath>
#include <iostream>
#include <string>

struct BoundingBoxDimensions {
    double width;
    double height;
};

class Shape {
public:
    virtual ~Shape() = default;
    virtual double                 square()     = 0;
    virtual BoundingBoxDimensions  dimensions() = 0;
    virtual std::string            type()       = 0;
};

class Circle : public Shape {
    double r_;
public:
    explicit Circle(double r) : r_(r) {}
    double square() override { return std::atan(1) * 4 * r_ * r_; }
    BoundingBoxDimensions dimensions() override { return {2 * r_, 2 * r_}; }
    std::string type() override { return "Circle"; }
};

class Rectangle : public Shape {
    double w_, h_;
public:
    Rectangle(double w, double h) : w_(w), h_(h) {}
    double square() override { return w_ * h_; }
    BoundingBoxDimensions dimensions() override { return {w_, h_}; }
    std::string type() override { return "Rectangle"; }
};

class Triangle : public Shape {
    double a_, b_, c_;
    double area() const {
        double p = (a_ + b_ + c_) / 2.0;
        return std::sqrt(p * (p - a_) * (p - b_) * (p - c_));
    }
public:
    Triangle(double a, double b, double c) : a_(a), b_(b), c_(c) {}
    double square() override { return area(); }
    BoundingBoxDimensions dimensions() override {
        double R = (a_ * b_ * c_) / (4.0 * area());
        double side = 2 * R;
        return {side, side};
    }
    std::string type() override { return "Triangle"; }
};

void printParams(Shape* shape) {
    std::cout << "Type: "   << shape->type() << "\n"
              << "Square: " << shape->square() << "\n"
              << "Width: "  << shape->dimensions().width << "\n"
              << "Height: " << shape->dimensions().height << "\n";
}

int main() {
    std::cout.setf(std::ios::fixed);
    std::cout.precision(2);

    std::string cmd;
    while (std::cin >> cmd) {
        if (cmd == "exit") { std::cout << "EXIT\n"; return 0; }
        if (cmd == "circle") {
            double r; std::cin >> r;
            Circle c(r);
            printParams(&c);
        } else if (cmd == "rectangle") {
            double w, h; std::cin >> w >> h;
            Rectangle r(w, h);
            printParams(&r);
        } else if (cmd == "triangle") {
            double a, b, c; std::cin >> a >> b >> c;
            Triangle t(a, b, c);
            printParams(&t);
        } else {
            std::cerr << "Unknown: " << cmd << "\n";
        }
    }
    return 0;
}
