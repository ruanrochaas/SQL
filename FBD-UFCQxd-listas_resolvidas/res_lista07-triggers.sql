--LISTA 7
--Questão 1
create or replace function func_max_emp_dep()
returns trigger as $$
begin
	if (select count(cpf) from empregados where dnumero=new.dnumero) = 3 then
		return null;
	else
		return new;
	end if;
end;
$$language plpgsql;

create trigger max_emp_dep
before insert or update
on empregados
for each row
execute procedure func_max_emp_dep();

/*
select * from empregados;
update empregados set dnumero=1 where enome='Ruan';
insert into empregados values (11,'Jaspion',924,1,1);
*/

--Questão 2
create or replace function func_qtd_proj_trab(cpf integer)
returns integer as $$
declare
	qtd_projetos integer;
begin
	if cpf in (select cpf_emp from trabalha) then
		select count(pnumero) into qtd_projetos from trabalha where cpf_emp=cpf;
		return qtd_projetos;
	end if;
end;
$$language plpgsql

/*
select * from trabalha;
select func_qtd_proj_trab(10);
*/

--Questão 3
create or replace function func_max_proj()
returns trigger as $$
begin
	if (select count(pnumero) from trabalha Tr where Tr.cpf_emp=new.cpf_emp) = 3 then
		return null;
	else
		return new;
	end if;
end;
$$language plpgsql;

create trigger max_proj
before insert
on trabalha
for each row
execute procedure func_max_proj();

/*
select * from trabalha;
insert into trabalha values(2,3);
insert into trabalha values(2,4);
*/

--Questão 4
create or replace function func_rem_proj()
returns trigger as $$
begin
	if old.pnumero in (select pnumero from trabalha) then
		delete from trabalha Tr where Tr.pnumero=old.pnumero;
		return old;
	else
		return null;
	end if;
end;
$$language plpgsql;

create trigger rem_proj
before delete
on projetos
for each row
execute procedure func_rem_proj();

/*
select * from projetos;
select * from trabalha;
insert into projetos values(123,'asdohaod',1);
insert into trabalha values(10,123);
delete from projetos where pnumero=123;
*/

--Questão 5
create or replace function func_rem_emp()
returns trigger as $$
begin
	if (old.cpf in (select cpf_gerente from departamentos)) and (old.cpf in (select cpf_emp from trabalha)) then
		delete from departamentos where cpf_gerente=old.cpf;
		delete from trabalha where cpf_emp=old.cpf;
		return old;
	end if;
	if old.cpf in (select cpf_gerente from departamentos) then
		delete from departamentos where cpf_gerente=old.cpf;
		return old;
	end if;
	if old.cpf in (select cpf_emp from trabalha) then
		delete from trabalha where cpf_emp=old.cpf;
		return old;
	end if;
	if old.cpf in (select cpf from empregados) then
		return old;
	end if;
	return null;
end;
$$language plpgsql;

create trigger rem_emp
before delete
on empregados
for each row
execute procedure func_rem_emp();

/*
select * from empregados;
select * from departamentos;
select * from trabalha;
insert into empregados values(123,'Zé Galudão',928,1,1);
insert into departamentos values(123,'Departamento do Zé',123);
insert into trabalha values(123,2);
delete from empregados where cpf=123;
*/

