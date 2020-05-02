# Docker

[Docker](https://docs.docker.com/) provides a way to run applications securely isolated in a container, packaged with all its dependencies and libraries.

## Get started with Docker

Set up your [Docker environment](https://docs.docker.com/get-started/) and run:

`$ docker --version`

## Postgres in a docker container

To start postgres in a docker container run:

```bash
$ docker volume create pgdata
$ docker run -it --rm -d -p 5432:5432 \
          -v pgdata:/var/lib/postgresql/data \
          -e POSTGRES_PASSWORD=postgres --name postgres postgres
```

Read more about `docker run` command in the [extended description](https://docs.docker.com/engine/reference/commandline/run/).
