# Postgres labs
These labs are intended to serve as a starting point for developers new to PostgreSQL.

## Prerequisites
* a recent version of docker (17.03+)
* good text editor (Visual Studio Code works quite well)
* optional: GUI client for Postgres, either PgAdmin or JetBrains DataGrip
* decent console emulator (I'd recommend ConEmu for Windows, iTerm2 for Mac, and Terminator for Linux)
* working knowledge of docker and SQL will be helpful

The labs were tested on Windows 10, but, if anything, should work the same way or better on *nix systems.

## Contents
* [Lab 1](./lab_1) — Basic setup
* [Lab 2](./lab_2) — Extending the stock image
* [Lab 3](./lab_3) — psql
* [Lab 4](./lab_4) — Configuration files

## How to use
Read the `README` for the lab and follow the instructions.
Important: before running `docker-compose up` make sure that you changed your working directory to the lab folder! For example:
```
cd lab_1
docker-compose up -d
```

## docker-compose in 5 minutes
The labs use `docker-compose` to spin up and tear down containers with PosgreSQL server and companion applications.

### Start and stop
Spin up complete working environment for the lab:
```
docker-compose up  -d
```
`-d` (detached) flag ensures that the containers are running in the background.

Stop the containers without destroying them — all data in PostgreSQL is preserved when you start the environment next time:
```
docker-compose stop
```

Tear down the containers to start from scratch:
```
docker-compose down
```

Important caveat: even if the containers were deleted, the image will be cached. If there was a problem caused by a broken image, make sure to rebuild it from scratch (that is not using cached layers) before running `docker-compose up` again:
```
docker-compose build --no-cache
```

### Inspect
View the logs for a container:
```
docker-compose logs -f
```

Attach to an interactive bash session in a container:
```
docker-compose exec postgres bash
```
In some labs the name of the resource can be `postgres_server` or `postgres_client`, subsitute it in the command accordingly.

### Clean up
Remove all stopped containers:
```
docker rm $(docker ps --filter=status=exited --filter=status=created -q)
```

Remove all labs images and clean up dangling images:
```
docker rmi $(docker images lab* -q)
docker rmi $(docker images -a --filter=dangling=true -q)
```
