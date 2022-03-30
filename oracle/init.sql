create tablespace johny_tabspace datafile 'johny_tabspace.dat' size 10M autoextend on;
create temporary tablespace johny_tabspace_temp tempfile 'johny_tabspace_temp.dat' size 5M autoextend on;
create user johny identified by 1234 default tablespace johny_tabspace temporary tablespace johny_tabspace_temp;
grant create session to johny;
grant create table to johny;
grant unlimited tablespace to johny;
GRANT CREATE ANY SEQUENCE, ALTER ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE TO johny;
grant select on V_$SESSION to johny;
grant select on V_$TRANSACTION to johny;
grant select on V_$DATABASE to johny;

CREATE SEQUENCE dept_seq START WITH 1;
create table STREAMING
(
    ID       NUMBER default "JOHNY"."DEPT_SEQ"."NEXTVAL" not null,
    INFO     VARCHAR2(100)                               not null,
    GEO      VARCHAR2(100),
    MODIFIED TIMESTAMP(6),
    constraint JOOQ_PK
        primary key (ID, INFO)
)
/
select * from user_types;

SELECT column_name FROM all_cons_columns WHERE constraint_name = (
    SELECT constraint_name FROM all_constraints
    WHERE UPPER(table_name) = UPPER('streaming') AND CONSTRAINT_TYPE = 'P'
);

select sys_context('userenv','instance_name') from dual;

docker exec -it 9b55ec581beb gosu oracle sqlplus /nolog
docker exec -it 9b55ec581beb /bin/bash
connect sys/oracle as sysdba
connect johny;

drop user .. cascade;

update STREAMING set INFO='info20' where INFO='info19';
select * from v$session;
select * from v$transaction;
SELECT RAWTOHEX(tx.xid)
FROM v$transaction tx
         JOIN v$session s ON tx.ses_addr = s.saddr;
