#include <iostream>
#include <sstream>
#include <string>

// Task 5 — Умный дом (M16.6 hwork)
// Симуляция за 2 дня (48 часов), пользователь вводит каждый час:
//   temp_inside temp_outside motion(yes/no) lights(on/off)
//
// Правила автоматов (bit mask switches):
//   temp_outside < 0   → WATER_PIPE_HEATING ON;  >  5  → OFF
//   16:00 ≤ time или time < 5:00 + motion=yes → LIGHTS_OUTSIDE ON; иначе OFF
//   temp_inside  < 22  → HEATERS ON;             ≥ 25  → HEATERS OFF
//   temp_inside  ≥ 30  → CONDITIONER ON;         = 25  → CONDITIONER OFF
//   16:00..20:00 → цветовая температура 5000K → 2700K (linear); 00:00 reset 5000K
//   Print только изменения состояния. LIGHTS_INSIDE не управляется автоматом
//   (это входное значение от пользователя), только цвет печатается если on.

enum switches {
    LIGHTS_INSIDE      = 1,
    LIGHTS_OUTSIDE     = 2,
    HEATERS            = 4,
    WATER_PIPE_HEATING = 8,
    CONDITIONER        = 16
};

// Helper: переключить флаг и напечатать сообщение, если состояние изменилось.
// Возвращает true если что-то изменилось.
bool setFlag(int& state, int flag, bool desired, const char* on_msg, const char* off_msg) {
    bool current = (state & flag) != 0;
    if (current == desired) return false;
    if (desired) state |= flag; else state &= ~flag;
    std::cout << (desired ? on_msg : off_msg) << std::endl;
    return true;
}

int colorTemperature(int hour) {
    // 16:00 → 5000K, 20:00 → 2700K (linear interp)
    // вне диапазона — 5000K
    if (hour < 16 || hour >= 20) return 5000;
    // hour = 16, 17, 18, 19 → 5000, 4425, 3850, 3275 (4 шага)
    // delta = (5000 - 2700) / 4 = 575 per hour
    return 5000 - 575 * (hour - 16);
}

int main() {
    int state = 0;

    for (int day = 0; day < 2; day++) {
        for (int hour = 0; hour < 24; hour++) {
            std::cerr << "Temperature inside, temperature outside, movement, lights:" << std::endl;
            std::string line;
            if (!std::getline(std::cin, line)) {
                if (line.empty()) return 0;  // EOF
            }
            if (line.empty() && !std::cin) return 0;
            std::stringstream ss(line);
            double t_in, t_out;
            std::string motion_str, lights_str;
            if (!(ss >> t_in >> t_out >> motion_str >> lights_str)) {
                std::cerr << "Parse error on hour " << hour << std::endl;
                return 1;
            }
            bool motion = (motion_str == "yes");
            bool lights_on = (lights_str == "on");

            // LIGHTS_INSIDE — пользовательский ввод. Не печатаем on/off (контролирует пользователь).
            if (lights_on) state |= LIGHTS_INSIDE;
            else state &= ~LIGHTS_INSIDE;

            // Обогрев водопровода
            if (t_out < 0) setFlag(state, WATER_PIPE_HEATING, true, "Water pipe heating ON!", "Water pipe heating OFF!");
            else if (t_out > 5) setFlag(state, WATER_PIPE_HEATING, false, "Water pipe heating ON!", "Water pipe heating OFF!");

            // Кондиционер (проверяем ДО HEATERS чтобы избежать конфликта)
            if (t_in >= 30) setFlag(state, CONDITIONER, true, "Conditioner ON!", "Conditioner OFF!");
            else if (t_in <= 25) setFlag(state, CONDITIONER, false, "Conditioner ON!", "Conditioner OFF!");

            // Отопление
            if (t_in < 22) setFlag(state, HEATERS, true, "Heaters ON!", "Heaters OFF!");
            else if (t_in >= 25) setFlag(state, HEATERS, false, "Heaters ON!", "Heaters OFF!");

            // Садовое освещение: вечер (16..23) или утро (0..4) + motion
            bool isEvening = (hour >= 16) || (hour < 5);
            bool needOutsideLight = isEvening && motion;
            setFlag(state, LIGHTS_OUTSIDE, needOutsideLight, "Lights outside ON!", "Lights outside OFF!");

            // Если LIGHTS_INSIDE on → печатаем цветовую температуру
            if (state & LIGHTS_INSIDE) {
                std::cout << "Color temperature: " << colorTemperature(hour) << "K" << std::endl;
            }
        }
    }
    return 0;
}
