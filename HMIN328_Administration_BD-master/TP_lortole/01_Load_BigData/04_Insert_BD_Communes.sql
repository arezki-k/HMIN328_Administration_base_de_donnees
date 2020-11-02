INSERT INTO Region (reg,chef_lieu,nom_reg)
VALUES
('991','chef_lieu','nom_reg')
;

UPDATE Region
SET chef_lieu = 'chef_lieu991'
WHERE reg = '991'
;

INSERT INTO Region (reg,chef_lieu,nom_reg)
VALUES
('992','chef_lieu','nom_reg')
;

UPDATE Region
SET chef_lieu = 'chef_lieu992'
WHERE reg = '992'
;


INSERT INTO Departement (reg,chef_lieu,dep)
VALUES
('991','chef_lieu','45')
;
UPDATE Departement
SET chef_lieu = 'chef_lieu991'
WHERE reg = '991'
;

INSERT INTO Departement (reg,chef_lieu,dep)
VALUES
('992','chef_lieu','46')
;
UPDATE Departement
SET chef_lieu = 'chef_lieu992'
WHERE reg = '992'
;


INSERT INTO Commune (reg,dep,com,pop_2010)
VALUES
('991','45','01',-1.0)
;
UPDATE Commune
SET pop_2010 = 1000
WHERE reg = '991'
;

INSERT INTO Commune (reg,dep,com,pop_2010)
VALUES
('992','46','02',1.0)
;
UPDATE Commune
SET pop_2010 = -1000
WHERE reg = '992'
;