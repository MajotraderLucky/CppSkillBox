// M21.5 Task 4 — Пошаговая ролевая игра 20×20 (доп. задача).
// Команды хода: L/R/U/D, save, load.

#include <cstdlib>
#include <cstring>
#include <ctime>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

constexpr int MAP_W = 20;
constexpr int MAP_H = 20;
constexpr int N_ENEMIES = 5;
constexpr const char* SAVE_FILE = "save.bin";

struct Vec2i { int x = 0; int y = 0; };

struct Character {
    std::string name;
    int health = 0;
    int armor  = 0;
    int damage = 0;
    Vec2i position;
    bool isPlayer = false;
    bool alive() const { return health > 0; }
};

void applyDamage(Character& target, int dmg) {
    target.armor -= dmg;
    if (target.armor < 0) {
        target.health += target.armor;   // оставшийся урон
        target.armor = 0;
    }
    if (target.health < 0) target.health = 0;
}

bool inBounds(int x, int y) {
    return x >= 0 && x < MAP_W && y >= 0 && y < MAP_H;
}

int findAt(const std::vector<Character>& chars, int x, int y) {
    for (size_t i = 0; i < chars.size(); ++i) {
        if (chars[i].alive() &&
            chars[i].position.x == x && chars[i].position.y == y) {
            return static_cast<int>(i);
        }
    }
    return -1;
}

bool occupied(const std::vector<Character>& chars, int x, int y) {
    return findAt(chars, x, y) >= 0;
}

void placeRandom(std::vector<Character>& chars, Character& c) {
    while (true) {
        int x = std::rand() % MAP_W;
        int y = std::rand() % MAP_H;
        if (!occupied(chars, x, y)) {
            c.position = {x, y};
            return;
        }
    }
}

void renderMap(const std::vector<Character>& chars, std::ostream& out) {
    char grid[MAP_H][MAP_W];
    for (int y = 0; y < MAP_H; ++y)
        for (int x = 0; x < MAP_W; ++x)
            grid[y][x] = '.';
    for (const auto& c : chars) {
        if (!c.alive()) continue;
        grid[c.position.y][c.position.x] = c.isPlayer ? 'P' : 'E';
    }
    for (int y = 0; y < MAP_H; ++y) {
        for (int x = 0; x < MAP_W; ++x) out << grid[y][x];
        out << "\n";
    }
}

bool tryMoveOrAttack(std::vector<Character>& chars, int actorIdx, int dx, int dy) {
    Character& a = chars[actorIdx];
    if (!a.alive()) return false;
    int nx = a.position.x + dx;
    int ny = a.position.y + dy;
    if (!inBounds(nx, ny)) return false;     // ход пропускается

    int targetIdx = findAt(chars, nx, ny);
    if (targetIdx >= 0) {
        // Если враги пытаются атаковать друг друга — пропуск хода.
        if (!a.isPlayer && !chars[targetIdx].isPlayer) return false;
        applyDamage(chars[targetIdx], a.damage);
        return true;
    }
    a.position = {nx, ny};
    return true;
}

void enemyTurn(std::vector<Character>& chars, size_t i) {
    if (!chars[i].alive() || chars[i].isPlayer) return;
    int dir = std::rand() % 4;
    int dx = 0, dy = 0;
    switch (dir) {
        case 0: dx = -1; break;
        case 1: dx =  1; break;
        case 2: dy = -1; break;
        case 3: dy =  1; break;
    }
    tryMoveOrAttack(chars, static_cast<int>(i), dx, dy);
}

bool allEnemiesDead(const std::vector<Character>& chars) {
    for (const auto& c : chars)
        if (!c.isPlayer && c.alive()) return false;
    return true;
}

const Character* findPlayer(const std::vector<Character>& chars) {
    for (const auto& c : chars) if (c.isPlayer) return &c;
    return nullptr;
}

// ---------- Save/Load (binary) ----------

void writeString(std::ofstream& f, const std::string& s) {
    int len = static_cast<int>(s.length());
    f.write(reinterpret_cast<char*>(&len), sizeof(len));
    f.write(s.c_str(), len);
}

std::string readString(std::ifstream& f) {
    int len = 0;
    f.read(reinterpret_cast<char*>(&len), sizeof(len));
    std::string s;
    s.resize(len);
    if (len > 0) f.read(&s[0], len);
    return s;
}

void writeCharacter(std::ofstream& f, const Character& c) {
    writeString(f, c.name);
    f.write(reinterpret_cast<const char*>(&c.health),       sizeof(c.health));
    f.write(reinterpret_cast<const char*>(&c.armor),        sizeof(c.armor));
    f.write(reinterpret_cast<const char*>(&c.damage),       sizeof(c.damage));
    f.write(reinterpret_cast<const char*>(&c.position),     sizeof(c.position));
    char isP = c.isPlayer ? 1 : 0;
    f.write(&isP, 1);
}

void readCharacter(std::ifstream& f, Character& c) {
    c.name = readString(f);
    f.read(reinterpret_cast<char*>(&c.health),   sizeof(c.health));
    f.read(reinterpret_cast<char*>(&c.armor),    sizeof(c.armor));
    f.read(reinterpret_cast<char*>(&c.damage),   sizeof(c.damage));
    f.read(reinterpret_cast<char*>(&c.position), sizeof(c.position));
    char isP;
    f.read(&isP, 1);
    c.isPlayer = (isP != 0);
}

bool saveGame(const std::vector<Character>& chars, const std::string& path) {
    std::ofstream f(path, std::ios::binary);
    if (!f.is_open()) return false;
    int n = static_cast<int>(chars.size());
    f.write(reinterpret_cast<char*>(&n), sizeof(n));
    for (const auto& c : chars) writeCharacter(f, c);
    return true;
}

bool loadGame(std::vector<Character>& chars, const std::string& path) {
    std::ifstream f(path, std::ios::binary);
    if (!f.is_open()) return false;
    int n = 0;
    f.read(reinterpret_cast<char*>(&n), sizeof(n));
    if (n < 0 || n > 1000) return false;
    chars.clear();
    chars.resize(n);
    for (int i = 0; i < n; ++i) readCharacter(f, chars[i]);
    return true;
}

bool fileExists(const std::string& path) {
    std::ifstream f(path);
    return f.is_open();
}

// ---------- Init ----------

void spawnEnemies(std::vector<Character>& chars) {
    for (int i = 0; i < N_ENEMIES; ++i) {
        Character e;
        e.name     = "Enemy #" + std::to_string(i + 1);
        e.health   = 50  + std::rand() % 101;   // [50, 150]
        e.armor    = 0   + std::rand() % 51;    // [0, 50]
        e.damage   = 15  + std::rand() % 16;    // [15, 30]
        e.isPlayer = false;
        placeRandom(chars, e);
        chars.push_back(e);
    }
}

Character makePlayer(const std::string& name, int hp, int armor, int dmg) {
    Character p;
    p.name     = name;
    p.health   = hp;
    p.armor    = armor;
    p.damage   = dmg;
    p.isPlayer = true;
    return p;
}

// ---------- Main loop ----------

int main(int argc, char** argv) {
    bool noLoop = false;
    unsigned seed = static_cast<unsigned>(std::time(nullptr));
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a == "--once") noLoop = true;
        else if (a.rfind("--seed=", 0) == 0) {
            seed = static_cast<unsigned>(std::stoul(a.substr(7)));
        }
    }
    std::srand(seed);

    std::vector<Character> chars;

    std::string playerName;
    int hp, armor, dmg;
    std::cerr << "Имя игрока: "; std::cin >> playerName;
    std::cerr << "Жизни: ";       std::cin >> hp;
    std::cerr << "Броня: ";       std::cin >> armor;
    std::cerr << "Урон: ";        std::cin >> dmg;

    Character player = makePlayer(playerName, hp, armor, dmg);
    placeRandom(chars, player);
    chars.push_back(player);
    spawnEnemies(chars);

    int playerIdx = -1;
    for (size_t i = 0; i < chars.size(); ++i)
        if (chars[i].isPlayer) { playerIdx = static_cast<int>(i); break; }

    renderMap(chars, std::cout);

    while (true) {
        if (allEnemiesDead(chars)) { std::cout << "Победа\n"; break; }
        if (!chars[playerIdx].alive()) { std::cout << "Поражение\n"; break; }

        std::string cmd;
        std::cerr << "Команда (L/R/U/D/save/load/q): ";
        if (!(std::cin >> cmd)) break;

        if (cmd == "q") { std::cout << "Выход\n"; break; }
        if (cmd == "save") {
            std::cout << (saveGame(chars, SAVE_FILE) ? "Сохранено\n" : "Ошибка save\n");
            if (noLoop) break;
            continue;
        }
        if (cmd == "load") {
            if (!fileExists(SAVE_FILE)) {
                std::cout << "Файл не найден\n";
            } else if (loadGame(chars, SAVE_FILE)) {
                std::cout << "Загружено\n";
                for (size_t i = 0; i < chars.size(); ++i)
                    if (chars[i].isPlayer) { playerIdx = static_cast<int>(i); break; }
            } else {
                std::cout << "Ошибка load\n";
            }
            if (noLoop) break;
            continue;
        }

        int dx = 0, dy = 0;
        if (cmd == "L") dx = -1;
        else if (cmd == "R") dx =  1;
        else if (cmd == "U") dy = -1;
        else if (cmd == "D") dy =  1;
        else { std::cerr << "Неизвестная команда\n"; continue; }

        tryMoveOrAttack(chars, playerIdx, dx, dy);
        for (size_t i = 0; i < chars.size(); ++i) {
            if (static_cast<int>(i) == playerIdx) continue;
            enemyTurn(chars, i);
        }
        renderMap(chars, std::cout);
        if (noLoop) break;
    }
    return 0;
}
