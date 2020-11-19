Vous testerez les sequences d''instruction suivantes et vous expliquerez les effets obtenus

-- sequence 1
set transaction read only;
select * from cat;
update employe set fonction='commerciale' where fonction='commercial';


Erreur SQL : ORA-01456: impossible d'exécuter l'opération insérer/supprimer/modifier dans une transaction READ ONLY
01456. 00000 -  "may not perform insert/delete/update operation inside a READ ONLY transaction"
*Cause:    A non-DDL insert/delete/update or select for update operation
           was attempted
*Action:   commit (or rollback) transaction, and re-execute

--sequence 2
select * from cat;
set transaction read only;
rollback;

Erreur SQL : ORA-01453: SET TRANSACTION doit être la première instruction de la transaction
01453. 00000 -  SET TRANSACTION must be first statement of transaction
*Cause:    self-evident
*Action:   commit (or rollback) transaction, and re-execute
Annulation (rollback) terminée.

Donc : On ne peut pas changer les propriétés d une transaction au cours de son exécution.

--sequence 3
set transaction read only;
create table PrVoir (valeur integer primary key);
update emp set fonction='commerciale' where fonction='commercial';
rollback;

Succès de l élément transaction READ.
Table PRVOIR créé(e).
6 lignes mis à jour.
Annulation (rollback) terminée.

Parceque : le create impose un commit avant&après (Une transation). Le mode read only ne s appliquera pas à la taransaction du update. 

--sequence 4
insert into PrVoir values (1);
insert into PrVoir values (2);
insert into PrVoir values (3);
insert into PrVoir values (4);
insert into PrVoir values (5);
create table EncorePrVoir (valeur integre cle primaire);
rollback;

create table EncorePrVoir (valeur integre cle primaire)
Rapport d erreur -
Erreur SQL : ORA-00907: parenthèse de droite absente
00907. 00000 -  "missing right parenthesis"
*Cause:    
*Action:
Annulation (rollback) terminée.


Parceque : Constation d une erreur pour l ordre create. L erreur est jugé importante donc le pré-commit ne s exécute pas.
 
--sequence 5
insert into PrVoir values (1);
insert into PrVoir values (2);
insert into PrVoir values (3);
insert into PrVoir values (4);
insert into PrVoir values (5);
create table EncorePrVoir (valeur integer primary key);
rollback;

Exécution normale.

--sequence 6
delete from PrVoir;
create table CorePrVoir (valeur integer primary key);
insert into PrVoir values (1);
insert into PrVoir values (2);
insert into PrVoir values (3);
insert into PrVoir values (4);
insert into PrVoir values (5);
rollback; 

Exécution :

delete from PrVoir;
--Pré - Commit
create table CorePrVoir (valeur integer primary key);
--Post - Commit
insert into PrVoir values (1); --Annulée
insert into PrVoir values (2); --Annulée
insert into PrVoir values (3); --Annulée
insert into PrVoir values (4); --Annulée
insert into PrVoir values (5); --Annulée
rollback;

--sequence 7
insert into PrVoir values (1);
create table CorePrVoir (valeur integre);
rollback;
select * from PrVoir;

Exécution : 

insert into PrVoir values (1);
--Pré-commit
create table CorePrVoir (valeur integre); --Erreur type non reconnu mais le pré-commit est réalisé et la table est crée (certification)
--Post-commit
rollback;
select * from PrVoir; -- Donne : 1

-------------------------------------------------------------------------------------------------PREMIERE PARTIE----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- sequence 8
-- deux sessions ouvertes par ex. wissem/wissem et houssem/houssem sur master (travaillez en binôme)

-- sur houssem
donner tous les droits a wissem sur la table emp
-- sur wissem
set transaction isolation level serializable;
--sur houssem
insérer un tuple dans la table emp (de houssem)
-- sur wissem
consulter la table houssem.emp 
constatation ?

la transaction exécutée en serializable prend en concidération juste l état de la base au moment du début de son exécution (Image). 
Même avec un commit par l autre utilisateur alors le tuple ajouté restera invisible.

-- sur houssem 
valider la transaction
-- sur wissem
consulter la table houssem.emp 
constatation ? quel aurait été le résultat avec un mode transactionnel read committed ?

Dans ce cas avant validation le tuple aurait été invisible. Mais après validation il serait devenu visible.

-- sur houssem 
-- mettre à jour un tuple 
update emp set salaire =1000 where num=12;

-- sur wissem
-- essayer de mettre à jour le même tuple
update houssem.emp set salaire =2000 where num=12;
constatation ?

Le tuple est vérouillé. La transaction attent qu il soit dévérouillé.
 
-- sur houssem 
valider la transaction
-- sur wissem
constatation ? 

Erreur SQL : ORA-08177: impossible de sérialiser laccès pour cette transaction
08177. 00000 -  can t serialize access for this transaction
*Cause:    Encountered data changed by an operation that occurred after
           the start of this serializable transaction.
*Action:   In read/write transactions, retry the intended operation or
           transaction.
		   
quel aurait été le résultat avec un mode transactionnel read committed ?

La transaction aurait terminé son exécution après le dévérouillage du tuple. 

-- sequence 9
-- interblocage
-- deux sessions ouvertes en mode read committed
-- sur houssem 
-- mettre à jour un tuple 
update emp set salaire =1000 where num=10;

-- sur wissem
-- essayer de mettre à jour le même tuple
update user_db.compte set salaire =2000 where num=11;

-- sur houssem 
-- mettre à jour le tuple verrouillé par user 1 
update emp set salaire =1000 where num=11;

-- sur wissem
-- mettre à jour le tuple verrouillé par user 2
update user_db.emp set salaire =2000 where num=10;

constatation ?

Erreur SQL : ORA-00060: détection d interblocage pendant l attente d une ressource
00060. 00000 -  "deadlock detected while waiting for resource"
*Cause:    Transactions deadlocked one another while waiting for resources.
*Action:   Look at the trace file to see the transactions and resources
           involved. Retry if necessary.
		   
Le système arrête la première transaction rentrée en conflit.

comment sortir de l interblocage et quelle est l information perdue
quel aurait été le résultat avec un mode transactionnel serializable ?7

L utilisateur libéré doit faire un commit. Les modifications seront juste ceux de l autre utilisateur. 

-------------------------------------------------------------------------------------------------DEUXIEME PARTIE----------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

2.2 Afficher les informations concernant les sessions utilisateurs en cours

Users :

USER_DB     proprietaire    99180      unknown       2016-12-02 01:42
WISSEM      proprietaire    99180      unknown       2016-12-02 15:15

a) select s.username, s.osuser, p.program from v$process p, v$session s
   where p.ADDR=s.PADDR
   AND s.type='USER';

b) select count(*) from dba_users;

2.3 Vues dynamiques et m´ecanismes transactionnels

