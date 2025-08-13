use taxi_project_DB


select * from dbo.TripData;
select * from dbo.TripFares;

--- CREATING TRIP VENDOR TABLE

create table TripVendor(
medallion CHAR(32) PRIMARY KEY,
hack_license CHAR(32) NOT NULL,
Vendor_id CHAR(10),
rate_code INT,
store_and_fwd_flag CHAR(10)
);


INSERT INTO TripVendor (medallion, hack_license, Vendor_id, rate_code, store_and_fwd_flag)
SELECT medallion, hack_license, vendor_id, rate_code, store_and_fwd_flag
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY medallion
               ORDER BY pickup_datetime
           ) AS rn
    FROM TripData
) t
WHERE rn = 1;



SELECT * FROM TripVendor;

--- CREATING TRIPPIC TABLE

create table TripPic(
 medallion CHAR(32) NOT NULL,
 pickup_datetime DATETIME2(0) NOT NULL,
 dropoff_datetime DATETIME2(0) NOT NULL,
 FOREIGN KEY (medallion) references TripVendor(medallion)

);

INSERT INTO TripPic(medallion, pickup_datetime, dropoff_datetime)
SELECT medallion, pickup_datetime, dropoff_datetime from TripData

SELECT * FROM TripPic;

--- CREATING TRIPDETAILS TABLE

create table TripDetails(
medallion CHAR(32) NOT NULL,
passenger_count TINYINT NOT NULL,
trip_time_in_secs INT NOT NULL,
trip_distance DECIMAL(6,2) NOT NULL,
 FOREIGN KEY (medallion) references TripVendor(medallion)
)

INSERT INTO TripDetails(medallion, passenger_count, trip_time_in_secs, trip_distance) 
select medallion, passenger_count, trip_time_in_secs, trip_distance from TripData;

SELECT * FROM TripDetails;

--- CREATING TRIPLOCATION TABLE

CREATE TABLE TripLocation (
    medallion CHAR(32) NOT NULL,
    pickup_longitude DECIMAL(9,6) CHECK (pickup_longitude BETWEEN -180 AND 180),
    pickup_latitude  DECIMAL(8,6) CHECK (pickup_latitude BETWEEN -90 AND 90),
    dropoff_longitude DECIMAL(9,6) CHECK (dropoff_longitude BETWEEN -180 AND 180),
    dropoff_latitude  DECIMAL(8,6) CHECK (dropoff_latitude BETWEEN -180 AND 180),
    FOREIGN KEY (medallion) REFERENCES TripVendor(medallion)
);

INSERT INTO TripLocation(medallion, pickup_longitude, pickup_latitude, dropoff_longitude, dropoff_latitude)
SELECT
    medallion,
    TRY_CAST(pickup_longitude AS DECIMAL(9,6)),
    TRY_CAST(pickup_latitude  AS DECIMAL(8,6)),
    TRY_CAST(dropoff_longitude AS DECIMAL(9,6)),
    TRY_CAST(dropoff_latitude  AS DECIMAL(8,6))
FROM TripData
WHERE 
    TRY_CAST(pickup_longitude AS DECIMAL(9,6)) BETWEEN -180 AND 180
    AND TRY_CAST(pickup_latitude AS DECIMAL(8,6)) BETWEEN -90 AND 90
    AND TRY_CAST(dropoff_longitude AS DECIMAL(9,6)) BETWEEN -180 AND 180
    AND TRY_CAST(dropoff_latitude AS DECIMAL(8,6)) BETWEEN -90 AND 90;



select * from dbo.TripLocation

--- CREATING FARE DETAILS TABLE 

CREATE TABLE FareDetails (
medallion CHAR(32) NOT NULL,
fare_amount DECIMAL(8,2) NOT NULL,
surcharge DECIMAL(8,2) NOT NULL,
mta_tax DECIMAL(8,2) NOT NULL,
tip_amount DECIMAL(8,2) NOT NULL,
tolls_amount DECIMAL(8,2) NOT NULL,
total_amount DECIMAL(8,2) NOT NULL,
FOREIGN KEY (medallion) references TripVendor(medallion)
);

INSERT INTO FareDetails(medallion, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount)
select 
medallion, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount
from TripFares;

select* from FareDetails

--- CREATING PAYMENTS TABLE

CREATE TABLE Payment (
    medallion CHAR(32) NOT NULL,
    payment_type VARCHAR(10) NOT NULL,  -- Changed from TINYINT to VARCHAR
    total_amount DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (medallion) REFERENCES TripVendor(medallion)
);


INSERT INTO Payment(medallion, payment_type, total_amount)
select medallion, payment_type, total_amount from TripFares

SELECT * FROM payment;
