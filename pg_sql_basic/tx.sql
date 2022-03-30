--## блокировки
--terminal1
SELECT * FROM aircrafts_tmp WHERE model ~'^Air'FOR UPDATE;
--terminal2
SELECT * FROM aircrafts_tmp WHERE model ~'^Air'FOR UPDATE;
--terminal1
UPDATE aircrafts_tmp SET range = 5800 WHERE aircraft_code ='320';
commit; --terminal2 отпустило
--terminal1
LOCK TABLE aircrafts_tmp IN ACCESS EXCLUSIVE MODE;
--terminal2
SELECT * FROM aircrafts_tmp WHERE model ~'^Air'FOR UPDATE;
--terminal1
rollback; --terminal2 отпустило

--задание 2
--terminal1

CREATE TABLE modes AS
SELECT num::integer, 'LOW' || num::text AS mode
FROM generate_series( 1, 100000 ) AS gen_ser( num )
UNION ALL
SELECT num::integer, 'HIGH' || ( num - 100000 )::text AS mode
FROM generate_series( 100001, 200000 ) AS gen_ser( num );

Блокировка при обновлении строки в read commited
select relation::regclass, * from pg_locks; --granted если захватил блокировку
select * from pg_stat_activity;

3270,ClientRead,idle in transaction,1705,,SHOW TRANSACTION ISOLATION LEVEL
3334,active,,1705,select * from pg_stat_activity
3351,transactionid,active,1706,1705,"UPDATE modes SET mode = 'LOW1' WHERE num = 1"

3351,ExclusiveLock
3334,AccessShareLock
3334,ExclusiveLock
3270,RowExclusiveLock
3270,RowExclusiveLock
3270,ExclusiveLock
3351,ExclusiveLock
3270,ExclusiveLock
3351,ExclusiveLock
3351,ShareLock


