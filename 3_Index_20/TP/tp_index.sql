select index_name, blevel, table_name from user_indexes;

--creer table commune à partir du schema utilisateur p00000009432:
create TABLE commune as select * from P00000009432.commune;


alter table COMMUNE add CONSTRAINT com_pk primary key(CODEINSEE);

--=> creer un index qui s'appelle compk(b+tree)

--mise a jour des stats pour un index donné.
analyze index com_pk validate structure;
--=> index_stats

select name, btree_space, most_repeated_key, lf_rows, br_rows, height from index_stats;


--2.1 exercices:
--1.que renvoit la requete suivante:
select rowid, rownum, codeinsee from commune;
--renvoie id de chaque ligne avec le num de ligne et du code insee(cle primaire)

--2.quels sont les index d ́ej`a pr ́esents sur votre sch ́ema utilisateur ? Expliquez leur pr ́esence
desc user_indexes;
SELECT index_name, index_type, table_name, table_owner from user_indexes;
--expliquer leurs présence:
--les indexes correspondent aux clés primaires pour chaque table.

--3.indiquer si les indexes sont uniques ou denses:
--

select v1.nomcommaj, dbms_rowid.rowid_block_number(v1.rowid) as numBloc, dbms_rowid.rowid_row_number(v1.rowid) as numLigne, dbms_rowid.rowid_object(v1.rowid) as idTable  from commune v1, commune v2 
where dbms_rowid.rowid_block_number(v1.rowid) = dbms_rowid.rowid_block_number(v2.rowid) and v2.nomcommaj='MONTPELLIER' and v1.nomcommaj <> 'MONTPELLIER';
