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

SELECT tt.cnt, count(*)
FROM (
  SELECT count(*) cnt
  FROM tickets t
  GROUP BY t.book_ref
) tt
GROUP BY tt.cnt
ORDER bY tt.cnt;

-- до каких городов нельзя добраться из москвы без пересадок
select distinct (arrival_city) from routes where arrival_city
    not in (select distinct (arrival_city) from routes where departure_city = 'Москва') and arrival_city<>'Москва';
select distinct (arrival_city) from routes except (select distinct (arrival_city) from routes where departure_city = 'Москва');
--Модель самолета выполняет больше всего рейсов ? меньше всего ?
select a.model, count(f.aircraft_code) from flights f, aircrafts a where f.aircraft_code=a.aircraft_code group by a.model order by count(a.model);
SELECT a.model, f.cnt
FROM aircrafts a
  LEFT JOIN (
    SELECT f.aircraft_code, count(*) cnt
    FROM flights f
    GROUP BY f.aircraft_code
  ) f
  ON f.aircraft_code = a.aircraft_code
ORDER BY cnt DESC NULLS LAST;
--Какая модель перевозит больше всего пассажиров ?
select a.model , sg.cnt from aircrafts a
left join(
 select s.aircraft_code, count(*) as cnt from seats s group by s.aircraft_code
) sg on a.aircraft_code = sg.aircraft_code
order by cnt;
 SELECT a.model, count(*) cnt
FROM flights f, boarding_passes bp, aircrafts a
WHERE bp.flight_id = f.flight_id AND a.aircraft_code = f.aircraft_code
GROUP BY a.model
ORDER BY count(*) DESC;
--https://postgrespro.ru/docs/postgrespro/10/apjs04.html#id-1.11.11.11.14 - описание представлений



