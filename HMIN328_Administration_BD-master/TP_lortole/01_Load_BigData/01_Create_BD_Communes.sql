CREATE TABLE Region 
(
	reg varchar(4),
	chef_lieu varchar(46),
	nom_reg varchar(30),
	CONSTRAINT pk_Region
	PRIMARY KEY(reg)
)
;

CREATE TABLE Departement
(
	reg varchar(4) not NULL,
	dep varchar(4),
	chef_lieu varchar(46),
	nom_dep varchar(30),
	CONSTRAINT pk_Departement
	PRIMARY KEY(dep),	
  	CONSTRAINT fk_Departement_Reg
    FOREIGN KEY(reg)
    REFERENCES Region(reg)
)
;

CREATE TABLE Commune
(
	reg varchar(4),
	dep varchar(4),
	com varchar(4),
	article varchar(4),
	nom_com varchar(46),
	longitude float,
	latitude float,
	pop_1975 float,
	pop_1976 float,
	pop_1977 float,
	pop_1978 float,
	pop_1979 float,
	pop_1980 float,
	pop_1981 float,
	pop_1982 float,
	pop_1983 float,
	pop_1984 float,
	pop_1985 float,
	pop_1986 float,
	pop_1987 float,
	pop_1988 float,
	pop_1989 float,
	pop_1990 float,
	pop_1991 float,
	pop_1992 float,
	pop_1993 float,
	pop_1994 float,
	pop_1995 float,
	pop_1996 float,
	pop_1997 float,
	pop_1998 float,
	pop_1999 float,
	pop_2000 float,
	pop_2001 float,
	pop_2002 float,
	pop_2003 float,
	pop_2004 float,
	pop_2005 float,
	pop_2006 float,
	pop_2007 float,
	pop_2008 float,
	pop_2009 float,
	pop_2010 float,
  	CONSTRAINT fk_Commune_Reg
    FOREIGN KEY (reg)
    REFERENCES Region(reg),
  	CONSTRAINT fk_Commune_Dept
    FOREIGN KEY (dep)
    REFERENCES Departement(dep)
)
;


ALTER TABLE Commune DISABLE CONSTRAINT fk_Commune_Reg
;

ALTER TABLE Commune DISABLE CONSTRAINT fk_Commune_Dept
;

CREATE TABLE Population
(
	valeurEstimee float,
	annee int,
	com varchar(4)
)
;