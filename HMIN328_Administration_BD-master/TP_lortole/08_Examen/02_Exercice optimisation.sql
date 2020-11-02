drop table Etudiant cascade constraints;
drop table Formation cascade constraints;
drop table InscritDans cascade constraints;
drop table Apprecie cascade constraints;

create table Etudiant (numINE varchar(10) constraint Etudiant_pk primary key, nom varchar(20), prenom varchar(15), dateNaissance date, genre varchar(5));
create table Formation (codeF varchar(9) constraint Formation_pk primary key, nomF varchar(20), niveau varchar(3), nomResponsable varchar(20));

create table InscritDans (numINE varchar(10), codeF varchar(9), anneeInscription number(4), constraint InscritDans_pk primary key (numINE, codeF, anneeInscription), constraint InscritDans_fk1 foreign key (numINE) references Etudiant(numINE), constraint InscritDans_fk2 foreign key (codeF) references Formation(codeF));

create table Apprecie (numEtudiant  varchar(10), numAmi  varchar(10), constraint Apprecie_pk primary key(numEtudiant,numAmi), constraint Apprecie_fk1 foreign key (numEtudiant) references Etudiant(numINE), constraint Apprecie_fk2 foreign key (numAmi) references Etudiant(numINE));

insert into Etudiant values ('20101234','Martin','Paul','20-aug-1990','homme');
insert into Etudiant values ('20102345','Martin','Marie','19-apr-1990','femme');
insert into Etudiant values ('20112345','Martinez','Mathilde','19-jun-1991','femme');
insert into Etudiant values ('20111234','Martinetti','Paul','2-aug-1989','homme');
insert into Etudiant values ('20113456','Chadi','Amina','8-mar-1990','femme');
insert into Etudiant values ('20123456','Faye','Moussa','1-mar-1991','homme');

alter table etudiant add constraint dom_genre check (genre in ('homme','femme'));


insert into Formation values ('HM1IN-604','IPS','M1','K. Todorov');
insert into Formation values ('HM1SN-601','BCD','M1','A. Fiston-Lavier');
insert into Formation values ('HM1PH-602','Physique-Numerique','M1','D. Cassagne');
insert into Formation values ('HM1BE-611','EPI','M1','C. Moulia');
insert into Formation values ('HM1GE-600','Geomatique','M1','C. Gervet');
insert into Formation values ('HM1BE-599','STIC-Eco','M1','C. Moulia');

insert into InscritDans values ('20101234','HM1IN-604','2015');
insert into InscritDans values ('20112345','HM1IN-604','2015');
insert into InscritDans values ('20102345','HM1SN-601','2015');
insert into InscritDans values ('20111234','HM1SN-601','2015');
insert into InscritDans values ('20113456','HM1BE-599','2015');
insert into InscritDans values ('20123456','HM1BE-599','2015');

insert into Apprecie values ('20101234', '20112345');
insert into Apprecie values ('20112345', '20101234');
insert into Apprecie values ('20101234', '20102345');
insert into Apprecie values ('20112345', '20102345');
insert into Apprecie values ('20123456', '20102345');
insert into Apprecie values ('20123456', '20101234');
insert into Apprecie values ('20102345', '20101234');

