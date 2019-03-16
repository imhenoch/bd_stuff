create function create_user() returns trigger as $create_user$
    declare
        user_id int;
    begin
        insert into admin.usuarios (email, contrasena) values (NEW.email, md5(NEW.email));
        user_id := (select id_usuario from admin.usuarios order by (id_usuario) desc limit 1);
        NEW.id_usuario := user_id;
        return NEW;
    end;
$create_user$ language plpgsql;

create trigger remote_employee_user before insert on empleado
    for each row execute procedure create_user();

create trigger remote_client_user before insert on cliente
    for each row execute procedure create_user();