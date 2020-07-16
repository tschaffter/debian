# Dockerized Debian environments

![ci](https://github.com/tschaffter/debian/workflows/ci/badge.svg)

Deploying reproducible, short-lived Debian development environments anywhere.

## Motivation

The current release of WSL and Mingw-w64 have strong limitations in terms of
enabling me to develop on Windows 10, so I opted for deploying my development
environments using Docker.

The benefits of this approach are:

| Property | Description |
|---|---|
| Cross-platform | Bring your dev environments to any hosts that have Docker installed. |
| Stability / security | Use short-lived environment instances; only add to `Dockerfile.*` the dependencies that you really need. |
| Provenance | If you know the date when you deployed an environment, you can retrieve the version of all the system dependencies used.\* |
| Reproducibility | Deploy any past versions of your environments. |

\* Assumes that the `latest` version of the environment available at that time has been
deployed. The script `debian.sh` is provided to garantee that by running
`docker-compose pull` before deploying the environment selected.

## Usage

Use the script `debian.sh <environment> <version>` to start the environment
that matches the name and version specified. The following commands are
equivalent.

```console
./debian.sh user latest
./debian.sh user
```

It is recommended to add `debian.sh` to your `PATH` so you can run environments
from anywhere.

The value of `<version>` can be set to any git tags for which Docker images have
been successfully pushed to DockerHub. For example,

```console
./debian.sh user 20200713
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

## Acknowledgement

Thanks to Aaron Hayden ([@ahayden](https://github.com/ahayden)) for sharing his
[repository](https://github.com/ahayden/debuerreotype/tree/037869977855fe6473e3f2096dbff650968df441)
that implements the approach this project is based on.
