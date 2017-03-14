#!/bin/bash
echo "Increasing logging levels for Postgres"
cat << EOL >> /usr/share/postgresql/9.6/postgresql.conf.sample

log_destination = 'stderr'
log_duration = on
log_min_duration_statement = 0
log_connections = on
log_disconnections = on
log_statement = 'all'
log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d,client=%h'
EOL

# runuser -l postgres -c "/usr/lib/postgresql/9.6/bin/pg_ctl reload -D /var/lib/postgresql/data"
