#!/bin/bash
set -euC

echo "export PGDATABASE=audit" >> /root/.bashrc
echo "export PGUSER=postgres" >> /root/.bashrc
echo "export PG_PASSWORD=password1" >> /root/.bashrc
