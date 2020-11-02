/*
2. Export de sch ́
ema
2.1
Pr ́
ealable
Le paquetage DBMS METADATA 1 int`egre différentes fonctions et procédures qui vont faciliter
les travaux de manipulation portant sur les schémas de bases de données. Nous exploitons plus parti-
culi`erement ici :
– les fonctions GET DDL et GET DEPENDENT DDL (voir aussi GET XML et GET DEPENDENT XML)
qui permettent d'afficher l'ordre de création d'un objet en particulier ou bien d'un schéma utili-
sateur en particulier. Ces fonctions renvoient une valeur de type CLOB (Character Large Object
Binary).
– la procédure SET TRANSFORM PARAM qui propose différents variantes `a l'affichage : point-
virgule final, informations sur le stockage, . . .au travers d'une prise en charge de couples pro-
priétés - valeurs.
Des exemples de fonctionnement vous sont donnés :
*/
/*
Table à tout faire DUAL
gestion CLOB
*/
set long 40000
select DBMS_METADATA.GET_DDL('TABLE','COMMUNE') from DUAL;

/*

DBMS_METADATA.GET_DDL('TABLE','COMMUNE')
--------------------------------------------------------------------------------

CREATE TABLE "LORTOLE"."COMMUNE"
(	"DEP" VARCHAR2(4),
"COM" VARCHAR2(4),
"ARTICLE" VARCHAR2(4),
"NOM_COM" VARCHAR2(46),
"LONGITUDE" FLOAT(126),
"LATITUDE" FLOAT(126),
"POP_1975" FLOAT(126),
"POP_1976" FLOAT(126),
"POP_1977" FLOAT(126),

DBMS_METADATA.GET_DDL('TABLE','COMMUNE')
--------------------------------------------------------------------------------
"POP_1978" FLOAT(126),
"POP_1979" FLOAT(126),
"POP_1980" FLOAT(126),
"POP_1981" FLOAT(126),
"POP_1982" FLOAT(126),
"POP_1983" FLOAT(126),
"POP_1984" FLOAT(126),
"POP_1985" FLOAT(126),
"POP_1986" FLOAT(126),
"POP_1987" FLOAT(126),
"POP_1988" FLOAT(126),

DBMS_METADATA.GET_DDL('TABLE','COMMUNE')
--------------------------------------------------------------------------------
"POP_1989" FLOAT(126),
"POP_1990" FLOAT(126),
"POP_1991" FLOAT(126),
"POP_1992" FLOAT(126),
"POP_1993" FLOAT(126),
"POP_1994" FLOAT(126),
"POP_1995" FLOAT(126),
"POP_1996" FLOAT(126),
"POP_1997" FLOAT(126),
"POP_1998" FLOAT(126),
"POP_1999" FLOAT(126),

DBMS_METADATA.GET_DDL('TABLE','COMMUNE')
--------------------------------------------------------------------------------
"POP_2000" FLOAT(126),
"POP_2001" FLOAT(126),
"POP_2002" FLOAT(126),
"POP_2003" FLOAT(126),
"POP_2004" FLOAT(126),
"POP_2005" FLOAT(126),
"POP_2006" FLOAT(126),
"POP_2007" FLOAT(126),
"POP_2008" FLOAT(126),
"POP_2009" FLOAT(126),
"POP_2010" FLOAT(126),

DBMS_METADATA.GET_DDL('TABLE','COMMUNE')
--------------------------------------------------------------------------------
"CODE_INSEE" VARCHAR2(6),
CONSTRAINT "PK_COMMUNE" PRIMARY KEY ("CODE_INSEE") DISABLE,
CONSTRAINT "FK_COMMUNE_DEPT" FOREIGN KEY ("DEP")
REFERENCES "LORTOLE"."DEPARTEMENT" ("DEP") ENABLE
) SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DE
FAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "USERS"


DBMS_METADATA.GET_DDL('TABLE','COMMUNE')
--------------------------------------------------------------------------------

*/

/*
Vues m ́
eta-sch ́
ema avec  ́
ecriture dans un fichier
*/
spool emp.sql
set long 40000
set head off echo off

exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',false);
select dbms_metadata.get_ddl('TABLE','REGION', USER) from user_tables;
spool off

/*

...

CREATE TABLE "LORTOLE"."REGION"
(	"REG" VARCHAR2(4),
"CHEF_LIEU" VARCHAR2(46),
"NOM_REG" VARCHAR2(30),
CONSTRAINT "PK_REGION" PRIMARY KEY ("REG") ENABLE
)

84 rows selected.
*/

spool emp.sql
set long 40000
set head off echo off

exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',false);
select dbms_metadata.get_ddl('TABLE','REGION', USER) from dual;
spool off

spool emp.sql
set long 40000
set head off echo off

exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',false);
select dbms_metadata.get_ddl('TABLE','REGION', 'LORTOLE') from dual;
spool off

/*
CREATE TABLE "LORTOLE"."REGION"
(	"REG" VARCHAR2(4),
"CHEF_LIEU" VARCHAR2(46),
"NOM_REG" VARCHAR2(30),
CONSTRAINT "PK_REGION" PRIMARY KEY ("REG") ENABLE
)
*/


/*

2.2
Exercices
1. Vous construirez une fonction nommée TouteTable qui renvoie les ordres de création de toutes
les tables d’un schéma utilisateur dont le nom est passé en param`etres d’entrée (variable de sortie
de type CLOB).

*/

CREATE OR REPLACE PACKAGE Pkg_MigExprtSchm
IS
-- Procédures publiques
procedure proc_Table(arg_table in varchar2 ,arg_username in varchar2);
procedure proc_TouteTable(arg_username in varchar2);
end Pkg_MigExprtSchm ;
/

desc Pkg_MigExprtSchm ;

CREATE OR REPLACE PACKAGE BODY Pkg_MigExprtSchm IS
procedure proc_Table (arg_table in varchar2 , arg_username in varchar2)
is
TYPE t_usertable IS TABLE OF VARCHAR2(50);
cursor cTable is
select dbms_metadata.get_ddl('TABLE',arg_table, arg_username) as createTable
from dual;
begin
for tup in cTable
loop
dbms_output.put_line('Table : '||tup.createTable) ;
end loop ;
end proc_Table;
/**/
procedure proc_TouteTable (arg_username in varchar2)
is
TYPE curseur_usertable IS REF CURSOR;
tables t_usertable ;
tab_name VARCHAR2(30);
begin
Pkg_Tools.proc_get_table(arg_username,tables);
  OPEN curseur_usertable FOR tables ;
  loop
    FETCH curseur_usertable INTO tab_name ;  -- fetch next row
    EXIT WHEN curseur_usertable%NOTFOUND;  -- exit loop when last row is fetched
    select dbms_metadata.get_ddl(tab_name,t_usertable(tupa), arg_username) as createTable
    from dual;
    begin
    for tup in ccTable
      loop
      dbms_output.put_line('Table : '||tup.createTable) ;
    end loop ;
  end loop ;
  CLOSE curseur_usertable;
end proc_TouteTable;
end Pkg_MigExprtSchm;
/

set serveroutput on ;
spool emp.sql ;
set long 40000 ;
set head off echo off ;
execute Pkg_MigExprtSchm.proc_Table('REGION','LORTOLE');
spool off;
