FROM debian:8.7
LABEL maintainer "savchuk.a@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get install -y wget curl vim

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update -qq && \
  apt-get install postgresql-client-9.6 postgresql-contrib-9.6 -y -q

# Some non-essential usability improvements
COPY ./scripts/ /scripts/
RUN for file in /scripts/*; do $file; done

WORKDIR /root

# Sleep for 24 hours - this is a hack to ensure that the container doesn't exit immediately
# and we get a chance to attach to it
ENTRYPOINT ["sleep", "86400"]

