1. Создайте индекс по столбцу amount таблицы перелетов
(ticket_flights).

create index ticket_flights_amount_idx on ticket_flights(amount);
19 sec

2. Напишите запрос, находящий количество перелетов
стоимостью более 180 000 руб. (менее 1% строк).
Какой метод доступа был выбран? Сколько времени
выполняется запрос ?

explain select count(*) from ticket_flights where amount >  180000;
Aggregate  (cost=70328.16..70328.17 rows=1 width=8)
  ->  Bitmap Heap Scan on ticket_flights  (cost=1008.91..70193.82 rows=53739 width=0)
        Recheck Cond: (amount > '180000'::numeric)
        ->  Bitmap Index Scan on ticket_flights_amount_idx  (cost=0.00..995.48 rows=53739 width=0)
              Index Cond: (amount > '180000'::numeric)

explain analyze select count(*) from ticket_flights where amount >  180000;
Aggregate  (cost=70328.16..70328.17 rows=1 width=8) (actual time=101.102..101.106 rows=1 loops=1)
  ->  Bitmap Heap Scan on ticket_flights  (cost=1008.91..70193.82 rows=53739 width=0) (actual time=26.470..88.676 rows=55640 loops=1)
        Recheck Cond: (amount > '180000'::numeric)
        Heap Blocks: exact=1747
        ->  Bitmap Index Scan on ticket_flights_amount_idx  (cost=0.00..995.48 rows=53739 width=0) (actual time=25.339..25.340 rows=55640 loops=1)
              Index Cond: (amount > '180000'::numeric)
Planning Time: 0.238 ms
Execution Time: 101.252 ms


3. Запретите выбранный метод доступа, снова выполните
запрос и сравните время выполнения. Прав ли был
оптимизатор ?

set enable_bitmapscan=off;
explain analyze select count(*) from ticket_flights where amount >  180000;
Finalize Aggregate  (cost=114696.75..114696.76 rows=1 width=8) (actual time=1459.674..1467.768 rows=1 loops=1)
  ->  Gather  (cost=114696.54..114696.75 rows=2 width=8) (actual time=1454.503..1467.752 rows=3 loops=1)
        Workers Planned: 2
        Workers Launched: 2
        ->  Partial Aggregate  (cost=113696.54..113696.55 rows=1 width=8) (actual time=1426.193..1426.195 rows=1 loops=3)
              ->  Parallel Seq Scan on ticket_flights  (cost=0.00..113640.56 rows=22391 width=0) (actual time=0.194..1421.116 rows=18547 loops=3)
                    Filter: (amount > '180000'::numeric)
                    Rows Removed by Filter: 2778737
Planning Time: 1.274 ms
Execution Time: 1467.949 ms

4. Повторите пункты 2 и 3 для стоимости менее 44000 руб.
(чуть более 90% строк).
set enable_bitmapscan=on;
explain analyze select count(*) from ticket_flights where amount <  44000;
4.2
Finalize Aggregate  (cost=122518.16..122518.17 rows=1 width=8) (actual time=1631.362..1637.338 rows=1 loops=1)
  ->  Gather  (cost=122517.95..122518.16 rows=2 width=8) (actual time=1631.156..1637.329 rows=3 loops=1)
        Workers Planned: 2
        Workers Launched: 2
        ->  Partial Aggregate  (cost=121517.95..121517.96 rows=1 width=8) (actual time=1609.275..1609.276 rows=1 loops=3)
              ->  Parallel Seq Scan on ticket_flights  (cost=0.00..113640.56 rows=3150955 width=0) (actual time=24.985..1335.778 rows=2527743 loops=3)
                    Filter: (amount < '44000'::numeric)
                    Rows Removed by Filter: 269541
Planning Time: 0.372 ms
Execution Time: 1637.437 ms
4.3
Finalize Aggregate  (cost=122518.16..122518.17 rows=1 width=8) (actual time=2123.535..2125.399 rows=1 loops=1)
  ->  Gather  (cost=122517.95..122518.16 rows=2 width=8) (actual time=2123.525..2125.392 rows=3 loops=1)
        Workers Planned: 2
        Workers Launched: 2
        ->  Partial Aggregate  (cost=121517.95..121517.96 rows=1 width=8) (actual time=2097.868..2097.869 rows=1 loops=3)
              ->  Parallel Seq Scan on ticket_flights  (cost=0.00..113640.56 rows=3150955 width=0) (actual time=27.489..1702.165 rows=2527743 loops=3)
                    Filter: (amount < '44000'::numeric)
                    Rows Removed by Filter: 269541
Planning Time: 0.350 ms
Execution Time: 2125.488 ms

SET enable_seqscan = off;
explain analyze select count(*) from ticket_flights where amount <  44000;
Finalize Aggregate  (cost=262053.89..262053.90 rows=1 width=8) (actual time=4379.089..4389.812 rows=1 loops=1)
  ->  Gather  (cost=262053.68..262053.89 rows=2 width=8) (actual time=4379.079..4389.804 rows=3 loops=1)
        Workers Planned: 2
        Workers Launched: 2
        ->  Partial Aggregate  (cost=261053.68..261053.69 rows=1 width=8) (actual time=4348.671..4348.672 rows=1 loops=3)
              ->  Parallel Bitmap Heap Scan on ticket_flights  (cost=141560.21..253176.29 rows=3150955 width=0) (actual time=2562.899..3977.021 rows=2527743 loops=3)
                    Recheck Cond: (amount < '44000'::numeric)
                    Rows Removed by Index Recheck: 98980
                    Heap Blocks: exact=11466 lossy=10554
                    ->  Bitmap Index Scan on ticket_flights_amount_idx  (cost=0.00..139669.63 rows=7562293 width=0) (actual time=2575.993..2575.994 rows=7583228 loops=1)
                          Index Cond: (amount < '44000'::numeric)
Planning Time: 1.587 ms
Execution Time: 4390.012 ms


Построение битовой карты bitmap index scan
Сканирование по битовой карте bitmap heap scan
Параллельное сканирование parallel bitmap heap scan
