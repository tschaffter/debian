# Dockerized Debian environments

![ci](https://github.com/tschaffter/debian/workflows/ci/badge.svg)
[![Docker](https://img.shields.io/badge/docker-tschaffter%2Fdebian-blue)](https://hub.docker.com/repository/docker/tschaffter/debian)
[![GitHub tag](https://img.shields.io/badge/release-20200802-blue)](https://github.com/tschaffter/debian/releases/tag/20200802)

Deploying reproducible, short-lived Debian development environments anywhere.

## Motivation

The current release of WSL and Mingw-w64 have strong limitations in terms of
enabling me to develop on Windows 10, so I opted for deploying my development
environments using Docker.

The benefits of this approach are:

| Property | Description |
|---|---|
| Cross-platform | Bring your dev environments to any hosts that have Docker installed. |
| Stability | Detect early if installing an update breaks your environment (CI/CD). |
| Security | Use short-lived environment instances; only add to `Dockerfile.*` the dependencies that you really need. |
| Provenance | If you know the date when you deployed an environment, you can retrieve the version of all the system dependencies used.\* |
| Reproducibility | Deploy past versions of your environments. |

\* Assumes that the `latest` version of the environment available at that time has been
deployed. The script `debian.sh` is provided to garantee that by running
`docker-compose pull` before deploying the environment selected.

## Usage

Use the script `debian.sh <environment> <version>` to start the environment
that matches the name and version specified. The following commands are
equivalent.

```console
bash debian.sh user latest
bash debian.sh user
```

It is recommended to add `debian.sh` to your `PATH` so you can run environments
from anywhere.

The value of `<version>` can be set to any git tags for which Docker images have
been successfully pushed to DockerHub. For example,

```console
bash debian.sh user 20200713
```

When using `Git Bash` on Windows 10, use the following command:

```console
winpty bash debian.sh user 20200713
```

Press CTRL+P followed by CTRL+Q to detatch from the container. To attach to the
running container:

```console
docker attach <container_id>
```

Enter `exit` or press CTRL+C followed by CTRL+D to exit and stop the container.

## Building the environments locally

The file `docker-compose.yml` includes the arguments required to build the
images locally (e.g. for testing). The value of the variables referenced by
`docker-compose.yml` should be specified using variable substitution. For
example, `user=tschaffter bash debian.sh user local`.

To build and start the environment `base` defined by `Dockerfile.base`:

```console
$ bash debian.sh base local
Pulling base ... done
Step 1/8 : FROM debian:buster-20200607-slim
...
Successfully tagged tschaffter/debian:base-local
root@base:/tmp#
```

Here `local` is the value given to the variable `version`. Because the
image `tschaffter/debian:base-local` does not exists on Docker Hub or any other
Docker registries you may be logged in to, the above command
builds the environment using the instructions specified in `docker-compose.yml`.

Building other environments may require to set the value of additional variables
such as the environment `user` that requires to set the variable `user`.

```console
$ user=tschaffter bash debian.sh user local
Pulling user ... done
Step 1/10 : ARG version
...
Successfully tagged tschaffter/debian:user-local
tschaffter@user:~$
```

Alternatively, you can also build multiple environment using
`docker-compose build`:

```console
user=tschaffter version=local docker-compose build \
    base user docker python synapse node
```

before starting the environment of your choice:

```console
bash debian.sh node local
```

## Creating your own environments

1. Fork and clone this repository.
2. Update the environments or create new ones (`Dockerfile.*`).
3. Update `docker-compose.yml` to account for the updated/new environments.
4. Update the GitHub Action `ci.yml`.

    - Replace the occurrence of `tschaffter` by your username.
    - Update to account for the updated/new environments.

5. Update the content of the file `VERSION`.
6. Set the GitHub secret `DOCKER_USERNAME` and `DOCKER_PASSWORD` used in `ci.yml`
to the credentials of a DockerHub account (service/machine user suggested).
7. After committing the changes, tag the commit to create a release.

    ```console
    tag -a 20200713
    git push origin 20200713
    ```

8. Run one of the environments once the GitHub Action `ci.yml` has successfully
completed.

    ```console
    $ ./debian.sh user
    Pulling user   ... done
    Pulling docker ... done
    tschaffter@user:~$
    ```

## Developing with VS Code inside a dev container

The article [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers)
describes how to use your local VS Code to develop inside a container.

### Usage

1. Install the VS Code extension [Remote - Container](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Start the `python` dev environment: `./debian python local`
3. In VS Code, click on the green button "Open a remote window" located on the
bottom-left corner
4. Select `Rmote-Containers: Attach to Running Container...`
5. Select the container named `/debian_python_run_<container ID>`

### VS Code extensions

VS Code runs extensions in one of two places: locally on the UI / client side,
or in the container. While extensions that affect the VS Code UI, like themes
and snippets, are installed locally, most extensions will reside inside a
particular container. This allows you to install only the extensions you need
for a given task in a container and seamlessly switch your entire tool-chain
just by connecting to a new container.

VS Code keeps tracks of the extensions installed in the containers in
configuration files saved on the host. The extensions installed are associated
to the **name of the Docker image** used to create a given container. Each time
you used VS Code to access a new container created from the same Docker image
name, you will always find that the extensions previously installed in
past containers based on the same Docker image are already installed.

See VS Code section [Managing extensions](https://code.visualstudio.com/docs/remote/containers#_managing-extensions)
for more information on how to manage extension when using VS Code to develop
in a container.

## Configuration

### Generating a new GPG key

A GPG key is required to sign git commits. Follow the instructions given in
GitHub's article [Generating a new GPG key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-gpg-key)
to generate a new key and then to get the GPG key ID.

```console
gpg --list-secret-keys --keyid-format LONG
```

### Git

```console
git config --list --show-origin
git config --global user.name tschaffter
git config --global user.email thomas.schaffter@gmail.com
git config --global commit.gpgsign true
git config --global user.signingkey <GPG key ID>
```

## Acknowledgement

Thanks to Aaron Hayden ([@ahayden](https://github.com/ahayden)) for sharing his
[repository](https://github.com/ahayden/debuerreotype/tree/037869977855fe6473e3f2096dbff650968df441)
that implements the approach this project is based on.
