#include <gtest/gtest.h>
#include <sstream>
#include "../elevator.h"

// Тестирование getValidatedInput()
TEST(GetValidatedInputTest, ValidatesPositiveHeight) {
    std::istringstream input("100.0\n");
    std::ostringstream output;
    double result = getValidatedInput(input, output);
    EXPECT_EQ(result, 100.0);
}

TEST(GetValidatedInputTest, ValidatesNegativeHeight) {
    std::istringstream input("-100.0\n100.0\n");
    std::ostringstream output;
    double result = getValidatedInput(input, output);
    EXPECT_EQ(result, 100.0);
}

TEST(GetValidatedInputTest, ValidatesZeroHeight) {
    std::istringstream input("0\n100.0\n");
    std::ostringstream output;
    double result = getValidatedInput(input, output);
    EXPECT_EQ(result, 100.0);
}

TEST(GetValidatedInputTest, ValidatesNonNumericInput) {
    std::istringstream input("abc\n100.0\n");
    std::ostringstream output;
    double result = getValidatedInput(input, output);
    EXPECT_EQ(result, 100.0);
}
