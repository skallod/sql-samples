-- select f.* from ticket_flights t , flights f where t.ticket_no = '0005435126781'
-- and t.flight_id=f.flight_id order by scheduled_departure;

-- select f.scheduled_departure, a.airport_code || ' ' || a.airport_name || ' ' || a.city ,
--        arr.airport_code || ' ' || arr.airport_name || ' ' || arr.city
--  from flights f, airports a, ticket_flights tf, airports arr where tf.ticket_no = '0005435126781'
--  and f.flight_id = tf.flight_id and a.airport_code = f.departure_airport
-- and arr.airport_code = f.arrival_airport order by f.scheduled_departure;

--места aircraft_code=773
-- select * from seats where aircraft_code='773' and seat_no ~ '^1.$';

--на каких местах сидел пассажир
-- select * from boarding_passes where ticket_no = '0005435126781';

-- сколько человек в одно бронирование
-- select * from tickets limit 1;
--select book_ref, count(passenger_id) from tickets group by book_ref order by count(passenger_id) desc limit 1; good
--select book_ref, count(passenger_id) over (partition by book_ref order by passenger_id) from tickets order by count desc limit 10; good
--select book_ref, dense_rank() over (partition by book_ref order by passenger_id) from tickets order by dense_rank desc limit 10; good
-- select * from tickets where book_ref='027B0C';

-- до каких городов нельзя добраться из москвы без пересадок
select distinct (departure_city) from routes where departure_city
    not in (select departure_city from routes where arrival_city='Москва') and departure_city<>'Москва';


