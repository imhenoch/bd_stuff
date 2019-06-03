-- Lab factura
-- *** Entregables
-- 1. Representacion XML de un CFDI
-- 2. Representacion impresa de un CFDI
-- ***
-- 
-- 1. Con Postgresql sacar XML
-- 1.1. Usando MySql_fdw
-- 1.2. Usando Postgres_fdw
-- 1.3. Usando Tds_fdw
-- 1.4. Usando funciones de postgres XML
-- 2. IReport para la representacion impresa
-- 3. Una conexion a postgres usando Java o Python
-- 4. Aplicacion con PHP o Python para capturar datos de cliente via web, mysql

-- Cliente (RFC, no. venta) -> Datos del cliente (nombre, direccion, codigo postal, email, uso CFDI, metodo de pago) -> Esto va a mysql

-- Create a new database called 'Test'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT name
        FROM sys.databases
        WHERE name = N'Test'
)
CREATE DATABASE Test
GO

-- Create a new table called 'empresa' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.empresa', 'U') IS NOT NULL
DROP TABLE dbo.empresa
GO
-- Create the table in the specified schema
CREATE TABLE dbo.empresa
(
    empresa_id INT NOT NULL PRIMARY KEY IDENTITY(1, 1), -- primary key column
    empresa [NVARCHAR](50) NOT NULL
);
GO

select * from empresa
go

insert into empresa
    (empresa)
values
    ('Some random company')
go

create table cfdi(
    cfdi varchar(10) not null primary key,
    descripcion varchar(30) not null
);

insert into cfdi(
    cfdi,
    descripcion
)
values
    ('G03', 'Gastos en general');

create table factura(
    id_factura int not null primary key,
    rfc varchar(13) not null,
    fecha date not null,
    no_factura varchar(32),
    folio_fiscal varchar(500) unique,
    cadena_original varchar(500) unique,
    sello_digital_emisor varchar(500) unique,
    sello_sat varchar(500) unique,
    cfdi varchar(10) not null references dbo.cfdi(cfdi)
)

select * from dbo.factura
go

-- On admin
create table cliente(
    id_cliente integer primary key auto_increment,
    rfc varchar(13) not null,
    razon_social varchar(100) not null,
    domicilio varchar(100) not null
);

insert into cliente
(
    rfc,
    razon_social,
    domicilio
)
VALUES
(
    'rfc',
    'Some Client',
    'Some address'
);

CREATE FOREIGN TABLE admin.cliente(
     id_cliente int,
     rfc varchar,
     razon_social varchar,
     domicilio varchar)
SERVER remote_admin
     OPTIONS (dbname 'admin', table_name 'cliente');






select
    '<?xml version="1.0" encoding="utf-8"?>'::text ||
    '<factura>'::text ||
        '<empresa>'::text ||
            (select empresa from mssql_empresa where empresa_id = 1)::text ||
        '</empresa>'::text ||
        '<cliente>'::text ||
            (select xmlforest(c.rfc, c.razon_social, c.domicilio, cfdi.cfdi, cfdi.descripcion)
                from admin.cliente c
                inner join admin.factura f on c.rfc = f.rfc
                inner join admin.cfdi cfdi on f.cfdi = cfdi.cfdi
                where f.id_factura = 5)::text ||
        '</cliente>'::text ||
        '<sat>'::text ||
            (select xmlforest(no_factura, folio_fiscal, sello_digital_emisor, sello_sat) from admin.factura where id_factura = 5)::text ||
        '</sat>'::text ||
        '<detalle>' ||
            (select xmlagg(rows) from (select xmlforest(p.producto, tp.cantidad, tp.precio_final) as rows
                from transaccion_producto tp
                inner join transaccion t on t.id_transaccion = tp.id_transaccion
               inner join producto p on p.id_producto = tp.id_producto
               where t.id_transaccion = 5) as queries) ||
        '</detalle>' ||
        '<totales>' ||
            (select xmlforest(totales.total, totales.iva, totales.subtotal)
                from (
                    select sum(tp.precio_final) as total, sum(tp.precio_final)-sum(tp.precio_final)/1.16 as iva, sum(tp.precio_final)/1.16 as subtotal
                        from transaccion_producto tp
                        inner join transaccion t on t.id_transaccion = tp.id_transaccion
                        inner join producto p on tp.id_producto = tp.id_producto
                        where t.id_transaccion = 5
                ) as totales) :: text ||
        '</totales>' ||
    '</factura>'::text
as xml_test;

create or replace function factura_xml(integer) returns xml as
$$
begin
    return(
        select
            '<?xml version="1.0" encoding="utf-8"?>'::text ||
            '<factura>'::text ||
                '<empresa>'::text ||
                    (select empresa from mssql_empresa where empresa_id = 1)::text ||
                '</empresa>'::text ||
                '<cliente>'::text ||
                    (select xmlforest(c.rfc, c.razon_social, c.domicilio, cfdi.cfdi, cfdi.descripcion)
                        from admin.cliente c
                        inner join admin.factura f on c.rfc = f.rfc
                        inner join admin.cfdi cfdi on f.cfdi = cfdi.cfdi
                        where f.id_factura = $1)::text ||
                '</cliente>'::text ||
                '<sat>'::text ||
                    (select xmlforest(no_factura, folio_fiscal, sello_digital_emisor, sello_sat) from admin.factura where id_factura = $1)::text ||
                '</sat>'::text ||
                '<detalle>' ||
                    (select xmlagg(rows) from (select xmlforest(p.producto, tp.cantidad, tp.precio_final) as rows
                        from transaccion_producto tp
                        inner join transaccion t on t.id_transaccion = tp.id_transaccion
                    inner join producto p on p.id_producto = tp.id_producto
                    where t.id_transaccion = $1) as queries) ||
                '</detalle>' ||
                '<totales>' ||
                    (select xmlforest(totales.total, totales.iva, totales.subtotal)
                        from (
                            select sum(tp.precio_final) as total, sum(tp.precio_final)-sum(tp.precio_final)/1.16 as iva, sum(tp.precio_final)/1.16 as subtotal
                                from transaccion_producto tp
                                inner join transaccion t on t.id_transaccion = tp.id_transaccion
                                inner join producto p on tp.id_producto = tp.id_producto
                                where t.id_transaccion = $1
                        ) as totales) :: text ||
                '</totales>' ||
            '</factura>'::text
        as factura);
end;
$$
language plpgsql;





-- 1. Check if the given rfc exists
select
    count(*)
from
    admin.cliente
where
    rfc = 'rfc';

-- 1.5. Create client if the rfc doesn't exist
insert into admin.cliente
(
    rfc,
    razon_social,
    domicilio
)
values
(
    'rfc2',
    'Another Client',
    'Another address'
);

-- 2. Obtain cfdi's
select * from admin.cfdi;

-- 2. Create bill
insert into admin.factura
(
    id_factura,
    rfc,
    fecha,
    no_factura,
    folio_fiscal,
    cadena_original,
    sello_digital_emisor,
    sello_sat,
    cfdi
)
values
(
    5, 'rfc', now(), md5('rfc' || 5), md5('rfc' || 5), md5('rfc' || 5), md5('rfc' || 5), md5('rfc' || 5), 'G03'
);