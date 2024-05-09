//
// Copyright (c) Zhanwei Wang (me@zhanwei.wang)
// Licenced under Apache License Version 2.0. See LICENSE for details.
//
#ifndef DEMO_SRC_EXAMPLES_GRPC_GREETER_SERVICE_H
#define DEMO_SRC_EXAMPLES_GRPC_GREETER_SERVICE_H

#include "proto/helloworld.grpc.pb.h"

namespace helloworld {
class greeter_service : public Greeter::AsyncService {
 public:
};
}  // namespace helloworld

#endif  // DEMO_SRC_EXAMPLES_GRPC_GREETER_SERVICE_H
