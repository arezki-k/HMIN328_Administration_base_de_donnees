/*
Vous donnerez l’écriture d’une procédure nommée nbreLikers qui renvoie pour un
étudiant donné dont le numéro INE est passé en paramètre d’entrée, le nombre d’étudiants
qui l’apprécient.
*/

select count(numAmi)
from Apprecie
where numAmi = &numEtudiant

CREATE OR REPLACE PACKAGE Pkg_Estudiantin
IS
  -- Procédures publiques
    procedure proc_nbreLikers(arg_numEtudiant in integer , out_nb_ami out integer);
end Pkg_Estudiantin ;
/

desc Pkg_Estudiantin ;

CREATE OR REPLACE PACKAGE BODY Pkg_Estudiantin IS
procedure proc_nbreLikers (arg_numEtudiant in integer) is
select count(numAmi) into out_nb_ami
from Apprecie
where numAmi = arg_numEtudiant;
exception
when no_data_found the dbms_ouput.put_line(arg_numEtudiant);
when others the dbms_ouput.put_line('others');
end ;
end proc_nbreLikers;
end Pkg_Estudiantin;
/

execute Pkg_Estudiantin.proc_nbreLikers('20101234');
