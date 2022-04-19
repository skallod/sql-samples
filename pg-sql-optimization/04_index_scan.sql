1. Напишите запрос, выбирающий максимальную сумму
бронирования.
Проверьте план выполнения. Какой метод доступа выбрал
планировщик? Эффективен ли такой доступ?

select max(total_amount) from bookings;
explain select max(total_amount) from bookings;
explain (ANALYZE, TIMING OFF) select max(total_amount) from bookings;
->  Gather  (cost=25442.36..25442.57 rows=2 width=32)
    -> Parallel aggregate
        -> Parallel seq scan
explain select total_amount from bookings order by total_amount desc limit 1;
Limit  (cost=27641.46..27641.58 rows=1 width=6)
  ->  Gather Merge  (cost=27641.46..232902.56 rows=1759258 width=6)
        Workers Planned: 2
        ->  Sort  (cost=26641.44..28840.51 rows=879629 width=6)
              Sort Key: total_amount DESC
              ->  Parallel Seq Scan on bookings  (cost=0.00..22243.29 rows=879629 width=6)

2. Создайте индекс по столбцу bookings.total_amount.
Снова проверьте план выполнения запроса. Какой метод
доступа выбрал планировщик теперь?

create index bookings_total_amount_idx on bookings(total_amount);
VACUUM bookings; -- обновляет таблицу видимости
SELECT current_setting('random_page_cost');
set random_page_cost = 1; --ssd
->  Limit  (cost=0.43..0.46 rows=1 width=6) (actual rows=1 loops=1)
          ->  Index Only Scan Backward using bookings_total_amount_idx on bookings  (cost=0.43..60112.86 rows=2111110 width=6) (actual rows=1 loops=1)
drop index bookings_total_amount_idx;

3. При создании индекса можно указать порядок сортировки
столбца. Зачем, если индекс можно просматривать в любом
направлении?

create index test_idx on test_t(x ASC, y DESC);
Нужно, если часто такие запросы идут
