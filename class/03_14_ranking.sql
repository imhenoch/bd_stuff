select
    extract(year from fecha) as id_year,
    extract(month from fecha) as id_month,
    id_sucursal as id_branch,
    id_empleado as id_employee,
    rank() over (
        partition by
            extract(year from fecha),
            extract(month from fecha), id_sucursal
        order by sum(cantidad * precio_final) desc
    ),
    sum(cantidad * precio_final) as amount
from
    transaccion join transaccion_producto using(id_transaccion)
group by
    extract(year from fecha),
    extract(month from fecha),
    id_sucursal,
    id_empleado
order by
    1, 2, 3
limit 10;

create table ranking as
    select
        extract(year from fecha) as id_year,
        extract(month from fecha) as id_month,
        id_sucursal as id_branch,
        id_empleado as id_employee,
        rank() over (
            partition by
                extract(year from fecha),
                extract(month from fecha), id_sucursal
            order by sum(cantidad * precio_final) desc
        ),
        sum(cantidad * precio_final) as amount
    from
        transaccion join transaccion_producto using(id_transaccion)
    group by
        extract(year from fecha),
        extract(month from fecha),
        id_sucursal,
        id_empleado
    order by
        1, 2, 3;

create table years as
    select
        id_year
    from
        ranking
    group by
        id_year;

alter table years add primary key (id_year);

create table months as
    select
        id_month
    from
        ranking
    group by
        id_month;

alter table months add primary key (id_month);

alter table ranking add foreign key (id_year) references years(id_year);
alter table ranking add foreign key (id_month) references months(id_month);