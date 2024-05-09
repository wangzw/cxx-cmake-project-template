FROM oraclelinux:9 as base

RUN yum install -y make which git flex bison rpm-build rpm-sign sudo tmux rsync graphviz \
      gcc-toolset-13 gcc-toolset-13-libasan-devel gcc-toolset-13-libasan-devel gcc-toolset-13-liblsan-devel \
      gcc-toolset-13-libtsan-devel gcc-toolset-13-libubsan-devel gcc-toolset-13-libatomic-devel \
      clang-tools-extra \
    && yum clean all \
    && ln -s /opt/rh/gcc-toolset-13/enable /etc/profile.d/gcc-toolset.sh \
    && /usr/bin/rm -f /etc/profile.d/which2.sh \
    && /usr/bin/rm -f /etc/profile.d/which2.csh

RUN curl -sSfL -o cmake-3.29.2-linux.sh \
      https://github.com/Kitware/CMake/releases/download/v3.29.2/cmake-3.29.2-linux-$(uname -m).sh \
    && bash cmake-3.29.2-linux.sh -- --prefix=/usr --skip-license \
    && /usr/bin/rm -f cmake-3.29.2-linux.sh

RUN <<EOF cat >>/opt/devel-toolchain.cmake
set(DEVELOP_COMPILER_ROOT /opt/rh/gcc-toolset-13/root)

set(CMAKE_C_COMPILER /opt/rh/gcc-toolset-13/root/usr/bin/gcc)
set(CMAKE_C_COMPILER_AR /opt/rh/gcc-toolset-13/root/usr/bin/ar)
set(CMAKE_C_COMPILER_RANLIB /opt/rh/gcc-toolset-13/root/usr/bin/ranlib)

set(CMAKE_CXX_COMPILER /opt/rh/gcc-toolset-13/root/usr/bin/g++)
set(CMAKE_CXX_COMPILER_AR /opt/rh/gcc-toolset-13/root/usr/bin/ar)
set(CMAKE_CXX_COMPILER_RANLIB /opt/rh/gcc-toolset-13/root/usr/bin/ranlib)

set(CMAKE_AR /opt/rh/gcc-toolset-13/root/usr/bin/ar)
set(CMAKE_RANLIB /opt/rh/gcc-toolset-13/root/usr/bin/ranlib)
set(CMAKE_LINKER /opt/rh/gcc-toolset-13/root/usr/bin/ld)

set(CMAKE_NM /opt/rh/gcc-toolset-13/root/usr/bin/nm)
set(CMAKE_OBJCOPY /opt/rh/gcc-toolset-13/root/usr/bin/objcopy)
set(CMAKE_OBJDUMP /opt/rh/gcc-toolset-13/root/usr/bin/objdump)
set(CMAKE_ADDR2LINE /opt/rh/gcc-toolset-13/root/usr/bin/addr2line)
set(CMAKE_READELF /opt/rh/gcc-toolset-13/root/usr/bin/readelf)
set(CMAKE_STRIP /opt/rh/gcc-toolset-13/root/usr/bin/strip)

set(GCOV_PATH /opt/rh/gcc-toolset-13/root/usr/bin/gcov)
set(CPPFILT_PATH /opt/rh/gcc-toolset-13/root/usr/bin/c++filt)

EOF


FROM base as build

COPY thirdparty/CMakeLists.txt /tmp/CMakeLists.txt

RUN mkdir -p /tmp/build \
    && cd /tmp/build \
    && cmake -DCMAKE_TOOLCHAIN_FILE=/opt/devel-toolchain.cmake .. \
    && make -j$(nproc --all)

FROM base

COPY --from=build /usr/local/ /usr/local/

RUN yum install -y python3-pip python-unversioned-command \
     && yum clean all

RUN pip3 install --no-cache-dir gcovr
