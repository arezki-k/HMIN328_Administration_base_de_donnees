-- sqlldr userid=user/mdp@venus/master control=Commune_ctl.txt
-- quelques manipulations après chargement des tuples dans la table Commune

update Commune set dep='0'||dep where dep <10;

update Commune set dep='2A' where dep ='201';
update Commune set dep='2B' where dep ='202';

update Commune set com='00'||com where length(com)=1;
update Commune set com='0'||com where length(com)=2;

/*
Vous rajouterez une colonne nommée code insee de type chaı̂ne de caractères de longueur 6 à la
table Commune
*/
ALTER TABLE Commune
add
(
	code_insee varchar(6)
)
;
/*
Vous mettrez à jour le contenu de cette colonne qui prendra pour chaque tuple, la valeur obtenue
par concaténation de dep et com
*/
UPDATE Commune
SET code_insee = CONCAT(dep,com)
;
/*
Vous définirez une contrainte de clé primaire portant sur cet attribut code insee
*/
ALTER TABLE Commune
DROP PRIMARY KEY
;

ALTER TABLE Commune
add
(
CONSTRAINT pk_Commune
PRIMARY KEY (code_insee)
)
;
/*
Le schéma de la base de données comprend une redondance (attribut reg) qu’il convient de
supprimer par souci d’efficacité. Cette redondance provient du contenu du fichier tabulé des
données sur les communes exploité.
*/
ALTER TABLE Commune
DROP COLUMN reg
;
/*
*/

ALTER TABLE Commune ENABLE CONSTRAINT fk_Commune_Dept
;

ALTER TABLE Departement ENABLE CONSTRAINT pk_Departement
;
