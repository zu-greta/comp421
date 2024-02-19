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
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone_number VARCHAR(22) NOT NULL,
    address VARCHAR(200) NOT NULL,
    credit_card_information VARCHAR(20) NOT NULL,
    PRIMARY KEY (user_id)
);
CREATE TABLE Registered (
    user_id INT NOT NULL,
    username VARCHAR(150) UNIQUE NOT NULL, ------------------------------------------------------------add
    password VARCHAR(10) NOT NULL,
    language CHAR(2) DEFAULT 'no' NOT NULL, -- modified from p1
    --history CLOB, -------------------------------------------------------------------------------------drop?
    PRIMARY KEY (user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
CREATE TABLE Cities (
    city_name VARCHAR(85) NOT NULL,
    country VARCHAR(50) NOT NULL,
    PRIMARY KEY (city_name, country)
);
CREATE TABLE DepartureCity( 
    departure_city VARCHAR(85) NOT NULL,
    departure_country VARCHAR(50) NOT NULL,
    airport_departure_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (departure_city, departure_country),
    FOREIGN KEY (departure_city, departure_country) REFERENCES Cities(city_name, country)
);
CREATE TABLE ArrivalCity( 
    arrival_city VARCHAR(85) NOT NULL,
    arrival_country VARCHAR(50) NOT NULL,
    airport_arrival_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (arrival_city, arrival_country),
    FOREIGN KEY (arrival_city, arrival_country) REFERENCES Cities(city_name, country)
);
CREATE TABLE Flights ( 
    flight_number VARCHAR(7) NOT NULL,
    airline_policy CLOB NOT NULL,
    airline VARCHAR(30) NOT NULL,
    airplane_model VARCHAR(50) NOT NULL,
    economy_seats VARCHAR(3500) NOT NULL,
    premium_economy_seats VARCHAR(3500),
    business_seats VARCHAR(3500),
    first_class_seats VARCHAR(3500),
    economy_cost DECIMAL(6, 2) NOT NULL,
    premium_economy_cost DECIMAL(6, 2),
    business_cost DECIMAL(7, 2),
    first_class_cost DECIMAL(7, 2),
    departure_city VARCHAR(85) NOT NULL,
    departure_country VARCHAR(50) NOT NULL,
    arrival_city VARCHAR(85) NOT NULL,
    arrival_country VARCHAR(50) NOT NULL,
    departure_date_time DATETIME NOT NULL,
    arrival_date_time DATETIME NOT NULL,
    flight_duration TIME NOT NULL,
    PRIMARY KEY (flight_number, departure_date_time),
    FOREIGN KEY (departure_city, departure_country) REFERENCES DepartureCity(departure_city, departure_country),
    FOREIGN KEY (arrival_city, arrival_country) REFERENCES ArrivalCity(arrival_city, arrival_country)
);
CREATE TABLE Car (
    car_license_plate VARCHAR(10) NOT NULL,
    number_of_seats INT NOT NULL,
    car_rental_agency VARCHAR(25) NOT NULL,
    transmission_type VARCHAR(15) NOT NULL,
    car_model VARCHAR(50) NOT NULL,
    car_engine_type VARCHAR(10) NOT NULL,
    car_daily_cost DECIMAL(5, 2) NOT NULL, -- changed from p1
    city_name VARCHAR(85) NOT NULL,
    country VARCHAR(50) NOT NULL,
    company_policy CLOB NOT NULL, 
    AC CHAR(1) NOT NULL, -- changed from p1
    carplay VARCHAR(50),
    PRIMARY KEY (car_license_plate),
    FOREIGN KEY (city_name, country) REFERENCES Cities(city_name, country)
);
CREATE TABLE Route ( 
    departure_city VARCHAR(85) NOT NULL,
    departure_country VARCHAR(50) NOT NULL,
    arrival_city VARCHAR(85) NOT NULL,
    arrival_country VARCHAR(50) NOT NULL,
    PRIMARY KEY (departure_city, departure_country, arrival_city, arrival_country),
    FOREIGN KEY (departure_city, departure_country) REFERENCES DepartureCity(departure_city, departure_country),
    FOREIGN KEY (arrival_city, arrival_country) REFERENCES ArrivalCity(arrival_city, arrival_country)
);
CREATE TABLE Hotel ( 
    brand_affiliation VARCHAR(50) NOT NULL,
    hotel_address VARCHAR(200) NOT NULL,
    hotel_policy CLOB NOT NULL, 
    airport_shuttle VARCHAR(50),
    business_facilities VARCHAR(50),
    restaurants VARCHAR(100),
    listing_name VARCHAR(50) NOT NULL,
    fitness_center VARCHAR(50),
    on_site_parking VARCHAR(50),
    pet_allowance VARCHAR(50),
    pool VARCHAR(50),
    city_name VARCHAR(85) NOT NULL,
    country VARCHAR(50) NOT NULL,
    PRIMARY KEY (brand_affiliation, hotel_address), 
    FOREIGN KEY (city_name, country) REFERENCES Cities(city_name, country)
);
CREATE TABLE Room ( 
    hotel_address VARCHAR(200) NOT NULL,
    brand_affiliation VARCHAR(50) NOT NULL,
    room_number INT NOT NULL,
    room_name VARCHAR(50) NOT NULL,
    -- availability removed from p1
    room_capacity INT NOT NULL,
    beds VARCHAR(50) NOT NULL,
    room_price DECIMAL(6, 2) NOT NULL,
    size DECIMAL(8, 2) NOT NULL, -- changed from p1
    free_wifi CHAR(1) NOT NULL, -- changed from p1
    view VARCHAR(25) NOT NULL, -- changed from p1
    minibar CHAR(1) NOT NULL, -- changed from p1
    private_bathroom CHAR(1) NOT NULL, -- changed from p1
    smoking CHAR(1) NOT NULL, -- changed from p1
    PRIMARY KEY (hotel_address, brand_affiliation, room_number),
    FOREIGN KEY (brand_affiliation, hotel_address) REFERENCES Hotel(brand_affiliation, hotel_address)
);
CREATE TABLE FlightBooking ( 
    flight_reference_number INT NOT NULL,
    user_id INT NOT NULL,
    passenger_names VARCHAR(600) NOT NULL,
    flight_number VARCHAR(7) NOT NULL,
    departure_date_time DATETIME NOT NULL,
    flight_total_cost DECIMAL(9, 2) NOT NULL,
    fare_class CHAR(5) NOT NULL,
    seat_numbers VARCHAR(18) NOT NULL,
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
    brand_affiliation VARCHAR(50) NOT NULL,
    hotel_address VARCHAR(200) NOT NULL,
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL,
    breakfast_inclusion VARCHAR(20) NOT NULL,   
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
    pickup_location VARCHAR(200) NOT NULL,
    return_location VARCHAR(200) NOT NULL,
    pickup_date_time DATETIME NOT NULL,
    return_date_time DATETIME NOT NULL,
    car_rental_booking_date DATE NOT NULL,
    car_rental_cost DECIMAL(5, 2) NOT NULL,
    car_rental_tax DECIMAL(4, 2) NOT NULL,
    car_rental_booking_fees DECIMAL(4, 2) NOT NULL,
    car_rental_total_cost DECIMAL(7, 2) NOT NULL,
    insurance CLOB NOT NULL, 
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
    (5, 'jj', '3333')
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
    ----------------------------------------------------------------------------------------------
    ('AC006', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER', 
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Montreal', 'Canada', 
    '2024-05-01 18:15:00', '2024-05-01 16:35:00', '11:00'),
    ----------------------------------------------------------------------------------------------
    ('AC301', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Montreal', 'Canada', 'Vancouver', 'Canada',
    '2024-05-01 7:10:00', '2024-05-01 10:00:00', '5:00'),
    ----------------------------------------------------------------------------------------------
    ('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',
    153, NULL, 16, NULL,
    300.00, NULL, 1000.00, NULL,
    'Vancouver', 'Canada', 'Montreal', 'Canada',
    '2024-05-01 11:30:00', '2024-05-01 19:19:00', '4:30'),
    ----------------------------------------------------------------------------------------------
    ('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',
    174, NULL, 16, NULL,
    120, NULL, 400.00, NULL,
    'Montreal', 'Canada', 'Toronto', 'Canada',
    '2024-05-01 9:10:00', '2024-05-01 10:46:00', '00:45'),
    ----------------------------------------------------------------------------------------------
    ('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',
    174, NULL, 16, NULL,
    120, NULL, 400.00, NULL,
    'Toronto', 'Canada', 'Montreal', 'Canada',
    '2024-05-01 10:00:00', '2024-05-01 11:16:00', '00:45'),
    ----------------------------------------------------------------------------------------------
    ('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',
    125, NULL, 12, NULL,
    150.00, NULL, 500.00, NULL,
    'Montreal', 'Canada', 'Toronto', 'Canada',
    '2024-05-01 13:10:00', '2024-05-01 14:46:00', '00:45'),
    ----------------------------------------------------------------------------------------------
    ('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',
    125, NULL, 12, NULL,
    150.00, NULL, 500.00, NULL,
    'Toronto', 'Canada', 'Montreal', 'Canada',
    '2024-05-01 14:00:00', '2024-05-01 15:20:00', '00:45'),
    ----------------------------------------------------------------------------------------------
    ('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER', 
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Vancouver', 'Canada', 'Tokyo', 'Japan', 
    '2024-05-01 13:00:00', '2024-05-02 16:05:00', '11:30'),
    ----------------------------------------------------------------------------------------------
    ('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER', 
    236, 24, 40, NULL, 
    900.00, 1200.00, 4000.00, NULL,
    'Tokyo', 'Japan', 'Vancouver', 'Canada', 
    '2024-05-01 18:55:00', '2024-05-01 10:40:00', '11:30'),
    ----------------------------------------------------------------------------------------------
    ('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',
    146, 21, 48, NULL,
    1000.00, 1300.00, 4500.00, NULL,
    'Vancouver', 'Canada', 'Tokyo', 'Japan',
    '2024-05-01 15:15:00', '2024-05-02 18:45:00', '10:30'),
    ----------------------------------------------------------------------------------------------
    ('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',
    146, 21, 48, NULL,
    1000.00, 1300.00, 4500.00, NULL,
    'Tokyo', 'Japan', 'Vancouver', 'Canada',
    '2024-05-01 21:55:00', '2024-05-01 13:45:00', '10:30')
    ----------------------------------------------------------------------------------------------
;
