create or replace function func_idade()
returns trigger as $$
begin
	if new.idade >= 18 then
		return new;
	else return null;
	end if;
end;
$$language plpgslq;

create trigger trig_idade
on amigo
before update or insert
for each row
execute procedure func_idade();

--2 questão (prova)
create or replace function func_10presentes()
returns trigger as $$
declare
	somapresente real;
	valorpresente real;

begin
	if (select count(*) from listapresente where aid=new.aid) = 10 then
		return null;
	else
		select sum(Pr.pvalor) into somapresente from listapresente LP, presente Pr where Pr.aid=new.aid and Pr.pid=LP.pid;
		select Pr.pvalor into valorpresente from presente Pr where Pr.pid=new.pid;
		if (valorpresente + somapresente)>500 then
			return null;
		else return new;
		end if;
	end if;
end;
$$language plpgsql;

create trigger trig_10presentes
before insert
on listapresente
for each row
execute procedure func_10presentes();

create or replace function func_somamaxima()
returns trigger as $$
declare
	cursor1 cursor is select LP.aid from listapresente LP where LP.pid=new.pid;
	id_amigo integer;
	somapresente_amigo real;

begin
	open cursor1;
	fetch cursor1 into id_amigo;
	loop
		exit when not found;
		select sum(Pr.pvalor) into somapresente_amigo from listapresente LP, presente Pr where LP.pid=Pr.pid and LP.aid=id_amigo;
		if (somapresente_amigo - old.pvalor + new.pvalor)>500 then
			return null;
		else
			fetch cursor1 into id_amigo;
		end if;
	end loop;
	close cursor1;
	return new;
end;
$$language plpgsql;
	
create trigger trigger_updatepresente
before update
on presente
for each row
execute procedure func_somamaxima();


/*date presente
set pvalor=700
where pid=1;

select * from presente;*/

--3 questão
create or replace function retornamaisbarato(id_amigo integer)
returns integer as $$

declare
	id_presente_barato int;
	
begin
	select Pr.pid into id_presente_barato from presente Pr, listapresente LP 
	where LP.pid=Pr.pid and LP.aid=id_amigo and Pr.pvalor<=all(select Pr.pvalor from listapresente LP, presente Pr
															where Pr.pid=LP.pid and LP.aid=id_amigo);
return id_presente_barato;
end;
$$language plpgsql;

select * from amigo;
select retornamaisbarato(1);




