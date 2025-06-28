#include <iostream>
#include <string>

bool isValidTime(const std::string& time) {
    if (time.length() != 5) return false;
    if (time[2] != ':') return false;
    
    for (int i = 0; i < 5; ++i) {
        if (i == 2) continue;
        if (time[i] < '0' || time[i] > '9') return false;
    }
    
    int hours = (time[0] - '0') * 10 + (time[1] - '0');
    int minutes = (time[3] - '0') * 10 + (time[4] - '0');
    
    return (hours >= 0 && hours <= 23) && (minutes >= 0 && minutes <= 59);
}

int timeToMinutes(const std::string& time) {
    int hours = (time[0] - '0') * 10 + (time[1] - '0');
    int minutes = (time[3] - '0') * 10 + (time[4] - '0');
    return hours * 60 + minutes;
}

void minutesToTime(int totalMinutes, int& hours, int& minutes) {
    hours = totalMinutes / 60;
    minutes = totalMinutes % 60;
}

int main() {
    std::string departure, arrival;
    
    while (true) {
        std::cout << "Введите время отправления (HH:MM): ";
        std::cin >> departure;
        
        if (isValidTime(departure)) {
            break;
        } else {
            std::cout << "Неверный формат времени. Используйте формат HH:MM (например, 09:30)" << std::endl;
        }
    }
    
    while (true) {
        std::cout << "Введите время прибытия (HH:MM): ";
        std::cin >> arrival;
        
        if (isValidTime(arrival)) {
            break;
        } else {
            std::cout << "Неверный формат времени. Используйте формат HH:MM (например, 15:45)" << std::endl;
        }
    }
    
    int departureMinutes = timeToMinutes(departure);
    int arrivalMinutes = timeToMinutes(arrival);
    
    int travelTime;
    if (arrivalMinutes >= departureMinutes) {
        travelTime = arrivalMinutes - departureMinutes;
    } else {
        travelTime = (24 * 60) - departureMinutes + arrivalMinutes;
    }
    
    int hours, minutes;
    minutesToTime(travelTime, hours, minutes);
    
    std::cout << "Поездка составила " << hours << " ч. " << minutes << " мин." << std::endl;
    
    return 0;
}