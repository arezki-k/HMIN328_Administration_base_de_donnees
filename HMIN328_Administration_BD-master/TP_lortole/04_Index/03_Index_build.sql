/*
4.1. Construction et manipulation d’index

Vous cr ́eerez un index non unique (DEP IDX) sur l’attribut DEP de COMMUNE et un in-
dex unique (COM IDX) sur la fonction tr`es simple LOWER(NOM COM). Consulter user indexes,
index stats et user extents pour avoir quelques informations sur les index cr ́e ́es. Vous exploiterez
les syntaxes suivantes pour soit d ́esactiver, soit supprimer les index (DEP IDX, COM IDX, COM-
MUNE PK) :
alter index <nom_index> disable;
alter index <nom_index> enable;
drop index <nom_index>;
Que remarquez vous ?
*/




/*
4.2. Evaluation du temps

Il existe diff ́erents mani`eres d’ ́evaluer le temps d’ex ́ecution d’une requˆete dans Oracle. Nous avons
dans le cours pr ́ec ́edent que l’information pouvait ˆetre obtenue `a partir des attributs cpu time et
elapsed time de la vue v$sql. Une alternative simple est d’exploiter la variable d’environnment TIMING
(set timing on pour l’activation et set timing off pour la d ́esactivation). Un exemple d’utilisation vous
est donn ́e que vous testerez sur une requˆete  ́el ́ementaire sur COMMUNE. Le r ́esultat est pr ́ecis au
centi`eme de secondes, ainsi la requˆete de l’exemple a demand ́e 62 centi`emes pour le processus (parse-
fetch-execute) donnant acc`es aux r ́esultats

*/

set time off ;
set timing on;


/*
4.3. Premi`eres  ́evaluations de performance
*/


/*
4.4. Autres tests
*/
