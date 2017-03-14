#!/bin/bash
set -euC

echo "Configuring psqlrc"
cat << EOL > /root/.psqlrc
\set ON_ERROR_ROLLBACK interactive
\set COMP_KEYWORD_CASE upper
\pset pager always
\pset null 'NULL'

\timing on
\x auto
\set VERBOSITY verbose
\set HISTSIZE 1000
\set HISTCONTROL ignoredups

\set PROMPT1 '%n@%M:%>%x %/# '

\set conninfo 'select usename, count(*) from pg_stat_activity group by usename;'

EOL
