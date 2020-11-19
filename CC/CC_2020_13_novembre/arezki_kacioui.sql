--AREZKI KACIOUI, Monomome, M2 IPS.
--Partie 1- paquetage DataCacheMetrics:


--creation du package DataCacheMetrics:

--declaration du package
create or replace package DataCacheMetrics
as

function blocksNumberInDataCache return integer;
--function allocatedBytesInDataCache return integer;
function ratioCachePerUser (username in varchar) return float;
function blocksNumberPerTablespac(tsname in varchar) return integer;
procedure afficheBlocsParTableSpace;
 
end DataCacheMetrics;
/
--corps du package:
create or replace package DataCacheMetrics
as
  --function 1: permet d'avoir le nombre total de blocs exploités.
 --create or replace
 function blocksNumberInDataCache return integer
  is
    blocks# integer ;
  begin
    SELECT count(*) INTO blocks# FROM v$bh;
  return blocks#;
  exception when others then return -1;
  end;


--   --function 2
--   function allocatedBytesInDataCache return integer
--   is
--   begin
--   return
--   exception
--   end

  --function 3:renvoie le pourcentage d'usage du cahce pour un user donné en parametre.

    --Nombre de bloc pour un user defini: 
        --select count(BLOCK#) from dba_objects, v$bh where OBJD=OBJECT_ID and  dba_objects.OWNER='E20160010237';
    --blocksNumberInDataCache():nombre de bloc total exploités.
 --create or replace
 function ratioCachePerUser (username in varchar) return float
  is 
    blocks# integer:=blocksNumberInDataCache();
    userblocks integer;
    Cursor c is
        select count(BLOCK#) from dba_objects, v$bh 
        where OBJD=OBJECT_ID 
        and  dba_objects.OWNER=username;
  begin
    open c;
    fetch c into userblocks;
    close c;
  return (userblocks/blocks#)*100;
  end;
  


  --function 4:renvoie pour une tablespace donnée le nombre de blocs de données exploités en memoire cache par celui-ci
        --nombre de bloc pour une tablespace definie:
            --select count(block#) from v$bh, v$tablespace where v$bh.TS#= v$tablespace.TS# and v$tablespace.name='USERS';
--create or replace 
function blocksNumberPerTablespac(tsname in varchar) return integer
 is 
    blocks integer;
    Cursor c is 
        select count(block#) from v$bh, v$tablespace 
        where v$bh.TS#= v$tablespace.TS# 
        and v$tablespace.name=tsname;
 begin 
    open c;
    fetch c into blocks;
    close c;
return blocks;
end;
      
    

 --Question 2:
    --Procedure:
--create or replace
procedure afficheBlocsParTableSpace
 is 
 cursor tsnames is
    select name from v$tablespace;
 begin
    for tn in tsnames loop
        dbms_output.put_line('nombre de blocks utilisés par la tablespace : '||tn.name||' est select'||blocksNumberPerTablespac(tsname)||'from dual');
    end loop;
 end;


end DataCacheMetrics;
/

--Question 3: Exemples de mise en oeuvre:
-- pour la fonction ratioCachePerUser('username')
--cette fonction permet renvoie le pourcentage d'usage du cahce pour un user donné en parametre.
--dans cet exemple de requete avec mon username et un username que j'ai recuperé avec la requete  
--select user, osuser, username from v$session;
--la fonction me renvoie le % de cache qui est exploité par le user
--au niveau du datacache.
/*
SQL> select ratioCachePerUser('E20160010237') from dual;

RATIOCACHEPERUSER('E20160010237')
---------------------------------
                       ,081395028


SQL> select ratioCachePerUser('E20160002018') from dual;
RATIOCACHEPERUSER('E20160002018')
---------------------------------
                       ,091869545

*/



--Partie 2: Library Cache et Data Buffer Cache:
        --Question 1:
        --details de la requete:
        set linesize 200 --defenit la taille de la ligne a 200 caractères.
        col osuser for a30 --définit la taille de la colonne osuser a 30 caractères.
        -- col sid for a5
        select s.sid, s.osuser, substr(a.sql_text,1,60), plan_hash_value 
        from v$session s join
        v$sqlarea a on a.hash_value = s.prev_hash_value ;

        --=>cette requete permet d'afficher des statistiques sur les requetes SQL qui sont en memoire, parsées et pretes à etre utilisé(substr(a.sql_text,1,60))
        --pour les utilisateurs de la base de données avec leurs hashvalues.

        --Illustrer l'interet de la requete:
        --permet de faire un suivie des requetes executées.

        /**
        SID OSUSER
                                            SUBSTR(A.SQL_TEXT,1,60)
---------- -------------------------------------------------------------------------------------------------------------------------------- ------------------------------------------------------------
PLAN_HASH_VALUE
---------------
        17 nihed.bendahman@etu.umontpellier.fr
                                            BEGIN DBMS_OUTPUT.GET_LINES(:LINES, :NUMLINES); END;
              0

        23 nihed.bendahman@etu.umontpellier.fr
                                            BEGIN DBMS_OUTPUT.GET_LINES(:LINES, :NUMLINES); END;
              0

       147 arezki.kacioui@etu.umontpellier.fr
                                            select s.sid, s.osuser, substr(a.sql_text,1,60), plan_hash_v
      411042773
        
        */
        --Enrichir la requete:

    select s.sid, s.osuser,s.username substr(a.sql_text,1,60), plan_hash_value    
        from v$session s join
        v$sqlarea a on a.hash_value = s.prev_hash_value ;