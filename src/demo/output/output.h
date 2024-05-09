//
// Copyright (c) Zhanwei Wang (me@zhanwei.wang)
// Licenced under Apache License Version 2.0. See LICENSE for details.
//
#ifndef DEMO_SRC_DEMO_OUTPUT_OUTPUT_H
#define DEMO_SRC_DEMO_OUTPUT_OUTPUT_H

#include <iostream>

namespace demo {
/**
 * @brief Output information to output stream.
 */
class output {
 public:
  /**
   * @brief Write information to given output stream. demo#greeting()
   * @param os The output stream write to.
   * @param str The information to write.
   * @return Return reference of this object.
   */
  output& write(std::ostream& os, std::string_view str);
};
}  // namespace demo

#endif  // DEMO_SRC_DEMO_OUTPUT_OUTPUT_H
