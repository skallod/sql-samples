-- cloning object
begin
@myid=1;
insert into parent_table(f1,f2,f3) select f1,f2,f3 from parent table where id=@myid;
@new_parent_id = last_insert_id();
insert into child_table (parent_id,n1,n2,n3) select new_parent_id,n1,n2,n3 from child_table where parent_id=@myid;
end
--------------------
begin;
-- max name +1 where name not only number
@var=select ifnull(max(cast(name as unsigned)),0)+1 from invoces where year(doc_date)=year(?)
-- lock rows
 amd company_id=? for update;
 update invoces set name=var where id=?
commit;
---------------------------
create table currency(name text, value number, up date);
db1=# insert into currency values('usd', 65, '2019-02-22');
db1=# insert into currency values('usd', 63, '2019-02-23');
db1=# insert into currency values('usd', 67, '2019-02-24');
db1=# insert into currency values('eur', 75, '2019-02-22');
db1=# insert into currency values('eur', 77, '2019-02-23');
db1=# insert into currency values('eur', 73, '2019-02-24');
db1=# insert into currency values('rub', 1, '2019-02-24');
задача достать макс  usd, eur
with cte as (select name,max(value) from currency group by name) select * from cte where name in ('usd','eur');

-------------------
Задача висит транзакция на вставку
select query, state, wait_event_type,wait_event, pid from pg_stat_activity where datname in ('table1','table2','table3') and not (state = 'idle' or pid = pg_backend_pid());
datname - название БД
select query, state, wait_event_type,wait_event, pid from pg_stat_activity where query like '%insert%' and not (state = 'idle' or pid = pg_backend_pid());
select query, state, wait, pid, xact_start,query_start,datname from pg_stat_activity;
select query, state, wait_event_type,wait_event, pid, xact_start,query_start,datname from pg_stat_activity;
select query, state, wait_event_type,wait_event, pid, xact_start,query_start,datname,usename,application_name,client_addr from pg_stat_activity;

------------deadlock
db1=# begin;
db1=# select * from currency;
db1=# update currency set value=5 where name='rub';
db1=# update currency set value=73 where name='eur' and up='2019-02-24';
UPDATE 1

begin;
BEGIN
db1=# select * from currency;
db1=# update currency set value=72 where name='eur' and up='2019-02-24';
UPDATE 1
db1=# update currency set value=6 where name='rub';
ОШИБКА:  обнаружена взаимоблокировка

---------------------- поиск улиц в разном порядке слов
WITH s AS (
  SELECT
    t.id,
    string_agg(t.street, ' ' ORDER BY t.street) AS street
  FROM (
    SELECT
      row_number() OVER () AS id,
      regexp_split_to_table(v.street, '\s+') AS street
    FROM
      (
        VALUES
          ('переулок Кедровый'),
          ('Кедровый переулок')
      ) AS v(street)
    ) AS t
  GROUP BY
    t.id
)
SELECT
  s.id, s.street
FROM
  s
WHERE
  EXISTS (
    SELECT 1
    FROM s AS i
    WHERE
      i.id < s.id AND
      i.street = s.street
  )
