ARG version
FROM tschaffter/debian:python-${version}

# Install required tools
RUN sudo apt-get update -qq -y \
    && sudo apt-get install --no-install-recommends -qq -y \
        gcc \
        g++ \
        ninja-build \
        git \
        lcov \
        curl \
        sudo \
        wget \
        clang-format-9 \
    && ln -s /usr/bin/clang-format-9 /usr/bin/clang-format \
    && mv /usr/bin/lsb_release /usr/bin/lsb_release.bak \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt-get/lists/*

# Install CMake
ARG CMAKE_VERSION=3.18
ARG CMAKE_BUILD=4
ARG CMAKE_INSTALL_DIR=/root
RUN cd $CMAKE_INSTALL_DIR \
    && wget https://cmake.org/files/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.$CMAKE_BUILD-Linux-x86_64.tar.gz  \
    && tar xzf cmake-$CMAKE_VERSION.$CMAKE_BUILD-Linux-x86_64.tar.gz  \
    && rm -rf cmake-$CMAKE_VERSION.$CMAKE_BUILD-Linux-x86_64.tar.gz  \
    && cd cmake-$CMAKE_VERSION.$CMAKE_BUILD-Linux-x86_64  \
    && ./bin/cmake --version

ENV PATH="${CMAKE_INSTALL_DIR}/cmake-${CMAKE_VERSION}.${CMAKE_BUILD}-Linux-x86_64/bin:${PATH}"

# Install cmake-format
RUN sudo pip install cmake-format==0.6.10