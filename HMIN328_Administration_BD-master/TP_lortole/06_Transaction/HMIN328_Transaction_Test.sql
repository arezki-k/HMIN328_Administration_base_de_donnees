--Vous testerez les sequences d''instruction suivantes et vous expliquerez les effets obtenus

PURGE recyclebin ;


-- sequence 1
set transaction read only;
 update emp set fonction='commerciale' where fonction='commercial';

commit ;


/*

ERREUR a la ligne 1 :
ORA-01456: impossible d'executer l'operation inserer/supprimer/modifier dans
une transaction READ ONLY

*/

SET TRANSACTION READ WRITE;
select * from cat;
update emp set fonction='commercial' where fonction='commerciale';

rollback ;

--sequence 2
select * from cat;
set transaction read only;
rollback;


--sequence 3
set transaction read only;
create table PrVoir (valeur integer primary key);
update emp set fonction='commerciale' where fonction='commercial';
rollback;


desc v$transaction ;

select name , STATUS , START_TIME from v$transaction ;



--sequence 4
insert into PrVoir values (1);
insert into PrVoir values (2);
insert into PrVoir values (3);
insert into PrVoir values (4);
insert into PrVoir values (5);

create table EncorePrVoir (valeur integer primary key);
select * from cat where TABLE_NAME like 'ENCOREPRVOIR' ;
rollback;


--sequence 5
insert into PrVoir values (1);
insert into PrVoir values (2);
insert into PrVoir values (3);
insert into PrVoir values (4);
insert into PrVoir values (5);
create table EncorePrVoir (valeur integer primary key);
rollback;

select * from cat where TABLE_NAME like '%VOIR%' ;


--sequence 6
delete from PrVoir;
create table CorePrVoir (valeur integer primary key);
insert into PrVoir values (1);
insert into PrVoir values (2);
insert into PrVoir values (3);
insert into PrVoir values (4);
insert into PrVoir values (5);
rollback;

select * from cat where TABLE_NAME like '%VOIR%' ;



--sequence 7
insert into PrVoir values (1);
create table CorePrVoir (valeur integre);
rollback;
select * from PrVoir;

select * from cat where TABLE_NAME like '%VOIR%' ;

-- sequence 8
-- deux sessions ouvertes par ex. user1/user1 et user2/user2 sur master (travaillez en binôme)

-- sur user2 donner tous les droits a user1 sur la table emp
GRANT ALL ON emp TO mmaiga;
REVOKE ALL ON emp FROM mmaiga;

GRANT INSERT, UPDATE ON emp TO msoltan;
REVOKE INSERT, UPDATE ON emp FROM msoltan;
/*
GRANT ALL ON emp TO public;
REVOKE ALL ON emp FROM public;
*/

-- sur user1
set transaction isolation level serializable;

--sur user2 insérer un tuple dans la table emp (de user2)
insert into mmaiga.emp values (99,'Lowx','Chloe','designer',3900,null,null,2,3);
insert into mmaiga.emp values (100,'Mariam','Chloe','designer',3900,null,null,2,3);
insert into mmaiga.emp values (101,'Mahshad','Chloe','designer',3900,null,null,2,3);
commit ;
select * from mmaiga.emp where nom like 'Lowx';

-- sur user1 consulter la table user2.emp constatation ?

Insertion visible chez user1 mais pas chez user2 si
-le user1 ne valide pas sa transaction
-le user2 est en mode isolation level serializable

-- sur user2 valider la transaction

-- sur user1 consulter la table user2.emp constatation ?
quel aurait été le résultat avec un mode transactionnel read committed ?

SET TRANSACTION isolation LEVEL READ  committed ;

-- sur user2
-- mettre à jour un tuple
update emp set salaire =4321 where num=13;
select * from emp where num=13;
commit;

-- sur user1
-- essayer de mettre à jour le même tuple
update mmaiga.emp set salaire =4500 where num=12;
select * from mmaiga.emp where num=12;
commit;

constatation ?
-- sur user2
valider la transaction
-- sur user1
constatation ?
quel aurait été le résultat avec un mode transactionnel read committed ?

-- sequence 9
-- interblocage
-- deux sessions ouvertes en mode read committed
-- sur user2
-- mettre à jour un tuple
update emp set salaire =1000 where num=10;

-- sur user1
-- essayer de mettre à jour le même tuple
update mmaiga.emp set salaire =9876 where num=11;

-- sur user2
-- mettre à jour le tuple verrouillé par user 1
update emp set salaire =1000 where num=12;

-- sur user1
-- mettre à jour le tuple verrouillé par user 2
update user2.compte set salaire =2000 where num=10;

constatation ? comment sortir de l''interblocage et quelle est l''information perdue
quel aurait été le résultat avec un mode transactionnel serializable ?
