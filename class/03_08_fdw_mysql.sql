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

CREATE FOREIGN TABLE admin.cliente(                                      
     id_cliente int,
     rfc varchar,
     razon_social varchar,
     domicilio varchar)
SERVER remote_admin
     OPTIONS (dbname 'admin', table_name 'cliente');

CREATE FOREIGN TABLE admin.cfdi(
     cfdi varchar,
     descripcion varchar)
SERVER remote_admin
     OPTIONS (dbname 'admin', table_name 'cfdi');


CREATE FOREIGN TABLE admin.factura(                                      
    id_factura int,
    rfc varchar,
    fecha date,
    no_factura varchar,
    folio_fiscal varchar,
    cadena_original varchar,
    sello_digital_emisor varchar,
    sello_sat varchar,
    cfdi varchar)
SERVER remote_admin
     OPTIONS (dbname 'admin', table_name 'factura');