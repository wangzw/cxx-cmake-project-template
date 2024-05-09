//
// Copyright (c) Zhanwei Wang (me@zhanwei.wang)
// Licenced under Apache License Version 2.0. See LICENSE for details.
//
#include "demo/output/output.h"

namespace demo {
output& output::write(std::ostream& os, std::string_view str) {
  os << str;
  return *this;
}
}  // namespace demo
