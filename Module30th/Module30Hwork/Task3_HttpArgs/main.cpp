// M30.4 Task 3 — Запросы с аргументами (POST form / GET query string)
//
// Ввод: пары "key value" пока key != "post" и key != "get".
// Затем post → POST + form, get → GET + ?key=val&key=val.

#include <array>
#include <cstdio>
#include <iostream>
#include <map>
#include <memory>
#include <sstream>
#include <string>

constexpr const char* DEFAULT_BASE = "http://httpbin.org";

std::string urlEncode(const std::string& s) {
    std::ostringstream os;
    for (char c : s) {
        if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') ||
            (c >= '0' && c <= '9') || c == '-' || c == '_' || c == '.' || c == '~') {
            os << c;
        } else {
            char buf[4];
            std::snprintf(buf, sizeof(buf), "%%%02X", static_cast<unsigned char>(c));
            os << buf;
        }
    }
    return os.str();
}

std::string buildQuery(const std::map<std::string, std::string>& args) {
    std::string q;
    for (const auto& [k, v] : args) {
        if (!q.empty()) q += "&";
        q += urlEncode(k) + "=" + urlEncode(v);
    }
    return q;
}

std::string runCurl(const std::string& cmd) {
    std::array<char, 4096> buf{};
    std::string result;
    std::unique_ptr<FILE, int(*)(FILE*)> pipe(popen(cmd.c_str(), "r"), pclose);
    if (!pipe) return "";
    while (std::fgets(buf.data(), buf.size(), pipe.get()) != nullptr) {
        result += buf.data();
    }
    return result;
}

std::string sendPost(const std::string& base,
                     const std::map<std::string, std::string>& args) {
    std::string cmd = "curl -s -X POST '" + base + "/post'";
    for (const auto& [k, v] : args) {
        cmd += " -d '" + k + "=" + v + "'";
    }
    cmd += " 2>/dev/null";
    return runCurl(cmd);
}

std::string sendGet(const std::string& base,
                    const std::map<std::string, std::string>& args) {
    std::string url = base + "/get";
    std::string q = buildQuery(args);
    if (!q.empty()) url += "?" + q;
    std::string cmd = "curl -s '" + url + "' 2>/dev/null";
    return runCurl(cmd);
}

int main(int argc, char** argv) {
    std::string base = DEFAULT_BASE;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--base=", 0) == 0) base = a.substr(7);
    }

    std::map<std::string, std::string> args;
    std::string key, value;
    while (std::cin >> key) {
        if (key == "post" || key == "get") {
            std::cout << "=== " << key << " ===\n";
            std::string body = (key == "post") ? sendPost(base, args)
                                                : sendGet(base, args);
            std::cout << body;
            return 0;
        }
        if (!(std::cin >> value)) break;
        args[key] = value;
    }
    std::cerr << "ERROR: input must end with 'post' or 'get'\n";
    return 1;
}
