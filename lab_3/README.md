# Lab 3 — psql
`psql` is the standard command-line tool for managing PostgreSQL. It normally comes packaged with PostgreSQL server, but it can also be installed separately as a client utility that connects to a remote server. This is exactly what we will be doing in this lab — instead of using `psql` on `postgres_server`, we will create a separate `postgres_client` and install everything we need there.

This is mainly to really drive home the difference between the *server* and the *client*. Imagine that `postgres_server` is some managed service like AWS RDS. You don't have access to the underlying OS, but you can still install `psql` on an EC2 instance and perform all the standard administration tasks, create backups with [`pg_dump`](https://www.postgresql.org/docs/current/static/app-pgdump.html), test performance with [`pgbench`](https://www.postgresql.org/docs/current/static/app-pgdump.html), and analyse logs with [`pgbadger`](https://github.com/dalibo/pgbadger).

## docker-compose.yml
In this lab we will be spinning up two linked containers.

[`postgres_server`](postgres_server/) is mostly similar to what we created in the previous lab, the main difference being that we increased the log verbosity (take a look at [01-configure_pg_logging.sh](./postgres_server/scripts/01-configure_pg_logging.sh) — the configuration files which allow us do this will be explored more in [Lab 4](../lab_4)).

[`postgres_client`](postgres_client/Dockerfile) is created from a stock Debian image. There is no database running in this container, so we will be connecting to `postgres_server` to run our queries. `postgres_client` runs several utility scripts which configure the system for better interactive experience. Most notably, there's [03-configure_psqlrc.sh](./postgres_client/scripts/03-configure_psqlrc.sh), which sets the configuration file for `psql`, and [05-configure_environment.sh](./postgres_client/scripts/05-configure_environment.sh), which sets some useful environment variables.

## Create the stack and connect to the server
As usual, run this command to create the stack:
```
docker-compose up -d
```
Feel free to ignore `debconf: delaying package configuration, since apt-utils is not installed` message in the log output, as it's just a harmless warning.

Connect to the client:
```
docker-compose exec postgres_client bash
```
## .psqlrc

Notice that we have created a `.psqlrc` file, which will make `psql` prompt more informative;
```
cat ~/.psqlrc
```

Some of the settings explained:
* `\pset null 'NULL'` — by default NULLs are displayed as `''`, which is indistinguishable from empty strings. This setting makes NULLs explicit.
* `\timing on` — report how much time it took for each query to execute
* `\x auto` — use best available output format. This means table format with column names at the top by default, but switching to expanded format (when columns are transposed to rows in the output) if there's too much data to fit in a single row.
* `\set VERBOSITY verbose` — some extra log output
* `\set HISTSIZE 1000` — store 1000 commands in the history file, located in `~/.psql_history` by default. It's also possible to have a separate history file per database: `\set HISTFILE ~/.psql_history- :DBNAME`
* `\set HISTCONTROL ignoredups` — this means that duplicate commands are not saved in the history file
* `\set PROMPT1 '%n@%M:%>%x %/# '` — this sets up a more informative prompt, which shows the name of the connected user (`%n`), host (`%M`), port (`%>`), transaction status (`%x`), and the database name (`%/`).
* `\set conninfo <...>` — an example of adding an alias for a useful command. You can then invoke this command by typing `:conninfo` in the interactive psql.

## psql
Try to run `psql`:
```
psql
```
```
psql: could not connect to server: No such file or directory
        Is the server running locally and accepting
        connections on Unix domain socket "/var/run/postgresql/.s.PGSQL.5432"?
```

We need to specify an external host, as there is no database server running on the same container:
```
psql -h postgres_server
```
or
```
psql -h db
```
because we linked the containers in `docker-compose.yml`.

### psql meta-commands in a nutshell
What you can see now is a psql prompt, which accepts both SQL commands (`DROP TABLE students;`) and psql-specific meta-commands (such as `\h` for help with SQL commands). The list of meta-commands is enormous, but here are some of the most useful ones:

* `\h` — help with SQL commands (`\h CREATE DATABASE`)
* `\?` — help with psql commands (a pretty long list)
* `\q` — quit (normal bash `Ctrl+D` works as well)
* `\c` — connect to a database (this is equivalent to `USE` in T-SQL)
* `\d` — list relations (tables) in the current database
* `\d[pattern]` — list or describe various objects in the database. For example, `\d+ my_table` describes table `my_table`.
* `\e` — open the default editor (specified in `$EDITOR` environment variable), which can be used to write a complex query
* `\i` — execute a file located on the client as if it were typed on the keyboard
* `(some query) \g [some file]` — send the query to the server (like `GO` in T-SQL) and store the output in a file on the client. This is placed at the end of the query, replacing semicolon.
* `\l` — list databases on the server (`\l+` for extra information)
* `\t` — toggle tuple only mode (omits column names and row count footer)
* `(some query) \watch (interval)` — repeatedly run a query at fixed interval and monitor its output
* `\x` — toggle expanded table formatting mode
* `\!` — launch a separate shell or execute a single shell command (`\! ls -la`) without logging out of psql. It executes on the client, so no, it doesn't provide a sneaky ssh session to the RDS host.

### psql in action
Let's try to see some of these commands in action.

Connect to the client again:
```
docker-compose exec postgres_client bash
```

From the client, use `psql` to connect to the server:
```
psql -h db
```

As you can see in the prompt, you have connected to the `audit` database.
Let's see if there are any tables there:
```
postgres@db:5432 audit# \dt+
No relations found.
```

This is strange, we definitively created some tables. The reason we can't see them now is that they are in the `logs` schema, and the default `search_path` only looks in the `public` schema (there are good reasons to avoid using the `public` schema, see [OWASP](https://www.owasp.org/index.php/OWASP_Backend_Security_Project_PostgreSQL_Hardening) for details).

The ways to see our tables is to specify the schema explicitly:
```
postgres@db:5432 audit# \dt+ logs.*
```

To avoid doing this every time, you can modify the `search_path` at the database or role level:
```
ALTER DATABASE audit SET search_path TO logs;
```

Reconnect to the database, and now you will be able to see the tables without specifying the schema explicitly.

### Non-interactive psql
`psql` can also be invoked non-interactively, which is very useful for automation scripts:
* `psql -c (command)` — execute a single command (`psql -c "SELECT 1;"`)
* `psql -f  (file)` — read commands from file and execute them (`psql -f backup.sql`). This is equivalent to `\i` meta-command.

Since PostgreSQL 9.6 it's possible to mix and match `-c` and `-f` options.

## Clean up
Clean up before continuing to the next lab:
```
docker-compose down
```
