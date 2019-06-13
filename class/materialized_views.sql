create materialized view mv_ranking as
select
    extract(year from fecha) as id_year,
    extract(month from fecha) as id_month,
    id_sucursal as id_branch,
    id_empleado as id_employee,
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

create table mranking as
    select
        id_year::integer as year,
        id_month::integer as month,
        id_branch::integer,
        id_employee::integer,
        amount::decimal,
        rank() over (
        partition by
            id_year,
            id_month,
            id_branch
            order by amount desc
        )
    from
        mv_ranking;




create materialized view m_view_empleado_curso_nomina as
    select 
        i.id_personal as id_employee,
        extract(year from fecha_fin) as year,
        count(*) course_quantity,
        sum(case when i.calificacion > 70 then 1 else 0 end) as passed_courses,
        (
            select
                count(distinct id_imparte)
            from
                rh.personal p
                inner join rh.imparte im on p.id_personal = im.id_personal
            where
                im.id_personal = i.id_personal
            group by
                im.id_personal
        ) as instructor
    from
        rh.inscripcion i
        inner join rh.imparte im on im.id_imparte = i.id_imparte
    group by
        year, id_employee
    order by
        i.id_personal asc;