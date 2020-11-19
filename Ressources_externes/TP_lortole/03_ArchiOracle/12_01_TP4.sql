/*
desc v$instance ;
 Name					   Null?    Type
 ----------------------------------------- -------- ----------------------------
 INSTANCE_NUMBER				    NUMBER
 INSTANCE_NAME					    VARCHAR2(16)
 HOST_NAME					    VARCHAR2(64)
 VERSION					    VARCHAR2(17)
 STARTUP_TIME					    DATE
 STATUS 					    VARCHAR2(12)
 PARALLEL					    VARCHAR2(3)
 THREAD#					    NUMBER
 ARCHIVER					    VARCHAR2(7)
 LOG_SWITCH_WAIT				    VARCHAR2(15)
 LOGINS 					    VARCHAR2(10)
 SHUTDOWN_PENDING				    VARCHAR2(3)
 DATABASE_STATUS				    VARCHAR2(17)
 INSTANCE_ROLE					    VARCHAR2(18)
 ACTIVE_STATE					    VARCHAR2(9)
 BLOCKED					    VARCHAR2(3)

*/
select * from v$instance ;

desc v$database ;
select * from v$database;

desc v$option ;
select * from v$option ;

desc v$version ;
select * from v$version ;



