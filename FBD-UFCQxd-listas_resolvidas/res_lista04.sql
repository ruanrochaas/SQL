CREATE TABLE empregados (
	cpf integer,
	enome varchar(60),
	salario float,
	cpf_supervisor integer,
	dnumero integer,
	PRIMARY KEY (cpf)
);

CREATE TABLE departamentos (
	dnumero integer,
	dnome varchar(60),
	cpf_gerente integer,
	PRIMARY KEY (dnumero),
	CONSTRAINT fk_cpf FOREIGN KEY(cpf_gerente) REFERENCES
	empregados(cpf)
);

CREATE TABLE trabalha (
	cpf_emp integer,
	pnumero integer,
	CONSTRAINT fk_cpfemp FOREIGN KEY(cpf_emp) REFERENCES
	empregados(cpf)
);

CREATE TABLE projetos (
	pnumero integer,
	pnome varchar(45),
	dnumero integer,
	PRIMARY KEY(pnumero),
	CONSTRAINT fk_dnum FOREIGN KEY(dnumero) REFERENCES
	departamentos(dnumero)
);

ALTER TABLE empregados ADD CONSTRAINT fk_dnum FOREIGN KEY(dnumero) REFERENCES departamentos(dnumero);

ALTER TABLE trabalha ADD CONSTRAINT fk_pnum FOREIGN KEY(pnumero) REFERENCES projetos(pnumero);



insert into departamentos values(1, 'Design Digital')
insert into departamentos values(2, 'Ciência da Computação')
select * from departamentos

insert into projetos values(1, 'Coordenação de DD', 1)
insert into projetos values(2, 'Mídias Locativas', 1)
insert into projetos values(3, 'Arte Arduino', 1)
insert into projetos values(4, 'Algoritmos', 2)
insert into projetos values(5, 'Redes Neurais', 2)
select * from projetos

insert into empregados values(1, 'João Vilnei', 6000, null, 1)
insert into empregados values(2, 'Ingrid', 8000, null, 1)
insert into empregados values(3, 'Paulo Victor', 7000, null, 1)
insert into empregados values(4, 'Ticiana', 7000, null, 2)
insert into empregados values(5, 'Paulyne', 8000, null, 2)
insert into empregados values(6, 'David', 8000, null, 2)
insert into empregados values(7, 'Tânia', 8000, null, 2)

update empregados set cpf_supervisor=2 where cpf=1
update empregados set cpf_supervisor=2 where cpf=2
update empregados set cpf_supervisor=2 where cpf=3
update empregados set cpf_supervisor=5 where cpf=4
update empregados set cpf_supervisor=5 where cpf=5
update empregados set cpf_supervisor=5 where cpf=6

update departamentos set cpf_gerente=2 where dnumero=1
update departamentos set cpf_gerente=5 where dnumero=2

select * from empregados

insert into trabalha values(1,1)
insert into trabalha values(2,1)
insert into trabalha values(3,2)
insert into trabalha values(1,3)
insert into trabalha values(4,4)
insert into trabalha values(5,4)
insert into trabalha values(6,5)

select * from trabalha

'Lista 3'
select * from departamentos
select enome, salario from empregados
select enome, cpf from empregados where cpf in (select cpf_gerente from departamentos)
select * from empregados where dnumero=1
select * from empregados where salario>3000
select enome from empregados where cpf_supervisor is null
select * from empregados where salario between 6000 and 7000

'Lista 4'
select enome, salario from empregados where dnumero=2 and salario>=6000 order by enome asc
select enome from empregados where cpf=(select cpf_supervisor where salario>5000)
select E.enome, E.salario from empregados E where E.salario>(select S.salario from empregados S where E.cpf_supervisor=S.cpf)
'obs: como fazer para não aparecer os próprios nomes dos empregados que são os supervisores?'
select E.enome from empregados E, projetos Pr, departamentos D where Pr.dnumero=D.dnumero and D.cpf_gerente=E.cpf
select Pr.pnome from projetos Pr, empregados E, trabalha Tr where Pr.pnumero=Tr.pnumero and Tr.cpf_emp=E.cpf and E.enome='João Vilnei'
select Pr.pnome from projetos Pr, departamentos D, empregados E where Pr.dnumero=D.dnumero and D.cpf_gerente=E.cpf and E.enome='João Vilnei'
select avg(E.salario) from empregados E, departamentos D where E.dnumero=D.dnumero and D.dnome='Design Digital'
select E.enome, count(*) from empregados E, projetos Pr, trabalha Tr where E.cpf=Tr.cpf_emp and Tr.pnumero=Pr.pnumero group by E.enome
select Pr.pnome, count(*) from projetos Pr, empregados E, trabalha Tr where E.cpf=Tr.cpf_emp and Tr.pnumero=Pr.pnumero group by Pr.pnome
select Pr.pnome, count(*) from projetos Pr, empregados E, trabalha Tr where E.cpf=Tr.cpf_emp and Tr.pnumero=Pr.pnumero group by Pr.pnome having count(*)>1
'Outra maneira a 10'
select Pr.pnome, count(Tr.cpf_emp) from projetos Pr, trabalha Tr where Pr.pnumero=Tr.pnumero group by Pr.pnome having count(Tr.cpf_emp)>1


'Lista 5'
select 	E.cpf from empregados E where E.cpf not in (select Tr.cpf_emp from trabalha Tr)
'Outra maneira de resolver a 1'
select E.cpf from empregados E except select Tr.cpf_emp from trabalha Tr
select E.cpf from empregados E where E.cpf in (select Tr.cpf_emp from trabalha Tr)
select E.cpf from empregados E where not exists ((select Pr.pnumero from projetos Pr) except (select Tr.pnumero from trabalha Tr where Tr.cpf_emp=E.cpf))
select E.enome, E.salario, D.dnome from empregados E left outer join departamentos D on E.cpf=D.cpf_gerente
select E.enome from empregados E, departamentos D where E.dnumero=D.dnumero and D.dnome='Design Digital' and E.salario in (select max(E.salario) from empregados E, departamentos D where E.dnumero=D.dnumero and D.dnome='Design Digital')
select count(E.cpf) from empregados E, trabalha Tr where E.cpf=Tr.cpf_emp group by E.cpf having count(Tr.pnumero)>1
select D.dnome, E.enome from departamentos D left join empregados E on E.dnumero=D.dnumero



select E.enome from empregados E where E.cpf=(select E.cpf from empregados E except select Tr.cpf_emp from trabalha Tr)





