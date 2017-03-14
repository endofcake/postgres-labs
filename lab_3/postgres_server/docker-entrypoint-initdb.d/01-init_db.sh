#!/bin/bash
set -e

# Use redirection operator (<<) to execute an inline script
psql --set=ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  -- basic hardening
  REVOKE CONNECT ON DATABASE postgres FROM PUBLIC;
  REVOKE ALL ON SCHEMA public FROM PUBLIC;
  -- create new db and role
  CREATE DATABASE audit;
  CREATE ROLE docker WITH LOGIN PASSWORD 'qwerty';
  GRANT ALL PRIVILEGES ON DATABASE audit TO docker;
EOSQL

# Use -c to execute a single command
# Note how we need to specify the database the we connect to by passing '-d users'
psql --username "$POSTGRES_USER" -d audit -c "CREATE SCHEMA IF NOT EXISTS logs;"

# Use -f to execute a file - no sense to do it in docker-entrypoint though,
# as it can do this automatically
# psql --username "$POSTGRES_USER" -f somefile.sql
