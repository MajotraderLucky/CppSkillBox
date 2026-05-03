#pragma once

struct Point2D {
    double x = 0.0;
    double y = 0.0;
};

bool readPoint(Point2D& p);
void printPoint(const Point2D& p);
bool equalPoints(const Point2D& a, const Point2D& b);

void scalpel(const Point2D& start, const Point2D& end);
void hemostat(const Point2D& p);
void tweezers(const Point2D& p);
void suture(const Point2D& start, const Point2D& end);
