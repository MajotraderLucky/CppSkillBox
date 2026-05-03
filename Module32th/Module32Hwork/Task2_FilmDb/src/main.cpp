// M32.5 Task 2 — анализ JSON-базы фильмов: поиск актёра по подстроке имени.
// Использует nlohmann/json (single header).
//
// Команды:
//   <CLI flag>:  --db=<path>    путь к JSON-базе (по умолчанию ./films.json)
//   <CLI flag>:  --query=<str>  выполнить один поиск и выйти (для тестов)
//
// Без --query — интерактивный режим:
//   введите подстроку имени актёра → программа выведет фильмы и роли;
//   пустая строка / "exit" → выход.

#include <algorithm>
#include <cctype>
#include <fstream>
#include <iostream>
#include <nlohmann/json.hpp>
#include <string>

using json = nlohmann::json;

static std::string toLower(const std::string& s) {
    std::string r = s;
    std::transform(r.begin(), r.end(), r.begin(),
                   [](unsigned char c) { return std::tolower(c); });
    return r;
}

// Возвращает true если хоть одно совпадение нашлось.
static bool searchActor(const json& db, const std::string& query, std::ostream& out) {
    const std::string q = toLower(query);
    bool anyHit = false;
    for (auto it = db.begin(); it != db.end(); ++it) {
        const std::string& filmTitle = it.key();
        const json&        info      = it.value();
        if (!info.contains("cast") || !info["cast"].is_array()) continue;
        for (const auto& member : info["cast"]) {
            if (!member.contains("actor") || !member.contains("role")) continue;
            const std::string actor = member["actor"].get<std::string>();
            if (toLower(actor).find(q) != std::string::npos) {
                out << filmTitle << " | " << actor << " as "
                    << member["role"].get<std::string>() << "\n";
                anyHit = true;
            }
        }
    }
    return anyHit;
}

int main(int argc, char** argv) {
    std::string dbPath = "films.json";
    std::string queryArg;
    bool        oneShot = false;

    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--db=", 0) == 0) {
            dbPath = a.substr(5);
        } else if (a.rfind("--query=", 0) == 0) {
            queryArg = a.substr(8);
            oneShot  = true;
        }
    }

    std::ifstream in(dbPath);
    if (!in) {
        std::cerr << "Cannot open " << dbPath << "\n";
        return 1;
    }
    json db;
    try {
        in >> db;
    } catch (const std::exception& e) {
        std::cerr << "JSON parse error: " << e.what() << "\n";
        return 1;
    }
    if (!db.is_object()) {
        std::cerr << "Database root must be an object" << "\n";
        return 1;
    }

    if (oneShot) {
        if (!searchActor(db, queryArg, std::cout)) {
            std::cout << "No matches" << "\n";
        }
        return 0;
    }

    std::cerr << "Films loaded: " << db.size() << "\n";
    std::cerr << "Enter actor name (substring) or 'exit':" << "\n";

    std::string line;
    while (std::getline(std::cin, line)) {
        if (line.empty() || line == "exit") break;
        if (!searchActor(db, line, std::cout)) {
            std::cout << "No matches" << "\n";
        }
    }
    return 0;
}
