--CRIANDO O BANCO
create table amigo(
	aid integer,
	anome varchar(40),
	sexo char,
	idade integer,
	primary key(aid)
);

create table presente(
	pid integer,
	pdescricao varchar,
	pvalor real,
	primary key(pid)
);

create table listapresente(
	aid integer,
	pid integer,
	preferencia integer,
	primary key(aid, pid)
);

create table amigosecreto(
	aid integer,
	aid_amigo integer,
	pid_recebido integer,
	primary key(aid, aid_amigo)
);

alter table listapresente add constraint fk_aid foreign key(aid) references amigo(aid);
alter table listapresente add constraint fk_pid foreign key(pid) references presente(pid);
alter table amigosecreto add constraint fk_aid foreign key(aid) references amigo(aid);
alter table amigosecreto add constraint fk_aid_amigo foreign key(aid_amigo) references amigo(aid);
alter table amigosecreto add constraint fk_pid foreign key(pid_recebido) references presente(pid);

--POVOANDO O BANCO
insert into amigo values(1,'Ruan','M',28);
insert into amigo values(2,'Juliana','F',33);
insert into amigo values(3,'Carol','F',20);
insert into amigo values(4,'Erisson','M',18);
insert into amigo values(5,'André','M',23);
insert into amigo values(6,'Nath','F',21);

insert into presente values(1,'Chocolate',10);
insert into presente values(2,'Meias',7.5);
insert into presente values(3,'Camiseta',23.7);
insert into presente values(4,'Tênis',35.7);

insert into listapresente values(1,3,5);
insert into listapresente values(1,1,3);
insert into listapresente values(1,2,1);
insert into listapresente values(2,1,5);
insert into listapresente values(2,3,3);
insert into listapresente values(3,1,5);
insert into listapresente values(3,2,2);
insert into listapresente values(4,4,5);
insert into listapresente values(5,3,5);
insert into listapresente values(6,2,5);
insert into listapresente values(5,1,3);

insert into amigosecreto values(1,2,1);
insert into amigosecreto values(2,3,3);
insert into amigosecreto values(3,1,2);
insert into amigosecreto values(4,5,2);
insert into amigosecreto values(5,4,3);
insert into amigosecreto values(6,3,3);

--EXERCÍCIOS
select Pr.pdescricao from presente Pr
where Pr.pid not in (select AmSec.pid_recebido from amigosecreto AmSec);

select Am.aid from amigosecreto Am
where Am.pid_recebido in (select LP.pid from listapresente LP where LP.aid=Am.aid);

select LP.aid from listapresente LP
where Lp.pid in (select LP2.pid from listapresente LP2, amigo Am
				where LP2.aid=Am.aid and LP2.aid<>LP.aid and Am.anome='André');

(select AmSec.pid_recebido from amigosecreto AmSec, presente Pr1
where AmSec.pid_recebido=Pr1.pid
group by AmSec.pid_recebido
having count(AmSec.pid_recebido)>=all(select count(AmSec2.pid_recebido) from amigosecreto AmSec2, presente Pr
									where AmSec2.pid_recebido=Pr.pid group by Pr.pid))
union
(select LP.pid from listapresente LP, presente Pr
where LP.pid=Pr.pid
group by LP.pid
having count(LP.pid)>=all(select count(LP2.pid) from listapresente LP2, presente Pr
						where LP2.pid=Pr.pid group by Pr.pid))

select distinct(Am.anome) from amigo Am, listapresente LP
where Am.aid=LP.aid and LP.pid in (select LP.pid from listapresente LP, presente Pr
								where LP.pid=PR.pid and LP.aid<>Am.aid
								group by LP.pid having count(LP.pid) > 2) 


