create user replicator replication login encrypted password 'pass';

-- On slave
pg_basebackup -h master -D /var/lib/postgresql/10/main/ -U replicator -v -P

-- /var/lib/postgresql/10/main/recovery.conf
-- standby_mode = 'on'
-- primary_conninfo = 'host=master port=5432 user=replicator password=pass sslmode=require'