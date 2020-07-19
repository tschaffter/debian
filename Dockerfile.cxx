ARG version
FROM tschaffter/debian:user-${version}


RUN sudo apt-get update -qq -y \
    && sudo apt-get install --no-install-recommends -qq -y \
        gnupg2 \
        software-properties-common

# Install Python (cmake-format)
RUN sudo add-apt-repository ppa:deadsnakes/ppa
    # sudo apt-get update -qq -y \
    # && sudo apt-get install --no-install-recommends -qq -y \
    #     python3.9 \
    #     python3-pip \
    # && sudo ln -s -f "$(command -v python3.9)" /usr/bin/python \
    # && sudo ln -s -f "$(command -v pip3)" /usr/bin/pip \
    # && pip install \
    #     cmake-format==0.6.10

