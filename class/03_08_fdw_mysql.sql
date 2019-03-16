-- Install this to use fdw with mysql
-- sudo apt install postgresql-10-mysql-fdw -y
-- On central as postgres user
create extension mysql_fdw;

grant usage on foreign data wrapper mysql_fdw to gerente;

-- On central as gerente
create server remote_admin
    foreign data wrapper mysql_fdw
    options (host 'admin', port '3306');

create user mapping for gerente
    server remote_admin
    options (username 'admin', password 'pass');

create schema admin;

import foreign schema admin
    from server remote_admin into admin;

alter table cliente
    add column id_usuario int;

alter table empleado
    add column id_usuario int;