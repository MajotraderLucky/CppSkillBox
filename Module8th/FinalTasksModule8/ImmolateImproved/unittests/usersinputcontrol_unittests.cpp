#include <gtest/gtest.h>
#include <sstream>
#include <iostream>
#include "../usersinputcontrol.hpp"

TEST(ProcessUserInputTest, HandlesDigitsOnly) {
    EXPECT_EQ(processUserInput("0.5"), std::make_pair(0.5, false));
}

TEST(ProcessUserInputTest, HandlesDigitsAndDot) {
    EXPECT_EQ(processUserInput("0.1.2"), std::make_pair(0.0, false));
}

TEST(ProcessUserInputTest, HandlesStopCommand) {
    EXPECT_EQ(processUserInput("stop"), std::make_pair(0.0, true));
}

TEST(ProcessUserInputTest, HandlesOutOfRange) {
    EXPECT_EQ(processUserInput("1.5"), std::make_pair(0.0, false));
}

TEST(ProcessUserInputTest, HandlesInvalidInput) {
    EXPECT_EQ(processUserInput("abc"), std::make_pair(0.0, false));
}

TEST(ProcessUserInputTest, HandlesEmptyString) {
    EXPECT_EQ(processUserInput(""), std::make_pair(0.0, false));
}

TEST(ProcessUserInputTest, IncorrectInput) {
    std::stringstream ss;
    auto oldCoutBuffer = std::cout.rdbuf();  // сохраняем оригинальный буфер
    std::cout.rdbuf(ss.rdbuf());  // перенаправляем cout в наш stringstream

ASSERT_FALSE(processUserInput("incorrect_input").second);
    std::string output = ss.str();
    std::cout.rdbuf(oldCoutBuffer);  // возвращаем оригинальный буфер

    ASSERT_EQ(output, "");
}
