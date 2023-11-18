#include <gtest/gtest.h>
#include "../photokiller.h"

// Test validateInput()
// Test validateInput()
TEST(ValidateInputTest, HandlesCorrectValues) {
  ASSERT_TRUE(validateInput(0));
  ASSERT_TRUE(validateInput(1));
  ASSERT_TRUE(validateInput(0.5));
}

TEST(ValidateInputTest, HandlesIncorrectValues) {
  ASSERT_FALSE(validateInput(-0.1));
  ASSERT_FALSE(validateInput(1.1));
  ASSERT_FALSE(validateInput(255));
}


int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
