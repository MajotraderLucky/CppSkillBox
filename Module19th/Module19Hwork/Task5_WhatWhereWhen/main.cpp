#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

// Task 5 — Что? Где? Когда? (M19.5 hwork)
// 13 секторов. Каждый ход: ввод offset → вычислить новый сектор.
// Если сектор уже играл — взять следующий неигравший.
// Прочитать question_<N>.txt, ожидать ответ, сравнить с answer_<N>.txt.
// Победа: 6 баллов у игрока ИЛИ зрителей.

const int N_SECTORS = 13;
const int WIN_SCORE = 6;

std::string readFile(const std::string& path) {
    std::ifstream f(path);
    if (!f.is_open()) return "";
    std::stringstream ss;
    ss << f.rdbuf();
    return ss.str();
}

std::string trim(const std::string& s) {
    size_t start = 0;
    size_t end = s.length();
    while (start < end && (s[start] == ' ' || s[start] == '\n' || s[start] == '\r' || s[start] == '\t')) start++;
    while (end > start && (s[end-1] == ' ' || s[end-1] == '\n' || s[end-1] == '\r' || s[end-1] == '\t')) end--;
    return s.substr(start, end - start);
}

int main(int argc, char* argv[]) {
    std::string sectorsDir = "sectors/";
    if (argc > 1) sectorsDir = argv[1];
    if (sectorsDir.back() != '/') sectorsDir += '/';

    std::vector<bool> played(N_SECTORS, false);
    int currentSector = 0;
    int playerScore = 0;
    int audienceScore = 0;

    while (playerScore < WIN_SCORE && audienceScore < WIN_SCORE) {
        std::cerr << "[Score: player=" << playerScore << ", audience=" << audienceScore << "] ";
        std::cerr << "Enter offset to spin: ";
        int offset;
        if (!(std::cin >> offset)) {
            std::cerr << "Invalid input" << std::endl;
            return 1;
        }
        // Compute new sector with wrap-around
        int newSector = ((currentSector + offset) % N_SECTORS + N_SECTORS) % N_SECTORS;
        // If played, find next unplayed (cycling)
        int tries = 0;
        while (played[newSector] && tries < N_SECTORS) {
            newSector = (newSector + 1) % N_SECTORS;
            tries++;
        }
        if (tries >= N_SECTORS) {
            std::cout << "All sectors played. ";
            break;
        }
        currentSector = newSector;
        played[newSector] = true;

        std::string qPath = sectorsDir + "question_" + std::to_string(newSector + 1) + ".txt";
        std::string aPath = sectorsDir + "answer_" + std::to_string(newSector + 1) + ".txt";
        std::string question = readFile(qPath);
        std::string correctAnswer = trim(readFile(aPath));
        if (question.empty() || correctAnswer.empty()) {
            std::cerr << "Sector " << (newSector + 1) << " files missing" << std::endl;
            return 1;
        }

        std::cout << "Sector " << (newSector + 1) << " question: " << question << std::endl;
        std::cerr << "Your answer: ";
        std::string playerAnswer;
        std::cin >> playerAnswer;
        if (playerAnswer == correctAnswer) {
            playerScore++;
            std::cout << "Correct! Player +1" << std::endl;
        } else {
            audienceScore++;
            std::cout << "Wrong. Audience +1 (correct: " << correctAnswer << ")" << std::endl;
        }
    }

    if (playerScore >= WIN_SCORE) {
        std::cout << "Player wins! " << playerScore << "-" << audienceScore << std::endl;
    } else {
        std::cout << "Audience wins! " << audienceScore << "-" << playerScore << std::endl;
    }
    return 0;
}
