# Dockerized Debian environment

Setup for deploying my Debian development environment.

## Motivation

The current release of WSL and Mingw-w64 have strong limitations in terms of
enabling me to develop on Windows 10, so I opted for deploying my development
environment using Docker.

## Usage

On Windows 10:

```terminal
docker-compose run user
```

Press CTRL+P followed by CTRL+Q to detatch from the container. To attach to the
running container:

```terminal
docker attach <container_id>
```

Enter `exit` or press CTRL+C followed by CTRL+D to exit and stop the container.
