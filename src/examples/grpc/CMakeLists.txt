cmake_minimum_required(VERSION 3.27)

find_package(protobuf CONFIG REQUIRED)
find_package(gRPC CONFIG REQUIRED)

add_library(grpc_proto OBJECT proto/helloworld.proto)

protobuf_generate(TARGET grpc_proto
        LANGUAGE cpp
        OUT_VAR PROTO_GENERATED_FILES
        IMPORT_DIRS ${CMAKE_CURRENT_SOURCE_DIR}
        PROTOC_OUT_DIR ${CMAKE_CURRENT_BINARY_DIR}
)

protobuf_generate(TARGET grpc_proto
        LANGUAGE grpc
        OUT_VAR PROTO_GRPC_GENERATED_FILES
        GENERATE_EXTENSIONS .grpc.pb.h .grpc.pb.cc
        PLUGIN "protoc-gen-grpc=\$<TARGET_FILE:gRPC::grpc_cpp_plugin>"
        IMPORT_DIRS ${CMAKE_CURRENT_SOURCE_DIR}
        PROTOC_OUT_DIR ${CMAKE_CURRENT_BINARY_DIR}
)

target_include_directories(grpc_proto PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(grpc_proto PUBLIC gRPC::grpc gRPC::grpc++)

demo_add_example(TARGET grpc_server FILES grpc_server.cpp greeter_service.h greeter_service.cpp)
target_link_libraries(grpc_server grpc_proto)

demo_add_example(TARGET grpc_client FILES grpc_client.cpp proto/helloworld.proto)
target_link_libraries(grpc_client grpc_proto)
