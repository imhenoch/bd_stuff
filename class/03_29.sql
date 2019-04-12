-- On Sql server
-- Create a simple table to test the tds installation

create table empresa
(
    empresa_id int primary key,
    empresa varchar(20)
);

insert into
    empresa
values
    ('Random name'),
    ('Awesome name'),
    ('Aweful name');

select
    *
from
    empresa;

-- On Postgrsql as postgres user
grant usage on foreign data wrapper tds_fdw to gerente;

-- On the OS add a new entry to the hosts file for the windows vm

-- On Postgresql as gerente
create server mssql_empresa
    foreign data wrapper tds_fdw
    options
(servername 'empresa', port '1433', database 'test')

create user mapping for gerente
    server
mssql_empresa
    options
(username 'SA', password 'a0ZsI83X');

create foreign table mssql_empresa
(
    empresa_id integer,
    empresa varchar)
server mssql_empresa
options
(table_name 'dbo.empresa', row_estimate_method 'showplan_all');

create foreign table mssql_factura
(
    id_factura integer,
    rfc varchar,
    fecha date,
    no_factura varchar,
    folio_fiscal varchar,
    cadena_original varchar,
    sello_digital_emisor varchar,
    sello_sat varchar)
server mssql_empresa 
options
(table_name 'dbo.factura', row_estimate_method 'showplan_all');
