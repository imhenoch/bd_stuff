-- Add CURP, NSS, RFC and email to 'personal' table on the rh database on the original VM
alter table personal
add column curp varchar(18),
add column rfc varchar(13),
add column nss varchar(11),
add column email varchar(100);

-- Add the corresponding domain to those columns

-- Drop databases from VM clone (now named 'central')

-- On central VM
create database central;
create user gerente with password 'pass';
grant all privileges on database central to gerente;

-- On central database
create table empleado(
    id_empleado serial primary key,
    nombre varchar(50) not null,
    apellido varchar(100),
    nacimiento date not null,
    rfc varchar(13),
    email varchar(100)
);

-- Enable rh postgres to allow remote connections
-- Check for ping between VMs

-- From central VM
PGPASSWORD=pass psql -U ejecutivo -d rh -h 10.28.207.174 -c "
create table tmp as (
    select
        id_personal as id_empleado,
        nombre,
        (papellido || ' ' || sapellido) as apellido,
        nacimiento,
        rfc,
        email
    from
        personal
)
"