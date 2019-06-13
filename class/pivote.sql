-- Vista materializada con la informacion de productos vendidos
create materialized view mv_productos_vendidos as 
    select
        t.id_empleado,
        extract (year from t.fecha) as anio,
        extract (month from t.fecha) as mes,
        extract (day from t.fecha) as dia,
        count (tp.cantidad) as productos_vendidos
    from 
        transaccion t
        join transaccion_producto tp using (id_transaccion)
    group by 
        1, 2, 3, 4;

-- Se tiene que habilitar esta extension para poder utilizar crosstab
create extension tablefunc;



create type pivot as 
(
    id_employee int,
    year double precision,
    month double precision
);

select 
    row (id_empleado, anio, mes) as datos,
    dia,
    productos_vendidos::int
from 
    mv_productos_vendidos;



-- CROSSTAB
select 
    * 
from 
    crosstab
    (
        'select 
            row (id_empleado, anio, mes)::pivot as datos,
            dia,
            productos_vendidos::int
        from 
            mv_productos_vendidos;'
    ) as ct 
    (
        "datos" pivot,
        "d1" int, "d2" int, "d3" int, "d4" int, "d5" int, "d6" int, "d7" int, "d8" int, "d9" int, "d10" int, "d11" int,
        "d12" int, "d13" int, "d14" int, "d15" int, "d16" int, "d17" int, "d18" int, "d19" int, "d20" int, "d21" int,
        "d22" int, "d23" int, "d24" int, "d25" int, "d26" int, "d27" int, "d28" int, "d29" int, "d30" int, "d31" int
    );