-- On central VM, central database

create table cliente(
    id_cliente serial primary key,
    nombre varchar(50) not null,
    apaterno varchar(50),
    amaterno varchar(50),
    nacimiento date not null,
    email varchar(100)
);

-- Add email domain to 'cliente'
create domain email as text check(
    value ~ '^[a-z]{4,8}([0-9]{0,3}|.[a-z]{4,10})@([a-z]{4,9}.)?([a-z-]{6}).(org|com|net)$'
);
alter table cliente alter column email type email;

create table estado(
    id_estado serial primary key,
    estado varchar(50) not null
);

create table municipio(
    id_municipio serial primary key,
    municipio varchar(100) not null,
    id_estado int references estado(id_estado)
);

create table cliente_direccion(
    id_cliente int references cliente(id_cliente),
    consecutivo int not null,
    calle varchar(100) not null,
    numero_interior varchar(20) not null,
    numero_exterior varchar(20) not null,
    colonia varchar(100),
    codigo_postal varchar(5),
    id_municipio int references municipio(id_municipio),
    primary key (id_cliente, consecutivo)
);

create table sucursal(
    id_sucursal serial primary key,
    sucursal varchar(50) not null,
    domicilio varchar(200),
    id_municipio int references municipio(id_municipio)
);

create table tipo_pago(
    id_tipo_pago serial primary key,
    tipo_pago varchar(20)
);

create table transaccion(
    id_transaccion serial primary key,
    id_sucursal int references sucursal(id_sucursal),
    id_empleado int references empleado(id_empleado),
    id_cliente int references cliente(id_cliente),
    fecha date not null
);

create table transaccion_pago(
    id_transaccion int references transaccion(id_transaccion),
    id_tipo_pago int references tipo_pago(id_tipo_pago),
    folio varchar(16) unique not null,
    monto numeric(10, 2) not null check (monto >= 0),
    primary key (folio)
);

create table proveedor(
    id_proveedor serial primary key,
    proveedor varchar(50) not null,
    rfc varchar(13) not null
);

create table marca(
    id_marca serial primary key,
    marca varchar(50) not null,
    id_proveedor int references proveedor(id_proveedor)
);

create table producto(
    id_producto serial primary key,
    producto varchar(50) not null,
    id_marca int references marca(id_marca)
);

create table producto_precio(
    id_producto int references producto(id_producto),
    fecha_inicial date not null,
    fecha_final date,
    precio_referencia numeric(10, 2) not null,
    primary key(id_producto, fecha_inicial)
);

create table transaccion_producto(
    id_transaccion int references transaccion(id_transaccion),
    id_producto int references producto(id_producto),
    cantidad numeric(10, 2) not null,
    precio_final numeric(10, 2) not null
);

----------------------------------------------------------------
--                Insert data this weekend :D                 --
----------------------------------------------------------------
-- Empleado             -->  20_000
-- Cliente              -->  1_000_000
-- Sucursal             -->  100 o 200
-- Metodos de pago      -->  10
-- ClienteDireccion     -->  1_000_000
-- Estado               -->  32
-- Municipio            -->  Sabe, los que haya, son como 2_700
-- Proveedores          -->  5_000
-- Marca                -->  10_000
-- Productos            -->  100_000
-- ProductoPrecio       -->  100_000
-- Transaccion          -->  5_000_000
-- TransaccionPago      -->  Minimo 5_000_000
-- TransaccionProducto  -->  Al menos 10_000_000





-- Unfortunately, today's practice isn't about those table creation... :'(
-- How do you update the 'empleado' table on 'central' every time a new employee is registered on 'rh'? O.o

-- Configure /etc/hosts file on 'rh' to add domain for 'central', something like:
-- 127.0.0.1       localhost.localdomain   localhost
-- ::1             localhost6.localdomain6 localhost6
-- 10.28.207.174   rh
-- 10.246.154.85   central
-- Now you can query data like 
-- PGPASSWORD=pass psql -U gerente -d central -h central -c "select count(*) from cliente"
-- instead of
-- PGPASSWORD=pass psql -U gerente -d central -h 10.246.154.85 -c "select count(*) from cliente"
-- It's simpler with a domain


-- We're gonna use db_link to achieve the connection between databases
-- On rh VM, rh database, logged as postgres
create extension dblink;
-- You can check your enabled extensions with \dx
-- Check the connection with:
select dblink_connect('host=central user=gerente password=pass dbname=central');
select * from dblink('host=central user=gerente password=pass dbname=central', 'select count(*) from empleado') as t(test int);

-- Now we have to create a trigger to insert a employee on central every time a row is inserted on rh
create function insert_remote_employee() returns trigger as $remote_employee$
    begin
    perform dblink_exec('host=central user=gerente password=pass dbname=central',
                        'insert into
                            empleado (id_empleado, nombre, apellido, nacimiento, rfc, email)
                        values
                            ('||NEW.id_personal||', '''||NEW.nombre||''', '''||NEW.papellido||''' || '' '' || '''||NEW.sapellido||''', '''||NEW.nacimiento||''', '''||NEW.rfc||''', '''||NEW.email||''')');
    return NEW;
    end;
$remote_employee$ language plpgsql;

create trigger remote_employee after insert on personal
    for each row execute procedure insert_remote_employee();