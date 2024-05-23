#!/bin/bash
databases=("pizza_deliveries_dev_primary" "pizza_deliveries_dev_replica")

for db in "${databases[@]}"; do
    echo "dropping database $db..."
    docker exec -i $db dropdb $db -U postgres

    echo "creating database $db..."
    docker exec -i $db createdb $db -U postgres
done
