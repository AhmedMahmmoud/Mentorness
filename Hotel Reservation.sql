

-- What is the total number of reservations in the dataset? 
select Count(*) as TotalReservations
from ['Hotel Reservation Dataset$'];


-- Which meal plan is the most popular among guests?
SELECT top (1) type_of_meal_plan, COUNT(*) AS ReservationCount
from ['Hotel Reservation Dataset$']
GROUP BY type_of_meal_plan
ORDER BY ReservationCount DESC;



--What is the average price per room for reservations involving children?
select AVG(avg_price_per_room) AS AveragePricePerRoom, room_type_reserved AS RoomType
from ['Hotel Reservation Dataset$'] 
where no_of_children > 0
GROUP BY room_type_reserved





-- How many reservations were made for the year 20XX (replace XX with the desired year)?
-- DD-MM-YYYY = 105
SELECT '2017' AS Year, COUNT(*) AS TotalReservations
FROM ['Hotel Reservation Dataset$']
WHERE TRY_CONVERT(date, arrival_date, 105) IS NOT NULL
AND YEAR(TRY_CONVERT(date, arrival_date, 105)) = 2017

UNION ALL

SELECT '2018' AS Year,COUNT(*) AS TotalReservations
FROM ['Hotel Reservation Dataset$']
WHERE TRY_CONVERT(date, arrival_date, 105) IS NOT NULL
AND YEAR(TRY_CONVERT(date, arrival_date, 105)) = 2018;






--What is the most commonly booked room type?
SELECT TOP(1) room_type_reserved ,COUNT(*) AS TotalReservations
FROM ['Hotel Reservation Dataset$']
GROUP BY room_type_reserved
ORDER BY TotalReservations DESC;






--How many reservations fall on a weekend (no_of_weekend_nights > 0)?
SELECT COUNT(*) AS TotalReservations
FROM ['Hotel Reservation Dataset$']
WHERE no_of_weekend_nights > 0;










--What is the highest and lowest lead time for reservations? 
SELECT MAX(lead_time) AS HighestLeadTime, MIN(lead_time) AS LowestLeadtime 
FROM ['Hotel Reservation Dataset$'];







--What is the most common market segment type for reservations? 
SELECT TOP(1)market_segment_type AS MostCommonMarketSegment ,COUNT(*) AS TotalReservations
FROM ['Hotel Reservation Dataset$']
GROUP BY market_segment_type
ORDER BY TotalReservations DESC






--How many reservations have a booking status of "Confirmed"? 
SELECT COUNT(*) AS TotalReservations
from ['Hotel Reservation Dataset$']
where booking_status ='Not_Canceled';






-- What is the total number of adults and children across all reservations?
SELECT SUM(no_of_adults) AS TotalAdults, SUM(no_of_children) AS TotalChildren
FROM ['Hotel Reservation Dataset$'];







--What is the average number of weekend nights for reservations involving children? 
SELECT 
    AVG(
        CASE WHEN no_of_children > 0 THEN no_of_weekend_nights ELSE NULL END
    ) AS AverageWeekendNightsWithChildren
FROM ['Hotel Reservation Dataset$'];






--How many reservations were made in each month of the year?
SELECT 
    YEAR(TRY_CONVERT(date, arrival_date, 105)) AS Year,
    MONTH(TRY_CONVERT(date, arrival_date, 105)) AS Month,
    COUNT(*) AS TotalReservations
FROM ['Hotel Reservation Dataset$']
WHERE 
    TRY_CONVERT(date, arrival_date, 105) IS NOT NULL
GROUP BY 
    YEAR(TRY_CONVERT(date, arrival_date, 105)), 
    MONTH(TRY_CONVERT(date, arrival_date, 105))
ORDER BY 
    Year, Month;


--What is the average number of nights (both weekend and weekday) spent by guests for each room type?
SELECT room_type_reserved,AVG((no_of_week_nights) + (no_of_weekend_nights)) AS AverageNightsSpent
FROM ['Hotel Reservation Dataset$']
GROUP BY room_type_reserved;




--For reservations involving children, what is the most common room type, and what is the average price for that room type?
-- Step 1: Find the most common room type for reservations involving children
WITH MostCommonRoomType AS (
    SELECT 
         TOP(1) room_type_reserved AS RoomType,
        COUNT(*) AS ReservationCount
    FROM 
        ['Hotel Reservation Dataset$']
    WHERE 
        no_of_children > 0
    GROUP BY 
        room_type_reserved
    ORDER BY 
        ReservationCount DESC
)
-- Step 2: Calculate the average price for that most common room type
SELECT 
    mcrt.RoomType,
    AVG(hrd.avg_price_per_room) AS AveragePricePerRoom
FROM 
    MostCommonRoomType mcrt
JOIN 
    ['Hotel Reservation Dataset$'] hrd
ON 
    mcrt.RoomType = hrd.room_type_reserved
WHERE 
    hrd.no_of_children > 0
GROUP BY 
    mcrt.RoomType;


-- Find the market segment type that generates the highest average price per room
SELECT TOP(1) market_segment_type  AS MarketSegment ,AVG(avg_price_per_room) AS AveragePricePerRoom
FROM ['Hotel Reservation Dataset$']
GROUP BY market_segment_type
ORDER BY AveragePricePerRoom DESC