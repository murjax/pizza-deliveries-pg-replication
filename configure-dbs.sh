#!/bin/bash

max_number_of_replicas=4
max_wal_senders=8

databases=("pizza_deliveries_dev_primary" "pizza_deliveries_dev_replica")

for db in "${databases[@]}"; do
    docker exec -i "$db" bash -c "sed -i 's/^#*wal_level .*$/wal_level = logical/' /var/lib/postgresql/data/postgresql.conf"
    docker exec -i "$db" bash -c "sed -i 's/^#*max_replication_slots .*$/max_replication_slots = $max_number_of_replicas/' /var/lib/postgresql/data/postgresql.conf"
    docker exec -i "$db" bash -c "sed -i 's/^#*max_wal_senders .*$/max_wal_senders = $max_wal_senders/' /var/lib/postgresql/data/postgresql.conf"
    docker exec -i "$db" bash -c "grep -qxF 'host replication all all md5' /var/lib/postgresql/data/pg_hba.conf || echo 'host replication all all md5' >> /var/lib/postgresql/data/pg_hba.conf"
    docker restart $db
done
