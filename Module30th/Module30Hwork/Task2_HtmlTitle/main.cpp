// M30.4 Task 2 — Захват заголовка HTML страницы
//
// Запрос http://httpbin.org/html с Accept: text/html, парсинг <h1>...</h1>.

#include <array>
#include <cstdio>
#include <iostream>
#include <memory>
#include <string>

constexpr const char* DEFAULT_URL = "http://httpbin.org/html";

std::string fetchHtml(const std::string& url) {
    std::string cmd = "curl -s -H 'Accept: text/html' '" + url + "' 2>/dev/null";
    std::array<char, 4096> buf{};
    std::string result;
    std::unique_ptr<FILE, int(*)(FILE*)> pipe(popen(cmd.c_str(), "r"), pclose);
    if (!pipe) return "";
    while (std::fgets(buf.data(), buf.size(), pipe.get()) != nullptr) {
        result += buf.data();
    }
    return result;
}

std::string extractH1(const std::string& html) {
    auto open = html.find("<h1>");
    if (open == std::string::npos) return "";
    auto start = open + 4;
    auto close = html.find("</h1>", start);
    if (close == std::string::npos) return "";
    return html.substr(start, close - start);
}

int main(int argc, char** argv) {
    std::string url = DEFAULT_URL;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--url=", 0) == 0) url = a.substr(6);
    }
    std::string body  = fetchHtml(url);
    std::string title = extractH1(body);
    if (title.empty()) {
        std::cout << "NOT FOUND\n";
        return 1;
    }
    std::cout << title << "\n";
    return 0;
}
