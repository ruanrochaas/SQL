--LISTA 8
--Questão 1
create or replace function func_menor_18()
returns trigger as $$
begin
	if new.idade<18 then
		return null;
	else
		return new;
	end if;
end;
$$language plpgsql

create trigger menor_18
before insert
on amigo
for each row
execute procedure func_menor_18();

--insert into amigo values(12312,'creusa','F',14);

--Questão 2
create or replace function func_restr1_listapres()
returns trigger as $$
declare
	val_lista real;
	val_pres real;
begin
	if (select count(pid) from listapresente where aid=new.aid) = 5 then
		return null;
	else
		select sum(Pr.pvalor) into val_lista from listapresente LP, presente Pr where LP.pid=Pr.pid and LP.aid=new.aid;
		select Pr.pvalor into val_pres from presente Pr where Pr.pid=new.pid;
		if val_lista + val_pres > 50 then
			return null;
		else
			return new;
		end if;
	end if;
end;
$$language plpgsql

create trigger restr_listapres
before insert
on listapresente
for each row
execute procedure func_restr1_listapres();

/*select * from listapresente;
select * from presente;
select * from amigo;
insert into presente values(4,'sapato da nike',300.00);
insert into listapresente values(5,4,3);*/

--Questão 3
create or replace function func_pres_mais_barato(id_ami integer)
returns varchar as $$
declare
	pres varchar;
begin
	if id_ami in (select aid from listapresente) then
		select Pr.pdescricao into pres from presente Pr, listapresente LP
		where Pr.pid=LP.pid and LP.aid=id_ami and Pr.pvalor <= all(select Pr.pvalor from presente Pr, listapresente LP
																where Pr.pid=LP.pid and LP.aid=id_ami);
		return pres;
	end if;
end;
$$language plpgsql

select Pr.pdescricao, Pr.pvalor from listapresente LP, presente Pr where LP.pid=Pr.pid and LP.aid=1;
select func_pres_mais_barato(1);

--Questão 4
create or replace function func_insert_pres(id_pres integer)
returns void as $$
declare
	curs_amigos cursor is (select aid from amigo where aid not in (select LP.aid from listapresen LP where LP.pid=id_pres));
	amigo integer;
	preferencia integer;
begin
	open curs_amigos;
	fetch curs_amigos into amigo;
	loop
		exit when not found;
		select max(preferencia)+1 into preferencia from listapresente where aid=amigo;
		if (preferencia is null) then preferencia = 1;
		end if;
		insert into listapresente values(amigo,id_pres,preferencia);
		fetch curs_amigos into amigo;
	end loop;
	close curs_amigos;
end;
$$language plpgsql

/*select * from listapresente;
select * from presente;
select func_insert_pres(4);
select func_rem_pres(4);*/


--LISTA 9
--Questão 1
create or replace function func_qtd_pres()
returns trigger as $$
begin
	if (select count(pid) from listapresente where aid=new.aid) = 2 then
		return null;
	else
		return new;
	end if;
end;
$$language plpgsql;

create or replace function func_qtdmin_pres()
returns trigger as $$
begin
	if (select count(pid) from listapresente where aid=old.aid) = 1 then
		return null;
	else
		return old;
	end if;
end;
$$language plpgsql;

create trigger qtd_presentes
before insert
on listapresente
for each row
execute procedure func_qtd_pres();

create trigger qtd_min_presentes
before delete
on listapresente
for each row
execute procedure func_qtdmin_pres(); --Pq tá dando erro?


/*insert into listapresente values(4,1,4)
select * from listapresente*/

--Questão 2
create or replace function func_pres_na_lista()
returns trigger as $$
begin
	if (new.pid_recebido not in (select LP.pid from listapresente LP where LP.aid=new.aid_amigo)) then
		return null;
	else
		return new;
	end if;
end;
$$language plpgsql;

create trigger pres_na_lista
before insert
on amigosecreto
for each row
execute procedure func_pres_na_lista();

/*select * from listapresente;
select * from amigosecreto;
insert into amigosecreto values(4,1,5);*/

--Questão 3
create or replace function func_add_pres(id_ami integer)
returns void as $$
declare
	curs1 cursor is select distinct(pid) from presente; --select Pr.pid from presente Pr where Pr.pid not in(select LP.pid from listapresente LP where LP.aid=id_ami)
	id_pres integer;
begin
	open curs1;
	fetch curs1 into id_pres;
	loop
		exit when not found;
		if (id_pres not in (select pid from listapresente where aid=id_ami)) then
			insert into listapresente values(id_ami,id_pres,5);
		end if;
		fetch curs1 into id_pres;
	end loop;
	close curs1;
end;
$$language plpgsql

/*select * from amigo;
select func_add_pres(6);
select func_add_pres(5);
select * from listapresente where aid=6;
select * from listapresente where aid=5*/

--Questão 4
create or replace function func_valor_lista(id_amigo integer)
returns real as $$
declare
	valor_tot real;
begin
	select sum(Pr.pvalor) into valor_tot from presente Pr, listapresente LP where Pr.pid=LP.pid and LP.aid=id_amigo;
	return valor_tot;
end;
$$language plpgsql;

/*select * from presente;
select * from listapresente;
select func_valor_lista(1);*/

--Questão 5
create or replace function func_rem_pres(id_pres integer)
returns void as $$
begin
	delete from listapresente where pid=id_pres;
	delete from amigosecreto where pid_recebido=id_pres;
	delete from presente where pid=id_pres;
end;
$$language plpgsql

--select func_rem_pres(4)

--Questão 6














