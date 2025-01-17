-- createtbl.sql

-- Write a SQL database schema for the relational schema you have designed using the CREATE TABLE command 
-- and enter it in the database. Choose suitable data types for your attributes. Indicate primary keys, 
-- foreign keys or any other integrity constraints that you can express with the commands learnt. 
-- Indicate the constraints you cannot express. The Online Information contains detailed information about data types, 
-- and the CREATE TABLE statement.

-- Once you have figured out the DDLs, you can write them into the createtbl.sql file and have it executed using 
-- the createtbl.sh. Verify that all the tables got created correctly in the log file. and turn in the createtbl.log 
-- produced by the script along with the createtbl.sql file.



-- Include your create table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
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
    economy_seats VARCHAR(1500) NOT NULL, --int
    premium_economy_seats VARCHAR(160),
    business_seats VARCHAR(240),
    first_class_seats VARCHAR(80),
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
    insurance VARCHAR(30) NOT NULL, 
    PRIMARY KEY (car_rental_reference_number), 
    FOREIGN KEY (car_license_plate) REFERENCES Car(car_license_plate),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);





-- droptbl.sql

-- Next, write the corresponding DROP TABLE statements into the droptbl.sql file and have it executed using the droptbl.sh. 
-- Verify that all the tables got dropped correctly in the log file. and turn in the createtbl.log produced by the script 
-- along with the droptbl.sql file.


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

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO COMP421;

INSERT INTO Users (user_id, name, email, phone_number, address, credit_card_information) VALUES
    (1, 'John Doe', 'jdoe@gmail.com', '+1(514)123-4567', '1234 Rue Saint-Catherine, Montreal, QC, Canada', '1234123412341234, 12/23, 123'),
    (2, 'Jane Doe', 'janed@gmail.com', '+1(438)123-4567', '1234 Rue Saint-Catherine, Montreal, QC, Canada', '4321432143214321, 11/25, 321'),
    (3, 'John Smith', 'jsmith@yahoo.com', '+1(514)345-6789', '321 Blvd Saint-Jean, Pointe-Claire, QC, Canada', '1234432112344321, 06/26, 456'),
    (4, 'Jane Smith', 'janes@yahoo.com', '+1(438)345-6789', '321 Blvd Saint-Jean, Pointe-Claire, QC, Canada', '4321123443211234, 07/24, 789'),
    (5, 'John Johnson', 'jj@gmail.com', '+1(514)567-8901', '1111 Blvd Saint-Charles, Montreal, QC, Canada', '1234123443214321, 06/27, 555'),
    (6, 'Jane Johnson', 'janej@gmail.com', '+1(438)567-8901', '1111 Blvd Saint-Charles, Montreal, QC, Canada', '4321123412344321, 07/25, 666'),
    (7, 'John Jackson', 'jjackson@gmail.com', '+1(514)678-9012', '2222 Rue Sainte-Catherine, Montreal, QC, Canada', '1234432143211234, 06/28, 777'),
    (8, 'Jane Jackson', 'jajackson@gmail.com', '+1(438)678-9012', '2222 Rue Sainte-Catherine, Montreal, QC, Canada', '4321123412344321, 07/26, 888')
;

--Add CONTRAINT to passwords?
--Format for History:
--  [flight_reference_number, flight_number, departure_city, departure_country, arrival_city, arrival_country, departure_date_time, arrival_date_time]
--  [hotel_reference_number, brand_affiliation, city_name, country, DATES!!!!!!!!]
--  [car_rental_reference_number, car_model, city_name, country, DATES!!!!!!!!]
INSERT INTO Registered (user_id, username, password, language) VALUES
    (1, 'jdoe', '1234', 'en'),
    (2, 'janed', '4321', 'en'),
    (3, 'jsmith', '1111', 'fr'),
    (4, 'janes', '2222', 'fr'),
    (5, 'jj', '3333', 'en'),
    (6, 'janej', '4444', 'en')
;


INSERT INTO CITIES (city_name, country) VALUES
    ('Vancouver', 'Canada'),
    ('Montreal', 'Canada'),
    ('Toronto', 'Canada'),
    ('London', 'Canada'), 
    ('Calgary', 'Canada'),
    ('Edmonton', 'Canada'),
    ('Ottawa', 'Canada'),
    ('Quebec City', 'Canada'),
    ('Winnipeg', 'Canada'),
    ('Halifax', 'Canada'),
    ('St. John''s', 'Canada'),
    ('Yellowknife', 'Canada'),
    ('London', 'UK'), 
    ('Manchester', 'UK'),
    ('Birmingham', 'UK'),
    ('Glasgow', 'UK'),
    ('Liverpool', 'UK'),
    ('Edinburgh', 'UK'),
    ('Belfast', 'UK'),
    ('Dublin', 'Ireland'),
    ('Paris', 'France'),
    ('Marseille', 'France'),
    ('Lyon', 'France'),
    ('Toulouse', 'France'),
    ('Nice', 'France'),
    ('Nantes', 'France'),
    ('Bordeaux', 'France'),
    ('Chicago', 'USA'),
    ('Houston', 'USA'),
    ('Phoenix', 'USA'),
    ('Philadelphia', 'USA'),
    ('San Antonio', 'USA'),
    ('San Diego', 'USA'),
    ('Dallas', 'USA'),
    ('San Jose', 'USA'),
    ('Austin', 'USA'),
    ('Jacksonville', 'USA'),
    ('San Francisco', 'USA'),
    ('Indianapolis', 'USA'),
    ('Columbus', 'USA'),
    ('Fort Worth', 'USA'),
    ('Charlotte', 'USA'),
    ('Detroit', 'USA'),
    ('El Paso', 'USA'),
    ('Memphis', 'USA'),
    ('Boston', 'USA'),
    ('Seattle', 'USA'),
    ('Denver', 'USA'),
    ('Washington', 'USA'),
    ('Nashville', 'USA'),
    ('Las Vegas', 'USA'),
    ('Portland', 'USA'),
    ('Oklahoma City', 'USA'),
    ('Albuquerque', 'USA'),
    ('Atlanta', 'USA'),
    ('Long Beach', 'USA'),
    ('Fresno', 'USA'),
    ('Sacramento', 'USA'),
    ('Mesa', 'USA'),
    ('Kansas City', 'USA'),
    ('New York', 'USA'),
    ('Los Angeles', 'USA'),
    ('Tokyo', 'Japan'),
    ('Osaka', 'Japan'),
    ('Kyoto', 'Japan'),
    ('Yokohama', 'Japan'),
    ('Nagoya', 'Japan'),
    ('Sapporo', 'Japan'),
    ('Fukuoka', 'Japan'),
    ('Kobe', 'Japan'),
    ('Kawasaki', 'Japan'),
    ('Saitama', 'Japan'),
    ('Hiroshima', 'Japan'),
    ('Sendai', 'Japan'),
    ('Chiba', 'Japan'),
    ('Kitakyushu', 'Japan'),
    ('Sakai', 'Japan'),
    ('Beijing', 'China'),
    ('Shanghai', 'China'),
    ('Guangzhou', 'China'),
    ('Shenzhen', 'China'),
    ('Wuhan', 'China'),
    ('Chengdu', 'China'),
    ('Tianjin', 'China'),
    ('Chongqing', 'China'),
    ('Nanjing', 'China'),
    ('Xi an', 'China'),
    ('Hangzhou', 'China'),
    ('Harbin', 'China'),
    ('Dalian', 'China'),
    ('Shenyang', 'China'),
    ('Jinan', 'China'),
    ('Qingdao', 'China'),
    ('Zhengzhou', 'China'),
    ('Changsha', 'China'),
    ('Kunming', 'China'),
    ('Fuzhou', 'China'),
    ('Xiamen', 'China'),
    ('Nanning', 'China'),
    ('Hefei', 'China'),
    ('Urumqi', 'China'),
    ('Changchun', 'China'),
    ('Shijiazhuang', 'China'),
    ('Lanzhou', 'China'),
    ('Guiyang', 'China'),
    ('Nanchang', 'China'),
    ('Haikou', 'China'),
    ('Taiyuan', 'China'),
    ('Xining', 'China'),
    ('Hohhot', 'China'),
    ('Lhasa', 'China'),
    ('Hong Kong', 'China'),
    ('Macao', 'China'),
    ('Sydney', 'Australia'),
    ('Melbourne', 'Australia'),
    ('Brisbane', 'Australia'),
    ('Perth', 'Australia'),
    ('Adelaide', 'Australia'),
    ('Canberra', 'Australia'),
    ('Wellington', 'New Zealand'),
    ('Auckland', 'New Zealand'),
    ('Christchurch', 'New Zealand'),
    ('Rio de Janeiro', 'Brazil'),
    ('Cape Town', 'South Africa'),
    ('Mumbai', 'India'),
    ('Dubai', 'UAE'),
    ('Moscow', 'Russia'),
    ('Rome', 'Italy'),
    ('Milan', 'Italy'), 
    ('Venice', 'Italy'),
    ('Athens', 'Greece'),
    ('Istanbul', 'Turkey'),
    ('Cairo', 'Egypt'),
    ('Nairobi', 'Kenya'),
    ('Mexico City', 'Mexico'),
    ('Buenos Aires', 'Argentina'),
    ('Santiago', 'Chile'),
    ('Lima', 'Peru'),
    ('Bogota', 'Colombia'),
    ('Caracas', 'Venezuela'),
    ('Havana', 'Cuba')
;
INSERT INTO DepartureCity (departure_city, departure_country, airport_departure_name) VALUES
    ('Vancouver', 'Canada', 'Vancouver International Airport'),
    ('Montreal', 'Canada', 'Montreal-Pierre Elliott Trudeau International Airport'),
    ('Toronto', 'Canada', 'Toronto Pearson International Airport'),
    ('London', 'Canada', 'London International Airport'),
    ('Calgary', 'Canada', 'Calgary International Airport'),
    ('Edmonton', 'Canada', 'Edmonton International Airport'),
    ('Ottawa', 'Canada', 'Ottawa Macdonald-Cartier International Airport'),
    ('Quebec City', 'Canada', 'Quebec City Jean Lesage International Airport'),
    ('Winnipeg', 'Canada', 'Winnipeg James Armstrong Richardson International Airport'),
    ('Halifax', 'Canada', 'Halifax Stanfield International Airport'),
    ('St. John''s', 'Canada', 'St. John''s International Airport'),
    ('Yellowknife', 'Canada', 'Yellowknife Airport'),
    ('London', 'UK', 'London Heathrow Airport'),
    ('Manchester', 'UK', 'Manchester Airport'),
    ('Birmingham', 'UK', 'Birmingham Airport'),
    ('Glasgow', 'UK', 'Glasgow Airport'),
    ('Liverpool', 'UK', 'Liverpool John Lennon Airport'),
    ('Edinburgh', 'UK', 'Edinburgh Airport'),
    ('Belfast', 'UK', 'Belfast International Airport'),
    ('Dublin', 'Ireland', 'Dublin Airport'),
    ('Paris', 'France', 'Charles de Gaulle Airport'),
    ('Marseille', 'France', 'Marseille Provence Airport'),
    ('Lyon', 'France', 'Lyon-Saint Exupéry Airport'),
    ('Toulouse', 'France', 'Toulouse-Blagnac Airport'),
    ('Nice', 'France', 'Nice Côte d''Azur Airport'),
    ('Nantes', 'France', 'Nantes Atlantique Airport'),
    ('Bordeaux', 'France', 'Bordeaux-Mérignac Airport'),
    ('Chicago', 'USA', 'O''Hare International Airport'),
    ('Houston', 'USA', 'George Bush Intercontinental Airport'),
    ('Phoenix', 'USA', 'Phoenix Sky Harbor International Airport'),
    ('Philadelphia', 'USA', 'Philadelphia International Airport'),
    ('San Antonio', 'USA', 'San Antonio International Airport'),
    ('San Diego', 'USA', 'San Diego International Airport'),
    ('Dallas', 'USA', 'Dallas/Fort Worth International Airport'),
    ('San Jose', 'USA', 'Norman Y. Mineta San Jose International Airport'),
    ('Austin', 'USA', 'Austin-Bergstrom International Airport'),
    ('Jacksonville', 'USA', 'Jacksonville International Airport'),
    ('San Francisco', 'USA', 'San Francisco International Airport'),
    ('Indianapolis', 'USA', 'Indianapolis International Airport'),
    ('Columbus', 'USA', 'John Glenn Columbus International Airport'),
    ('Fort Worth', 'USA', 'Dallas/Fort Worth International Airport'),
    ('Charlotte', 'USA', 'Charlotte Douglas International Airport'),
    ('Detroit', 'USA', 'Detroit Metropolitan Wayne County Airport'),
    ('El Paso', 'USA', 'El Paso International Airport'),
    ('Memphis', 'USA', 'Memphis International Airport'),
    ('Boston', 'USA', 'Logan International Airport'),
    ('Seattle', 'USA', 'Seattle-Tacoma International Airport'),
    ('Denver', 'USA', 'Denver International Airport'),
    ('Washington', 'USA', 'Washington Dulles International Airport'),
    ('Nashville', 'USA', 'Nashville International Airport'),
    ('Las Vegas', 'USA', 'McCarran International Airport'),
    ('Portland', 'USA', 'Portland International Airport'),
    ('Oklahoma City', 'USA', 'Will Rogers World Airport'),
    ('Albuquerque', 'USA', 'Albuquerque International Sunport'),
    ('Atlanta', 'USA', 'Hartsfield-Jackson Atlanta International Airport'),
    ('Long Beach', 'USA', 'Long Beach Airport'),
    ('Fresno', 'USA', 'Fresno Yosemite International Airport'),
    ('Sacramento', 'USA', 'Sacramento International Airport'),
    ('Mesa', 'USA', 'Phoenix-Mesa Gateway Airport'),
    ('Kansas City', 'USA', 'Kansas City International Airport'),
    ('New York', 'USA', 'John F. Kennedy International Airport'),
    ('Los Angeles', 'USA', 'Los Angeles International Airport'),
    ('Tokyo', 'Japan', 'Narita International Airport'),
    ('Osaka', 'Japan', 'Kansai International Airport'),
    ('Kyoto', 'Japan', 'Kansai International Airport'),
    ('Yokohama', 'Japan', 'Narisawa'),
    ('Nagoya', 'Japan', 'Chubu Centrair International Airport'),
    ('Sapporo', 'Japan', 'New Chitose Airport'),
    ('Fukuoka', 'Japan', 'Fukuoka Airport'),
    ('Kobe', 'Japan', 'Kansai International Airport'),
    ('Kawasaki', 'Japan', 'Narisawa'),
    ('Saitama', 'Japan', 'Narisawa'),
    ('Hiroshima', 'Japan', 'Hiroshima Airport'),
    ('Sendai', 'Japan', 'Sendai Airport'),
    ('Chiba', 'Japan', 'Narisawa'),
    ('Kitakyushu', 'Japan', 'Fukuoka Airport'),
    ('Sakai', 'Japan', 'Narisawa'),
    ('Beijing', 'China', 'Beijing Capital International Airport'),
    ('Shanghai', 'China', 'Shanghai Pudong International Airport'),
    ('Guangzhou', 'China', 'Guangzhou Baiyun International Airport'),
    ('Shenzhen', 'China', 'Shenzhen Bao''an International Airport'),
    ('Wuhan', 'China', 'Wuhan Tianhe International Airport'),
    ('Chengdu', 'China', 'Chengdu Shuangliu International Airport'),
    ('Tianjin', 'China', 'Tianjin Binhai International Airport'),
    ('Chongqing', 'China', 'Chongqing Jiangbei International Airport'),
    ('Nanjing', 'China', 'Nanjing Lukou International Airport'),
    ('Xi an', 'China', 'Xi''an Xianyang International Airport'),
    ('Hangzhou', 'China', 'Hangzhou Xiaoshan International Airport'),
    ('Harbin', 'China', 'Harbin Taiping International Airport'),
    ('Dalian', 'China', 'Dalian Zhoushuizi International Airport'),
    ('Shenyang', 'China', 'Shenyang Taoxian International Airport'),
    ('Jinan', 'China', 'Jinan Yaoqiang International Airport'),
    ('Qingdao', 'China', 'Qingdao Liuting International Airport'),
    ('Zhengzhou', 'China', 'Zhengzhou Xinzheng International Airport'),
    ('Changsha', 'China', 'Changsha Huanghua International Airport'),
    ('Kunming', 'China', 'Kunming Changshui International Airport'),
    ('Fuzhou', 'China', 'Fuzhou Changle International Airport'),
    ('Xiamen', 'China', 'Xiamen Gaoqi International Airport'),
    ('Nanning', 'China', 'Nanning Wuxu International Airport'),
    ('Hefei', 'China', 'Hefei Xinqiao International Airport'),
    ('Urumqi', 'China', 'Ürümqi Diwopu International Airport'),
    ('Changchun', 'China', 'Changchun Longjia International Airport'),
    ('Shijiazhuang', 'China', 'Shijiazhuang Zhengding International Airport'),
    ('Lanzhou', 'China', 'Lanzhou Zhongchuan International Airport'),
    ('Guiyang', 'China', 'Guiyang Longdongbao International Airport'),
    ('Nanchang', 'China', 'Nanchang Changbei International Airport'),
    ('Haikou', 'China', 'Haikou Meilan International Airport'),
    ('Taiyuan', 'China', 'Taiyuan Wusu International Airport'),
    ('Xining', 'China', 'Xining Caojiabao Airport'),
    ('Hohhot', 'China', 'Hohhot Baita International Airport'),
    ('Lhasa', 'China', 'Lhasa Gonggar Airport'),
    ('Hong Kong', 'China', 'Hong Kong International Airport'),
    ('Macao', 'China', 'Macau International Airport'),
    ('Sydney', 'Australia', 'Sydney Kingsford Smith International Airport'),
    ('Melbourne', 'Australia', 'Melbourne Airport'),
    ('Brisbane', 'Australia', 'Brisbane Airport'),
    ('Perth', 'Australia', 'Perth Airport'),
    ('Adelaide', 'Australia', 'Adelaide Airport'),
    ('Canberra', 'Australia', 'Canberra Airport'),
    ('Wellington', 'New Zealand', 'Wellington International Airport'),
    ('Auckland', 'New Zealand', 'Auckland Airport'),
    ('Christchurch', 'New Zealand', 'Christchurch International Airport'),
    ('Rio de Janeiro', 'Brazil', 'Rio de Janeiro-Galeão International Airport'),
    ('Cape Town', 'South Africa', 'Cape Town International Airport'),
    ('Mumbai', 'India', 'Chhatrapati Shivaji Maharaj International Airport'),
    ('Dubai', 'UAE', 'Dubai International Airport'),
    ('Moscow', 'Russia', 'Sheremetyevo International Airport'),
    ('Rome', 'Italy', 'Leonardo da Vinci-Fiumicino Airport'),
    ('Milan', 'Italy', 'Milan Malpensa Airport'),
    ('Venice', 'Italy', 'Venice Marco Polo Airport'),
    ('Athens', 'Greece', 'Athens International Airport'),
    ('Istanbul', 'Turkey', 'Istanbul Airport'),
    ('Cairo', 'Egypt', 'Cairo International Airport'),
    ('Nairobi', 'Kenya', 'Jomo Kenyatta International Airport'),
    ('Mexico City', 'Mexico', 'Mexico City International Airport'),
    ('Buenos Aires', 'Argentina', 'Ministro Pistarini International Airport'),
    ('Santiago', 'Chile', 'Comodoro Arturo Merino Benítez International Airport'),
    ('Lima', 'Peru', 'Jorge Chávez International Airport'),
    ('Bogota', 'Colombia', 'El Dorado International Airport'),
    ('Caracas', 'Venezuela', 'Simón Bolívar International Airport'),
    ('Havana', 'Cuba', 'José Martí International Airport')
;
INSERT INTO ArrivalCity (arrival_city, arrival_country, airport_arrival_name) VALUES
    ('Vancouver', 'Canada', 'Vancouver International Airport'),
    ('Montreal', 'Canada', 'Montreal-Pierre Elliott Trudeau International Airport'),
    ('Toronto', 'Canada', 'Toronto Pearson International Airport'),
    ('London', 'Canada', 'London International Airport'),
    ('Calgary', 'Canada', 'Calgary International Airport'),
    ('Edmonton', 'Canada', 'Edmonton International Airport'),
    ('Ottawa', 'Canada', 'Ottawa Macdonald-Cartier International Airport'),
    ('Quebec City', 'Canada', 'Quebec City Jean Lesage International Airport'),
    ('Winnipeg', 'Canada', 'Winnipeg James Armstrong Richardson International Airport'),
    ('Halifax', 'Canada', 'Halifax Stanfield International Airport'),
    ('St. John''s', 'Canada', 'St. John''s International Airport'),
    ('Yellowknife', 'Canada', 'Yellowknife Airport'),
    ('London', 'UK', 'London Heathrow Airport'),
    ('Manchester', 'UK', 'Manchester Airport'),
    ('Birmingham', 'UK', 'Birmingham Airport'),
    ('Glasgow', 'UK', 'Glasgow Airport'),
    ('Liverpool', 'UK', 'Liverpool John Lennon Airport'),
    ('Edinburgh', 'UK', 'Edinburgh Airport'),
    ('Belfast', 'UK', 'Belfast International Airport'),
    ('Dublin', 'Ireland', 'Dublin Airport'),
    ('Paris', 'France', 'Charles de Gaulle Airport'),
    ('Marseille', 'France', 'Marseille Provence Airport'),
    ('Lyon', 'France', 'Lyon-Saint Exupéry Airport'),
    ('Toulouse', 'France', 'Toulouse-Blagnac Airport'),
    ('Nice', 'France', 'Nice Côte d''Azur Airport'),
    ('Nantes', 'France', 'Nantes Atlantique Airport'),
    ('Bordeaux', 'France', 'Bordeaux-Mérignac Airport'),
    ('Chicago', 'USA', 'O''Hare International Airport'),
    ('Houston', 'USA', 'George Bush Intercontinental Airport'),
    ('Phoenix', 'USA', 'Phoenix Sky Harbor International Airport'),
    ('Philadelphia', 'USA', 'Philadelphia International Airport'),
    ('San Antonio', 'USA', 'San Antonio International Airport'),
    ('San Diego', 'USA', 'San Diego International Airport'),
    ('Dallas', 'USA', 'Dallas/Fort Worth International Airport'),
    ('San Jose', 'USA', 'Norman Y. Mineta San Jose International Airport'),
    ('Austin', 'USA', 'Austin-Bergstrom International Airport'),
    ('Jacksonville', 'USA', 'Jacksonville International Airport'),
    ('San Francisco', 'USA', 'San Francisco International Airport'),
    ('Indianapolis', 'USA', 'Indianapolis International Airport'),
    ('Columbus', 'USA', 'John Glenn Columbus International Airport'),
    ('Fort Worth', 'USA', 'Dallas/Fort Worth International Airport'),
    ('Charlotte', 'USA', 'Charlotte Douglas International Airport'),
    ('Detroit', 'USA', 'Detroit Metropolitan Wayne County Airport'),
    ('El Paso', 'USA', 'El Paso International Airport'),
    ('Memphis', 'USA', 'Memphis International Airport'),
    ('Boston', 'USA', 'Logan International Airport'),
    ('Seattle', 'USA', 'Seattle-Tacoma International Airport'),
    ('Denver', 'USA', 'Denver International Airport'),
    ('Washington', 'USA', 'Washington Dulles International Airport'),
    ('Nashville', 'USA', 'Nashville International Airport'),
    ('Las Vegas', 'USA', 'McCarran International Airport'),
    ('Portland', 'USA', 'Portland International Airport'),
    ('Oklahoma City', 'USA', 'Will Rogers World Airport'),
    ('Albuquerque', 'USA', 'Albuquerque International Sunport'),
    ('Atlanta', 'USA', 'Hartsfield-Jackson Atlanta International Airport'),
    ('Long Beach', 'USA', 'Long Beach Airport'),
    ('Fresno', 'USA', 'Fresno Yosemite International Airport'),
    ('Sacramento', 'USA', 'Sacramento International Airport'),
    ('Mesa', 'USA', 'Phoenix-Mesa Gateway Airport'),
    ('Kansas City', 'USA', 'Kansas City International Airport'),
    ('New York', 'USA', 'John F. Kennedy International Airport'),
    ('Los Angeles', 'USA', 'Los Angeles International Airport'),
    ('Tokyo', 'Japan', 'Narita International Airport'),
    ('Osaka', 'Japan', 'Kansai International Airport'),
    ('Kyoto', 'Japan', 'Kansai International Airport'),
    ('Yokohama', 'Japan', 'Narisawa'),
    ('Nagoya', 'Japan', 'Chubu Centrair International Airport'),
    ('Sapporo', 'Japan', 'New Chitose Airport'),
    ('Fukuoka', 'Japan', 'Fukuoka Airport'),
    ('Kobe', 'Japan', 'Kansai International Airport'),
    ('Kawasaki', 'Japan', 'Narisawa'),
    ('Saitama', 'Japan', 'Narisawa'),
    ('Hiroshima', 'Japan', 'Hiroshima Airport'),
    ('Sendai', 'Japan', 'Sendai Airport'),
    ('Chiba', 'Japan', 'Narisawa'),
    ('Kitakyushu', 'Japan', 'Fukuoka Airport'),
    ('Sakai', 'Japan', 'Narisawa'),
    ('Beijing', 'China', 'Beijing Capital International Airport'),
    ('Shanghai', 'China', 'Shanghai Pudong International Airport'),
    ('Guangzhou', 'China', 'Guangzhou Baiyun International Airport'),
    ('Shenzhen', 'China', 'Shenzhen Bao''an International Airport'),
    ('Wuhan', 'China', 'Wuhan Tianhe International Airport'),
    ('Chengdu', 'China', 'Chengdu Shuangliu International Airport'),
    ('Tianjin', 'China', 'Tianjin Binhai International Airport'),
    ('Chongqing', 'China', 'Chongqing Jiangbei International Airport'),
    ('Nanjing', 'China', 'Nanjing Lukou International Airport'),
    ('Xi an', 'China', 'Xi''an Xianyang International Airport'),
    ('Hangzhou', 'China', 'Hangzhou Xiaoshan International Airport'),
    ('Harbin', 'China', 'Harbin Taiping International Airport'),
    ('Dalian', 'China', 'Dalian Zhoushuizi International Airport'),
    ('Shenyang', 'China', 'Shenyang Taoxian International Airport'),
    ('Jinan', 'China', 'Jinan Yaoqiang International Airport'),
    ('Qingdao', 'China', 'Qingdao Liuting International Airport'),
    ('Zhengzhou', 'China', 'Zhengzhou Xinzheng International Airport'),
    ('Changsha', 'China', 'Changsha Huanghua International Airport'),
    ('Kunming', 'China', 'Kunming Changshui International Airport'),
    ('Fuzhou', 'China', 'Fuzhou Changle International Airport'),
    ('Xiamen', 'China', 'Xiamen Gaoqi International Airport'),
    ('Nanning', 'China', 'Nanning Wuxu International Airport'),
    ('Hefei', 'China', 'Hefei Xinqiao International Airport'),
    ('Urumqi', 'China', 'Ürümqi Diwopu International Airport'),
    ('Changchun', 'China', 'Changchun Longjia International Airport'),
    ('Shijiazhuang', 'China', 'Shijiazhuang Zhengding International Airport'),
    ('Lanzhou', 'China', 'Lanzhou Zhongchuan International Airport'),
    ('Guiyang', 'China', 'Guiyang Longdongbao International Airport'),
    ('Nanchang', 'China', 'Nanchang Changbei International Airport'),
    ('Haikou', 'China', 'Haikou Meilan International Airport'),
    ('Taiyuan', 'China', 'Taiyuan Wusu International Airport'),
    ('Xining', 'China', 'Xining Caojiabao Airport'),
    ('Hohhot', 'China', 'Hohhot Baita International Airport'),
    ('Lhasa', 'China', 'Lhasa Gonggar Airport'),
    ('Hong Kong', 'China', 'Hong Kong International Airport'),
    ('Macao', 'China', 'Macau International Airport'),
    ('Sydney', 'Australia', 'Sydney Kingsford Smith International Airport'),
    ('Melbourne', 'Australia', 'Melbourne Airport'),
    ('Brisbane', 'Australia', 'Brisbane Airport'),
    ('Perth', 'Australia', 'Perth Airport'),
    ('Adelaide', 'Australia', 'Adelaide Airport'),
    ('Canberra', 'Australia', 'Canberra Airport'),
    ('Wellington', 'New Zealand', 'Wellington International Airport'),
    ('Auckland', 'New Zealand', 'Auckland Airport'),
    ('Christchurch', 'New Zealand', 'Christchurch International Airport'),
    ('Rio de Janeiro', 'Brazil', 'Rio de Janeiro-Galeão International Airport'),
    ('Cape Town', 'South Africa', 'Cape Town International Airport'),
    ('Mumbai', 'India', 'Chhatrapati Shivaji Maharaj International Airport'),
    ('Dubai', 'UAE', 'Dubai International Airport'),
    ('Moscow', 'Russia', 'Sheremetyevo International Airport'),
    ('Rome', 'Italy', 'Leonardo da Vinci-Fiumicino Airport'),
    ('Milan', 'Italy', 'Milan Malpensa Airport'),
    ('Venice', 'Italy', 'Venice Marco Polo Airport'),
    ('Athens', 'Greece', 'Athens International Airport'),
    ('Istanbul', 'Turkey', 'Istanbul Airport'),
    ('Cairo', 'Egypt', 'Cairo International Airport'),
    ('Nairobi', 'Kenya', 'Jomo Kenyatta International Airport'),
    ('Mexico City', 'Mexico', 'Mexico City International Airport'),
    ('Buenos Aires', 'Argentina', 'Ministro Pistarini International Airport'),
    ('Santiago', 'Chile', 'Comodoro Arturo Merino Benítez International Airport'),
    ('Lima', 'Peru', 'Jorge Chávez International Airport'),
    ('Bogota', 'Colombia', 'El Dorado International Airport'),
    ('Caracas', 'Venezuela', 'Simón Bolívar International Airport'),
    ('Havana', 'Cuba', 'José Martí International Airport')
;

INSERT INTO ROUTE (departure_city, departure_country, arrival_city, arrival_country) VALUES
    ('Montreal', 'Canada', 'Toronto', 'Canada'),
    ('Toronto', 'Canada', 'Montreal', 'Canada'),
    ('Montreal', 'Canada', 'Vancouver', 'Canada'),
    ('Vancouver', 'Canada', 'Montreal', 'Canada'),
    ('Montreal', 'Canada', 'Calgary', 'Canada'),
    ('Calgary', 'Canada', 'Montreal', 'Canada'),
    ('Montreal', 'Canada', 'Tokyo', 'Japan'),
    ('Tokyo', 'Japan', 'Montreal', 'Canada'),
    ('Vancouver', 'Canada', 'Tokyo', 'Japan'),
    ('Tokyo', 'Japan', 'Vancouver', 'Canada')
;
INSERT INTO Flights (flight_number, airline_policy, airline, airplane_model, 
economy_seats, premium_economy_seats, business_seats, first_class_seats, 
economy_cost, premium_economy_cost, business_cost, first_class_cost, 
departure_city, departure_country, arrival_city, arrival_country, 
departure_date_time, arrival_date_time, flight_duration) VALUES
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER', 
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-01 13:05:00', '2024-05-02 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER', 
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-02 13:05:00', '2024-05-03 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-03 13:05:00', '2024-05-04 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-04 13:05:00', '2024-05-05 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-05 13:05:00', '2024-05-06 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-06 13:05:00', '2024-05-07 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-07 13:05:00', '2024-05-08 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-08 13:05:00', '2024-05-09 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-09 13:05:00', '2024-05-10 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-10 13:05:00', '2024-05-11 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-11 13:05:00', '2024-05-12 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-12 13:05:00', '2024-05-13 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-13 13:05:00', '2024-05-14 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-14 13:05:00', '2024-05-15 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-15 13:05:00', '2024-05-16 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-16 13:05:00', '2024-05-17 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-17 13:05:00', '2024-05-18 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-18 13:05:00', '2024-05-19 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-19 13:05:00', '2024-05-20 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-20 13:05:00', '2024-05-21 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-21 13:05:00', '2024-05-22 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-22 13:05:00', '2024-05-23 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-23 13:05:00', '2024-05-24 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-24 13:05:00', '2024-05-25 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-25 13:05:00', '2024-05-26 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-26 13:05:00', '2024-05-27 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-27 13:05:00', '2024-05-28 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-28 13:05:00', '2024-05-29 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-29 13:05:00', '2024-05-30 16:40:00', '13:00'),
    ('AC005', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Montreal', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-30 13:05:00', '2024-05-31 16:40:00', '13:00'),
    ----------------------------------------------------------------------------------------------
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER', 
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-01 18:15:00', '2024-05-01 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER', 
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-02 18:15:00', '2024-05-02 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-03 18:15:00', '2024-05-03 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-04 18:15:00', '2024-05-04 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-05 18:15:00', '2024-05-05 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-06 18:15:00', '2024-05-06 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-07 18:15:00', '2024-05-07 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-08 18:15:00', '2024-05-08 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-09 18:15:00', '2024-05-09 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-10 18:15:00', '2024-05-10 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-11 18:15:00', '2024-05-11 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-12 18:15:00', '2024-05-12 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-13 18:15:00', '2024-05-13 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-14 18:15:00', '2024-05-14 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-15 18:15:00', '2024-05-15 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-16 18:15:00', '2024-05-16 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-17 18:15:00', '2024-05-17 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-18 18:15:00', '2024-05-18 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-19 18:15:00', '2024-05-19 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-20 18:15:00', '2024-05-20 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-21 18:15:00', '2024-05-21 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-22 18:15:00', '2024-05-22 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-23 18:15:00', '2024-05-23 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-24 18:15:00', '2024-05-24 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-25 18:15:00', '2024-05-25 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-26 18:15:00', '2024-05-26 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-27 18:15:00', '2024-05-27 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-28 18:15:00', '2024-05-28 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-29 18:15:00', '2024-05-29 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-30 18:15:00', '2024-05-30 16:35:00', '11:00'),
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-31 18:15:00', '2024-05-31 16:35:00', '11:00'),
    ----------------------------------------------------------------------------------------------
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-01 7:10:00', '2024-05-01 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-02 7:10:00', '2024-05-02 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-03 7:10:00', '2024-05-03 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-04 7:10:00', '2024-05-04 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-05 7:10:00', '2024-05-05 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-06 7:10:00', '2024-05-06 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-07 7:10:00', '2024-05-07 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-08 7:10:00', '2024-05-08 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-09 7:10:00', '2024-05-09 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-10 7:10:00', '2024-05-10 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-11 7:10:00', '2024-05-11 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-12 7:10:00', '2024-05-12 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-13 7:10:00', '2024-05-13 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-14 7:10:00', '2024-05-14 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-15 7:10:00', '2024-05-15 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-16 7:10:00', '2024-05-16 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-17 7:10:00', '2024-05-17 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-18 7:10:00', '2024-05-18 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-19 7:10:00', '2024-05-19 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-20 7:10:00', '2024-05-20 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-21 7:10:00', '2024-05-21 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-22 7:10:00', '2024-05-22 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-23 7:10:00', '2024-05-23 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-24 7:10:00', '2024-05-24 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-25 7:10:00', '2024-05-25 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-26 7:10:00', '2024-05-26 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-27 7:10:00', '2024-05-27 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-28 7:10:00', '2024-05-28 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-29 7:10:00', '2024-05-29 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-30 7:10:00', '2024-05-30 10:00:00', '5:00'),
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-31 7:10:00', '2024-05-31 10:00:00', '5:00'),
    ----------------------------------------------------------------------------------------------
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Vancouver', 'Canada', 'Montreal', 'Canada',
    '2024-05-01 11:30:00', '2024-05-01 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-02 11:30:00', '2024-05-02 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-03 11:30:00', '2024-05-03 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-04 11:30:00', '2024-05-04 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-05 11:30:00', '2024-05-05 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-06 11:30:00', '2024-05-06 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-07 11:30:00', '2024-05-07 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-08 11:30:00', '2024-05-08 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-09 11:30:00', '2024-05-09 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-10 11:30:00', '2024-05-10 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-11 11:30:00', '2024-05-11 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-12 11:30:00', '2024-05-12 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-13 11:30:00', '2024-05-13 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-14 11:30:00', '2024-05-14 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-15 11:30:00', '2024-05-15 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-16 11:30:00', '2024-05-16 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-17 11:30:00', '2024-05-17 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-18 11:30:00', '2024-05-18 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-19 11:30:00', '2024-05-19 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-20 11:30:00', '2024-05-20 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-21 11:30:00', '2024-05-21 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-22 11:30:00', '2024-05-22 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-23 11:30:00', '2024-05-23 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-24 11:30:00', '2024-05-24 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-25 11:30:00', '2024-05-25 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-26 11:30:00', '2024-05-26 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-27 11:30:00', '2024-05-27 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-28 11:30:00', '2024-05-28 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-29 11:30:00', '2024-05-29 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-30 11:30:00', '2024-05-30 19:19:00', '4:30'),
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',153, NULL, 16, NULL,300.00, NULL, 1000.00, NULL,'Vancouver', 'Canada', 'Montreal', 'Canada','2024-05-31 11:30:00', '2024-05-31 19:19:00', '4:30'),
    ----------------------------------------------------------------------------------------------
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',
    174, NULL, 16, NULL,
    120, NULL, 400.00, NULL,
    'Montreal', 'Canada', 'Toronto', 'Canada',
    '2024-05-01 9:10:00', '2024-05-01 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-02 9:10:00', '2024-05-02 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-03 9:10:00', '2024-05-03 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-04 9:10:00', '2024-05-04 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-05 9:10:00', '2024-05-05 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-06 9:10:00', '2024-05-06 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-07 9:10:00', '2024-05-07 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-08 9:10:00', '2024-05-08 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-09 9:10:00', '2024-05-09 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-10 9:10:00', '2024-05-10 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-11 9:10:00', '2024-05-11 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-12 9:10:00', '2024-05-12 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-13 9:10:00', '2024-05-13 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-14 9:10:00', '2024-05-14 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-15 9:10:00', '2024-05-15 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-16 9:10:00', '2024-05-16 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-17 9:10:00', '2024-05-17 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-18 9:10:00', '2024-05-18 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-19 9:10:00', '2024-05-19 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-20 9:10:00', '2024-05-20 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-21 9:10:00', '2024-05-21 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-22 9:10:00', '2024-05-22 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-23 9:10:00', '2024-05-23 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-24 9:10:00', '2024-05-24 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-25 9:10:00', '2024-05-25 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-26 9:10:00', '2024-05-26 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-27 9:10:00', '2024-05-27 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-28 9:10:00', '2024-05-28 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-29 9:10:00', '2024-05-29 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-30 9:10:00', '2024-05-30 10:46:00', '00:45'),
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-31 9:10:00', '2024-05-31 10:46:00', '00:45'),
    ----------------------------------------------------------------------------------------------
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',
    174, NULL, 16, NULL,
    120, NULL, 400.00, NULL,
    'Toronto', 'Canada', 'Montreal', 'Canada',
    '2024-05-01 10:00:00', '2024-05-01 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-02 10:00:00', '2024-05-02 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-03 10:00:00', '2024-05-03 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-04 10:00:00', '2024-05-04 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-05 10:00:00', '2024-05-05 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-06 10:00:00', '2024-05-06 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-07 10:00:00', '2024-05-07 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-08 10:00:00', '2024-05-08 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-09 10:00:00', '2024-05-09 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-10 10:00:00', '2024-05-10 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-11 10:00:00', '2024-05-11 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-12 10:00:00', '2024-05-12 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-13 10:00:00', '2024-05-13 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-14 10:00:00', '2024-05-14 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-15 10:00:00', '2024-05-15 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-16 10:00:00', '2024-05-16 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-17 10:00:00', '2024-05-17 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-18 10:00:00', '2024-05-18 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-19 10:00:00', '2024-05-19 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-20 10:00:00', '2024-05-20 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-21 10:00:00', '2024-05-21 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-22 10:00:00', '2024-05-22 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-23 10:00:00', '2024-05-23 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-24 10:00:00', '2024-05-24 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-25 10:00:00', '2024-05-25 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-26 10:00:00', '2024-05-26 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-27 10:00:00', '2024-05-27 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-28 10:00:00', '2024-05-28 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-29 10:00:00', '2024-05-29 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-30 10:00:00', '2024-05-30 11:16:00', '00:45'),
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',174, NULL, 16, NULL,120.00, NULL, 400.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-31 10:00:00', '2024-05-31 11:16:00', '00:45'),
    ----------------------------------------------------------------------------------------------
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',
    125, NULL, 12, NULL,
    150.00, NULL, 500.00, NULL,
    'Montreal', 'Canada', 'Toronto', 'Canada',
    '2024-05-01 13:10:00', '2024-05-01 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-02 13:10:00', '2024-05-02 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-03 13:10:00', '2024-05-03 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-04 13:10:00', '2024-05-04 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-05 13:10:00', '2024-05-05 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-06 13:10:00', '2024-05-06 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-07 13:10:00', '2024-05-07 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-08 13:10:00', '2024-05-08 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-09 13:10:00', '2024-05-09 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-10 13:10:00', '2024-05-10 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-11 13:10:00', '2024-05-11 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-12 13:10:00', '2024-05-12 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-13 13:10:00', '2024-05-13 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-14 13:10:00', '2024-05-14 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-15 13:10:00', '2024-05-15 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-16 13:10:00', '2024-05-16 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-17 13:10:00', '2024-05-17 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-18 13:10:00', '2024-05-18 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-19 13:10:00', '2024-05-19 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-20 13:10:00', '2024-05-20 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-21 13:10:00', '2024-05-21 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-22 13:10:00', '2024-05-22 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-23 13:10:00', '2024-05-23 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-24 13:10:00', '2024-05-24 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-25 13:10:00', '2024-05-25 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-26 13:10:00', '2024-05-26 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-27 13:10:00', '2024-05-27 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-28 13:10:00', '2024-05-28 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-29 13:10:00', '2024-05-29 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-30 13:10:00', '2024-05-30 14:46:00', '00:45'),
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Montreal', 'Canada', 'Toronto', 'Canada','2024-05-31 13:10:00', '2024-05-31 14:46:00', '00:45'),
    ----------------------------------------------------------------------------------------------
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',
    125, NULL, 12, NULL,
    150.00, NULL, 500.00, NULL,
    'Toronto', 'Canada', 'Montreal', 'Canada',
    '2024-05-01 14:00:00', '2024-05-01 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-02 14:00:00', '2024-05-02 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-03 14:00:00', '2024-05-03 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-04 14:00:00', '2024-05-04 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-05 14:00:00', '2024-05-05 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-06 14:00:00', '2024-05-06 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-07 14:00:00', '2024-05-07 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-08 14:00:00', '2024-05-08 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-09 14:00:00', '2024-05-09 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-10 14:00:00', '2024-05-10 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-11 14:00:00', '2024-05-11 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-12 14:00:00', '2024-05-12 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-13 14:00:00', '2024-05-13 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-14 14:00:00', '2024-05-14 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-15 14:00:00', '2024-05-15 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-16 14:00:00', '2024-05-16 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-17 14:00:00', '2024-05-17 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-18 14:00:00', '2024-05-18 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-19 14:00:00', '2024-05-19 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-20 14:00:00', '2024-05-20 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-21 14:00:00', '2024-05-21 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-22 14:00:00', '2024-05-22 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-23 14:00:00', '2024-05-23 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-24 14:00:00', '2024-05-24 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-25 14:00:00', '2024-05-25 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-26 14:00:00', '2024-05-26 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-27 14:00:00', '2024-05-27 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-28 14:00:00', '2024-05-28 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-29 14:00:00', '2024-05-29 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-30 14:00:00', '2024-05-30 15:20:00', '00:45'),
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',125, NULL, 12, NULL,150.00, NULL, 500.00, NULL,'Toronto', 'Canada', 'Montreal', 'Canada','2024-05-31 14:00:00', '2024-05-31 15:20:00', '00:45'),
    ----------------------------------------------------------------------------------------------
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER', 
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Vancouver', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-01 13:00:00', '2024-05-02 16:05:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-02 13:00:00', '2024-05-03 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-03 13:00:00', '2024-05-04 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-04 13:00:00', '2024-05-05 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-05 13:00:00', '2024-05-06 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-06 13:00:00', '2024-05-07 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-07 13:00:00', '2024-05-08 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-08 13:00:00', '2024-05-09 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-09 13:00:00', '2024-05-10 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-10 13:00:00', '2024-05-11 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-11 13:00:00', '2024-05-12 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-12 13:00:00', '2024-05-13 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-13 13:00:00', '2024-05-14 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-14 13:00:00', '2024-05-15 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-15 13:00:00', '2024-05-16 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-16 13:00:00', '2024-05-17 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-17 13:00:00', '2024-05-18 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-18 13:00:00', '2024-05-19 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-19 13:00:00', '2024-05-20 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-20 13:00:00', '2024-05-21 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-21 13:00:00', '2024-05-22 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-22 13:00:00', '2024-05-23 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-23 13:00:00', '2024-05-24 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-24 13:00:00', '2024-05-25 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-25 13:00:00', '2024-05-26 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-26 13:00:00', '2024-05-27 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-27 13:00:00', '2024-05-28 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-28 13:00:00', '2024-05-29 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-29 13:00:00', '2024-05-30 16:50:00', '11:30'),
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-30 13:00:00', '2024-05-31 16:50:00', '11:30'),
    ----------------------------------------------------------------------------------------------
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER', 
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Vancouver', 'Canada', 
    '2024-05-01 18:55:00', '2024-05-01 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-02 18:55:00', '2024-05-02 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-03 18:55:00', '2024-05-03 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-04 18:55:00', '2024-05-04 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-05 18:55:00', '2024-05-05 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-06 18:55:00', '2024-05-06 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-07 18:55:00', '2024-05-07 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-08 18:55:00', '2024-05-08 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-09 18:55:00', '2024-05-09 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-10 18:55:00', '2024-05-10 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-11 18:55:00', '2024-05-11 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-12 18:55:00', '2024-05-12 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-13 18:55:00', '2024-05-13 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-14 18:55:00', '2024-05-14 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-15 18:55:00', '2024-05-15 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-16 18:55:00', '2024-05-16 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-17 18:55:00', '2024-05-17 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-18 18:55:00', '2024-05-18 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-19 18:55:00', '2024-05-19 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-20 18:55:00', '2024-05-20 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-21 18:55:00', '2024-05-21 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-22 18:55:00', '2024-05-22 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-23 18:55:00', '2024-05-23 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-24 18:55:00', '2024-05-24 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-25 18:55:00', '2024-05-25 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-26 18:55:00', '2024-05-26 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-27 18:55:00', '2024-05-27 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-28 18:55:00', '2024-05-28 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-29 18:55:00', '2024-05-29 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-30 18:55:00', '2024-05-30 10:40:00', '11:30'),
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',236, 24, 40, NULL,900.00, 1200.00, 4000.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-31 18:55:00', '2024-05-31 10:40:00', '11:30'),
    ----------------------------------------------------------------------------------------------
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',
    146, 21, 48, NULL,
    1000.00, 1300.00, 4500.00, NULL,
    'Vancouver', 'Canada', 'Tokyo', 'Japan',
    '2024-05-01 15:15:00', '2024-05-02 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-02 15:15:00', '2024-05-03 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-03 15:15:00', '2024-05-04 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-04 15:15:00', '2024-05-05 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-05 15:15:00', '2024-05-06 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-06 15:15:00', '2024-05-07 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-07 15:15:00', '2024-05-08 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-08 15:15:00', '2024-05-09 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-09 15:15:00', '2024-05-10 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-10 15:15:00', '2024-05-11 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-11 15:15:00', '2024-05-12 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-12 15:15:00', '2024-05-13 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-13 15:15:00', '2024-05-14 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-14 15:15:00', '2024-05-15 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-15 15:15:00', '2024-05-16 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-16 15:15:00', '2024-05-17 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-17 15:15:00', '2024-05-18 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-18 15:15:00', '2024-05-19 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-19 15:15:00', '2024-05-20 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-20 15:15:00', '2024-05-21 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-21 15:15:00', '2024-05-22 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-22 15:15:00', '2024-05-23 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-23 15:15:00', '2024-05-24 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-24 15:15:00', '2024-05-25 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-25 15:15:00', '2024-05-26 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-26 15:15:00', '2024-05-27 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-27 15:15:00', '2024-05-28 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-28 15:15:00', '2024-05-29 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-29 15:15:00', '2024-05-30 18:45:00', '10:30'),
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Vancouver', 'Canada', 'Tokyo', 'Japan','2024-05-30 15:15:00', '2024-05-31 18:45:00', '10:30'),
    ----------------------------------------------------------------------------------------------
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',
    146, 21, 48, NULL,
    1000.00, 1300.00, 4500.00, NULL,
    'Tokyo', 'Japan', 'Vancouver', 'Canada',
    '2024-05-01 21:55:00', '2024-05-01 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-02 21:55:00', '2024-05-02 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-03 21:55:00', '2024-05-03 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-04 21:55:00', '2024-05-04 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-05 21:55:00', '2024-05-05 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-06 21:55:00', '2024-05-06 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-07 21:55:00', '2024-05-07 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-08 21:55:00', '2024-05-08 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-09 21:55:00', '2024-05-09 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-10 21:55:00', '2024-05-10 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-11 21:55:00', '2024-05-11 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-12 21:55:00', '2024-05-12 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-13 21:55:00', '2024-05-13 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-14 21:55:00', '2024-05-14 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-15 21:55:00', '2024-05-15 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-16 21:55:00', '2024-05-16 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-17 21:55:00', '2024-05-17 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-18 21:55:00', '2024-05-18 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-19 21:55:00', '2024-05-19 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-20 21:55:00', '2024-05-20 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-21 21:55:00', '2024-05-21 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-22 21:55:00', '2024-05-22 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-23 21:55:00', '2024-05-23 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-24 21:55:00', '2024-05-24 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-25 21:55:00', '2024-05-25 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-26 21:55:00', '2024-05-26 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-27 21:55:00', '2024-05-27 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-28 21:55:00', '2024-05-28 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-29 21:55:00', '2024-05-29 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-30 21:55:00', '2024-05-30 13:45:00', '10:30'),
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',146, 21, 48, NULL,1000.00, 1300.00, 4500.00, NULL,'Tokyo', 'Japan', 'Vancouver', 'Canada','2024-05-31 21:55:00', '2024-05-31 13:45:00', '10:30')
    ----------------------------------------------------------------------------------------------
;
INSERT INTO Car (car_license_plate, number_of_seats, car_rental_agency, transmission_type,
car_model, car_engine_type, car_daily_cost, city_name, country, company_policy, AC, carplay) VALUES
    ('ABC123', 5, 'Enterprise', 'Automatic', 'Toyota Corolla', 'Gasoline', 
    50.00, 'Montreal', 'Canada', 'No smoking, Pets allowed, Insurance included', 
    'Y', 'Y'),
    ('GRETA21', 2, 'Hertz', 'Automatic', 'Porshe GT3 RS', 'Gasoline',
    150.00, 'Montreal', 'Canada', 'No smoking, No pets, Insurance included',
    'Y', 'Y'),
    ('ZU21', 5, 'AVIS', 'Automatic', 'BMW X3', 'Gasoline',
    100.00, 'Montreal', 'Canada', 'No smoking, No pets, Insurance included',
    'Y', 'Y'),
    ('GRTZ', 5, 'AVIS', 'Automatic', 'Mercedes-Benz CLA250', 'Gasoline',
    100.00, 'Montreal', 'Canada', 'No smoking, No pets, Insurance included',
    'Y', 'Y'),
    ('GZ2003', 2, 'Hertz', 'Automatic', 'Ferrari SF90 Spider', 'Gasoline',
    400.00, 'Tokyo', 'Japan', 'No smoking, No pets, Insurance included',
    'Y', 'Y'),
    ('EMSBAI', 5, 'Enterprise', 'Automatic', 'Mercedes-Benz G-Class', 'Gasoline',
    150.00, 'Tokyo', 'Japan', 'No smoking, No pets, Insurance included',
    'Y', 'Y')
;
INSERT INTO Hotel (brand_affiliation, hotel_address, hotel_policy,
airport_shuttle, business_facilities, restaurants, listing_name,
fitness_center, on_site_parking, pet_allowance, pool, city_name, country) VALUES
    ('Hilton', '1234 Rue Sherbrooke Ouest', 
    'No smoking, Check-in time: 3:00 PM, Check-out time: 11:00 AM, Free cancellation',
    'Bi-hourly, 24/7', 'Workstations and printers available', 'French restaurant and bar on-site', 'Hilton Montreal Downtown',
    '24/7 Fitness center', 'On-site parking available: $40 per day', 'Y', 'Y', 'Montreal', 'Canada'),
    ('Marriott', '1234 Rue René-Lévesque Ouest',
    'No smoking, Check-in time: 3:00 PM, Check-out time: 11:00 AM, Free cancellation',
    'Twice daily', 'Workstations and printers available', 'Japanese restaurant and bar on-site', 'Marriott Montreal Downtown',
    '24/7 Fitness center', 'On-site parking available: $30 per day', 'Y', 'Y', 'Montreal', 'Canada'),
    ('Hilton', '1234 Yonge Street', 
    'No smoking, Check-in time: 3:00 PM, Check-out time: 11:00 AM, Free cancellation',
    'Bi-hourly, 24/7', 'Workstations and printers available', 'Pan-American restaurant', 'Hilton Toronto Downtown',
    '24/7 Fitness center', 'No on-site parking', 'Y', 'Y', 'Toronto', 'Canada'),
    ('Holiday Inn', '1234 Broadway Street',
    'No smoking, Check-in time: 3:00 PM, Check-out time: 11:00 AM, Free cancellation',
    'Twice daily', 'Workstations and printers available', 'Chinese restaurant', 'Holiday Inn Vancouver Downtown',
    '24/7 Fitness center', 'On-site parking available: $20 per day', 'Y', 'Y', 'Vancouver', 'Canada'),
    ('APA Hotel', '10-2 Nihonbashi-Kakigara-cho, Chuo-ku',
    'No smoking, Check-in time: 3:00 PM, Check-out time: 11:00 AM, Free cancellation',
    NULL, 'Printers available', 'Sushi restaurant on-site', 'APA Hotel Tokyo Nihonbashi',
    NULL, NULL, 'N', 'N', 'Tokyo', 'Japan')
;
INSERT INTO Room (hotel_address, brand_affiliation, room_number, room_name, room_capacity, beds, room_price, 
size, free_wifi, view, minibar, private_bathroom, smoking) VALUES
    ('1234 Rue Sherbrooke Ouest', 'Hilton', 101, 'Standard Room', 2, '1 Queen Bed', 150.00,
    '300 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue Sherbrooke Ouest', 'Hilton', 102, 'Standard Room', 2, '1 Queen Bed', 150.00,
    '300 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue Sherbrooke Ouest', 'Hilton', 103, 'Standard Room', 2, '1 Queen Bed', 150.00,
    '300 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue Sherbrooke Ouest', 'Hilton', 104, 'Standard Room', 2, '1 Queen Bed', 150.00,
    '300 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue Sherbrooke Ouest', 'Hilton', 105, 'Standard Room', 2, '1 Queen Bed', 150.00,
    '300 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue Sherbrooke Ouest', 'Hilton', 106, 'Family Room', 4, '2 Queen Bed', 250.00,
    '600 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue Sherbrooke Ouest', 'Hilton', 107, 'Family Room', 4, '2 Queen Bed', 250.00,
    '600 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue Sherbrooke Ouest', 'Hilton', 108, 'Family Room', 4, '2 Queen Bed', 250.00,
    '600 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue René-Lévesque Ouest', 'Marriott', 101, 'Standard Room', 2, '1 Queen Bed', 150.00,
    '300 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue René-Lévesque Ouest', 'Marriott', 102, 'Standard Room', 2, '1 Queen Bed', 150.00,
    '300 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue René-Lévesque Ouest', 'Marriott', 103, 'Standard Room', 2, '1 Queen Bed', 150.00,
    '300 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue René-Lévesque Ouest', 'Marriott', 104, 'Standard Room', 2, '1 Queen Bed', 150.00,
    '300 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue René-Lévesque Ouest', 'Marriott', 105, 'Standard Room', 2, '1 Queen Bed', 150.00,
    '300 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue René-Lévesque Ouest', 'Marriott', 106, 'Family Room', 4, '2 Queen Bed', 250.00,
    '600 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('1234 Rue René-Lévesque Ouest', 'Marriott', 107, 'Family Room', 4, '2 Queen Bed', 250.00,
    '600 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('10-2 Nihonbashi-Kakigara-cho, Chuo-ku', 'APA Hotel', 101, 'Single Room', 1, '1 Double Bed', 80.00,
    '200 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('10-2 Nihonbashi-Kakigara-cho, Chuo-ku', 'APA Hotel', 102, 'Single Room', 1, '1 Double Bed', 80.00,
    '200 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('10-2 Nihonbashi-Kakigara-cho, Chuo-ku', 'APA Hotel', 103, 'Single Room', 1, '1 Double Bed', 80.00,
    '200 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('10-2 Nihonbashi-Kakigara-cho, Chuo-ku', 'APA Hotel', 104, 'Single Room', 1, '1 Double Bed', 80.00,
    '200 sq ft', 'Y', 'City view', 'Y', 'Y', 'N'),
    ('10-2 Nihonbashi-Kakigara-cho, Chuo-ku', 'APA Hotel', 201, 'Double Room', 2, '2 Double Bed', 130.00,
    '400 sq ft', 'Y', 'City view', 'Y', 'Y', 'N')
    ;
    INSERT INTO FlightBooking (flight_reference_number, user_id, passenger_names, flight_number, departure_date_time,
    flight_total_cost, fare_class, seat_numbers, plane_ticket_cost, plane_ticket_surcharge, plane_ticket_tax, 
    flight_booking_fees, flight_booking_date) VALUES
        (1, 1, 'John Doe, Jane Doe', 'AC005', '2024-05-01 13:05:00',
        2220.00, 'Economy', 'A33, B33', 1800.00, 100.00, 270.00, 
        50.00, '2024-04-01'),
        (2, 3, 'John Smith', 'AC005', '2024-05-01 13:05:00',
        1110.00, 'Economy', 'A34', 900.00, 50.00, 135.00,
        25.00, '2024-04-01'),
        (3, 3, 'John Smith', 'AC006', '2024-05-21 18:15:00',
        1110.00, 'Economy', 'A34', 900.00, 50.00, 135.00,
        25.00, '2024-04-01'),
        (4, 4, 'Jane Smith', 'AC405', '2024-05-01 09:10:00',
        535.00, 'Business', 'A1', 400.00, 50.00, 60.00,
        25.00, '2024-04-02'),
        (5, 4, 'Jane Smith', 'AC406', '2024-05-21 10:00:00',
        535.00, 'Business', 'A1', 400.00, 50.00, 60.00,
        25.00, '2024-04-02')
    ;
    INSERT INTO HotelBooking (hotel_reference_number, user_id, room_number, brand_affiliation, hotel_address,
    checkin_date, checkout_date, hotel_total_cost, room_cost, hotel_tax, hotel_booking_fees, hotel_booking_date) VALUES
        (1, 1, 201, 'APA Hotel', '10-2 Nihonbashi-Kakigara-cho, Chuo-ku',
        '2024-05-02', '2024-05-21', 2727.00, 2470.00, 247.00, 10.00, '2024-04-01'),
        (2, 3, 101, 'APA Hotel', '10-2 Nihonbashi-Kakigara-cho, Chuo-ku',
        '2024-05-02', '2024-05-21', 1682.00, 1520.00, 152.00, 10.00, '2024-04-01'),
        (3, 3, 101, 'Hilton', '1234 Rue Sherbrooke Ouest',
        '2024-05-22', '2024-05-25', 527.50, 450.00, 67.50, 10.00, '2024-04-01'),
        (4, 4, 102, 'Hilton', '1234 Rue Sherbrooke Ouest',
        '2024-05-22', '2024-05-25', 527.50, 450.00, 67.50, 10.00, '2024-04-02'),
        (5, 4, 101, 'Marriott', '1234 Rue René-Lévesque Ouest',
        '2024-05-25', '2024-05-28', 527.50, 450.00, 67.50, 10.00, '2024-04-02')
    ;
    INSERT INTO CarRentalBooking (car_rental_reference_number, user_id, car_license_plate, pickup_location, return_location,
    pickup_date_time, return_date_time, car_rental_booking_date, car_rental_cost, car_rental_tax, car_rental_booking_fees,
    car_rental_total_cost, insurance) VALUES
        (1, 1, 'EMSBAI', 'Narita International Airport', 'Narita International Airport',
        '2024-05-02 18:00:00', '2024-05-21 10:00:00', '2024-04-01', 3000.00, 300.00, 10.00, 
        3310.00, 'Fully covered'),
        (2, 3, 'GZ2003', 'Narita International Airport', 'Narita International Airport',
        '2024-05-02 18:00:00', '2024-05-21 10:00:00', '2024-04-01', 8000.00, 800.00, 10.00,
        8810.00, 'Fully covered'),
        (3, 4, 'GRTZ', 'AVIS Downtown Montreal', 'AVIS Downtown Montreal',
        '2024-05-01 10:00:00', '2024-05-22 10:00:00', '2024-04-02', 2200.00, 315.00, 10.00,
        2425.00, 'Fully covered'),
        (4, 4, 'ZU21', 'AVIS Downtown Montreal', 'AVIS Downtown Montreal',
        '2024-05-22 10:00:00', '2024-05-25 10:00:00', '2024-04-02', 400.00, 60.00, 10.00,
        470.00, 'Fully covered'),
        (5, 4, 'GRETA21', 'Hertz Peel', 'Hertz Peel',
        '2024-05-25 10:00:00', '2024-05-28 10:00:00', '2024-04-02', 600.00, 90.00, 10.00,
        700.00, 'Fully covered')
    ;

-- write a query using the select-from-where construct of SQL. The queries should be typical queries of the application domain.
-- query should exhibit some advanced features: queries over at least three tables, aggregation together with group by over at least two tables, using WITH, subqueries, combination of set and join operators, etc.



-- 1. Find the total cost of all the bookings made by user 4
SELECT 
    FlightBooking.user_id, 
    SUM(FlightBooking.flight_total_cost) AS flight_total_cost, 
    SUM(HotelBooking.hotel_total_cost) AS hotel_total_cost, 
    SUM(CarRentalBooking.car_rental_total_cost) AS car_rental_total_cost
FROM 
    FlightBooking
JOIN 
    HotelBooking ON FlightBooking.user_id = HotelBooking.user_id
JOIN 
    CarRentalBooking ON FlightBooking.user_id = CarRentalBooking.user_id
WHERE 
    FlightBooking.user_id = 4
GROUP BY 
    FlightBooking.user_id;

-- find all bookings made by user 4, only show the user_id and the total costs
SELECT 
    COALESCE(flight.user_id, hotel.user_id, car.user_id) AS user_id,
    flight.flight_total_cost AS flight_total_cost,
    hotel.hotel_total_cost AS hotel_total_cost,
    car.car_rental_total_cost AS car_rental_total_cost
FROM
    (SELECT 
        user_id,
        SUM(flight_total_cost) AS flight_total_cost
    FROM 
        FlightBooking
    WHERE 
        user_id = 4
    GROUP BY 
        user_id) AS flight
FULL OUTER JOIN
    (SELECT 
        user_id,
        SUM(hotel_total_cost) AS hotel_total_cost
    FROM 
        HotelBooking
    WHERE 
        user_id = 4
    GROUP BY 
        user_id) AS hotel ON flight.user_id = hotel.user_id
FULL OUTER JOIN
    (SELECT 
        user_id,
        SUM(car_rental_total_cost) AS car_rental_total_cost
    FROM 
        CarRentalBooking
    WHERE 
        user_id = 4
    GROUP BY 
        user_id) AS car ON flight.user_id = car.user_id;

-- Find the number of economy seats remaining on the flight from Montreal to Tokyo on May 1 2024 using FlightBooking
SELECT
    F.flight_number,
    F.economy_seats - COUNT(CASE WHEN FB.fare_class = 'Economy' THEN 1 ELSE NULL END) AS remaining_economy_seats
FROM
    Flights F
    JOIN FlightBooking FB ON F.flight_number = FB.flight_number
WHERE
    F.departure_city = 'Montreal' AND F.arrival_city = 'Tokyo' AND F.departure_date_time = '2024-05-01 13:05:00'
GROUP BY
    F.flight_number, F.economy_seats;

    -- list all users taking a flight from Montreal to Tokyo on May 1 2024
SELECT
    U.user_id,
    U.name,
    FB.flight_number,
    FB.departure_date_time
FROM
    Users U
    JOIN FlightBooking FB ON U.user_id = FB.user_id
    JOIN Flights F ON FB.flight_number = F.flight_number
WHERE
    F.departure_city = 'Montreal' AND F.arrival_city = 'Tokyo' AND F.departure_date_time = '2024-05-01 13:05:00';


-- interesting query using WITH
-- list all users who have a round trip flight with their costs
WITH round_trip_flights AS (
    SELECT
        FB.user_id,
        FB.flight_reference_number,
        FB.flight_number,
        FB.departure_date_time,
        FB.flight_total_cost
    FROM
        FlightBooking FB
    JOIN Flights F ON FB.flight_number = F.flight_number
    WHERE
        F.departure_city = 'Montreal' AND F.arrival_city = 'Tokyo' 
    UNION
    SELECT
        FB.user_id,
        FB.flight_reference_number,
        FB.flight_number,
        FB.departure_date_time,
        FB.flight_total_cost
    FROM
        FlightBooking FB
    JOIN Flights F ON FB.flight_number = F.flight_number
    WHERE
        F.departure_city = 'Tokyo' AND F.arrival_city = 'Montreal' 
)
SELECT
    U.user_id,
    U.name,
    RTF.flight_reference_number,
    RTF.flight_number,
    RTF.departure_date_time,
    RTF.flight_total_cost
FROM
    Users U
    JOIN round_trip_flights RTF ON U.user_id = RTF.user_id;




SELECT u.user_id, u.name, u.email, u.phone_number
FROM Users u
WHERE EXISTS (
    SELECT 1 FROM FlightBooking fb1
    JOIN FlightBooking fb2 ON fb1.user_id = fb2.user_id
    JOIN Flights f1 ON fb1.flight_number = f1.flight_number
    JOIN Flights f2 ON fb2.flight_number = f2.flight_number
    WHERE fb1.user_id = u.user_id
    AND fb1.departure_date_time < fb2.departure_date_time
    AND fb1.flight_reference_number != fb2.flight_reference_number
    AND f1.arrival_city = f2.departure_city
    AND f2.arrival_city = f1.departure_city
);


-- find the average cost of a user's booking, flight, hotel, and car rental using WITH
WITH user_booking_costs AS (
    SELECT
        user_id,
        AVG(flight_total_cost) AS avg_flight_cost,
        AVG(hotel_total_cost) AS avg_hotel_cost,
        AVG(car_rental_total_cost) AS avg_car_rental_cost
    FROM
        (
            SELECT
                user_id,
                flight_total_cost,
                NULL AS hotel_total_cost,
                NULL AS car_rental_total_cost
            FROM
                FlightBooking
            UNION ALL
            SELECT
                user_id,
                NULL AS flight_total_cost,
                hotel_total_cost,
                NULL AS car_rental_total_cost
            FROM
                HotelBooking
            UNION ALL
            SELECT
                user_id,
                NULL AS flight_total_cost,
                NULL AS hotel_total_cost,
                car_rental_total_cost
            FROM
                CarRentalBooking
        ) AS all_bookings
    GROUP BY
        user_id
)
SELECT
    UBC.user_id,
    UBC.avg_flight_cost,
    UBC.avg_hotel_cost,
    UBC.avg_car_rental_cost
FROM
    user_booking_costs UBC
JOIN Users U ON UBC.user_id = U.user_id;


-- find the average cost of hotel rooms that have been booked in Tokyo using subqueries
SELECT AVG(R.room_price) AS avg_room_price
FROM HotelBooking HB
JOIN Room R ON HB.room_number = R.room_number AND HB.hotel_address = R.hotel_address
WHERE HB.hotel_address IN (
    SELECT hotel_address FROM Hotel WHERE city_name = 'Tokyo'
);

-- find the average cost of hotel rooms from APA Hotel that have been booked using subqueries
SELECT AVG(R.room_price) AS avg_room_price
FROM HotelBooking HB
JOIN Room R ON HB.room_number = R.room_number AND HB.hotel_address = R.hotel_address
WHERE HB.hotel_address IN (
    SELECT hotel_address FROM Hotel WHERE brand_affiliation = 'APA Hotel'
);


-- find the average cost for flights from Vancouver to Tokyo for economy seats using subqueries
SELECT AVG(FB.flight_total_cost) AS avg_flight_cost
FROM FlightBooking FB
JOIN Flights F ON FB.flight_number = F.flight_number
WHERE F.departure_city = 'Vancouver' AND F.arrival_city = 'Tokyo' AND FB.fare_class = 'Economy';



-- find the average cost of all flight bookings made by users who are flying from Montreal to Tokyo using subqueries
SELECT AVG(flight_total_cost) AS avg_flight_cost
FROM FlightBooking
WHERE user_id IN (
    SELECT user_id FROM FlightBooking
    JOIN Flights ON FlightBooking.flight_number = Flights.flight_number
    WHERE Flights.departure_city = 'Montreal' AND Flights.arrival_city = 'Tokyo'
);


-- find the average cost of all car rentals made by users who are renting cars from each location using subqueries
SELECT AVG(car_rental_total_cost) AS avg_car_rental_cost
FROM CarRentalBooking
WHERE user_id IN (
    SELECT user_id FROM CarRentalBooking
    JOIN Car ON CarRentalBooking.car_license_plate = Car.car_license_plate
    WHERE Car.city_name = 'Montreal'
);


-- List all cities that have a flight going there from Montreal with hotels and car rentals offered
SELECT DISTINCT f.arrival_city
FROM Flights f
WHERE f.departure_city = 'Montreal'
AND f.arrival_city IN (SELECT h.city_name FROM Hotel h)
AND f.arrival_city IN (SELECT c.city_name FROM Car c);


--The first view represents the contact information of all users irrespective of registration, including both email and phone number. It pulls its information solely from the Users table and has a simple constraint where the user is also a registered user. 
CREATE VIEW contact_information AS
SELECT user_id, name, email, phone_number
FROM Users
WHERE user_id IN (SELECT user_id FROM Registered);



-- The second view represents the a view of the statistics of total bookings for each flight, as well as their respective departure and arrival cities.
-- generate a view that shows the total number of bookings for each flight, as well as the departure and arrival cities of the flight.
CREATE VIEW FlightTotalBookings AS
SELECT flight_number, COUNT(flight_reference_number) AS total_bookings
FROM FlightBooking
GROUP BY flight_number;


CREATE VIEW Flight_stats AS
SELECT 
    FB.flight_number, 
    F.departure_city, 
    F.arrival_city, 
    COUNT(FB.flight_reference_number) AS total_bookings
FROM 
    FlightBooking FB
JOIN 
    Flights F ON FB.flight_number = F.flight_number
GROUP BY 
    FB.flight_number, F.departure_city, F.arrival_city;


-- create a view that shows the total amount of bookings for flights, hotels and car rentals for each city
CREATE VIEW CityTotalBookings AS
SELECT 
    F.departure_city AS city_name, 
    COUNT(DISTINCT FB.flight_reference_number) AS total_flight_bookings,
    COUNT(DISTINCT HB.hotel_reference_number) AS total_hotel_bookings,
    COUNT(DISTINCT CRB.car_rental_reference_number) AS total_car_rental_bookings
FROM 
    Flights F
LEFT JOIN 
    FlightBooking FB ON F.flight_number = FB.flight_number
LEFT JOIN 
    HotelBooking HB ON F.departure_city = HB.hotel_address
LEFT JOIN 
    CarRentalBooking CRB ON F.departure_city = CRB.pickup_location
GROUP BY 
    F.departure_city;


-- create a view that shows the total amount of bookings for flights, hotels and car rentals for each city
-- find each city, find the total amount of bookings for flights arriving at that city, the total amount of bookings for hotels in that city, and the total amount of bookings for car rentals bring picked up in that city
CREATE VIEW CityTotalBookings AS
SELECT 
    F.arrival_city AS city_name, 
    COUNT(DISTINCT FB.flight_reference_number) AS total_flight_bookings,
    COUNT(DISTINCT HB.hotel_reference_number) AS total_hotel_bookings,
    COUNT(DISTINCT CRB.car_rental_reference_number) AS total_car_rental_bookings
FROM
    Flights F
LEFT JOIN
    FlightBooking FB ON F.flight_number = FB.flight_number
LEFT JOIN
    HotelBooking HB ON F.arrival_city = HB.hotel_address
LEFT JOIN
    CarRentalBooking CRB ON F.arrival_city = CRB.pickup_location
GROUP BY
    F.arrival_city;



--Create a view that shows the total cost of each booking for each user.
CREATE VIEW TotalCost AS
SELECT user_id, flight_reference_number, flight_total_cost AS total_cost
FROM FlightBooking
UNION
SELECT user_id, hotel_reference_number, hotel_total_cost AS total_cost
FROM HotelBooking
UNION
SELECT user_id, car_rental_reference_number, car_rental_total_cost AS total_cost
FROM CarRentalBooking
ORDER BY user_id;