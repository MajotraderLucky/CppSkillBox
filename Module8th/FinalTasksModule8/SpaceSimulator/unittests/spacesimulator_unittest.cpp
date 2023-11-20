#include <gtest/gtest.h>
#include <string>
#include <sstream>
#include "../spacesimulator.h"

bool isValidInput(const std::string& input, float& output) {
    std::istringstream iss(input);
    if (!(iss >> output) || output <= 0) {
        return false;
    }
    return iss.eof();  // проверка на дополнительные символы после числа
}

TEST(ValidateInputTest, HandlesInvalidInput) {
    float output;

    ASSERT_FALSE(isValidInput("-1", output));
    ASSERT_FALSE(isValidInput("0", output));
    ASSERT_FALSE(isValidInput("abc", output));
    ASSERT_FALSE(isValidInput("1abc", output));
}

TEST(ValidateInputTest, HandlesValidInput) {
    float output;

    ASSERT_TRUE(isValidInput("1", output));
    ASSERT_FLOAT_EQ(output, 1.0f);
    
    ASSERT_TRUE(isValidInput("1.5", output));
    ASSERT_FLOAT_EQ(output, 1.5f);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
