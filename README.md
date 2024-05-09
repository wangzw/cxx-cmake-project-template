# Demo

This is a cmake based C++ demo project.
You can quickly and easily boostrap a new C++ cmake project from this git repository.

## Motivation

It is not easy to set up a new C++ repository from scratch.
This repository is a good start, and you can build your project from here.

## Features

This demo project include almost everything that a rigorous project should have.

* CMake support
* Code sanitizer
* Code coverage
* GoogleTest and Google Benchmark support
* Doxygen and a builtin theme
* Clang format and clang tidy support
* CMake ExternalProject based third party management
* CPack based package support
* Dev Container support
* Github workflows support
* Integration of all above

## Usage

1. Clone this repository `git clone https://github.com/wangzw/cxx-cmake-project-template.git`
2. Run `bootstrap.sh YourProjectName` to change project name
3. Update project information in top level CMakeLists.txt

Now, you are almost done to bootstrap a new project.
And then you can set up your development environment with [DevContainer](https://containers.dev/)
or just start a Docker container using `docker compose`

With DevContainer:
```shell
devcontainer up --workspace-folder .
```

With Docker compose:
```shell
docker compose up -d
```

And now you have a container based development environment with all dependencies.

## CMake support

Some CMake functions and predefined targets are created to ease of use of CMake.

This follow functions are used to add your targets. 
Replace `xxx` to your project name in lower case.
They have covered many details such as clang-tidy, code coverage, code sanitizer and installation.

```cmake
xxx_add_library()
xxx_add_executable()
xxx_add_example()
xxx_add_test()
xxx_add_benchmark()
```

And there are also some predefined targets:

* test - to run all tests
* benchmark - to run benchmark tests.
* docs - to build doxygen based documents.
* check_public_header - to check integration of installed headers.
* coverage - to generate html format code coverage report
* coverage-xml - to generate xml format code coverage report

## Build your own docker image

When you add your own third party dependencies into `thirdparty/CMakeLists.txt` or update Dockerfile,
you need to build your own docker image.

1. Update image name in `docker-compose.yml` and workflow files in `.github/workflows/`.
2. Build your own docker image with `docker build -t your-image-name .`

You can build and push your own docker image to your image repository manually. 
Or build your image using Github workflows.
Check workflow file `.github/workflows/image.yml` for details.
