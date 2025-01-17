CONNECT TO COMP421;

-- Remember to put the create table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables have already been created.

-- orders are changed from p1 to make more sense logically
CREATE TABLE Users (
    user_id INT NOT NULL,
    name VARCHAR(25) NOT NULL,
    email VARCHAR(40) NOT NULL,
    phone_number VARCHAR(22) NOT NULL,
    address VARCHAR(50) NOT NULL,
    credit_card_information VARCHAR(28) NOT NULL,
    PRIMARY KEY (user_id)
);
CREATE TABLE Registered (
    user_id INT NOT NULL,
    username VARCHAR(10) UNIQUE NOT NULL, ------------------------------------------------------------add
    password VARCHAR(10) NOT NULL,
    language CHAR(2) DEFAULT 'no' NOT NULL, -- modified from p1
    totalspent DECIMAL(15, 2) DEFAULT 0.00 NOT NULL, 
    --history CLOB, -------------------------------------------------------------------------------------drop?
    PRIMARY KEY (user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
CREATE TABLE Cities (
    city_name VARCHAR(20) NOT NULL,
    country VARCHAR(15) NOT NULL,
    PRIMARY KEY (city_name, country)
);
CREATE TABLE DepartureCity( 
    departure_city VARCHAR(20) NOT NULL,
    departure_country VARCHAR(15) NOT NULL,
    airport_departure_name VARCHAR(65) NOT NULL,
    PRIMARY KEY (departure_city, departure_country),
    FOREIGN KEY (departure_city, departure_country) REFERENCES Cities(city_name, country)
);
CREATE TABLE ArrivalCity( 
    arrival_city VARCHAR(20) NOT NULL,
    arrival_country VARCHAR(15) NOT NULL,
    airport_arrival_name VARCHAR(65) NOT NULL,
    PRIMARY KEY (arrival_city, arrival_country),
    FOREIGN KEY (arrival_city, arrival_country) REFERENCES Cities(city_name, country)
);
CREATE TABLE Route ( 
    departure_city VARCHAR(20) NOT NULL,
    departure_country VARCHAR(15) NOT NULL,
    arrival_city VARCHAR(20) NOT NULL,
    arrival_country VARCHAR(15) NOT NULL,
    PRIMARY KEY (departure_city, departure_country, arrival_city, arrival_country),
    FOREIGN KEY (departure_city, departure_country) REFERENCES DepartureCity(departure_city, departure_country),
    FOREIGN KEY (arrival_city, arrival_country) REFERENCES ArrivalCity(arrival_city, arrival_country)
);
CREATE TABLE Flights ( 
    flight_number VARCHAR(7) NOT NULL,
    airline_policy VARCHAR(45) NOT NULL,
    airline VARCHAR(25) NOT NULL,
    airplane_model VARCHAR(25) NOT NULL,
    economy_seats INT NOT NULL,
    premium_economy_seats INT,
    business_seats INT,
    first_class_seats INT,
    economy_cost DECIMAL(6, 2) NOT NULL,
    premium_economy_cost DECIMAL(6, 2),
    business_cost DECIMAL(7, 2),
    first_class_cost DECIMAL(7, 2),
    departure_city VARCHAR(20) NOT NULL,
    departure_country VARCHAR(15) NOT NULL,
    arrival_city VARCHAR(20) NOT NULL,
    arrival_country VARCHAR(15) NOT NULL,
    departure_date_time DATETIME NOT NULL,
    arrival_date_time DATETIME NOT NULL,
    flight_duration TIME NOT NULL,
    PRIMARY KEY (flight_number, departure_date_time),
    FOREIGN KEY (departure_city, departure_country, arrival_city, arrival_country) REFERENCES Route(departure_city, departure_country, arrival_city, arrival_country)
    --FOREIGN KEY (arrival_city, arrival_country) REFERENCES ArrivalCity(arrival_city, arrival_country)
);
CREATE TABLE Car (
    car_license_plate VARCHAR(10) NOT NULL,
    number_of_seats INT NOT NULL,
    car_rental_agency VARCHAR(12) NOT NULL,
    transmission_type VARCHAR(12) NOT NULL,
    car_model VARCHAR(25) NOT NULL,
    car_engine_type VARCHAR(10) NOT NULL,
    car_daily_cost DECIMAL(5, 2) NOT NULL, -- changed from p1
    city_name VARCHAR(20) NOT NULL,
    country VARCHAR(15) NOT NULL,
    company_policy VARCHAR(50) NOT NULL, 
    AC CHAR(1) NOT NULL, -- changed from p1
    carplay CHAR(1),
    PRIMARY KEY (car_license_plate),
    FOREIGN KEY (city_name, country) REFERENCES Cities(city_name, country)
);
CREATE TABLE Hotel ( 
    brand_affiliation VARCHAR(15) NOT NULL,
    hotel_address VARCHAR(50) NOT NULL,
    hotel_policy VARCHAR(100) NOT NULL, 
    airport_shuttle VARCHAR(20),
    business_facilities VARCHAR(40),
    restaurants VARCHAR(45),
    listing_name VARCHAR(35) NOT NULL,
    fitness_center VARCHAR(20),
    on_site_parking VARCHAR(45),
    pet_allowance CHAR(1),
    pool CHAR(1),
    city_name VARCHAR(20) NOT NULL,
    country VARCHAR(15) NOT NULL,
    PRIMARY KEY (brand_affiliation, hotel_address), 
    FOREIGN KEY (city_name, country) REFERENCES Cities(city_name, country)
);
CREATE TABLE Room ( 
    hotel_address VARCHAR(50) NOT NULL,
    brand_affiliation VARCHAR(15) NOT NULL,
    room_number INT NOT NULL,
    room_name VARCHAR(20) NOT NULL,
    -- availability removed from p1
    room_capacity INT NOT NULL,
    beds VARCHAR(15) NOT NULL,
    room_price DECIMAL(6, 2) NOT NULL,
    size VARCHAR(10) NOT NULL, -- changed from p1
    free_wifi CHAR(1) NOT NULL, -- changed from p1
    view VARCHAR(20) NOT NULL, -- changed from p1
    minibar CHAR(1) NOT NULL, -- changed from p1
    private_bathroom CHAR(1) NOT NULL, -- changed from p1
    smoking CHAR(1) NOT NULL, -- changed from p1
    PRIMARY KEY (hotel_address, brand_affiliation, room_number),
    FOREIGN KEY (brand_affiliation, hotel_address) REFERENCES Hotel(brand_affiliation, hotel_address)
);
CREATE TABLE FlightBooking ( 
    flight_reference_number INT NOT NULL,
    user_id INT NOT NULL,
    passenger_names VARCHAR(150) NOT NULL,
    flight_number VARCHAR(7) NOT NULL,
    departure_date_time DATETIME NOT NULL,
    flight_total_cost DECIMAL(9, 2) NOT NULL,
    fare_class VARCHAR(10) NOT NULL,
    seat_numbers VARCHAR(21) NOT NULL,
    plane_ticket_cost DECIMAL(8, 2) NOT NULL,
    plane_ticket_surcharge DECIMAL(7, 2) NOT NULL,
    plane_ticket_tax DECIMAL(7, 2) NOT NULL,
    flight_booking_fees DECIMAL(5, 2) NOT NULL,
    flight_booking_date DATE NOT NULL,
    PRIMARY KEY (flight_reference_number),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (flight_number, departure_date_time) REFERENCES Flights(flight_number, departure_date_time)
);
CREATE TABLE HotelBooking ( 
    hotel_reference_number INT NOT NULL,
    user_id INT NOT NULL,
    room_number INT NOT NULL,
    brand_affiliation VARCHAR(15) NOT NULL,
    hotel_address VARCHAR(50) NOT NULL,
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL,
    --breakfast_inclusion VARCHAR(20) NOT NULL, -- removed from p1   
    hotel_total_cost DECIMAL(10, 2) NOT NULL,
    room_cost DECIMAL(6, 2) NOT NULL,
    hotel_tax DECIMAL(9, 2) NOT NULL,
    hotel_booking_fees DECIMAL(5, 2) NOT NULL,
    hotel_booking_date DATE NOT NULL,
    PRIMARY KEY (hotel_reference_number),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (hotel_address, brand_affiliation, room_number) REFERENCES Room(hotel_address, brand_affiliation, room_number)
);
CREATE TABLE CarRentalBooking (
    car_rental_reference_number INT NOT NULL,
    user_id INT NOT NULL,
    car_license_plate VARCHAR(10) NOT NULL,
    pickup_location VARCHAR(50) NOT NULL,
    return_location VARCHAR(50) NOT NULL,
    pickup_date_time DATETIME NOT NULL,
    return_date_time DATETIME NOT NULL,
    car_rental_booking_date DATE NOT NULL,
    car_rental_cost DECIMAL(6, 2) NOT NULL,
    car_rental_tax DECIMAL(5, 2) NOT NULL,
    car_rental_booking_fees DECIMAL(4, 2) NOT NULL,
    car_rental_total_cost DECIMAL(7, 2) NOT NULL,
    insurance VARCHAR(50) NOT NULL, 
    PRIMARY KEY (car_rental_reference_number), 
    FOREIGN KEY (car_license_plate) REFERENCES Car(car_license_plate),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


