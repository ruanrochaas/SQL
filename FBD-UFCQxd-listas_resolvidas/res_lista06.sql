--CRIANDO TABELAS
create table fornecedor(
	fid int,
	fnome varchar(40),
	fcidade varchar(40),
	primary key(fid)
);

create table peca(
	pid int,
	pnome varchar(40),
	cor varchar(40),
	primary key(pid)
);

create table projetos(
	jid int,
	jnome varchar(40),
	cidade varchar(40),
	primary key(jid)
);

create table fornpecaproj(
	fid int,
	pid int,
	jid int,
	qtd int,
	primary key(fid, pid, jid),
	constraint fk_fid foreign key(fid) references fornecedor(fid),
	constraint fk_pid foreign key(pid) references peca(pid),
	constraint fk_jid foreign key(jid) references projetos(jid)
);

--POVOANDO O BANCO
insert into fornecedor values(1,'São Geraldo','Quixadá');
insert into fornecedor values(2,'Pinheiro','Quixadá');
insert into fornecedor values(3,'Dinal','Quixadá');
insert into fornecedor values(4,'Olivan','Quixadá');

insert into peca values(1,'Calabresa','Vermelho');
insert into peca values(2,'Massa de Cuscuz','Amarelo');
insert into peca values(3,'Ovo','Branco');

insert into projetos values(1,'Casa do Ruan','Quixadá');
insert into projetos values(2,'Casa da Juh','Quixadá');
insert into projetos values(3,'Casa da Carol','Quixadá');

insert into fornpecaproj values(1,1,1,2);
insert into fornpecaproj values(2,1,2,1);
insert into fornpecaproj values(1,3,1,15);
insert into fornpecaproj values(2,3,2,30);
insert into fornpecaproj values(2,2,2,3);
insert into fornpecaproj values(2,2,1,1);
insert into fornpecaproj values(2,2,3,2);
insert into fornpecaproj values(4,1,1,10);


/*PROVA 2 FBD
select FPP.fid from fornpecaproj FPP
where not exists ((select FPP2.qtd from fornpecaproj FPP2 where FPP2.fid=FPP.fid) 
				except (select FPP2.qtd from fornpecaproj FPP2 where FPP2.fid=FPP.fid and FPP2.qtd=10));*/


--EXERCÍCIOS LISTA 6
select Pe.pid from peca Pe where Pe.pid not in (select FPP.pid from fornpecaproj FPP)

select FPP.jid from fornpecaproj FPP, peca Pe
where FPP.pid=Pe.pid and Pe.pnome='Massa de Cuscuz' and FPP.qtd > (select min(FPP2.qtd) from fornpecaproj FPP2 
				where FPP2.pid=FPP.pid);

select FPP.pid from fornpecaproj FPP, fornecedor F where FPP.fid=F.fid and F.fnome='São Geraldo';

select Pe.pnome, max(FPP.qtd), min(FPP.qtd) from peca Pe, fornpecaproj FPP, fornecedor F
where Pe.pid=FPP.pid and FPP.fid=F.fid and F.fnome<>'Dinal' group by Pe.pnome

select FPP.pid from fornpecaproj FPP
group by FPP.pid having count(FPP.fid)>1;

select F.fid, sum(FPP.qtd) from fornecedor F left outer join fornpecaproj FPP
on F.fid=FPP.fid
group by F.fid;

select distinct(F.fnome) from fornecedor F,fornpecaproj FPP
where F.fid=FPP.fid and not exists((select FPP2.pid from fornpecaproj FPP2) 
								except (select FPP2.pid from fornpecaproj FPP2 
										where FPP2.fid=FPP.fid));

select FPP.fid from fornpecaproj FPP
group by FPP.fid having count(distinct(FPP.jid)) > all(select count(distinct(FPP2.jid)) from fornpecaproj FPP2
											where FPP2.fid<>FPP.fid group by FPP.fid);
											
select distinct(FPP.fid) from fornpecaproj FPP
where not exists ((select FPP2.jid from fornpecaproj FPP2 where FPP2.pid=FPP.pid) 
				except (select FPP2.jid from fornpecaproj FPP2 
						where FPP2.pid=FPP.pid and FPP2.fid=FPP.fid));

select F.fnome from fornecedor F
where F.fid in (select distinct(FPP.fid) from fornpecaproj FPP
where not exists ((select FPP2.pid from fornpecaproj FPP2, projetos Pr
				where FPP2.jid=Pr.jid and Pr.jnome='Casa do Ruan') 
				except (select FPP2.pid from fornpecaproj FPP2, projetos Pr 
						where FPP2.jid=Pr.jid and FPP2.fid=FPP.fid)));





