#include "tools.h"

#include <cmath>
#include <iostream>

bool readPoint(Point2D& p) {
    return static_cast<bool>(std::cin >> p.x >> p.y);
}

void printPoint(const Point2D& p) {
    std::cout << "(" << p.x << "," << p.y << ")";
}

bool equalPoints(const Point2D& a, const Point2D& b) {
    constexpr double EPS = 1e-9;
    return std::fabs(a.x - b.x) < EPS && std::fabs(a.y - b.y) < EPS;
}

void scalpel(const Point2D& start, const Point2D& end) {
    std::cout << "SCALPEL: cut from ";
    printPoint(start);
    std::cout << " to ";
    printPoint(end);
    std::cout << "\n";
}

void hemostat(const Point2D& p) {
    std::cout << "HEMOSTAT: clamp at ";
    printPoint(p);
    std::cout << "\n";
}

void tweezers(const Point2D& p) {
    std::cout << "TWEEZERS: pick at ";
    printPoint(p);
    std::cout << "\n";
}

void suture(const Point2D& start, const Point2D& end) {
    std::cout << "SUTURE: stitch from ";
    printPoint(start);
    std::cout << " to ";
    printPoint(end);
    std::cout << "\n";
}
