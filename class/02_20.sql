insert into curso
    (curso, no_horas)
values 
    ('Test course', 30),
    ('Another test course', 30),
    ('One more test course', 30),
    ('Last test course', 30);

insert into diplomado
    (diplomado, no_horas)
values
    ('Test certified', 120);

insert into curso_diplomado
    (id_curso, id_diplomado)
values
    (501, 101),
    (502, 101),
    (503, 101),
    (504, 101);

insert into personal
    (nombre, papellido, sapellido, nacimiento)
values
    ('Some', 'Random', 'Dude', '1990/01/01');

insert into imparte
    (id_personal, id_curso, fecha_inicio, fecha_fin)
values
    (1, 501, '2018/01/01', '2018/12/31'),
    (1, 502, '2018/01/01', '2018/12/31'),
    (1, 503, '2018/01/01', '2018/12/31'),
    (1, 504, '2018/01/01', '2018/12/31');

insert into inscripcion
    (id_personal, id_imparte, calificacion)
values
    (10001, 1205, 90),
    (10001, 1206, 90),
    (10001, 1207, 90),
    (10001, 1208, 90);


select
    i.id_personal as id_employee,
    extract(year from fecha_fin) as year,
    count(*) course_quantity,
    sum(case when i.calificacion > 70 then 1 else 0 end) as passed_courses
from
    inscripcion i
    inner join imparte im on im.id_imparte=i.id_imparte
group by year, id_employee order by i.id_personal asc limit 30;


select
    i.id_personal as id_employee,
    extract(year from fecha_fin) as year,
    count(*) course_quantity,
    sum(case when i.calificacion > 70 then 1 else 0 end) as passed_courses
from
    inscripcion i
    inner join imparte im on im.id_imparte=i.id_imparte
where 
    i.id_personal=10001 group by year, id_employee order by i.id_personal asc limit 30;


select
    i.id_personal as id_employee,
    extract(year from fecha_fin) as year,
    count(*) course_quantity,
    sum(case when i.calificacion > 70 then 1 else 0 end) as passed_courses,
    (
        select
            count(distinct id_diplomado)
        from
            inscripcion i2
            inner join imparte im on i2.id_personal=im.id_personal
            inner join curso_diplomado cd on im.id_curso=cd.id_curso
        where 
            i2.id_personal=i.id_personal group by cd.id_diplomado
    ) as certified_quantity
from
    inscripcion i
    inner join imparte im on im.id_imparte=i.id_imparte
where 
    i.id_personal=10001 group by year, id_employee order by i.id_personal asc limit 30;





select
    i.id_personal as id_employee,
    extract(year from fecha_fin) as year,
    count(*) course_quantity,
    sum(case when i.calificacion > 70 then 1 else 0 end) as passed_courses,
    (
        select
            count(distinct id_diplomado)
        from
            inscripcion i2
            inner join imparte im on i2.id_personal=im.id_personal
            inner join curso_diplomado cd on im.id_curso=cd.id_curso
        where 
            i2.id_personal=i.id_personal group by cd.id_diplomado
    ) as certified_quantity
from
    inscripcion i
    inner join imparte im on im.id_imparte=i.id_imparte
where 
    i.id_personal=10001 group by year, id_employee order by i.id_personal asc limit 30;



select
    count(*) as certified_courses_quantity,

from
    curso_diplomado
where
    id_diplomado=101;