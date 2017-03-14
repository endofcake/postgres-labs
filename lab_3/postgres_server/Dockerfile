FROM postgres:9.6.1
LABEL maintainer "savchuk.a@gmail.com"

# Some non-essential usability improvements
COPY ./scripts/ /scripts/
RUN for file in /scripts/*; do $file; done

COPY ./docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/
