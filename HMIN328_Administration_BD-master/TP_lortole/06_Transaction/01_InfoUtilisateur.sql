set linesize 300 ;
/*
Nous allons travailler sur la base de données employés dont le schéma relationnel vous est donné
ci-dessous :
fonction(nom f varchar(15), salaire min float, salaire max float)
dep (num d number, nom d, adresse)
emp (num e number, nom varchar(15), prenom varchar(15), fonction varchar(15), salaire float,
commission float, date embauche date, n sup number, n dep number)
Avec employe(n sup) ⊆ employe(num) et employe(fonction) ⊆ fonction(nom f) et employe(n dep) ⊆
departement(num d)
Un script de création des tables est également donné.
*/

/*
2. Objectifs
Il s'agit, dans ce TP, d'explorer diff ́erents ordres SQL et vues dynamiques orient ́ees vers de la
manipulation des m ́ecanismes transactionnels et de la supervision de bases de donn ́ees Oracle. Vous
travaillerez de ce fait en binˆ
ome afin d'ex ́ecuter des transactions d ́efinies au sein de deux sessions
utilisateur diff ́erentes mais portant sur les mˆemes objets.
*/


/*
2.1
Vérifier vos connaissances au sujet du modèle transactionnel
Un fichier portant une extension .sql vous est fourni, vous testerez les diff ́erents blocs d’ordres
contenus et vous r ́epondrez aux questions associ ́ees `a ces tests.
*/

/*
2.2
Afficher les informations concernant les sessions utilisateurs en cours
Vous d ́efinirez une premi`ere requˆete SQL qui consultera le contenu des vues dynamiques v$session
et v$process et qui restituera le nom des usagers connect ́es, la date d’ouverture de leur session ainsi
que des informations sur leurs applications clientes. A titre d’exemple, une requˆete SQL dont vous
pouvez vous inspirer, vous est propos ́ee.
*/

select paddr, username, osuser, process, terminal,
to_char(logon_time, 'YYYY-MM-DD HH24:MI') as logon_time
from v$session vs
where type='USER';


select vs.username, vs.osuser, vs.process, vs.terminal,
to_char(vs.logon_time, 'YYYY-MM-DD HH24:MI') as logon_time  , vp.addr
from v$session vs ,v$process vp
where type='USER' and vp.addr = vs.paddr;

select vs.username, vs.osuser, vs.process, vs.terminal,
to_char(vs.logon_time, 'YYYY-MM-DD HH24:MI') as logon_time  , vp.addr
from v$session vs ,v$transaction vt
where type='USER' and vt.addr = vs.paddr;


select * from

/*
USERNAME		       OSUSER			      PROCESS		       TERMINAL 		      LOGON_TIME
------------------------------ ------------------------------ ------------------------ ------------------------------ ----------------
JMUNOZAVENDA		       jmunozavenda		      5654		       pts/1			      2016-12-02 14:57
MHOUADJ 		       mhouadj			      22999		       pts/2			      2016-12-02 14:41
JCHOPELET		       jchopelet		      13931		       pts/2			      2016-12-02 14:44
YSHIH			       yshih			      10237		       pts/2			      2016-12-02 14:53
YZAHIDI 		       yzahidi			      3057		       pts/1			      2016-12-02 15:25
LAMRANI 		       lamrani			      16133		       pts/1			      2016-12-02 14:44
MIMZOURH		       mimzourh 		      17009		       pts/2			      2016-12-02 16:35
ADIOUF			       adiouf			      10044		       pts/2			      2016-12-02 15:28
AHADDADOU		       ahaddadou		      8986		       pts/2			      2016-12-02 14:34
IMOUGENOT		       imougenot		      12063		       pts/3			      2016-12-02 16:18
AHADDADOU		       ahaddadou		      9987		       pts/0			      2016-12-02 15:22

USERNAME		       OSUSER			      PROCESS		       TERMINAL 		      LOGON_TIME
------------------------------ ------------------------------ ------------------------ ------------------------------ ----------------
YKERMOUCHE		       ykermouche		      5234		       pts/1			      2016-12-02 14:17
AVULETIC		       avuletic 		      3696		       pts/2			      2016-12-02 16:01
JDESTOUCHES		       jdestouches		      2891		       pts/3			      2016-12-02 16:29
SYAN			       syan			      12030		       pts/4			      2016-12-02 14:36
MPYZ			       mpyz			      3383		       pts/2			      2016-12-02 15:14
LORTOLE 		       lortole			      378		       pts/7			      2016-12-02 16:44
JJULIEN 		       jjulien			      9011		       pts/2			      2016-12-02 16:41
IHAMDAOUI		       ihamdaoui		      9794		       pts/1			      2016-12-02 14:52
MMAIGA			       mmaiga			      8085		       pts/2			      2016-12-02 14:24
MREZE			       mreze			      2317		       pts/1			      2016-12-02 15:57

21 rows selected.

*/

/*
La vue v$process (jointure avec v$session sur l’attribut paddr) restitue des informations, concernant
les applications clientes, exploit ́ees par les usagers, pour interagir avec la base de donn ́ees.
Vous pouvez  ́egalement travailler sur la vue dba users pour rendre compte du nombre d’usagers
connect ́es, par rapport au nombre d’usagers poss ́edant un compte sur la BD. Vous noterez qu’une
session est identifi ́ee par un identifiant de session, nomm ́e sid.
*/


/*

2.3
2
Vues dynamiques et m ́
ecanismes transactionnels
Des vues sont plus, pr ́ecis ́ement, d ́edi ́ees `a rendre compte des transactions en cours d’ex ́ecution, des
verrous pos ́es par ces transactions et des blocages  ́eventuels relatant de conflits d’acc`es `a des ressources
de la base de donn ́ees,  ́emanant de transactions concurrentes.
Ces vues vont permettre de donner des r ́eponses `a des questions telles que :
– quelles sont les transactions qui ont pos ́e des verrous sur la base de donn ́ees ?
– quelles sont les ressources verrouill ́ees ?
– quelle transaction est en attente de lib ́eration de verrou ?
– quelle transaction est bloquante pour quelle autre transaction ? Si une transaction est bloquante,
quels sont les ordres SQL qui ont provoqu ́e d’une part le blocage, et d’autre part la situation
d’attente ?
– ...

*/


/*

2.3.1
Exemple de la vue v$lock
La vue v$lock est une vue, particuli`erement informative, pour tout ce qui concerne les verrous
pos ́es sur la base.

*/

select  *
from v$lock vl
;




select  vl.SID ,username, osuser, process, terminal
from v$lock vl , v$session vs
where vl.BLOCK = 1 and vs.SID = vl.SID;


select SID ,username, osuser, process, terminal,
to_char(logon_time, 'YYYY-MM-DD HH24:MI') as logon_time
from v$session where type='USER';

select oracle_username, os_user_name, locked_mode,
object_name, object_type from v$locked_object a,dba_objects b
where a.object_id = b.object_id



select oracle_username, os_user_name, locked_mode, object_name, object_type , v.block
from v$locked_object a,dba_objects b , v$lock V
where a.object_id = b.object_id and v.ID1 = b.object_id  ;
/*


ORACLE_USERNAME 	       OS_USER_NAME		      LOCKED_MODE OBJECT_NAME							   OBJECT_TYPE
------------------------------ ------------------------------ ----------- -------------------------------------------------------------------------------------------------------------------------------- -------------------
ADIOUF			       adiouf					3 DEFERRED_STG$ 						   TABLE
ADIOUF			       adiouf					3 RECYCLEBIN$							   TABLE
ADIOUF			       adiouf					3 PRODUIT							   TABLE
ADIOUF			       adiouf					3 PROPOSE							   TABLE
MMAIGA			       mmaiga					3 EMP								   TABLE
MHOUADJ 		       mhouadj					3 FONCTION							   TABLE
MHOUADJ 		       mhouadj					3 DEP								   TABLE
MHOUADJ 		       mhouadj					3 EMP								   TABLE
MHOUADJ 		       mhouadj					3 VENTE 							   TABLE
MMAIGA			       mmaiga					3 EMP								   TABLE

10 rows selected.
*/


/*
2.3.4
Qui se trouve en situtation d’attente ?
Le nom de l’usager qui se trouve en attente d’une ressource, son identifiant de session et son temps
d’attente sont retourn ́es.
col username for a12
*/

select s.username ,s.sid,w.seconds_in_wait as n_seconds
from v$session s, v$session_wait w
where s.sid = w.sid ;


/*
2.3.5
Qui a pos ́
e des verrous bloquants ?
Des exemples qui permettent de renseigner les sessions (et transactions) qui ont pos ́e des verrous
qui peuvent s’av ́erer  ́eventuellement bloquants pour d’autres sessions.
*/

select sid,username from V$SESSION where sid in
(select sid from V$LOCK where block=1);

--ou

select username, v$lock.sid, lmode, request, block, v$lock.type
from v$lock, v$session where v$lock.sid = v$session.sid


/*
2.3.6
Qui bloque qui ?
Les colonnes id1 et id2 de la table v$lock permettent de mettre en correspondance les couples
session bloquante - session bloqu ́ee (qui partagent ces mˆemes identifiants, corr ́el ́es au segment d’annu-
lation exploit ́e de mani`ere sous-jacente). La session bloqu ́ee est dans l’impossibilit ́e de voir sa requˆete
ex ́ecut ́ee, et de sorte sa requˆete (colonne request) a une valeur sup ́erieure `a 0 (num ́ero correspondant
au type de verrou demand ́e).

Vous exploiterez de fa ̧con appropri ́ee les diff ́erentes vues explor ́ees (v$lock, v$session wait, dba blockers,
. . .) dans une proc ́edure PL/SQL qui permet pour une session en train de poser diff ́erents verrous (mise
a jour de tuples) de percevoir les autres sessions en concurrence subissant les effets des verrous pos ́es.
*/

select a.SID as blockingSession, b.SID as blockedSession, b.request
from v$lock a, v$lock b
where a.SID != b.SID and a.ID1 = b.ID1
and a.ID2 = b.ID2 and b.request > 0
and a.block = 1;
