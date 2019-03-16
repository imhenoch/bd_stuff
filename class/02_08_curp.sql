create database renapo;

create table persona(
	id_persona serial primary key,
	nombre varchar(100) not null,
	papellido varchar(100),
	sapellido varchar(100),
	curp varchar(18) not null,
	nacimiento date not null);

insert into persona (nombre, papellido, sapellido, curp, nacimiento) values ('Isidro Henoch', 'Ojeda', 'Ramirez', 'OERI960803HGTJMS07', '1996/08/03');

alter table persona add sexo varchar(1);

update persona set sexo='H';

CREATE DOMAIN curp AS TEXT CHECK(
Value ~ '^[A-Z]{4}[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])[HM]{1}(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE)[0-9A-Z]{5}$'
);

alter table persona alter COLUMN  curp type curp;

create table estado(
	id_estado serial primary key,
	clave_estado varchar(2) not null);

INSERT INTO persona (clave_estado) VALUES ('AS', 'BC', 'BS', 'CC', 'CS', 'CH', 'CL', 'CM', 'DF', 'DG', 'GT', 'GR', 'HG', 'JC', 'MC', 'MN', 'MS', 'NT', 'NL', 'OC', 'PL', 'QT', 'QR', 'SP', 'SL', 'SR', 'TC', 'TS', 'TL', 'VZ', 'YN', 'ZS', 'NE');

select upper(
(case when length(p.papellido) > 0 then substring(p.papellido from 0 for 3) else 'XX' end)
|| (case when length(p.sapellido) > 0 then substring(p.sapellido from 0 for 2) else 'X' end)
|| (substring(p.nombre from 0 for 2))
|| (substring(extract(year from p.nacimiento)::text from 3 for 3))
|| (case when extract(month from p.nacimiento) < 10 then '0' else '' end || extract(month from p.nacimiento))
|| (case when extract(day from p.nacimiento) < 10 then '0' else '' end || extract(day from p.nacimiento))
|| (p.sexo)
|| (select clave_estado from estado order by random() limit 1)
|| (substring(md5(p.nombre || p.id_persona) from 0 for 6))
) as curp from persona p;

create function generate_curp() returns trigger as $curp$
    begin
    NEW.curp = upper(
                (case when length(NEW.papellido) > 0 then substring(NEW.papellido from 0 for 3) else 'XX' end)
            ||  (case when length(NEW.sapellido) > 0 then substring(NEW.sapellido from 0 for 2) else 'X' end)
            ||  (substring(NEW.nombre from 0 for 2))
            ||  (substring(extract(year from NEW.nacimiento)::text from 3 for 3))
            ||  (case when extract(month from NEW.nacimiento) < 10 then '0' else '' end || extract(month from NEW.nacimiento))
            ||  (case when extract(day from NEW.nacimiento) < 10 then '0' else '' end || extract(day from NEW.nacimiento))
            ||  (NEW.sexo)
            ||  (select clave_estado from estado order by random() limit 1)
            ||  (substring(md5(NEW.nombre || NEW.id_persona) from 0 for 6))
        );
    return NEW;
    end;
$curp$ language plpgsql;

create trigger curp_generator before insert or update on persona
    for each row execute procedure generate_curp();


