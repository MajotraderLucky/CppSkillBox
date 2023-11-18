#include <gtest/gtest.h>
#include "../knightsmove.h"

// Пишем тесты
TEST(ConvertDoubleToIntTest, PositiveNos) {
    EXPECT_EQ(0, convertDoubleToInt(0.0));
    EXPECT_EQ(5, convertDoubleToInt(0.5));
    EXPECT_EQ(3, convertDoubleToInt(100.3));
    EXPECT_EQ(7, convertDoubleToInt(12345678.7456));
}

// Основная функция
int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
