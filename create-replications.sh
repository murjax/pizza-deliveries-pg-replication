#!/bin/bash

master_db="pizza_deliveries_dev_primary"
replicas=("pizza_deliveries_dev_replica")

# Copy primary schema to replicas
docker exec -i $master_db pg_dump --schema-only $master_db -U postgres > new_schema.sql

for replica in "${replicas[@]}"; do
  docker cp new_schema.sql $replica:/tmp/schema.sql
  docker exec -i $replica psql -U postgres -d $replica -f /tmp/schema.sql
done

# Create new primary publication
docker exec -i "$master_db" psql -U postgres -d $master_db -c "CREATE PUBLICATION my_publication FOR ALL TABLES;"

# Create new replica subscriptions
for replica in "${replicas[@]}"; do
    docker exec -i "$replica" psql -U postgres -d $replica -c "CREATE SUBSCRIPTION ${replica}_subscription CONNECTION 'dbname=$master_db host=$master_db user=postgres password=postgres' PUBLICATION my_publication;"
done
