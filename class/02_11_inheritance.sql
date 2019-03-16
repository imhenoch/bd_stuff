create database ejemplo;

create user usuario with password 'pass';

grant all privileges on database ejemplo to usuario;

create table pelicula(
    id_pelicula serial primary key,
    pelicula varchar(100),
    duracion int,
    sinopsis varchar(100),
    id_genero int,
    id_clasificacion int,
    id_idioma int,
    id_tipo int
);

create table disco(
    id_region int,
    id_capacidad int,
    id_resolucion int,
    tres_d boolean
) inherits(pelicula);

insert into pelicula(pelicula, duracion, sinopsis, id_genero, id_clasificacion, id_idioma) values ('Volver al futuro', 123, 'Viajes en el tiempo', 1, 1, 1);

insert into disco(pelicula, duracion, sinopsis, id_genero, id_clasificacion, id_idioma, id_tipo, id_region, id_capacidad, id_resolucion, tres_d) values ('Avengers 8', 123, ':|', 1, 1, 1, 1, 1, 1, 1, true);

create table paciente(
    id_paciente serial primary key,
    nombre varchar(50),
    apellidos varchar(100),
    fecha_nacimiento date
);

create table paciente_pediatrico(
    vacunas varchar(100),
    dentacion varchar(100),
    peso_nacimiento int,
    talla_nacimiento int,
    semana_nacimiento int
) inherits(paciente);

create table paciente_femenino(
    historial_gineco_obstetrico varchar(100),
    fum date
) inherits(paciente);

create table employee(
    id_employee serial primary key,
    first_name varchar(100),
    last_name varchar(100)
);

create table regular_employee(
    salary int
) inherits(employee);

create table contract_employee(
    salary_peer_hour int,
    contract_period daterange
) inherits(employee);