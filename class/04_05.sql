-- On central, mysql
create table cliente
(
    rfc varchar(30) primary key,
    razon_social varchar(200),
    domiclio varchar(200)
);

create table cfdi
(
    cfdi varchar(5) primary key,
    descripcion varchar(100) not null
);

create table factura
(
    rfc varchar(13) not null,
    id_transaccion integer not null,
    cfdi varchar(5) references cfdi(cfdi),
    primary key(rfc, id_transaccion)
);

insert into cfdi (
    cfdi,
    descripcion
) values
    ();

-- iReport
