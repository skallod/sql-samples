explain select avg(amount) from ticket_flights limit 1;
Limit  (cost=114641.35..114641.36 rows=1 width=32)
  ->  Finalize Aggregate  (cost=114641.35..114641.36 rows=1 width=32)
        ->  Gather  (cost=114641.13..114641.34 rows=2 width=32)
              Workers Planned: 2
              ->  Partial Aggregate  (cost=113641.13..113641.14 rows=1 width=32)
                    ->  Parallel Seq Scan on ticket_flights  (cost=0.00..104899.50 rows=3496650 width=6)

explain select avg(amount) from ticket_flights;
Finalize Aggregate  (cost=114641.35..114641.36 rows=1 width=32)
  ->  Gather  (cost=114641.13..114641.34 rows=2 width=32)
        Workers Planned: 2
        ->  Partial Aggregate  (cost=113641.13..113641.14 rows=1 width=32)
              ->  Parallel Seq Scan on ticket_flights  (cost=0.00..104899.50 rows=3496650 width=6)

-- все равно делает параллельно, хотя используется общее табл выражен
explain with tt as (select avg(amount) as mid_am from ticket_flights) select mid_am from tt;
CTE Scan on tt  (cost=114641.36..114641.38 rows=1 width=32)
  CTE tt
    ->  Finalize Aggregate  (cost=114641.35..114641.36 rows=1 width=32)
          ->  Gather  (cost=114641.13..114641.34 rows=2 width=32)
                Workers Planned: 2
                ->  Partial Aggregate  (cost=113641.13..113641.14 rows=1 width=32)
                      ->  Parallel Seq Scan on ticket_flights  (cost=0.00..104899.50 rows=3496650 width=6)

--on появился узел gather но параллелизма не произошло, возможно т.к. flights мелкая
set force_parallel_mode='on';
set min_parallel_table_scan_size=512;
select * from pg_settings where name='max_parallel_workers_per_gather';
select * from pg_settings where name='min_parallel_table_scan_size';
select * from pg_settings where name='force_parallel_mode';
explain analyse select * from flights;
--21 Mb
SELECT pg_size_pretty(pg_table_size('flights')) size;