// M33.5 Task 1 — корзина онлайн-магазина с std::invalid_argument / std::runtime_error.
//
// Команды:
//   stock <sku> <qty>        — пополнить склад (init phase)
//   add    <sku> <qty>       — добавить в корзину
//   remove <sku> <qty>       — убрать из корзины
//   list                     — показать корзину
//   exit                     — выход
//
// Errors:
//   invalid_argument — sku отсутствует на складе, qty <= 0
//   runtime_error    — qty превышает доступное (склад/корзина)

#include <iostream>
#include <map>
#include <sstream>
#include <stdexcept>
#include <string>

class Shop {
    std::map<std::string, int> stock_;       // склад
    std::map<std::string, int> cart_;        // корзина

public:
    void stock(const std::string& sku, int qty) {
        if (qty <= 0) throw std::invalid_argument("qty must be positive");
        stock_[sku] += qty;
    }

    void add(const std::string& sku, int qty) {
        if (qty <= 0) throw std::invalid_argument("qty must be positive");
        auto it = stock_.find(sku);
        if (it == stock_.end()) {
            throw std::invalid_argument("unknown sku: " + sku);
        }
        if (it->second < qty) {
            throw std::runtime_error("not enough on stock for sku: " + sku);
        }
        it->second -= qty;
        cart_[sku] += qty;
    }

    void remove(const std::string& sku, int qty) {
        if (qty <= 0) throw std::invalid_argument("qty must be positive");
        auto it = cart_.find(sku);
        if (it == cart_.end()) {
            throw std::invalid_argument("sku not in cart: " + sku);
        }
        if (it->second < qty) {
            throw std::runtime_error("not enough in cart for sku: " + sku);
        }
        it->second -= qty;
        stock_[sku] += qty;
        if (it->second == 0) cart_.erase(it);
    }

    void list(std::ostream& out) const {
        if (cart_.empty()) {
            out << "Cart is empty" << std::endl;
            return;
        }
        for (const auto& [sku, qty] : cart_) {
            out << sku << " " << qty << std::endl;
        }
    }
};

int main() {
    Shop shop;
    std::cerr << "Commands: stock|add|remove <sku> <qty> | list | exit" << std::endl;

    std::string line;
    while (std::getline(std::cin, line)) {
        std::istringstream iss(line);
        std::string cmd;
        if (!(iss >> cmd)) continue;
        if (cmd == "exit") break;

        try {
            if (cmd == "list") {
                shop.list(std::cout);
                continue;
            }

            std::string sku;
            int qty;
            if (!(iss >> sku >> qty)) {
                throw std::invalid_argument("usage: <cmd> <sku> <qty>");
            }

            if      (cmd == "stock")  shop.stock(sku, qty);
            else if (cmd == "add")    shop.add(sku, qty);
            else if (cmd == "remove") shop.remove(sku, qty);
            else throw std::invalid_argument("unknown cmd: " + cmd);

            std::cout << "OK" << std::endl;
        } catch (const std::invalid_argument& e) {
            std::cout << "Invalid: " << e.what() << std::endl;
        } catch (const std::runtime_error& e) {
            std::cout << "Runtime: " << e.what() << std::endl;
        }
    }
    return 0;
}
