# Postgres Logical Replication Example

This is an example of logical replication in Postgres. This configuration sets up two Docker containers with a primary and replica server. When configured, records will be copied to the replica on each primary transaction.

Scripts taken and improved from this blog post:  https://dev.to/ietxaniz/practical-postgresql-logical-replication-setting-up-an-experimentation-environment-using-docker-4h50

## Setup
1. Build the containers: `docker compose up`
2. Setup replication configs: `./configure-dbs.sh`
3. Create one or more tables on the primary: `docker exec -i pizza_deliveries_dev_primary psql -U postgres -d pizza_deliveries_dev_primary -c "CREATE TABLE users (name VARCHAR(255), email VARCHAR(255));"`
4. Setup the replication. This script copies the schema to the replica and configures the necessary subscriptions and replication slots. `./create-replications`
5. Perform inserts, updates, and deletes on the primary. Then select from the replica. You should now see the data copied over.
6. After making additional schema changes on the primary, run `./reset-replications` to refresh the replica schema and subscriptions.
7. To stop replication, run `./clear-replications`.
