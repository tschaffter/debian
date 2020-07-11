FROM debian:buster-20200607-slim

LABEL maintainer="thomas.schaffter@gmail.com"

ARG user=tschaffter
ENV miniconda3_version="py38_4.8.3"
ENV PATH="/home/${user}/miniconda3/bin:${PATH}"
ENV timezone="America/Los_Angeles"
ENV workdir=/root

# Required for non-interactive tzdata install
RUN ln -snf /usr/share/zoneinfo/${timezone} /etc/localtime \
    && echo ${timezone} > /etc/timezone

# Install dependencies
# hadolint ignore=DL3008
RUN apt-get update -qq -y && apt-get install --no-install-recommends -qq -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg2 \
    htop \
    software-properties-common \
    sudo \
    tmux \
    vim \
    wget \
    && update-ca-certificates \
    # Install Docker
    && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - \
    && add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable" \
    && apt-get update -qq -y \
    && apt-get install --no-install-recommends -qq -y docker-ce \
        docker-ce-cli \
        containerd.io \
    && rm -rf /var/lib/apt/lists/*

# Create user and set work directory
RUN useradd -m ${user} \
    && usermod -a -G sudo ${user} \
    && usermod -a -G docker ${user} \
    && echo "${user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${user} \
	&& chmod 0440 /etc/sudoers.d/${user}
USER ${user}
WORKDIR /home/${user}

# Create the initial structure of the persistent volume
RUN mkdir -p persist/.ssh && ln -s persist/.ssh . \
    && mkdir -p persist/dev && ln -s persist/dev . \
    && touch persist/.gitconfig && ln -s persist/.gitconfig . \
    && touch persist/.synapseConfig && ln -s persist/.synapseConfig .

# Install miniconda
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-${miniconda3_version}-Linux-x86_64.sh \
    && mkdir /home/${user}/.conda \
    && bash Miniconda3-${miniconda3_version}-Linux-x86_64.sh -b \
    && rm -f Miniconda3-${miniconda3_version}-Linux-x86_64.sh
RUN conda --version

# Create conda environments
RUN conda create --name synapse python=3.8 \
    && conda run --name synapse pip install \
    synapseclient==2.1.1 \
    challengeutils==2.2.0 \
    pandas==1.0.5
RUN /bin/bash -c "conda config --set auto_activate_base false \
    && conda init bash"