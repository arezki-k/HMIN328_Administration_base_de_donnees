--1. création des tables region et departement:
CREATE table departement AS
SELECT *
from P00000009432.departement;

CREATE table region AS
SELECT *
from P00000009432.region;

--2. exemples de requetes renvoyant le meme resultat:

--1
select nomcommaj, numdep, latitude, longitude
from commune
where nomcommaj 
 like 'M%' and numdep in ('30', '34');

--2
select nomcommaj, numdep, latitude, longitude
from commune
where nomcommaj 
  like 'M%' and (numdep='30' OR numdep='34');

--3
    SELECT nomcommaj, numdep, latitude, longitude
    FROM commune
    WHERE nomcommaj LIKE 'M%' and numdep = '30'
UNION
    SELECT nomcommaj, numdep, latitude, longitude
    FROM commune
    WHERE nomcommaj LIKE 'M%' and numdep = '34';
--* semble etre la forme la plus couteuse car on consulte la table commune deux fois;

--4
select nomcommaj, numdep, latitude, longitude
from commune
where(nomcommaj 
  like 'M%' and numdep='30') OR (nomcommaj like 'M%' and numdep='34');

--execice 2:
/*vous  ́ecrirez en alg`ebre relationnelle et de diff ́erentes mani`eres, la requˆete qui renvoie le nomde
 la commune (en majuscules), et le num ́ero de d ́epartement, quand cette commune se situedans le 
d ́epartement de l’AVEYRON. Vous indiquerez en le justifiant la forme alg ́ebriquequi vous semble 
la moins coˆuteuse.(b) Cette requˆete peut ˆetre trait ́ee sous la forme d’une semi-jointure.
 Donnez l’ ́ecriture algebriquede cette semi-jointure et proposez deux fa ̧cons de l’exprimer en 
 SQL (pr ́edicats EXISTS etIN)*/

--1
SELECT c.nomcommaj, c.numdep
FROM commune c, departement d
WHERE d.nomdepmaj = 'AVEYRON' AND c.numdep = d.numdep;
--2
SELECT c.nomcommaj, c.numdep
FROM commune c, departement d
WHERE c.numdep = d.numdep and d.nomdepmaj = 'AVEYRON';

select c.nomcommaj, c.numdep, c.latitude, c.longitude, d.nomdepmaj, r.nomregmaj
FROM commune c, departement d, region r
WHERE c.numdep = d.numdep AND (d.numreg=r.numreg AND r.nomregmaj='OCCITANIE'); 

--3
SELECT c.nomcommaj, c.numdep
FROM commune c
    INNER JOIN departement d
    ON d.nomdepmaj = 'AVEYRON'
WHERE c.numdep = d.numdep;

--*plus optimisé car on effectue un filtre sur la table dept, avant de faire la jointure

--4
SELECT c.nomcommaj, c.numdep
FROM commune c
    INNER JOIN departement d
    ON c.numdep = d.numdep
WHERE d.nomdepmaj = 'AVEYRON';


--5
SELECT c.nomcommaj, c.numdep
FROM commune c 
WHERE EXISTS(
    SELECT d.numdep 
    from departement d 
    WHERE d.nomdepmaj = 'AVEYRON' 
    AND c.numdep = d.numdep
);

--6
SELECT c.nomcommaj, c.numdep
FROM commune c 
where c.numdep IN(
    SELECT d.numdep
    from departement d 
    WHERE d.nomdepmaj = 'AVEYRON'
);
--!exercice 3:

select R.nomregmaj ,D.nomdepmaj , C.nomcommaj
from commune C , departement D , region R
where C.numdep = D.numdep and R.numreg = D.numreg ;


SELECT c.nomcommaj, c.latitude, c.longitude
FROM commune c 
WHERE EXISTS (
    SELECT d.numdep, d.numreg, r.numreg
    from region r, departement d 
    WHERE d.numreg=r.numreg 
    and r.nomregmaj = 'OCCITANIE'
) AND c.nomcommaj LIKE 'M%';



select /*+ use_merge(c d r)*/c.nomcommaj, c.numdep, c.latitude, c.longitude, d.nomdepmaj, r.nomregmaj
FROM commune c, departement d, region r
WHERE c.numdep = d.numdep AND (d.numreg=r.numreg AND r.nomregmaj='OCCITANIE') AND nomcommaj like 'M%'; 





explain plan for select R.nomregmaj ,D.nomdepmaj , C.nomcommaj
from commune C , departement D , region R
where C.numdep = D.numdep and R.numreg = D.numreg ;
select plan_table_output from table(dbms_xplan.display()) ;






