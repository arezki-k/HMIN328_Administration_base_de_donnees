/*
La construction d'un index entraˆıne un surcoˆ
ut de stockage qui peut s'av ́erer non n ́egligeable.
Vous testerez les fonctionnalit ́es d'estimation de la taille en blocs (allou ́es et utilis ́es) d'un index dont
la cr ́eation est envisag ́ee (testez sur DEP IDX et COM IDX). Vous v ́erifierez ensuite la pertinence
de ces estimations en recr ́eant DEP IDX et COM IDX et en interrogeant la vue USER SEGMENTS.
L'utilisation de la proc ́edure CREATE INDEX COST se fait par le biais de variables d'environnement
(bind variables) et donc l'utilisation du SQL Dynamique. Nous verrons dans le prochain TP que ces
variables pr ́esentent un int ́erˆet tout particulier dans tout ce qui rel`eve de l'ex ́ecution de requˆetes.
*/
-- declaration des variables de session
variable used_bytes number
variable alloc_bytes number
exec dbms_space.create_index_cost( 'create index testCommune_idx on commune(nom_com)',
:used_bytes, :alloc_bytes );
-- affichage contenu variables
print :used_bytes
print :alloc_bytes
-- valeur reelle de la taille
create index testCommune_idx on commune(nom_com);
select trim(to_char(bytes, '999,999,999')) actual_bytes
from user_segments where segment_name = 'TESTCOMMUNE_IDX';
