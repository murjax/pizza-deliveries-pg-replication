#!/bin/bash
databases=("primary_db" "replica_db")

for db in "${databases[@]}"; do
    echo "dropping database $db..."
    docker exec -i $db dropdb $db -U postgres

    echo "creating database $db..."
    docker exec -i $db createdb $db -U postgres
done
