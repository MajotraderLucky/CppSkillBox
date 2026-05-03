// M21.5 Task 2 — Модель данных для посёлка.
// Иерархия структур + перечисления + расчёт coverage %.

#include <iostream>
#include <string>
#include <vector>

enum RoomType { living, children, kitchen, bathroom, bedroom };

struct Room {
    RoomType type;
    double area;            // м²
};

struct Floor {
    double ceilingHeight;   // м
    std::vector<Room> rooms;
};

struct Stove {
    double pipeHeight;      // м (труба)
};

struct House {
    double area;            // площадь дома
    std::vector<Floor> floors;
    bool hasStove = false;
    Stove stove;
};

struct Garage  { double area; };
struct Shed    { double area; };
struct Bath    { double area; bool hasStove = false; Stove stove; };

struct Plot {
    int    number;
    double area;            // общая площадь участка
    bool   hasHouse  = false; House  house;
    bool   hasGarage = false; Garage garage;
    bool   hasShed   = false; Shed   shed;
    bool   hasBath   = false; Bath   bath;
};

struct Village {
    std::vector<Plot> plots;
};

// Сумма площадей всех построек на участке.
double builtAreaOf(const Plot& p) {
    double s = 0.0;
    if (p.hasHouse)  s += p.house.area;
    if (p.hasGarage) s += p.garage.area;
    if (p.hasShed)   s += p.shed.area;
    if (p.hasBath)   s += p.bath.area;
    return s;
}

// Процент застроенности (по всему посёлку).
double coveragePercent(const Village& v) {
    double total = 0.0, built = 0.0;
    for (const auto& p : v.plots) {
        total += p.area;
        built += builtAreaOf(p);
    }
    if (total <= 0.0) return 0.0;
    return 100.0 * built / total;
}

// Парсер ввода (для unit-тестов).
// Формат:
//   <num_plots>
//   для каждого участка:
//     <plot_number> <plot_area>
//     <num_buildings>
//     для каждой постройки:
//       <type:house|garage|shed|bath>
//       специфичные поля
Village readVillage(std::istream& in) {
    Village v;
    int n;
    in >> n;
    for (int i = 0; i < n; ++i) {
        Plot p;
        in >> p.number >> p.area;
        int b;
        in >> b;
        for (int j = 0; j < b; ++j) {
            std::string kind;
            in >> kind;
            if (kind == "house") {
                p.hasHouse = true;
                in >> p.house.area;
                int floors;
                in >> floors;
                for (int k = 0; k < floors; ++k) {
                    Floor f;
                    int rooms;
                    in >> f.ceilingHeight >> rooms;
                    for (int r = 0; r < rooms; ++r) {
                        Room rm;
                        int t;
                        in >> t >> rm.area;
                        rm.type = static_cast<RoomType>(t);
                        f.rooms.push_back(rm);
                    }
                    p.house.floors.push_back(f);
                }
                int hasStove;
                in >> hasStove;
                p.house.hasStove = (hasStove != 0);
                if (p.house.hasStove) in >> p.house.stove.pipeHeight;
            } else if (kind == "garage") {
                p.hasGarage = true;
                in >> p.garage.area;
            } else if (kind == "shed") {
                p.hasShed = true;
                in >> p.shed.area;
            } else if (kind == "bath") {
                p.hasBath = true;
                in >> p.bath.area;
                int hasStove;
                in >> hasStove;
                p.bath.hasStove = (hasStove != 0);
                if (p.bath.hasStove) in >> p.bath.stove.pipeHeight;
            }
        }
        v.plots.push_back(p);
    }
    return v;
}

int main() {
    std::cerr << "Ввод модели посёлка:\n";
    Village v = readVillage(std::cin);

    std::cout << "plots=" << v.plots.size() << "\n";
    for (const auto& p : v.plots) {
        std::cout << "plot#" << p.number << " area=" << p.area
                  << " built=" << builtAreaOf(p);
        if (p.hasHouse) {
            std::cout << " floors=" << p.house.floors.size();
            int totalRooms = 0;
            for (const auto& f : p.house.floors) totalRooms += f.rooms.size();
            std::cout << " rooms=" << totalRooms;
        }
        std::cout << "\n";
    }
    // Округление до 2 знаков, чтобы тесты были детерминированы.
    double pct = coveragePercent(v);
    long rounded = static_cast<long>(pct * 100.0 + (pct >= 0 ? 0.5 : -0.5));
    std::cout << "coverage=" << (rounded / 100) << "." ;
    int frac = rounded % 100;
    if (frac < 10) std::cout << "0";
    std::cout << frac << "%\n";
    return 0;
}
