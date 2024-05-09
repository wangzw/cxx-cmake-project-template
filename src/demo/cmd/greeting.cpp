//
// Copyright (c) Zhanwei Wang (me@zhanwei.wang)
// Licenced under Apache License Version 2.0. See LICENSE for details.
//
#include "demo/cmd/greeting.h"

#include <iostream>

#include "demo/common/utils.h"
#include "demo/output/output.h"

namespace demo {
void greeting() {
  utils u;
  output o;
  o.write(std::cout, u.generate_greeting_string());
}
}  // namespace demo