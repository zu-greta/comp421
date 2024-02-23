-- Include your drop table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO COMP421;

-- Remember to put the drop table ddls for the tables with foreign key references
--    BEFORE the ddls to drop the parent tables (reverse of the creation order).


DROP TABLE Users;
DROP TABLE Registered;
DROP TABLE FlightBooking;
DROP TABLE Flights;
DROP TABLE HotelBooking;
DROP TABLE Hotel;
DROP TABLE Cities;
DROP TABLE CarRentalBooking;
DROP TABLE Car;
DROP TABLE Room;
DROP TABLE Route;
DROP TABLE ArrivalCity;
DROP TABLE DepartureCity;
