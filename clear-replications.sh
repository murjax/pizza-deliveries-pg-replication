#!/bin/bash

# Define the master database and the replicas
master_db="primary_db"
replicas=("replica_db")

# Delete subscriptions and reset schema on replicas
for replica in "${replicas[@]}"; do
    docker exec -i "$replica" psql -U postgres -d $replica -c "DELETE FROM pg_subscription;"
    docker exec -i "$replica" psql -U postgres -d $replica -c "DELETE FROM pg_subscription_rel;"
    docker exec -i "$replica" psql -U postgres -d $replica -c "DELETE FROM pg_replication_origin;"
done

# Delete replication slots from primary
for replica in "${replicas[@]}"; do
    docker exec -i "$master_db" psql -U postgres -d $master_db -c "SELECT pg_drop_replication_slot('${replica}_subscription');"
done

# Delete primary publication
docker exec -i "$master_db" psql -U postgres -d $master_db -c "DROP PUBLICATION IF EXISTS my_publication;"

# Perform schema changes manually after this point.
