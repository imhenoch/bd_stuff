-- On another VM named admin, clone of rh, mysql
create database admin;

create user 'admin'@'localhost' identified by 'pass';

create user 'admin'@'%' identified by 'pass';

grant all privileges on admin.* to 'admin'@'localhost';

grant all privileges on admin.* to 'admin'@'%';

flush privileges;

-- On admin database
create table usuarios(
    id_usuario integer primary key auto_increment,
    email varchar(100) not null,
    contrasena varchar(32) not null
);

-- In the file /etc/mysql/mysql.conf.d/mysqld.cnf
-- This line:
-- bind-address            = 0.0.0.0

insert into
    usuarios (email, contrasena)
values
    ('luislao@itcelaya.edu.mx', md5('pass')),
    ('yo@yo.yo', md5('pass'));

-- Add admin and rh hosts to central and ping them

-- On central VM, central database, as postgres user
create extension postgres_fdw;

grant usage on foreign data wrapper postgres_fdw to gerente;

create server remote_rh
    foreign data wrapper postgres_fdw
    options (host 'rh', port '5432', dbname 'rh');

create user mapping for gerente
    server remote_rh
    options (user 'ejecutivo', password 'pass');

create schema rh;

import foreign schema public
    from server remote_rh into rh;

-- To test this
set schema 'rh';
\d -- This should show the foreign tables

set schema 'public';

select
    *
from
    empleado join rh.personal on id_empleado=id_personal
    limit 30;