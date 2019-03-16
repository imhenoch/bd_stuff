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