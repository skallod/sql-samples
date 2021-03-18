Вычислите среднюю стоимость одного билета; посчитайте
среднее время выполнения этого запроса

select avg (amount) from ticket_flights;

Многократно запросите данные о бронировании с номером
0824C5; посчитайте среднее время выполнения.

select * from bookings where book_ref='0824C5';
execute 55 ms
perform 87 ms

!!!  В ответах наоборот, особенно быстрый запрос быстрее выполняется

-- Выполняется 45 с
DO $$
BEGIN
 FOR i IN 1..10 LOOP
 EXECUTE 'select avg (amount) from ticket_flights;';
 END LOOP;
END;
$$ LANGUAGE plpgsql;
Для подготовленного оператора (здесь SELECT заменяется на
PERFORM, поскольку нас не интересует результат как таковой):
-- Выполняется 53 с
DO $$
    BEGIN
        FOR i IN 1..10 LOOP
                PERFORM avg (amount) from ticket_flights;
            END LOOP;
    END;
$$ LANGUAGE plpgsql;