#include <iostream>
#include <vector>

// Task 3 — Top-5 smallest (M15.6 hwork)
// С клавиатуры вводятся числа. Когда пользователь вводит -1: вывести 5-е
// по возрастанию из всех введённых. -2: завершить.
//
// Optimization (требуется заданием): хранить только top-5 minimum.
// Если приходит число >= max в top-5 — отбросить. Иначе заменить max и пересортировать.
// Memory O(1) (constant 5), per-insert O(1) (constant 5 sort).

const int K = 5;

// Вставить val в top-5 vector (sorted ascending). Если уже 5 и val >= last → отбросить.
void insertTop(std::vector<int>& top, int val) {
    if (top.size() < static_cast<size_t>(K)) {
        // Ещё не заполнено — вставить с сохранением порядка
        size_t i = 0;
        while (i < top.size() && top[i] <= val) i++;
        top.insert(top.begin() + i, val);
        return;
    }
    // Уже 5 элементов — заменить только если val < max
    if (val >= top.back()) return;
    top.pop_back();
    size_t i = 0;
    while (i < top.size() && top[i] <= val) i++;
    top.insert(top.begin() + i, val);
}

int main() {
    std::vector<int> top;
    int x;
    std::cerr << "Enter numbers (-1 = print 5th smallest, -2 = exit): ";
    while (std::cin >> x) {
        if (x == -2) {
            break;
        }
        if (x == -1) {
            if (top.size() < static_cast<size_t>(K)) {
                std::cout << "Less than 5 numbers entered (have " << top.size() << ")" << std::endl;
            } else {
                std::cout << top[K - 1] << std::endl;
            }
            continue;
        }
        insertTop(top, x);
    }
    return 0;
}
