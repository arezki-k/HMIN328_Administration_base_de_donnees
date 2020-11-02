/*
1. Nom et population en 2010 des communes de l’Hérault,
*/
SELECT nom_dep
FROM Departement
ORDER BY nom_dep
;

SELECT nom_dep, SUM(Commune.pop_2010)
FROM Departement, Commune
WHERE nom_dep like 'HERAULT' AND  (Commune.dep = Departement.dep)
GROUP BY nom_dep
;

SELECT nom_dep, SUM(Commune.pop_2010)
FROM Departement, Commune
WHERE (Commune.dep = Departement.dep)
GROUP BY nom_dep
;
/*
2. Donner les communes qui sont à la fois chef lieu de région et de département
*/
SELECT R.chef_lieu, nom_reg, nom_dep , D.chef_lieu
FROM Region R, Departement D
WHERE R.chef_lieu = D.chef_lieu
ORDER BY R.chef_lieu
;

SELECT chef_lieu
FROM Departement
INTERSECT
SELECT chef_lieu
FROM Region
;

/*
3. Donner les communes qui sont chef lieu de département sans être chef lieu de région
*/
/*
SELECT nom_com , nom_dep , nom_reg
FROM Region R, Departement D, Commune C
WHERE R.chef_lieu != C.code_insee and C.code_insee = D.chef_lieu
ORDER BY nom_com
;
*/

SELECT chef_lieu
FROM Departement
MINUS
SELECT chef_lieu
FROM Region
;

SELECT nom_com
FROM Commune
WHERE code_insee NOT IN (SELECT chef_lieu FROM Departement)
AND code_insee  IN (SELECT chef_lieu FROM Region)
;


/*
4. Donner les communes qui sont chef lieu de région sans être chef lieu de département
*/
/*
SELECT nom_com , nom_dep , nom_reg
FROM Region R, Departement D, Commune C
WHERE C.code_insee != D.chef_lieu and C.code_insee = D.chef_lieu
ORDER BY nom_com
*/

SELECT chef_lieu
FROM Region
MINUS
SELECT chef_lieu
FROM Departement
;

SELECT nom_com
FROM Commune
WHERE code_insee IN (SELECT chef_lieu FROM Departement)
AND code_insee NOT IN (SELECT chef_lieu FROM Region)
;

/*
5. Donner les communes qui dépendent du même chef lieu de département que FLORENSAC (code INSEE 34101)
*/

SELECT nom_com, code_insee FROM Commune WHERE code_insee LIKE '%34101%'
;

SELECT chef_lieu
from Departement
WHERE dep = (SELECT dep FROM Commune WHERE code_insee LIKE '%34101%')
;

SELECT nom_com
from Commune C
WHERE C.dep = (SELECT dep FROM Commune WHERE code_insee LIKE '%34101%')
;

/*
6. Donner le nombre de départements par région
*/

SELECT nom_reg , COUNT(nom_dep)
FROM Region R, Departement D
WHERE R.reg = D.reg
GROUP BY nom_reg
ORDER BY nom_reg
;

/*
7. Donner le nombre de communes et de départements par région
*/

DROP VIEW view_dep_com
;

CREATE VIEW view_dep_com AS
SELECT d.dep , COUNT(nom_com) AS nb_com
FROM Commune c, Departement d
WHERE(c.dep = d.dep)
GROUP by d.dep
;

SELECT * from view_dep_com

SELECT nom_reg , COUNT(nom_dep), SUM(nb_com)
FROM Region R, Departement D , view_dep_com v
WHERE R.reg = D.reg  AND v.dep = D.dep
GROUP BY nom_reg
ORDER BY nom_reg
;

/*
8. Donner pour la plus petit commune (ou les plus petites communes) de France métropolitaine
(en nombre d’habitants en 2010), son nom, le nom de son département et le nom de sa région
*/

SELECT nom_com , pop_2010 , nom_dep , nom_reg
FROM Commune c, Departement d , Region R
where pop_2010 = (SELECT MIN(pop_2010)
	from Commune) AND (c.dep = d.dep) AND (d.reg = r.reg)
;

/*
9. Ecrivez une requête qui permet de faire ressortir le manque d’informations pour les communes
appartenant aux régions de l’ultra-marin (GUYANE ou MAYOTTE par exemple)
*/

SELECT chef_lieu , nom_reg
FROM Region
ORDER BY chef_lieu
;

SELECT code_insee
FROM Commune
WHERE code_insee LIKE'97%'
;

SELECT nom_com , code_insee
FROM Commune
WHERE code_insee LIKE'92%'
;


/*
10. Nom, populations en 1975 et en 2010 des communes qui ont connu un afflux de population entre 1975 et 2010
*/

SELECT nom_com , pop_1975,pop_2010
FROM Commune
WHERE pop_2010 > pop_1975
ORDER BY pop_2010
;



/*
11. Nom, population en 1975 et population en 2010 des communes de Languedoc-Roussillon
(triées par ordre alphabetique) qui ont connu une diminution de population entre 1975 et 2010
*/

SELECT nom_com , pop_1975,pop_2010
FROM Commune
WHERE pop_2010 < pop_1975
ORDER BY nom_com
;

/*
12. Vue qui collecte les informations des communes (nom commune, nom département, nom région
et recul de population) dont la population a baissé entre 2000 et 2010 puis consultation de cette
vue
*/

DROP VIEW view_com_dep_reg
;
CREATE VIEW view_com_dep_reg AS
SELECT nom_com , nom_dep , nom_reg , (c.pop_2010 - c.pop_1975) AS recul_pop
FROM Commune c, Departement d , Region R
WHERE(c.dep = d.dep) AND (d.reg = r.reg) AND pop_2010 < pop_2000
;

SELECT * FROM view_com_dep_reg
;


/*
13. A partir de la vue, existe t’il des départements dont aucune commune n’a subi de recul de
population entre 2000 et 2010 ?
*/

SELECT COUNT(v.nom_dep)
FROM view_com_dep_reg v
WHERE v.nom_com IN (SELECT Commune.nom_com
FROM Commune
WHERE pop_2010 > pop_2000)
ORDER BY nom_dep
;

SELECT COUNT(v.nom_dep)
FROM view_com_dep_reg v
WHERE v.nom_com NOT IN (SELECT Commune.nom_com
FROM Commune
WHERE pop_2010 > pop_2000)
ORDER BY nom_dep
;

SELECT COUNT(v.nom_dep)
FROM view_com_dep_reg v
WHERE v.nom_com IN (SELECT Commune.nom_com
FROM Commune
WHERE pop_2010 < pop_2000)
ORDER BY nom_dep
;


SELECT COUNT(v.nom_dep)
FROM view_com_dep_reg v
WHERE v.nom_com NOT IN (SELECT Commune.nom_com
FROM Commune
WHERE pop_2010 < pop_2000)
ORDER BY nom_dep
;

/*
14. Nom de la ou des communes du Languedoc-Roussillon qui ont le plus grand différentiel en terme
de diminution de population (nombre de personnes) entre 1975 et 2010
*/

SELECT nom_com , pop_1975 , pop_2010
FROM Commune
WHERE (pop_2010 - pop_1975) = (SELECT MIN(ABS(pop_2010 - pop_1975))
FROM Commune C, Departement D, Region R
WHERE C.dep=D.dep and D.reg=R.reg and R.nom_reg like 'LANGUEDOC-ROUSSILLON')
ORDER BY nom_com
;
