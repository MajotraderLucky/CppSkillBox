#include <gtest/gtest.h>
#include <cmath>
#include "../pitchcontrol.h"  // замените на путь и имя вашего файла

// Определяем тестовый случай
TEST(ConvertDegreesToRadiansTest, NegativeMoreThan360) {
    double result = convertDegreesToRadians(-720.0);
    EXPECT_NEAR(result, -4 * M_PI, 0.000001);  // учитываем погрешность при работе с числами с плавающей точкой
}

// Основная функция
int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
