// M33.5 Task 3 — шаблонный реестр Registry<Key, Value>.
//
// Команды (для всех вариантов типов: int|double|string):
//   add    <key> <value>     — добавить пару
//   remove <key>             — удалить ВСЕ пары с этим ключом
//   find   <key>             — вывести все значения по ключу
//   print                    — вывести все пары
//   exit                     — выход
//
// Тип реестра выбирается через CLI:
//   --types=int,int          (default)
//   --types=string,int
//   --types=string,string
//   --types=int,double
//   --types=double,string
//   ... и т.д.

#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

template <typename K, typename V>
class Registry {
    std::vector<std::pair<K, V>> data_;

public:
    void add(const K& key, const V& value) {
        data_.emplace_back(key, value);
    }

    int remove(const K& key) {
        int removed = 0;
        for (auto it = data_.begin(); it != data_.end(); ) {
            if (it->first == key) {
                it = data_.erase(it);
                ++removed;
            } else {
                ++it;
            }
        }
        return removed;
    }

    void find(const K& key, std::ostream& out) const {
        bool any = false;
        for (const auto& [k, v] : data_) {
            if (k == key) {
                out << v << std::endl;
                any = true;
            }
        }
        if (!any) out << "(no entries)" << std::endl;
    }

    void print(std::ostream& out) const {
        if (data_.empty()) { out << "(empty)" << std::endl; return; }
        for (const auto& [k, v] : data_) {
            out << k << " " << v << std::endl;
        }
    }
};

template <typename K, typename V>
K readKey(std::istringstream& iss) {
    K key;
    if (!(iss >> key)) throw std::invalid_argument("bad key");
    return key;
}

template <typename K, typename V>
V readVal(std::istringstream& iss) {
    V val;
    if (!(iss >> val)) throw std::invalid_argument("bad value");
    return val;
}

template <typename K, typename V>
void runRepl(std::istream& in, std::ostream& out) {
    Registry<K, V> reg;
    std::string line;
    while (std::getline(in, line)) {
        std::istringstream iss(line);
        std::string cmd;
        if (!(iss >> cmd)) continue;
        if (cmd == "exit") break;
        try {
            if (cmd == "add") {
                K k = readKey<K, V>(iss);
                V v = readVal<K, V>(iss);
                reg.add(k, v);
                out << "OK" << std::endl;
            } else if (cmd == "remove") {
                K k = readKey<K, V>(iss);
                int n = reg.remove(k);
                out << "removed " << n << std::endl;
            } else if (cmd == "find") {
                K k = readKey<K, V>(iss);
                reg.find(k, out);
            } else if (cmd == "print") {
                reg.print(out);
            } else {
                out << "Unknown: " << cmd << std::endl;
            }
        } catch (const std::exception& e) {
            out << "Err: " << e.what() << std::endl;
        }
    }
}

int main(int argc, char** argv) {
    std::string types = "int,int";
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--types=", 0) == 0) types = a.substr(8);
    }

    if      (types == "int,int")          runRepl<int, int>(std::cin, std::cout);
    else if (types == "int,double")       runRepl<int, double>(std::cin, std::cout);
    else if (types == "int,string")       runRepl<int, std::string>(std::cin, std::cout);
    else if (types == "double,int")       runRepl<double, int>(std::cin, std::cout);
    else if (types == "double,double")    runRepl<double, double>(std::cin, std::cout);
    else if (types == "double,string")    runRepl<double, std::string>(std::cin, std::cout);
    else if (types == "string,int")       runRepl<std::string, int>(std::cin, std::cout);
    else if (types == "string,double")    runRepl<std::string, double>(std::cin, std::cout);
    else if (types == "string,string")    runRepl<std::string, std::string>(std::cin, std::cout);
    else {
        std::cerr << "Unsupported types: " << types << std::endl;
        return 1;
    }
    return 0;
}
