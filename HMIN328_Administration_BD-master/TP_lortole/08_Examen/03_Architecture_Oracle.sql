select instance_name , host_name from v$instance ;
/*
INSTANCE_NAME	 HOST_NAME
---------------- ----------------------------------------------------------------
master		 venus.ens.info-ufr.univ-montp2.fr
*/

select name , created from v$database ;

/*
NAME	     CREATED
------------ ---------
MASTER	     25-SEP-14
*/
