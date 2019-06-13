create table inventario as
select
    t.id_sucursal,
    tp.id_producto
from
    transaccion t
    join transaccion_producto tp using (id_transaccion)
group by
    1, 2;

CREATE table mes
(
  id_mes serial primary key,
  mes   varchar(20)
);

insert into
    mes(mes)
values 
    ('Enero'),
    ('Febrero'),
    ('Marzo'),
    ('Abril'),
    ('Mayo'),
    ('Junio'),
    ('Julio'),
    ('Agosto'),
    ('Septiembre'),
    ('Octubre'),
    ('Noviembre'),
    ('Diciembre');

create table trimestre
(
  id_mes       integer references mes (id_mes) on update cascade on delete cascade,
  id_trimestre integer not null,
  primary key (id_mes, id_trimestre)
);

insert into 
    trimestre
values 
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 2),
    (5, 2),
    (6, 2),
    (7, 3),
    (8, 3),
    (9, 3),
    (10, 4),
    (11, 4),
    (12, 4);

create materialized view mv_venta_producto_trimestral as
    select 
        extract (year from t.fecha) as year,
        (
            select
                id_trimestre 
            from
                trimestre 
            where 
                id_mes = extract (month from t.fecha)
        ) as trimestre,
        t.id_sucursal,
        tp.id_producto,
        sum(cantidad) as cantidad
    from 
        transaccion t 
        join transaccion_producto tp using (id_transaccion)
    group by 
        1, 2, 3, 4;

select
    id_producto
from
    mv_venta_producto_trimestral
where
    cantidad < 20
    and year = 2018
    and trimestre = 4
union
select
    id_producto
from
    inventario
where
    id_producto not in 
    (
        select 
            id_producto 
        from
            mv_venta_producto_trimestral
        where
            year = 2018
            and trimestre = 4
    );