create table usuario(
	uid serial primary key,
	unome varchar
);

create table grupo(
	gid serial primary key,
	gnome varchar,
	id_admin int,
	constraint fk_id_gerente foreign key(id_admin) references usuario(uid)
);

create table usuarios_grupos(
	gid serial,
	uid serial,
	primary key(gid,uid),
	constraint fk_gid foreign key(gid) references grupo(gid),
	constraint fk_uid foreign key(uid) references usuario(uid)
);

create table mensagem(
	mid serial primary key,
	uid int,
	gid int,
	msg varchar,
	constraint fk_uid foreign key(uid) references usuario(uid),
	constraint fk_gid foreign key(gid) references grupo(gid)
);


create or replace function func_del_dep_usu()
returns trigger as $$
declare
	min_uid int;
	grupos_administrados cursor is (select gid from grupo Gr where Gr.uid=new.uid);
	id_grupo_adm int;
	grupo_onde_tem_msg cursor is (select gid from mensagem Msg where Msg.uid=new.uid);
	id_grupo_msg int;
begin
	if (new.uid in (select id_admin from grupo)) then
		open grupos_administrados;
		fetch grupos_administrados into id_grupo_adm;
		loop
			exit when not found;
			select min(uid) into min_uid from usuarios_grupos where gid=id_grupo_adm;
			if not exists ((select uid from usuarios_grupos where gid=id_grupo_adm)except(select uid from usuario U where U.uid=new.uid)) then
				delete from grupo where gid=id_grupo_adm;
			else
				update table grupo set id_admin=min_uid where gid=id_grupo_adm;
			end if;
			fetch grupos_administrados into id_grupo_adm;
		end loop;
		close grupos_administrados;
	end if;
	
	if (new.uid in (select uid from mensagem)) then
		open grupo_onde_tem_msg;
		fetch grupo_onde_tem_msg into id_grupo_msg;
		loop
			exit when not found;
			select min(uid) into min_uid from usuario;
			update table mensagem set uid=min_uid where gid=id_grupo_msg;
			fetch grupo_onde_tem_msg into id_grupo_msg;
		end loop;
	end if;
	
	delete from usuarios_grupos UG where UG.uid=new.uid;


create trigger del_dep_usu
before delete
on usuario
for each row
execute procedure func_del_dep_usu();


create or replace function func_del_dep_grupo()
returns trigger as $$
begin
	delete from usuarios_grupos UG where UG.gid=new.gid;
	delete from mensagem Me where Me.gid=new.gid;
	return new;
end;
$$language plpgsql;

create trigger del_dep_grupo
before delete
on grupo
for each row
execute procedure func_del_dep_grupo();