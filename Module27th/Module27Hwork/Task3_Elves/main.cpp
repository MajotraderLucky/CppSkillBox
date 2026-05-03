// M27.4 Task 3 — Деревня эльфов
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <string>
#include <vector>

class Branch {
public:
    Branch*              parent  = nullptr;
    std::vector<Branch*> children;
    std::string          elfName;     // пустая строка = нет эльфа

    Branch(Branch* p = nullptr) : parent(p) {}

    ~Branch() {
        for (Branch* c : children) delete c;
    }

    bool isTree() const          { return parent == nullptr; }
    bool isBigBranch() const     { return parent && parent->parent == nullptr; }
    bool isMediumBranch() const  { return parent && parent->parent && parent->parent->parent == nullptr; }

    Branch* getTopBranch() {
        if (parent == nullptr) return nullptr;
        if (parent->parent == nullptr) return this;
        return parent->getTopBranch();
    }

    // Рекурсивный поиск ветви, содержащей эльфа с данным именем.
    Branch* findElf(const std::string& name) {
        if (elfName == name) return this;
        for (Branch* c : children) {
            Branch* found = c->findElf(name);
            if (found) return found;
        }
        return nullptr;
    }

    // Подсчитать всех эльфов в этой ветви и поддереве.
    int countElves() const {
        int n = (elfName.empty() ? 0 : 1);
        for (const Branch* c : children) n += c->countElves();
        return n;
    }
};

// Создать дерево с 3-5 большими ветвями, в каждой 2-3 средние ветви.
// Дома эльфов — на больших и средних ветвях.
Branch* makeTree() {
    Branch* tree = new Branch(nullptr);
    int bigCount = 3 + std::rand() % 3;     // [3, 5]
    for (int i = 0; i < bigCount; ++i) {
        Branch* big = new Branch(tree);
        tree->children.push_back(big);
        int medCount = 2 + std::rand() % 2; // [2, 3]
        for (int j = 0; j < medCount; ++j) {
            Branch* med = new Branch(big);
            big->children.push_back(med);
        }
    }
    return tree;
}

// Обход всех домов (большие + средние ветви), запрос имени эльфа.
void populate(Branch* node) {
    if (!node->isTree()) {
        std::cerr << "Эльф для дома (введите None для пропуска): ";
        std::string name;
        if (!(std::cin >> name)) return;
        if (name != "None") node->elfName = name;
    }
    for (Branch* c : node->children) populate(c);
}

int main(int argc, char** argv) {
    unsigned seed = 42;
    std::string forcedTarget;
    bool        hasForcedTarget = false;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--seed=", 0) == 0) seed = std::stoul(a.substr(7));
        else if (a.rfind("--target=", 0) == 0) {
            forcedTarget    = a.substr(9);
            hasForcedTarget = true;
        }
    }
    std::srand(seed);

    constexpr int N_TREES = 5;
    std::vector<Branch*> forest;
    for (int i = 0; i < N_TREES; ++i) forest.push_back(makeTree());

    for (Branch* t : forest) populate(t);

    std::string target;
    if (hasForcedTarget) {
        target = forcedTarget;
    } else {
        std::cerr << "Имя искомого эльфа: ";
        if (!(std::cin >> target)) return 1;
    }

    Branch* found = nullptr;
    for (Branch* t : forest) {
        found = t->findElf(target);
        if (found) break;
    }

    if (!found) {
        std::cout << "NOT FOUND\n";
    } else {
        Branch* topBranch = found->isBigBranch() ? found : found->getTopBranch();
        int total = topBranch->countElves();
        std::cout << "NEIGHBOURS: " << (total - 1) << "\n";
    }

    for (Branch* t : forest) delete t;
    return 0;
}
