-- select f.* from ticket_flights t , flights f where t.ticket_no = '0005435126781'
-- and t.flight_id=f.flight_id order by scheduled_departure;

select f.scheduled_departure, a.airport_code || ' ' || a.airport_name || ' ' || a.city ,
       arr.airport_code || ' ' || arr.airport_name || ' ' || arr.city
 from flights f, airports a, ticket_flights tf, airports arr where tf.ticket_no = '0005435126781'
 and f.flight_id = tf.flight_id and a.airport_code = f.departure_airport
and arr.airport_code = f.arrival_airport order by f.scheduled_departure;


