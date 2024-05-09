//
// Copyright (c) Zhanwei Wang (me@zhanwei.wang)
// Licenced under Apache License Version 2.0. See LICENSE for details.
//
#include "demo/output/output.h"

#include <gtest/gtest.h>

namespace {

using namespace demo;

TEST(output, write) {
  output o;
  std::stringstream ss;
  o.write(ss, "hello world");
  EXPECT_EQ(ss.str(), "hello world");
}
}  // namespace
