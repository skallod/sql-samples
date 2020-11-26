--сначала перейти в базу потом команды
create schema dummyreplschema;
create role role1;
grant all privileges on database dummyrepldb to role1;
grant all privileges on schema dummyreplschema to role1;
create user dummyreplschema with password 'test123';
grant role1 to dummyreplschema;

grant connect on database dummyrepldb to role1;
grant create on database dummyrepldb to role1;
grant usage on schema dummyreplschema to role1;
grant create on schema dummyreplschema to role1;
-- grant select on all tables in schema dummyreplschema to role1;
grant all privileges on all tables in schema dummyreplschema to role1;
grant create on all tables in schema dummyreplschema to role1;

alter default privileges in schema dummyreplschema grant all privileges on tables to role1;
grant all privileges on all tables in schema dummyreplschema to role1;
alter default privileges in schema dummyreplschema grant all privileges on tables to role1;
create user user1 with password 'test123';
grant role1 to user1;
ALTER ROLE role1 SET search_path TO dummyreplschema;
create user dummyreplschema with password 'test123';
grant role1 to dummyreplschema;
alter default privileges in schema dummyreplschema grant all privileges on tables to role1;

create database dummyrepldb;
create schema dummy_replication;
create role dummyreplrole1;
-- grant all privileges on database dummyrepldb to dummyreplrole;
grant all privileges on schema dummy_replication to dummyreplrole1;
alter default privileges in schema dummy_replication grant all privileges on tables to dummyreplrole1;
create user dummy_replication1 with password 'dummy_replication';
grant dummyreplrole1 to dummy_replication1;
create user dummy_replication_ms1 with password 'dummy_replication_ms';
grant dummy_replication1 to dummy_replication_ms1;
ALTER DATABASE dummyrepldb SET search_path TO dummy_replication;
