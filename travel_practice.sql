-- SQL Practice: Travel & Booking Database
-- Custom questions and answers for practice
-- Schema:
--   traveler (id, name, country, passport_no, join_date, tier)
--   destination (id, city, country, continent, avg_temp_c, best_season)
--   flight (id, origin, destination_id, airline, departure, arrival, price, seats_available)
--   hotel (id, name, destination_id, stars, price_per_night, amenities)
--   booking (id, traveler_id, flight_id, hotel_id, booking_date, status, total_cost)
--   review (id, traveler_id, destination_id, rating, comment, review_date)
--   airline (id, name, country, hub_city, rating)

-- ============================================================
-- SECTION 1: Basic SELECT and WHERE
-- ============================================================

-- Q1. Show all 5-star hotels
SELECT name, price_per_night FROM hotel
WHERE stars = 5
ORDER BY price_per_night ASC;

-- Q2. Show all flights to Singapore under $500
SELECT airline, departure, arrival, price FROM flight
WHERE destination_id = (SELECT id FROM destination WHERE city = 'Singapore')
AND price < 500
ORDER BY price;

-- Q3. Show all destinations in Asia
SELECT city, country, best_season FROM destination
WHERE continent = 'Asia'
ORDER BY country;

-- Q4. Show travelers with gold or platinum tier
SELECT name, country, tier FROM traveler
WHERE tier IN ('gold', 'platinum')
ORDER BY tier, name;

-- Q5. Show all confirmed bookings in 2025
SELECT * FROM booking
WHERE status = 'confirmed'
AND YEAR(booking_date) = 2025
ORDER BY booking_date DESC;

-- ============================================================
-- SECTION 2: Aggregation
-- ============================================================

-- Q6. How many destinations are there per continent?
SELECT continent, COUNT(id) AS destination_count
FROM destination
GROUP BY continent
ORDER BY destination_count DESC;

-- Q7. What is the average hotel price per star rating?
SELECT stars, ROUND(AVG(price_per_night), 2) AS avg_price
FROM hotel
GROUP BY stars
ORDER BY stars DESC;

-- Q8. Which airlines have more than 100 bookings?
SELECT airline.name, COUNT(booking.id) AS booking_count
FROM airline
JOIN flight ON airline.name = flight.airline
JOIN booking ON flight.id = booking.flight_id
GROUP BY airline.name
HAVING COUNT(booking.id) > 100
ORDER BY booking_count DESC;

-- Q9. What is the total revenue from bookings per destination?
SELECT destination.city, SUM(booking.total_cost) AS total_revenue
FROM destination
JOIN hotel ON destination.id = hotel.destination_id
JOIN booking ON hotel.id = booking.hotel_id
GROUP BY destination.city
ORDER BY total_revenue DESC;

-- Q10. Which destination has the highest average rating?
SELECT destination.city, ROUND(AVG(review.rating), 2) AS avg_rating
FROM destination
JOIN review ON destination.id = review.destination_id
GROUP BY destination.city
ORDER BY avg_rating DESC
LIMIT 5;

-- ============================================================
-- SECTION 3: JOIN
-- ============================================================

-- Q11. Show each booking with traveler name, destination and total cost
SELECT traveler.name, destination.city, booking.booking_date,
       booking.status, booking.total_cost
FROM booking
JOIN traveler ON booking.traveler_id = traveler.id
JOIN flight ON booking.flight_id = flight.id
JOIN destination ON flight.destination_id = destination.id
ORDER BY booking.booking_date DESC;

-- Q12. Show all hotels in destinations rated above 4.5 on average
SELECT hotel.name, hotel.stars, hotel.price_per_night, destination.city
FROM hotel
JOIN destination ON hotel.destination_id = destination.id
WHERE destination.id IN (
    SELECT destination_id FROM review
    GROUP BY destination_id
    HAVING AVG(rating) > 4.5
);

-- Q13. Show travelers who have visited more than 3 different countries
SELECT traveler.name, COUNT(DISTINCT destination.country) AS countries_visited
FROM traveler
JOIN booking ON traveler.id = booking.traveler_id
JOIN flight ON booking.flight_id = flight.id
JOIN destination ON flight.destination_id = destination.id
WHERE booking.status = 'confirmed'
GROUP BY traveler.name
HAVING COUNT(DISTINCT destination.country) > 3
ORDER BY countries_visited DESC;

-- Q14. Show the cheapest flight to each destination
SELECT destination.city, MIN(flight.price) AS cheapest_price, flight.airline
FROM flight
JOIN destination ON flight.destination_id = destination.id
GROUP BY destination.city, flight.airline
ORDER BY cheapest_price ASC;

-- Q15. Show top rated airlines by average booking review
SELECT airline.name, ROUND(AVG(review.rating), 2) AS avg_rating
FROM airline
JOIN flight ON airline.name = flight.airline
JOIN booking ON flight.id = booking.flight_id
JOIN review ON booking.traveler_id = review.traveler_id
GROUP BY airline.name
ORDER BY avg_rating DESC;

-- ============================================================
-- SECTION 4: Subqueries
-- ============================================================

-- Q16. Show destinations more expensive than average hotel price
SELECT destination.city, ROUND(AVG(hotel.price_per_night), 2) AS avg_hotel_price
FROM destination
JOIN hotel ON destination.id = hotel.destination_id
GROUP BY destination.city
HAVING AVG(hotel.price_per_night) > (SELECT AVG(price_per_night) FROM hotel)
ORDER BY avg_hotel_price DESC;

-- Q17. Show travelers who have never left a review
SELECT name FROM traveler
WHERE id NOT IN (
    SELECT DISTINCT traveler_id FROM review
);

-- Q18. Show the most booked destination
SELECT destination.city, COUNT(booking.id) AS booking_count
FROM destination
JOIN flight ON destination.id = flight.destination_id
JOIN booking ON flight.id = booking.flight_id
GROUP BY destination.city
ORDER BY booking_count DESC
LIMIT 1;

-- Q19. Show flights cheaper than average price to the same destination
SELECT f1.airline, destination.city, f1.price
FROM flight f1
JOIN destination ON f1.destination_id = destination.id
WHERE f1.price < (
    SELECT AVG(f2.price)
    FROM flight f2
    WHERE f2.destination_id = f1.destination_id
)
ORDER BY destination.city, f1.price;

-- Q20. Show platinum travelers who have spent more than $10,000 total
SELECT traveler.name, SUM(booking.total_cost) AS total_spent
FROM traveler
JOIN booking ON traveler.id = booking.traveler_id
WHERE traveler.tier = 'platinum'
AND booking.status = 'confirmed'
GROUP BY traveler.name
HAVING SUM(booking.total_cost) > 10000
ORDER BY total_spent DESC;
