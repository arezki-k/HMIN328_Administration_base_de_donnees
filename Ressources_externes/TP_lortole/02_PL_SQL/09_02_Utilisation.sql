select salaire, Finances.conversionF_ED(salaire) as enDollars,
Finances.conversionF_EF(salaire) as enFrancs from employe;
select * from employe where Finances.conversionF_EF(salaire) > 10000 ;
