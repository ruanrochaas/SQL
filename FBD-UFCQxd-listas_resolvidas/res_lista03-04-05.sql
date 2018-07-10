--CRIANDO AS TABELAS
create table departamentos(
	dnumero int,
	dnome varchar(45),
	cpf_gerente int,
	primary key (dnumero)
);

create table empregados(
	cpf int,
	enome varchar(45),
	salario float,
	cpf_supervisor int,
	dnumero int,
	primary key (cpf)
);

create table trabalha(
	cpf_emp int,
	pnumero int,
	primary key (cpf_emp, pnumero)
);

create table projetos(
	pnumero int,
	pnome varchar(45),
	dnumero int,
	primary key (pnumero)
);

--ADICIONANDO AS CHAVES ESTRANGEIRAS
alter table departamentos add constraint fk_cpf_gerente foreign key(cpf_gerente) references empregados(cpf); 

alter table empregados add constraint fk_dnumero foreign key(dnumero) references departamentos(dnumero);
alter table empregados add constraint fk_cpf_superv foreign key(cpf_supervisor) references empregados(cpf);

alter table trabalha add constraint fk_cpf_emp foreign key(cpf_emp) references empregados(cpf);
alter table trabalha add constraint fk_pnumero foreign key(pnumero) references projetos(pnumero);

alter table projetos add constraint fk_dnumero foreign key(dnumero) references departamentos(dnumero);

--POVOANDO
insert into departamentos values(1,'Design Digital',null);
insert into departamentos values(2,'Ciência da Computação',null);
insert into departamentos values(3,'Engenharia de Software',null);
update departamentos set cpf_gerente=1 where dnumero=1;
update departamentos set cpf_gerente=4 where dnumero=2;
update departamentos set cpf_gerente=7 where dnumero=3;
insert into departamentos values(4,'Redes de Computadores', null);

insert into empregados values(1,'Ingrid',10000.00,null,1);
insert into empregados values(2,'João',6000.00,1,1);
insert into empregados values(3,'Paulo',7000.00,1,1);
insert into empregados values(4,'Paulo de Tarso',8000.00,null,2);
insert into empregados values(5,'Ticiana',8000.00,4,2);
insert into empregados values(6,'Lívia',8000.00,4,2);
insert into empregados values(7,'Carla',8000.00,null,3);
insert into empregados values(8,'Diana',7000.00,7,3);
insert into empregados values(9,'Paulyne',10000.00,7,3);
update empregados set cpf_supervisor=1 where cpf=1;
update empregados set cpf_supervisor=4 where cpf=4;
update empregados set cpf_supervisor=7 where cpf=7;
insert into empregados values(10,'Ruan',1,1);

insert into projetos values(1,'Coordenação DD',1);
insert into projetos values(2,'Arduíno',1);
insert into projetos values(3,'Mídias Locativas',1);
insert into projetos values(4,'Algorítmos',2);
insert into projetos values(5,'Big Data',2);
insert into projetos values(6,'Análise de dados',2);
insert into projetos values(7,'Oficina de Jogos',3);
insert into projetos values(8,'UML',3);
insert into projetos values(9,'Controle Residencial');

insert into trabalha values(1,1);
insert into trabalha values(2,2);
insert into trabalha values(3,3);
insert into trabalha values(4,4);
insert into trabalha values(5,5);
insert into trabalha values(6,6);
insert into trabalha values(7,8);
insert into trabalha values(8,9);
insert into trabalha values(9,7);
insert into trabalha values(2,1);
insert into trabalha values(3,1);
insert into trabalha values(10,1);
insert into trabalha values(10,2);
insert into trabalha values(10,3);
insert into trabalha values(10,4);
insert into trabalha values(10,5);
insert into trabalha values(10,6);
insert into trabalha values(10,7);
insert into trabalha values(10,8);
insert into trabalha values(10,9);

--EXERCÍCIOS LISTA 3
select * from departamentos;
select E.enome, E.salario from empregados E;
select E.enome, E.cpf from empregados E, departamentos D where E.cpf=D.cpf_gerente;
select E.enome from empregados E where E.dnumero=2;
select E.enome from empregados E where E.salario>8000.0;
select E.enome from empregados E where E.cpf_supervisor=null;
--select E.enome from empregados E where E.cpf_supervisor is null;
select E.enome from empregados E where E.salario>7000.00 and E.salario<10000.00;
--select E.enome from empregados E where E.salario between 7500 and 9500;

--EXERCÍCIOS LISTA 4
select E.enome from empregados E where E.dnumero=2 and E.salario>7000.00 order by E.enome asc;

select E.enome from empregados E where E.salario>5000.00 and E.cpf in (select E2.cpf_supervisor from empregados E2);

select E.enome, E.salario from empregados E 
where E.cpf in (select E.cpf from empregados E group by E.cpf 
				having E.salario>(select E2.salario from empregados E2 where E2.cpf=E.cpf_supervisor));

select E.enome from empregados E, departamentos D 
where E.cpf=D.cpf_gerente and D.dnumero in (select Pr.dnumero from projetos Pr);

select Pr.pnome from projetos Pr, trabalha Tr, empregados E 
where Pr.pnumero=Tr.pnumero and Tr.cpf_emp=E.cpf and E.enome='João';

select Pr.pnome from projetos Pr, departamentos D, empregados E
where Pr.dnumero=D.dnumero and D.cpf_gerente=E.cpf and E.enome='João';

select avg(E.salario) from empregados E, departamentos D where E.dnumero=D.dnumero and D.dnome='Design Digital';

select E.enome, count(Tr.pnumero) from empregados E, trabalha Tr where Tr.cpf_emp=E.cpf group by E.enome;

select Pr.pnome, count(Tr.cpf_emp) from projetos Pr, trabalha Tr where Pr.pnumero=Tr.pnumero group by Pr.pnome;

select Pr.pnome, count(Tr.cpf_emp) as qtd_empregados from projetos Pr, trabalha Tr 
where Pr.pnumero=Tr.pnumero group by Pr.pnome having count(Tr.cpf_emp)>1;

--EXERCÍCIOS LISTA 5
(select E.cpf from empregados E) except (select Tr.cpf_emp from trabalha Tr); 
--select E.cpf from empregados E where E.cpf not in (select Tr.cpf_emp from trabalha Tr);
--select E.cpf from empregados E left join trabalha Tr on E.cpf=Tr.cpf_emp where Tr.cpf_emp is null; 

select Tr.cpf_emp from trabalha Tr group by Tr.cpf_emp having count(Tr.pnumero)>1;

select distinct(Tr.cpf_emp) from trabalha Tr 
where not exists((select Pr.pnumero from projetos Pr) 
				except (select Pr2.pnumero from projetos Pr2, trabalha Tr2 
						where Pr2.pnumero=Tr2.pnumero and Tr2.cpf_emp=Tr.cpf_emp));

select E.enome, E.salario, D.dnumero from empregados E left outer join departamentos D on E.cpf=D.cpf_gerente;
--select E.enome, E.salario, D.dnumero from empregados E left join departamentos D on E.cpf=D.cpf_gerente;

select E.enome from empregados E, departamentos D 
where E.dnumero=D.dnumero and D.dnome='Design Digital' group by E.cpf 
having E.salario>all(select E2.salario from empregados E2, departamentos D2 
					where E2.dnumero=D2.dnumero and E2.dnumero=E.dnumero and E2.cpf<>E.cpf);
/*select E.enome from empregados E, departamentos D 
where E.dnumero=D.dnumero and D.dnome='Design Digital' and E.salario in (
	select max(E.salario) from empregados E, departamentos D2 where E.dnumero=D2.dnumero and D2.dnome=D.dnome);*/

select count(E.cpf) from empregados E
where E.cpf in (select Tr.cpf_emp from trabalha Tr group by Tr.cpf_emp having count(Tr.pnumero)>1);

select D.dnome, E.enome from departamentos D left outer join empregados E on D.dnumero=E.dnumero;

create view qtd_emp(Projeto, Empregados) as
select Pr.pnome, count(Tr.cpf_emp) from projetos Pr, trabalha Tr
where Pr.pnumero=Tr.pnumero
group by Pr.pnome;

/*select * from qtd_emp;
select avg(empregados) from qtd_emp;*/

select projeto from qtd_emp where empregados>(select avg(empregados) from qtd_emp);
/*PQ ASSIM DÁ CERTO?
select projeto from qtd_emp group by projeto having sum(empregados)>(select avg(empregados) from qtd_emp);*/


