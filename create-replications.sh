#!/bin/bash

# Perform schema changes manually before this point.

master_db="primary_db"
replicas=("replica_db")

# Create new primary publication
docker exec -i "$master_db" psql -U postgres -d $master_db -c "CREATE PUBLICATION my_publication FOR ALL TABLES;"

# Create new replica subscriptions
for replica in "${replicas[@]}"; do
    docker exec -i "$replica" psql -U postgres -d $replica -c "CREATE SUBSCRIPTION ${replica}_subscription CONNECTION 'dbname=$master_db host=$master_db user=postgres password=postgres' PUBLICATION my_publication;"
done
