-- sudo docker run -d --name=leo_postgres -e POSTGRESQL_PASSWORD=123456 -e POSTGRESQL_DATABASE=otus -p 5432:5432 bitnami/postgresql:10
-- -v /var/lib/postgres:/bitnami/postgresql
-- ## postgres 10 ##
create table changes (
    id uuid PRIMARY KEY,
    built_at timestamp with time zone not null,
    inserted_at timestamp with time zone not null,
    owner varchar(100) not null,
    data jsonb not null
) PARTITION BY RANGE (inserted_at);
-- !! error primary key
create table changes (
    id uuid not null,
    built_at timestamp with time zone not null,
    inserted_at timestamp with time zone not null,
    owner varchar(100) not null,
    data jsonb not null
) PARTITION BY RANGE (inserted_at);

CREATE TABLE changes_y2020m11d16 PARTITION OF changes FOR VALUES FROM ('2020-11-16') TO ('2020-11-17');
CREATE INDEX ON changes_y2020m11d16 (inserted_at);
--CREATE UNIQUE INDEX i_changes_y2020m11d16 ON changes_y2020m11d16(id);
ALTER TABLE changes_y2020m11d16 ADD UNIQUE (id);

-- not work @var=SELECT md5(random()::text || clock_timestamp()::text)::uuid
-- with a as (SELECT md5(random()::text || clock_timestamp()::text)::uuid)
insert into changes_y2020m11d16(id, built_at, inserted_at, owner, data)
values ('40e6215d-b5c6-4896-987c-f30f3678f608', now(), now(), 'test_owner', '{"tdata":"tdata"}');
-- from SELECT md5(random()::text || clock_timestamp()::text)::uuid;

-- insert into changes_y2020m11d16
-- select md5, now(), now(), 'test_owner', '{\"tdata\":\"tdata\"}'
-- from md5(random()::text || clock_timestamp()::text)::uuid;

CREATE TABLE changes_y2020m11d17 PARTITION OF changes FOR VALUES FROM ('2020-11-17') TO ('2020-11-18');
CREATE INDEX ON changes_y2020m11d17 (inserted_at);
ALTER TABLE changes_y2020m11d17 ADD UNIQUE (id);

-- postgres 11
create table changes (
    id uuid not null,
    built_at timestamp with time zone not null,
    inserted_at timestamp with time zone not null,
    owner varchar(100) not null,
    data jsonb not null
)  PARTITION by list (owner);
--
CREATE TABLE changes_y2020m11d16 PARTITION OF changes FOR VALUES FROM ('2020-11-16') TO ('2020-11-17');
CREATE INDEX ON changes_y2020m11d16 (inserted_at);
ALTER TABLE changes_y2020m11d16 ADD UNIQUE (id);
insert into changes_y2020m11d16(id, built_at, inserted_at, owner, data)
values ('40e6215d-b5c6-4896-987c-f30f3678f608', now(), now(), 'test_owner', '{"tdata":"tdata"}');
insert into changes(id, built_at, inserted_at, owner, data)
values ('40e6215d-b5c6-4896-987c-f30f3678f615', now(), to_timestamp('2020-11-17 23:59','YYYY-MM-DD HH24:MI'), 'test_owner', '{"tdata":"tdata"}');
--
explain select to_char(inserted_at, 'Day Mon dd, yyyy HH12:MI AM (TZ)') from changes where inserted_at in (date'2020-11-17');
explain select * from changes where inserted_at between timestamp'2020-11-17 00:00:00' and timestamp'2020-11-17 23:59:59';
explain select to_char(inserted_at, 'Day Mon dd, yyyy HH12:MI AM (TZ)') from changes where inserted_at >= to_timestamp('2020-11-17 00:00','YYYY-MM-DD HH24:MI') and inserted_at < to_timestamp('2020-11-18 00:00','YYYY-MM-DD HH24:MI');


select to_char(inserted_at, 'Day Mon dd, yyyy HH12:MI AM (TZ)') from changes_y2020m11d17;
select to_char(date'2020-11-17', 'Day Mon dd, yyyy HH12:MI AM (TZ)') from changes_y2020m11d17;
--to_timestamp return timestamp with zone
--try set moscow timezone
----------------------------------
set timezone = 'Europe/Moscow';
-- postgres=# alter database smartrepl set timezone='Europe/Moscow';
-- ALTER DATABASE
--     postgres=# alter user postgres set timezone='Europe/Moscow';
-- ALTER ROLE
create table changes (
    id uuid not null,
    built_at timestamp with time zone not null,
    inserted_at timestamp with time zone not null,
    owner varchar(100) not null,
    data jsonb not null
) PARTITION by list (owner);
drop table changes2_towner;
CREATE TABLE changes2_towner PARTITION OF changes2 FOR VALUES in ('towner') partition by range (inserted_at);
CREATE TABLE changes2_tz PARTITION OF changes2 FOR VALUES in ('tz') partition by range (inserted_at);
CREATE TABLE if not exists changes2_towner_20201115 PARTITION OF changes2_towner FOR VALUES FROM ('2020-11-15') TO ('2020-11-16');
CREATE TABLE if not exists changes2_towner_20201116 PARTITION OF changes2_towner FOR VALUES FROM ('2020-11-16') TO ('2020-11-17');
CREATE INDEX if not exists changes2_towner_20201116_inserted ON changes2_towner_20201116 (inserted_at);
ALTER TABLE changes2_towner_20201116 ADD UNIQUE (id);
CREATE TABLE changes2_towner_20201117 PARTITION OF changes2_towner FOR VALUES FROM ('2020-11-17') TO ('2020-11-18');
CREATE TABLE changes2_towner_20201118 PARTITION OF changes2_towner FOR VALUES FROM ('2020-11-18') TO ('2020-11-19');
CREATE TABLE changes2_towner_20201120 PARTITION OF changes2_towner FOR VALUES FROM ('2020-11-20') TO ('2020-11-21');
CREATE INDEX ON changes2_towner_20201117 (inserted_at);
ALTER TABLE changes2_towner_20201117 ADD UNIQUE (id);
insert into changes2(id, built_at, inserted_at, owner, data)
values ('40e6215d-b5c6-4896-987c-f30f3678f616', now(), to_timestamp('2020-11-17 00:00','YYYY-MM-DD HH24:MI'), 'towner', '{"tdata":"tdata"}');

insert into changes(id, built_at, inserted_at, owner, data) values ('40e6215d-b5c6-4896-987c-f30f3678f616', now(), now() , 'nazi', '{"tdata":"tdata"}');

select to_char(inserted_at, 'Day Mon dd, yyyy HH12:MI AM (TZ)') from changes order by  inserted_at desc limit 1;
select to_char(inserted_at, 'Day Mon dd, yyyy HH12:MI AM (TZ)') from changes_nazi_20201124 order by  inserted_at desc limit 1;

explain
select to_char(inserted_at, 'Day Mon dd, yyyy HH12:MI AM (TZ)') from changes2 where owner='towner' and inserted_at >= to_timestamp('2020-11-17 00:00','YYYY-MM-DD HH24:MI');
--where owner='towner' and inserted_at >= to_timestamp('2020-11-17 00:00','YYYY-MM-DD HH24:MI') and inserted_at < to_timestamp('2020-11-18 00:00','YYYY-MM-DD HH24:MI');
show constraint_exclusion; -- value partition pg 10 part optimisation
--пока не понял ALTER TABLE changes2_towner_20201116 ADD CONSTRAINT y2020fdasfsa
--     CHECK ( inserted_at >= DATE '2020-11-16' AND inserted_at < DATE '2020-11-17' );


SELECT inhrelid::regclass AS child -- optionally cast to text
FROM   pg_catalog.pg_inherits
WHERE  inhparent = 'changes'::regclass;

SELECT cron.schedule('0 12 * * *', $CRON$do $$ begin
execute 'CREATE TABLE if not exists changes2_towner_'||to_char(now() + interval '24 hours','YYYYMMDD')||' PARTITION OF changes2_towner FOR VALUES FROM ('''||to_char(now() + interval '24 hours','YYYY-MM-DD')||''') TO ('''||to_char(now() + interval '48 hours','YYYY-MM-DD')||''')';
execute 'CREATE INDEX ON changes2_towner_'||to_char(now() + interval '24 hours','YYYYMMDD')||' (inserted_at)';
execute 'ALTER TABLE changes2_towner_'||to_char(now() + interval '24 hours','YYYYMMDD')||' ADD UNIQUE (id)';
execute 'DROP TABLE if exists changes2_towner_'||to_char(now() - interval '72 hours','YYYYMMDD');
end$$;$CRON$);
SELECT cron.schedule('*/2 * * * *', $CRON$do $$ begin
execute 'CREATE TABLE if not exists changes2_tz_'||to_char(now() + interval '24 hours','YYYYMMDD')||' PARTITION OF changes2_tz FOR VALUES FROM ('''||to_char(now() + interval '24 hours','YYYY-MM-DD')||''') TO ('''||to_char(now() + interval '48 hours','YYYY-MM-DD')||''')';
execute 'CREATE INDEX ON changes2_tz_'||to_char(now() + interval '24 hours','YYYYMMDD')||' (inserted_at)';
execute 'ALTER TABLE changes2_tz_'||to_char(now() + interval '24 hours','YYYYMMDD')||' ADD UNIQUE (id)';
execute 'DROP TABLE if exists changes2_tz_'||to_char(now() - interval '72 hours','YYYYMMDD');
end$$;$CRON$);

select * from cron.job;
SELECT cron.unschedule(12);

select 'prefix_' || to_char(now(),'YYMMDD') as tn;

drop table if exists tn as (select 'prefix_' || to_char(now(),'YYMMDD'));
-- create table if not exists changes2_towner_20201120  PARTITION OF changes2_towner FOR VALUES FROM;
ALTER TABLE changes2_towner_20201120 ADD CONSTRAINT changes2_towner_20201120_unique_id_constraint UNIQUE (id);
DROP TABLE if exists changes2_towner_20201116;
-- do $$
CREATE TABLE if not exists changes2_towner_20201116 PARTITION OF changes2_towner FOR VALUES FROM ('2020-11-15') TO ('2020-11-16');

select changes_partitioning('nazi');

select changes_partitioning_init('nazi');

create or replace function changes_partitioning_init(in owner text ) returns void
as $$
declare
    masterTableName text;
    currentDayTable text;
    currentDayKebab text;
    plus1dayKebab text;
    insertedIndexName text;
    uniqueIdConstraintName text;
    createOwnerTableQuery text;
    createDateTableQuery text;
    createInsertedIdxQuery text;
    createConstraintQuery text;
begin
    select 'changes_'||owner into masterTableName;
    select masterTableName||'_'||to_char(now(),'YYYYMMDD') into currentDayTable;
    select to_char(now(),'YYYY-MM-DD') into currentDayKebab;
    select to_char(now() + interval '24 hours','YYYY-MM-DD') into plus1dayKebab;
    select currentDayTable||'_inserted_idx' into insertedIndexName;
    select currentDayTable||'_unique_id_constraint' into uniqueIdConstraintName;
    createOwnerTableQuery:=format('CREATE TABLE if not exists %I PARTITION OF changes FOR VALUES in (''%s'') partition by range (inserted_at);',masterTableName,owner);
    createDateTableQuery:=format('CREATE TABLE if not exists %I  PARTITION OF %I FOR VALUES FROM (''%s'') to (''%s'')',currentDayTable,masterTableName,currentDayKebab,plus1dayKebab);
    createInsertedIdxQuery:=format('CREATE INDEX IF NOT EXISTS %I ON %I (inserted_at)',insertedIndexName,currentDayTable);
    createConstraintQuery:=format('ALTER TABLE %I ADD CONSTRAINT %I UNIQUE (id)',currentDayTable,uniqueIdConstraintName);
    execute createOwnerTableQuery;
    execute createDateTableQuery;
    execute createInsertedIdxQuery;
    BEGIN
        execute createConstraintQuery;
    EXCEPTION
        WHEN duplicate_object THEN RAISE NOTICE 'Constraint object already exists';
        WHEN duplicate_table THEN RAISE NOTICE 'Constraint table already exists';
    END;
end;
$$ language plpgsql;

select changes_partioning_all_owners();

create or replace function changes_partioning_all_owners() returns void
as $$
declare
    ownerPartitions text[]= ARRAY(SELECT inhrelid::regclass AS child FROM  pg_catalog.pg_inherits WHERE  inhparent = 'changes'::regclass);
    x text;
    invokeFuncQry text;
begin
    FOREACH x IN ARRAY ownerPartitions LOOP
        invokeFuncQry=format('select changes_partitioning(''%s'')',x);
        execute invokeFuncQry;
    END LOOP;
end;
$$ language plpgsql;


create or replace function changes_partitioning(in ownerPartition text ) returns void
as $$
declare
    plus1dayTable text;
    createTableQuery text;
    plus1dayKebab text;
    plus2dayKebab text;
    insertedIndexName text;
    uniqueIdConstraintName text;
    dropTableName text;
    createInsertedIdxQuery text;
    createConstraintQuery text;
    dropTableQuery text;
--     masterTableName text;
begin
--     select 'changes_'||owner into masterTableName;
    select ownerPartition||'_'||to_char(now() + interval '24 hours','YYYYMMDD') into plus1dayTable;
    select to_char(now() + interval '24 hours','YYYY-MM-DD') into plus1dayKebab;
    select to_char(now() + interval '48 hours','YYYY-MM-DD') into plus2dayKebab;
    select plus1dayTable||'_inserted_idx' into insertedIndexName;
    select plus1dayTable||'_unique_id_constraint' into uniqueIdConstraintName;
    select ownerPartition||'_'||to_char(now() - interval '72 hours','YYYYMMDD') into dropTableName;
    createTableQuery:=format('CREATE TABLE if not exists %I  PARTITION OF %I FOR VALUES FROM (''%s'') to (''%s'')',plus1dayTable,ownerPartition,plus1dayKebab,plus2dayKebab);
    createInsertedIdxQuery:=format('CREATE INDEX IF NOT EXISTS %I ON %I (inserted_at)',insertedIndexName,plus1dayTable);
    createConstraintQuery:=format('ALTER TABLE %I ADD CONSTRAINT %I UNIQUE (id)',plus1dayTable,uniqueIdConstraintName);
    dropTableQuery:=format('DROP TABLE if exists %I',dropTableName);
    RAISE NOTICE 'plus1dayTable qry=%', createTableQuery;
    RAISE NOTICE 'index qry=%', createInsertedIdxQuery;
    RAISE NOTICE 'constraint qry=%', createConstraintQuery;
    RAISE NOTICE 'dropTable qry=%', dropTableName;
    execute createTableQuery;
    execute createInsertedIdxQuery;
    execute dropTableQuery;
    BEGIN
        execute createConstraintQuery;
    EXCEPTION
        WHEN duplicate_object THEN RAISE NOTICE 'Constraint object already exists';
        WHEN duplicate_table THEN RAISE NOTICE 'Constraint table already exists';
    END;
end;
$$ language plpgsql;

--         RAISE 'TEST QUERY %',createTableQuery;
--     execute 'CREATE TABLE if not exists changes2_towner_'||to_char(now() + interval '24 hours','YYYYMMDD')||' PARTITION OF changes2_towner FOR VALUES FROM ('''||to_char(now() + interval '24 hours','YYYY-MM-DD')||''') TO ('''||to_char(now() + interval '48 hours','YYYY-MM-DD')||''')';
--     execute 'CREATE INDEX ON changes2_towner_'||to_char(now() + interval '24 hours','YYYYMMDD')||' (inserted_at)';
--     execute 'ALTER TABLE changes2_towner_'||to_char(now() + interval '24 hours','YYYYMMDD')||' ADD UNIQUE (id)';
--     execute 'DROP TABLE if exists changes2_towner_'||to_char(now() - interval '72 hours','YYYYMMDD');

--                          ' PARTITION OF changes2_towner FOR VALUES FROM (''%I'') TO (''%I'')',lower(plus1day),plus1dayKebab,plus2dayKebab);
--     execute createTableQuery;

select to_char(now(), 'Day Mon dd, yyyy HH12:MI AM (TZ)');
show timezone;
select 'drop table '||'changes2_towner'||to_char(now(),'YYMMDD')||';' from pg_tables;
select to_char(now() - interval '72 hours','YYYYMMDD');

-- DO $$
-- DECLARE
--     l_hold_tbl_name TEXT;
--     query1 text ;
--     query2 text ;
-- BEGIN
--     SELECT Concat('a_save_tbl_', cost_center)
--     INTO   l_hold_tbl_name
--     FROM   a_input_tbl limit 1;
--
--     query1 := format('drop table if exists %I', lower(l_hold_tbl_name));
--     query2 := format('create table  %I as select 2 as id',lower(l_hold_tbl_name));
--     EXECUTE query1;
--     EXECUTE query2;
-- END $$;