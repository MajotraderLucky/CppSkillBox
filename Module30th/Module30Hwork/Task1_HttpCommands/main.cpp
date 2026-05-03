// M30.4 Task 1 — Пользовательские HTTP-запросы к httpbin.org
//
// Реализация через popen("curl ...") вместо CPR — same контракт, без
// тяжелой FetchContent-сборки. Production submission: подменить httpRequest
// на cpr::Get/Post/Put/Delete/Patch.

#include <array>
#include <cstdio>
#include <iostream>
#include <memory>
#include <string>

constexpr const char* BASE_URL = "http://httpbin.org";

// Выполнить HTTP-метод через curl. method = "GET"/"POST"/"PUT"/"DELETE"/"PATCH".
// Возвращает body ответа (или сообщение ошибки).
std::string httpRequest(const std::string& method, const std::string& path) {
    std::string cmd = "curl -s -X " + method + " '" + BASE_URL + path + "' 2>&1";
    std::array<char, 4096> buf{};
    std::string result;
    std::unique_ptr<FILE, int(*)(FILE*)> pipe(popen(cmd.c_str(), "r"), pclose);
    if (!pipe) return "ERROR: popen failed";
    while (std::fgets(buf.data(), buf.size(), pipe.get()) != nullptr) {
        result += buf.data();
    }
    return result;
}

int main() {
    std::cerr << "Команды: get/post/put/delete/patch/exit\n";
    std::string cmd;
    while (std::cin >> cmd) {
        if (cmd == "exit") {
            std::cout << "EXIT\n";
            return 0;
        }
        std::string method, path;
        if      (cmd == "get")    { method = "GET";    path = "/get"; }
        else if (cmd == "post")   { method = "POST";   path = "/post"; }
        else if (cmd == "put")    { method = "PUT";    path = "/put"; }
        else if (cmd == "delete") { method = "DELETE"; path = "/delete"; }
        else if (cmd == "patch")  { method = "PATCH";  path = "/patch"; }
        else {
            std::cerr << "Unknown: " << cmd << "\n";
            continue;
        }
        std::cout << "=== " << method << " " << path << " ===\n";
        std::cout << httpRequest(method, path);
    }
    return 0;
}
