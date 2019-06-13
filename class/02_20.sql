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



create view view_empleado_curso_nomina as
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

create table fact_empleado_nomina as
    select
        id_employee,
        year,
        sum(course_quantity) as course_quantity,
        sum(passed_courses) as passed_courses,
        sum(instructor) as instructor,
        sum((passed_courses * 500) + (instructor * 2000)) as bonus
    from
        view_empleado_curso_nomina
    group by
        1, 2
    order by
        1, 2;