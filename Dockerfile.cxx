ARG version
FROM tschaffter/debian:python-${version}

ARG clang_format_version="11"

# Install build tools
RUN sudo apt-get update -qq -y \
    && sudo apt-get install --no-install-recommends -qq -y \
        cmake \
        g++ \
        gcc \
        lcov \
        ninja-build \
    && sudo apt-get -y autoclean \
    && sudo apt-get -y autoremove \
    && sudo rm -rf /var/lib/apt-get/lists/*

# Install cmake-format
RUN sudo pip install cmake-format==0.6.10

# Install clang-format (buster is several versions behind)
RUN sudo apt-get update -qq -y \
    && sudo apt-get install --no-install-recommends -qq -y \
        gnupg2 \
        software-properties-common \
    && curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add - \
    && sudo add-apt-repository \
        "deb [arch=amd64] https://apt.llvm.org/$(lsb_release -cs) \
        llvm-toolchain-buster-11 \
        main" \
    && sudo apt-get update -qq -y \
    && sudo apt-get install --no-install-recommends -qq -y \
        clang-format-${clang_format_version} \
    && sudo update-alternatives --install \
        /usr/bin/clang-format clang-format /usr/bin/clang-format-${clang_format_version} 10 \
    && sudo apt-get -y autoclean \
    && sudo apt-get -y autoremove \
    && sudo rm -rf /var/lib/apt-get/lists/*