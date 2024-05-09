//
// Copyright (c) Zhanwei Wang (me@zhanwei.wang)
// Licenced under Apache License Version 2.0. See LICENSE for details.
//
#include "demo/common/utils.h"

#include <gtest/gtest.h>

namespace {

using namespace demo;

TEST(common, utils) {
  utils u;
  EXPECT_EQ(u.generate_greeting_string(), "hello world");
}
}  // namespace
