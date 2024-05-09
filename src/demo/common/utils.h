//
// Copyright (c) Zhanwei Wang (me@zhanwei.wang)
// Licenced under Apache License Version 2.0. See LICENSE for details.
//
#ifndef DEMO_SRC_DEMO_COMMON_UTILS_H
#define DEMO_SRC_DEMO_COMMON_UTILS_H

#include <string>

namespace demo {
/**
 * @brief Utility used to generate greeting information.
 */
class utils {
 public:
  /**
   * @brief Generate greeting information
   * @return Greeting information
   */
  std::string generate_greeting_string();
};
}  // namespace demo

#endif  // DEMO_SRC_DEMO_COMMON_UTILS_H
