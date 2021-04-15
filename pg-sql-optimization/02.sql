Вычислите среднюю стоимость одного билета; посчитайте
среднее время выполнения этого запроса

select avg (amount) from ticket_flights;

Многократно запросите данные о бронировании с номером
0824C5; посчитайте среднее время выполнения.

select * from bookings where book_ref='0824C5';
-- execute 55 ms / 73 ms
-- perform 87 ms / 18 ms

!!!  В ответах наоборот, особенно быстрый запрос быстрее выполняется (на повторном запросе )

-- Выполняется 45 с
DO $$
BEGIN
 FOR i IN 1..100 LOOP
--  EXECUTE 'select avg (amount) from ticket_flights;';
  EXECUTE 'select * from bookings where book_ref=''0824C5''';
 END LOOP;
END;
$$ LANGUAGE plpgsql;
Для подготовленного оператора (здесь SELECT заменяется на
PERFORM, поскольку нас не интересует результат как таковой):
-- Выполняется 53 с
DO $$
    BEGIN
        FOR i IN 1..100 LOOP
--                 PERFORM avg (amount) from ticket_flights;
                PERFORM * from bookings where book_ref='0824C5';
            END LOOP;
    END;
$$ LANGUAGE plpgsql;