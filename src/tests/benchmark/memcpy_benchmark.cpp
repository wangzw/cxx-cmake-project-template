//
// Copyright (c) Zhanwei Wang (me@zhanwei.wang)
// Licenced under Apache License Version 2.0. See LICENSE for details.
//
#include <benchmark/benchmark.h>

#include <cstring>

namespace {
void memcpy_benchmark(benchmark::State& state) {
  char* src = new char[state.range(0)];
  char* dst = new char[state.range(0)];
  ::memset(src, 'x', state.range(0));

  for (auto _ : state) {
    ::memcpy(dst, src, state.range(0));
  }

  state.SetBytesProcessed(int64_t(state.iterations()) *
                          int64_t(state.range(0)));
  delete[] src;
  delete[] dst;
}

BENCHMARK(memcpy_benchmark)->RangeMultiplier(2)->Range(8, 8 << 10);
}  // namespace
