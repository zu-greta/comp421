//package p3; //remove when submitting

import java.sql.* ;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import javax.lang.model.type.NullType;

import java.util.Random;

class jj //find better name
{
    public static void main ( String [ ] args ) throws SQLException
    {
      // Unique table names.  Either the user supplies a unique identifier as a command line argument, or the program makes one up.
        String tableName = "";
        int sqlCode=0;      // Variable to hold SQLCODE
        String sqlState="00000";  // Variable to hold SQLSTATE

        if ( args.length > 0 )
            tableName += args [ 0 ] ;
        else
          tableName += "exampletbl";

        // Register the driver.  You must register the driver before you can use it.
        try { DriverManager.registerDriver ( new com.ibm.db2.jcc.DB2Driver() ) ; }
        catch (Exception cnfe){ System.out.println("Class not found"); }

        // This is the url you must use for DB2.
        //Note: This url may not valid now ! Check for the correct year and semester and server name.
        String url = "jdbc:db2://winter2024-comp421.cs.mcgill.ca:50000/comp421";

        //REMEMBER to remove your user id and password before submitting your code!!
        String your_userid = "cs421g118";
        String your_password = "PassPass_118";
        //AS AN ALTERNATIVE, you can just set your password in the shell environment in the Unix (as shown below) and read it from there.
        //$  export SOCSPASSWD=yoursocspasswd 
        if(your_userid == null && (your_userid = System.getenv("SOCSUSER")) == null)
        {
          System.err.println("Error!! do not have a password to connect to the database!");
          System.exit(1);
        }
        if(your_password == null && (your_password = System.getenv("SOCSPASSWD")) == null)
        {
          System.err.println("Error!! do not have a password to connect to the database!");
          System.exit(1);
        }
        Connection con = DriverManager.getConnection (url,your_userid,your_password) ;
        Statement statement = con.createStatement ( ) ;

        //main program
        try (Scanner scanner0 = new Scanner(System.in)) {
            boolean run = true;
            while(run) {
                System.out.println("\nBookings Main Menu: ");
                System.out.println("    1. Find all booking total costs for a given user"); //query
                System.out.println("    2. Add a new booking for a user"); //choose type (fight, hotel, car) //get info //query for options //book (create booking and insert) 
                System.out.println("    3. Update a registered user's profile information"); //query for user //update
                System.out.println("    4. Flight Cancellation (for admins only)"); //query for flight bookings //query for next available flight //update bookings for all users //delete flight 
                System.out.println("    5. Find all bookings for a given user (booking history)"); //query
                System.out.println("    6. Quit");
                System.out.print("Please Enter Your Option Number: ");

                if (!scanner0.hasNextInt()) {
                    System.out.println("Invalid option. Please try again.");
                    scanner0.next();
                    continue;
                }
                else {
                    int option = scanner0.nextInt();
                    switch (option) {
                        case 1: //change THIS
                            bookingTotalCosts(statement);
                            break;
                        case 2:
                            newBooking(con, statement, scanner0);
                            break;
                        case 3:
                            updateData(con, statement, scanner0);
                            break;
                        case 4:
                            deleteData(statement, scanner0);
                            break;
                        case 5: //add THIS
                            userHistory(statement);
                            break;
                        case 6:
                            run = false;
                            break;
                        default:
                            System.out.println("Invalid option. Please try again.");
                            break;
                    }
                }
            }
        } 
        catch (SQLException e) {
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE

            // Your code to handle errors comes here;
            // something more meaningful than a print would be good
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
        }
        statement.close ( ) ;
        con.close ( ) ;
    }
    

    // Method to query data
    static void bookingTotalCosts(Statement statement) throws SQLException {
        // Taking user input for user id
        boolean flag = true;
        while (flag) {
            // Taking user input for user id
            System.out.print("Enter the user id: ");
            int userId = Integer.parseInt(System.console().readLine());
            //check if user exists
            ResultSet resultSet = statement.executeQuery("SELECT user_id FROM Users WHERE user_id = " + userId);
            if (!resultSet.next()) {
                System.out.println("User does not exist. Please try again.");
                continue;
            }
            else {
                flag = false;
                String query = "SELECT COALESCE(flight.user_id, hotel.user_id, car.user_id) AS user_id, flight.flight_total_cost AS flight_total_cost, " +
                "hotel.hotel_total_cost AS hotel_total_cost, car.car_rental_total_cost AS car_rental_total_cost FROM (SELECT user_id, " +
                "SUM(flight_total_cost) AS flight_total_cost FROM FlightBooking WHERE user_id = " + userId + " GROUP BY user_id) AS flight " +
                "FULL OUTER JOIN (SELECT user_id, SUM(hotel_total_cost) AS hotel_total_cost FROM HotelBooking WHERE user_id = " + userId + 
                " GROUP BY user_id) AS hotel ON flight.user_id = hotel.user_id FULL OUTER JOIN (SELECT user_id, " +
                "SUM(car_rental_total_cost) AS car_rental_total_cost FROM CarRentalBooking WHERE user_id = " + userId + " GROUP BY " +
                "user_id) AS car ON flight.user_id = car.user_id";

                ResultSet resultSet2 = statement.executeQuery(query);

                System.out.println("+------------+-------------------+------------------+-----------------------+");
                System.out.println("| User ID    | Flight Total Cost | Hotel Total Cost | Car Rental Total Cost |");
                System.out.println("+------------+-------------------+------------------+-----------------------+");
                // Process and display query results
                while (resultSet2.next()) {
                    int resultUserId = resultSet2.getInt("user_id");
                    double flightTotalCost = resultSet2.getDouble("flight_total_cost");
                    double hotelTotalCost = resultSet2.getDouble("hotel_total_cost");
                    double carRentalTotalCost = resultSet2.getDouble("car_rental_total_cost");
                    System.out.printf("| %-10d | %-17.2f | %-16.2f | %-21.2f |\n", resultUserId, flightTotalCost, hotelTotalCost, carRentalTotalCost);
                }
                System.out.println("+------------+-------------------+------------------+-----------------------+");
                resultSet2.close();
            }
            resultSet.close();
        }   
    }

    // Method to insert data
    //choose type (fight, hotel, car) //get info //query for options //book (create booking and insert) - either registered user or create a temp user
    static void newBooking(Connection con, Statement statement, Scanner scanner) throws SQLException {
        try {
            boolean flag2 = false;
            int option = 0;
            int booking = 0;
            int userID = 0;
                while(!flag2) {
                    // get user info
                    // user or registered
                    System.out.println("Are you a registered user?");
                    System.out.println("    1. Yes");
                    System.out.println("    2. No");
                    System.out.print("Please Enter Your Option Number: ");
                    if (!scanner.hasNextInt()) {
                        System.out.println("Invalid option. Please try again.");
                        scanner.next();
                        continue;
                    }
                    else {
                        option = scanner.nextInt();
                    }
                    switch (option) {
                        case 1:
                            // Registered user
                            // Get user info from user: username, password
                            // Taking user input for username and password
                            scanner.nextLine(); // Consume the newline character
                            while (true) {
                                System.out.print("Enter the username: ");
                                String userName = scanner.nextLine();
                                if (userName.length() > 10) {
                                    System.out.println("Username is too long. Please try again.");
                                    continue;
                                }
                                 //check if user exists
                                //using prepared statemtne to prevent injection attacks
                                String userQuery = "SELECT username FROM Registered WHERE username = ?"; 
                                try (PreparedStatement userPrepStatement = con.prepareStatement(userQuery)) {
                                    userPrepStatement.setString(1, userName);
                                    try (ResultSet resultSet = userPrepStatement.executeQuery()) {
                                        if (!resultSet.next()) {
                                            System.out.println("User does not exist or is not registered. Please try again.");
                                            continue;
                                        }
                                        else {
                                            //check password
                                            boolean goodpass = false;
                                            String password = "";
                                            for (int i = 0; i < 3; i++) {
                                                System.out.print("Enter the password: ");
                                                password = scanner.nextLine();
                                                if (password.length() > 10) {
                                                    System.out.println("Password is too long. Please try again.");
                                                    i--;
                                                    continue;
                                                }
                                                String passQuery = "SELECT password FROM Registered WHERE username = ? AND password = ?";
                                                try (PreparedStatement passPrepStatement = con.prepareStatement(passQuery)) {
                                                    passPrepStatement.setString(1, userName);
                                                    passPrepStatement.setString(2, password);
                                                    try (ResultSet resultSet2 = passPrepStatement.executeQuery()) {
                                                        if (!resultSet2.next()) {
                                                            System.out.println("Password is incorrect. Please try again.");
                                                            continue;
                                                        }
                                                        else {
                                                            goodpass = true;
                                                            break;
                                                        }
                                                    }
                                                }
                                            }
                                            if (!goodpass) {
                                                System.out.println("You have entered the wrong password too many times. Please try again later.");
                                                return;
                                            }
                                            // Query for user_id using the given username and password
                                            userID = 0;
                                            String userQuery2 = "SELECT user_id FROM Registered WHERE username = ? AND password = ?";
                                            try (PreparedStatement userPrepStatement2 = con.prepareStatement(userQuery2)) {
                                                userPrepStatement2.setString(1, userName);
                                                userPrepStatement2.setString(2, password);
                                                try (ResultSet resultSet3 = userPrepStatement2.executeQuery()) {
                                                    while (resultSet3.next()) {
                                                        userID = resultSet3.getInt("user_id");
                                                    }
                                                }
                                            }
                                            // Get user input for booking type
                                            booking = bookanything(con, statement, userID, scanner);
                                            flag2 = true;
                                            break;
                                        }
                                    }
                                }                        
                            }
                            break;
                        case 2:
                            // New user
                            // Get user info from user: name, email, phone number, address, credit card information, language
                            scanner.nextLine(); // Consume the newline character
                            System.out.println("Create a new user: ");
                            String name="";
                            while(true) {
                                // get user input for name
                                System.out.print("Enter your name: ");
                                name = scanner.nextLine();
                                if (name.length() > 25) {
                                    System.out.println("Name is too long. Please try again.");
                                    continue;
                                }
                                else {
                                    break;
                                }
                            }
                            String email="";
                            while(true) {
                                // get user input for email
                                System.out.print("Enter your email: ");
                                email = scanner.nextLine();
                                if (email.length() > 40) {
                                    System.out.println("Email is too long. Please try again.");
                                    continue;
                                }
                                else {
                                    break;
                                }
                            }
                            String phoneNumber="";
                            while(true) {
                                // get user input for phone number
                                System.out.print("Enter your phone number: ");
                                phoneNumber = scanner.nextLine();
                                if (phoneNumber.length() > 22) {
                                    System.out.println("Phone number is too long. Please try again.");
                                    continue;
                                }
                                else {
                                    break;
                                }
                            }
                            String address="";
                            while(true) {
                                // get user input for address
                                System.out.print("Enter your address: ");
                                address = scanner.nextLine();
                                if (address.length() > 50) {
                                    System.out.println("Address is too long. Please try again.");
                                    continue;
                                }
                                else {
                                    break;
                                }
                            }
                            String creditCardInfo="";
                            while (true) {
                                // get user input for credit card information
                                System.out.print("Enter your credit card information: ");
                                creditCardInfo = scanner.nextLine();
                                if (creditCardInfo.length() > 36) {
                                    System.out.println("Credit card information is too long. Please try again.");
                                    continue;
                                }
                                else {
                                    break;
                                }
                            }
                            // create a unique user_id
                            ResultSet rs = statement.executeQuery("SELECT MAX(user_id) FROM Users");
                            rs.next();
                            userID = rs.getInt(1) + 1;
                            // Insert into Users table
                            String insertUserQuery = "INSERT INTO Users VALUES (?, ?, ?, ?, ?, ?)";
                            try (PreparedStatement insertUserPrepStatement = con.prepareStatement(insertUserQuery)) {
                                insertUserPrepStatement.setInt(1, userID);
                                insertUserPrepStatement.setString(2, name);
                                insertUserPrepStatement.setString(3, email);
                                insertUserPrepStatement.setString(4, phoneNumber);
                                insertUserPrepStatement.setString(5, address);
                                insertUserPrepStatement.setString(6, creditCardInfo);
                                insertUserPrepStatement.executeUpdate();
                            }
                            // Get user info from user: booking type
                            booking = bookanything(con, statement, userID, scanner);
                            flag2 = true;
                            break;
                        default:
                            System.out.println("Invalid option. Please try again.");
                            break;
                    }
                }
                if (flag2) {
                    // Query for booking info
                    String bookingQuery = ""; 
                    switch (booking) {
                        case 1:
                            bookingQuery = "SELECT * FROM FlightBooking WHERE user_id = ?";
                            try (PreparedStatement bookingPrepStatement = con.prepareStatement(bookingQuery)) {
                                bookingPrepStatement.setInt(1, userID);
                                // Process and display query results
                                ResultSet resultSet = bookingPrepStatement.executeQuery();
                                while (resultSet.next()){
                                    // print booking info formatted into a table
                                    int flightReferenceNumber = resultSet.getInt("flight_reference_number");
                                    int user_id = resultSet.getInt("user_id");
                                    String passengerNames = resultSet.getString("passenger_names");
                                    String flightNumber = resultSet.getString("flight_number");
                                    String departureDateTime = resultSet.getString("departure_date_time");
                                    double flightTotalCost = resultSet.getDouble("flight_total_cost");
                                    String fareClass = resultSet.getString("fare_class");
                                    String seatNumbers = resultSet.getString("seat_numbers");
                                    double planeTicketCost = resultSet.getDouble("plane_ticket_cost");
                                    double planeTicketSurcharge = resultSet.getDouble("plane_ticket_surcharge");
                                    double planeTicketTax = resultSet.getDouble("plane_ticket_tax");
                                    double flightBookingFees = resultSet.getDouble("flight_booking_fees");
                                    String flightBookingDate = resultSet.getString("flight_booking_date");
                                    System.out.println("+----------------------+----------------------+----------------------+----------------------+-----------------------+----------------------+----------------------+----------------------+----------------------+-----------------------+-----------------------+---------------------+---------------------+");
                                    System.out.println("| Flight Reference No. | User ID              | Passenger Names      | Flight Number        | Departure Date Time   | Flight Total Cost    | Fare Class           | Seat Numbers         | Plane Ticket Cost    | Plane Ticket Surcharge| Plane Ticket Tax      | Flight Booking Fees | Flight Booking Date |");
                                    System.out.println("+----------------------+----------------------+----------------------+----------------------+-----------------------+----------------------+----------------------+----------------------+----------------------+-----------------------+-----------------------+---------------------+---------------------+");
                                    System.out.printf("| %-20d | %-20d | %-20s | %-20s | %-20s | %-20.2f | %-20s | %-20s | %-20.2f | %-21.2f | %-21.2f | %-19.2f | %-19s |\n", flightReferenceNumber, user_id, passengerNames, flightNumber, departureDateTime, flightTotalCost, fareClass, seatNumbers, planeTicketCost, planeTicketSurcharge, planeTicketTax, flightBookingFees, flightBookingDate);
                                }
                                System.out.println("+----------------------+----------------------+----------------------+----------------------+-----------------------+----------------------+----------------------+----------------------+----------------------+-----------------------+-----------------------+---------------------+---------------------+");
                                // Print booking success message
                                System.out.println("Booking successful");
                            }
                            break;
                        case 2:
                            bookingQuery = "SELECT * FROM HotelBooking WHERE user_id = ?";
                            try (PreparedStatement bookingPrepStatement = con.prepareStatement(bookingQuery)) {
                                bookingPrepStatement.setInt(1, userID);
                                // Process and display query results
                                ResultSet resultSet = bookingPrepStatement.executeQuery();
                                while (resultSet.next()){
                                    // print booking info formatted into a table
                                    int hotelReferenceNumber = resultSet.getInt("hotel_reference_number");
                                    int user_id = resultSet.getInt("user_id");
                                    int roomNumber = resultSet.getInt("room_number");
                                    String brandAffiliation = resultSet.getString("brand_affiliation");
                                    String hotelAddress = resultSet.getString("hotel_address");
                                    String checkinDate = resultSet.getString("checkin_date");
                                    String checkoutDate = resultSet.getString("checkout_date");
                                    double hotelTotalCost = resultSet.getDouble("hotel_total_cost");
                                    double roomCost = resultSet.getDouble("room_cost");
                                    double hotelTax = resultSet.getDouble("hotel_tax");
                                    double hotelBookingFees = resultSet.getDouble("hotel_booking_fees");
                                    String hotelBookingDate = resultSet.getString("hotel_booking_date");
                                    System.out.println("+----------------------+----------------------+----------------------+----------------------+------------------------------------------+----------------------+----------------------+----------------------+----------------------+----------------------+-----------------------+---------------------+");
                                    System.out.println("| Hotel Reference No.  | User ID              | Room Number          | Brand Affiliation    | Hotel Address                            | Checkin Date         | Checkout Date        | Hotel Total Cost     | Room Cost            | Hotel Tax            | Hotel Booking Fees    | Hotel Booking Date  |");
                                    System.out.println("+----------------------+----------------------+----------------------+----------------------+------------------------------------------+----------------------+----------------------+----------------------+----------------------+----------------------+-----------------------+---------------------+");
                                    System.out.printf("| %-20d | %-20d | %-20d | %-20s | %-40s | %-20s | %-20s | %-20.2f | %-20.2f | %-20.2f | %-21.2f | %-19s |\n", hotelReferenceNumber, user_id, roomNumber, brandAffiliation, hotelAddress, checkinDate, checkoutDate, hotelTotalCost, roomCost, hotelTax, hotelBookingFees, hotelBookingDate);
                                }
                                System.out.println("+----------------------+----------------------+----------------------+----------------------+------------------------------------------+----------------------+----------------------+----------------------+----------------------+----------------------+-----------------------+---------------------+");
                                // Print booking success message
                                System.out.println("Booking successful");
                            }
                            break;
                        case 3:
                            bookingQuery = "SELECT * FROM CarRentalBooking WHERE user_id = ?";
                            try (PreparedStatement bookingPrepStatement = con.prepareStatement(bookingQuery)) {
                                bookingPrepStatement.setInt(1, userID);
                                // Process and display query results
                                ResultSet resultSet = bookingPrepStatement.executeQuery();
                                while (resultSet.next()){
                                    // print booking info formatted into a table
                                    int carRentalReferenceNumber = resultSet.getInt("car_rental_reference_number");
                                    int user_id = resultSet.getInt("user_id");
                                    String carLicensePlate = resultSet.getString("car_license_plate");
                                    String pickupLocation = resultSet.getString("pickup_location");
                                    String returnLocation = resultSet.getString("return_location");
                                    String pickupDateTime = resultSet.getString("pickup_date_time");
                                    String returnDateTime = resultSet.getString("return_date_time");
                                    String carRentalBookingDate = resultSet.getString("car_rental_booking_date");
                                    double carRentalCost = resultSet.getDouble("car_rental_cost");
                                    double carRentalTax = resultSet.getDouble("car_rental_tax");
                                    double carRentalBookingFees = resultSet.getDouble("car_rental_booking_fees");
                                    double carRentalTotalCost = resultSet.getDouble("car_rental_total_cost");
                                    String insurance = resultSet.getString("insurance");
                                    System.out.println("+--------------------------+------------+----------------------+--------------------------------+--------------------------------+-----------------------+-----------------------+-------------------------+----------------------+----------------------+-------------------------+-----------------------+----------------------------------------------+");
                                    System.out.println("| Car Rental Reference No. | User ID    | Car License Plate    | Pickup Location                | Return Location                | Pickup Date Time      | Return Date Time      | Car Rental Booking Date | Car Rental Cost      | Car Rental Tax       | Car Rental Booking Fees | Car Rental Total Cost | Insurance                                    |");
                                    System.out.println("+--------------------------+------------+----------------------+--------------------------------+--------------------------------+-----------------------+-----------------------+-------------------------+----------------------+----------------------+-------------------------+-----------------------+----------------------------------------------+");
                                    System.out.printf("| %-24d | %-10d | %-20s | %-30s | %-30s | %-21s | %-21s | %-23s | %-20.2f | %-20.2f | %-23.2f | %-21.2f | %-44s |\n", carRentalReferenceNumber, user_id, carLicensePlate, pickupLocation, returnLocation, pickupDateTime, returnDateTime, carRentalBookingDate, carRentalCost, carRentalTax, carRentalBookingFees, carRentalTotalCost, insurance);
                                }
                                System.out.println("+--------------------------+------------+----------------------+--------------------------------+--------------------------------+-----------------------+-----------------------+-------------------------+----------------------+----------------------+-------------------------+-----------------------+----------------------------------------------+");
                                // Print booking success message
                                System.out.println("Booking successful");
                            }
                            break;
                    }
                } 
        }
        catch (SQLException e) {
            e.printStackTrace(); 
        }
    }
    //helper to book
    static int bookanything(Connection con, Statement statement, int userID, Scanner scanner) throws SQLException {
        // Get user input for booking type
        while(true) {
            // Taking user input for booking type
            System.out.println("Choose the booking type: ");
            System.out.println("    1. Flight");
            System.out.println("    2. Hotel");
            System.out.println("    3. Car Rental");
            System.out.print("Please Enter Your Option Number: ");
            if (!scanner.hasNextInt()) {
                System.out.println("Invalid option. Please try again.");
                scanner.next();
                continue;
            }
            int bookingType = scanner.nextInt();
            String fareClass = "";
            int year = 0;
            int month = 0;
            int day = 0;
            int ryear = 0;
            int rmonth = 0;
            int rday = 0;
            String departureCity ="";
            String departureCountry = "";
            String arrivalCity = "";
            String arrivalCountry = "";
            String airline = "";
            String date = "";
            String rdate = "";
            String flightQuery = "";
            String fare="";
            String returnCity = "";
            String pickupCity = "";
            String pickupCountry = "";
            String car_license_plate = "";
            double car_daily_cost = 0;
            String car_rental_agency = "";
            String insurance = "";
            switch (bookingType) {
                case 1:
                    // Flight booking
                    // Get flight info from user: departure date, airline, fare class, departure city and country, arrival city and country
                    while(true){
                        //select a year
                        System.out.println("Choose the year: ");
                        System.out.println("    2024");
                        System.out.print("Please Enter Your Option Number: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        year = scanner.nextInt();
                        if (year != 2024) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        //select a month
                        System.out.println("Choose the month: ");
                        System.out.println("    1. January");
                        System.out.println("    2. February");
                        System.out.println("    3. March");
                        System.out.println("    4. April");
                        System.out.println("    5. May");
                        System.out.println("    6. June");
                        System.out.println("    7. July");
                        System.out.println("    8. August");
                        System.out.println("    9. September");
                        System.out.println("    10. October");
                        System.out.println("    11. November");
                        System.out.println("    12. December");
                        System.out.print("Please Enter Your Option Number: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        month = scanner.nextInt();
                        if (month < 1 || month > 12) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        //select a day
                        System.out.print("Choose the day: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        day = scanner.nextInt();
                        if (day < 1 || day > 31) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        String dday = "";
                        if (day >= 1 && day <= 9) {
                            //add a 0 in front of the day
                            dday = "0" + day;
                        }
                        else {
                            dday = "" + day;
                        }
                        String mmonth = "";
                        if (month >= 1 && month <= 9) {
                            //add a 0 in front of the month
                            mmonth = "0" + month;
                        }
                        else {
                            mmonth = "" + month;
                        }
                        //check if there are flights on that day using the database
                        date = year + "-" + mmonth + "-" + dday;
                        String dateQuery = "SELECT departure_date_time FROM Flights WHERE DATE(departure_date_time) = ?";
                        try (PreparedStatement datePrepStatement = con.prepareStatement(dateQuery)) {
                            datePrepStatement.setString(1, date);
                            try (ResultSet resultSet = datePrepStatement.executeQuery()) {
                                if (!resultSet.next()) {
                                    System.out.println("There are no flights on that day. Please try again.");
                                    continue;
                                }
                            }
                        }
                        //select a departure city
                        scanner.nextLine(); // Consume the newline character
                        boolean flag8 = true;
                        while(flag8) {
                            //fetch cities and country from database (flights table)
                            String cityQuery = "SELECT DISTINCT departure_city, departure_country FROM Flights WHERE DATE(departure_date_time) = ?";
                            try (PreparedStatement cityPrepStatement = con.prepareStatement(cityQuery)) {
                                cityPrepStatement.setString(1, date);
                                try (ResultSet resultSet = cityPrepStatement.executeQuery()) {
                                    List<String> cities = new ArrayList<>();
                                    List<String> countries = new ArrayList<>();
                                    while (resultSet.next()) {
                                        cities.add(resultSet.getString("departure_city"));
                                        countries.add(resultSet.getString("departure_country"));
                                    }
                                    System.out.println("Choose the departure city: ");
                                    for (int i = 0; i < cities.size(); i++) {
                                        System.out.println("    " + (i+1) + ". " + cities.get(i) + ", " + countries.get(i));
                                    }
                                    System.out.print("Please Enter Your Option Number: ");
                                    if (!scanner.hasNextInt()) {
                                        System.out.println("Invalid option. Please try again.");
                                        scanner.next();
                                        continue;
                                    }
                                    int departureCityOption = scanner.nextInt();
                                    if (departureCityOption < 1 || departureCityOption > cities.size()) {
                                        System.out.println("Invalid option. Please try again.");
                                        continue;
                                    }
                                    departureCity = cities.get(departureCityOption-1);
                                    departureCountry = countries.get(departureCityOption-1);
                                    flag8 = false;
                                    boolean flag7 = true;
                                    while(flag7) {
                                        //select an arrival city
                                        //fetch cities and country from database (flights table)
                                        String cityQuery2 = "SELECT DISTINCT arrival_city, arrival_country FROM Flights WHERE departure_city = ? AND departure_country = ? AND DATE(departure_date_time) = ?";
                                        try (PreparedStatement cityPrepStatement2 = con.prepareStatement(cityQuery2)) {
                                            cityPrepStatement2.setString(1, departureCity);
                                            cityPrepStatement2.setString(2, departureCountry);
                                            cityPrepStatement2.setString(3, date);
                                            try (ResultSet resultSet2 = cityPrepStatement2.executeQuery()) {
                                                List<String> arrivalCities = new ArrayList<>();
                                                List<String> arrivalCountries = new ArrayList<>();
                                                while (resultSet2.next()) {
                                                    arrivalCities.add(resultSet2.getString("arrival_city"));
                                                    arrivalCountries.add(resultSet2.getString("arrival_country"));
                                                }
                                                System.out.println("Choose the arrival city: ");
                                                for (int i = 0; i < arrivalCities.size(); i++) {
                                                    System.out.println("    " + (i+1) + ". " + arrivalCities.get(i) + ", " + arrivalCountries.get(i));
                                                }
                                                System.out.print("Please Enter Your Option Number: ");
                                                if (!scanner.hasNextInt()) {
                                                    System.out.println("Invalid option. Please try again.");
                                                    scanner.next();
                                                    continue;
                                                }
                                                int arrivalCityOption = scanner.nextInt();
                                                if (arrivalCityOption < 1 || arrivalCityOption > arrivalCities.size()) {
                                                    System.out.println("Invalid option. Please try again.");
                                                    continue;
                                                }
                                                flag7 = false;
                                                arrivalCity = arrivalCities.get(arrivalCityOption-1);
                                                arrivalCountry = arrivalCountries.get(arrivalCityOption-1);
                                                boolean flag5 = true;
                                                while(flag5) {
                                                    //select an airline
                                                    //fetch airlines from database (flights table)
                                                    String airlineQuery = "SELECT DISTINCT airline FROM Flights WHERE departure_city = ? AND departure_country = ? AND arrival_city = ? AND arrival_country = ? AND DATE(departure_date_time) = ?";
                                                    try (PreparedStatement airlinePrepStatement = con.prepareStatement(airlineQuery)) {
                                                        airlinePrepStatement.setString(1, departureCity);
                                                        airlinePrepStatement.setString(2, departureCountry);
                                                        airlinePrepStatement.setString(3, arrivalCity);
                                                        airlinePrepStatement.setString(4, arrivalCountry);
                                                        airlinePrepStatement.setString(5, date);
                                                        try (ResultSet resultSet3 = airlinePrepStatement.executeQuery()) {
                                                            List<String> airlines = new ArrayList<>();
                                                            while (resultSet3.next()) {
                                                                airlines.add(resultSet3.getString("airline"));
                                                            }
                                                            System.out.println("Choose the airline: ");
                                                            for (int i = 0; i < airlines.size(); i++) {
                                                                System.out.println("    " + (i+1) + ". " + airlines.get(i));
                                                            }
                                                            System.out.print("Please Enter Your Option Number: ");
                                                            if (!scanner.hasNextInt()) {
                                                                System.out.println("Invalid option. Please try again.");
                                                                scanner.next();
                                                                continue;
                                                            }
                                                            int airlineOption = scanner.nextInt();
                                                            if (airlineOption < 1 || airlineOption > airlines.size()) {
                                                                System.out.println("Invalid option. Please try again.");
                                                                continue;
                                                            }
                                                            airline = airlines.get(airlineOption-1);
                                                            flag5 = false;
                                                            boolean flag4 = true;
                                                            while(flag4) {
                                                                //select a fare class options: Economy, Business, First Class, Premium Economy
                                                                //submenu to choose from
                                                                System.out.println("Choose the fare class: ");
                                                                System.out.println("    1. Economy");
                                                                System.out.println("    2. Business");
                                                                System.out.println("    3. First Class");
                                                                System.out.println("    4. Premium Economy");
                                                                System.out.print("Please Enter Your Option Number: ");
                                                                if (!scanner.hasNextInt()) {
                                                                    System.out.println("Invalid option. Please try again.");
                                                                    scanner.next();
                                                                    continue;
                                                                }
                                                                int fareClassOption = scanner.nextInt();
                                                                if (fareClassOption < 1 || fareClassOption > 4) {
                                                                    System.out.println("Invalid option. Please try again.");
                                                                    continue;
                                                                }
                                                                String fareseats = "";
                                                                switch (fareClassOption) {
                                                                    case 1:
                                                                        fareClass = "Economy";
                                                                        fareseats = "economy_seats";
                                                                        flightQuery = "SELECT flight_number, departure_date_time, economy_cost FROM Flights WHERE departure_city = ? AND departure_country = ? AND arrival_city = ? AND arrival_country = ? AND airline = ? AND economy_seats > 0 AND DATE(departure_date_time) = ?";
                                                                        fare = "economy_cost";
                                                                        break;
                                                                    case 2:
                                                                        fareClass = "Business";
                                                                        fareseats = "business_seats";
                                                                        flightQuery = "SELECT flight_number, departure_date_time, business_cost FROM Flights WHERE departure_city = ? AND departure_country = ? AND arrival_city = ? AND arrival_country = ? AND airline = ? AND business_seats > 0 AND DATE(departure_date_time) = ?";
                                                                        fare = "business_cost";
                                                                        break;
                                                                    case 3:
                                                                        fareClass = "First Class";
                                                                        fareseats = "first_class_seats";
                                                                        flightQuery = "SELECT flight_number, departure_date_time, first_class_cost FROM Flights WHERE departure_city = ? AND departure_country = ? AND arrival_city = ? AND arrival_country = ? AND airline = ? AND first_class_seats > 0 AND DATE(departure_date_time) = ?";
                                                                        fare = "first_class_cost";
                                                                        break;
                                                                    case 4:
                                                                        fareClass = "Premium Economy";
                                                                        fareseats = "premium_economy_seats";
                                                                        flightQuery = "SELECT flight_number, departure_date_time, premium_economy_cost FROM Flights WHERE departure_city = ? AND departure_country = ? AND arrival_city = ? AND arrival_country = ? AND airline = ? AND premium_economy_seats > 0 AND DATE(departure_date_time) = ?";
                                                                        fare = "premium_economy_cost";
                                                                        break;
                                                                }
                                                                //check if seats available for that fare class
                                                                String seatsQuery = "SELECT " + fareseats + " FROM Flights WHERE departure_city = ? AND departure_country = ? AND arrival_city = ? AND arrival_country = ? AND airline = ? AND DATE(departure_date_time) = ?";
                                                                try (PreparedStatement seatsPrepStatement = con.prepareStatement(seatsQuery)) {
                                                                    seatsPrepStatement.setString(1, departureCity);
                                                                    seatsPrepStatement.setString(2, departureCountry);
                                                                    seatsPrepStatement.setString(3, arrivalCity);
                                                                    seatsPrepStatement.setString(4, arrivalCountry);
                                                                    seatsPrepStatement.setString(5, airline);
                                                                    seatsPrepStatement.setString(6, date);
                                                                    try (ResultSet resultSet4 = seatsPrepStatement.executeQuery()) {
                                                                        while (resultSet4.next()) {
                                                                            int seats = resultSet4.getInt(fareseats);
                                                                            if (resultSet4.wasNull() || seats <= 0) {
                                                                                flag4 = true;
                                                                                continue;
                                                                            }
                                                                            else {
                                                                                flag4 = false;
                                                                                break;
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                if (flag4) {
                                                                    System.out.println("There are no available seats for that fare class. Please try again.");
                                                                    continue;
                                                                }
                                                            }
                                                        } 
                                                    } 
                                                } 
                                            }
                                        }
                                    } 
                                }
                            } 
                        } break;                                                 
                    }
                    boolean flag3 = true;
                    while(flag3) {
                        // Query for flight options using the given info
                        // Display flight options as a sub menu to choose from
                        try (PreparedStatement flightPrepStatement = con.prepareStatement(flightQuery)) {
                            flightPrepStatement.setString(1, departureCity);
                            flightPrepStatement.setString(2, departureCountry);
                            flightPrepStatement.setString(3, arrivalCity);
                            flightPrepStatement.setString(4, arrivalCountry);
                            flightPrepStatement.setString(5, airline);
                            flightPrepStatement.setString(6, date);
                            // Process and display query results as a list
                            try (ResultSet resultSet = flightPrepStatement.executeQuery()) {
                                List<String> flightNumbers = new ArrayList<>();
                                List<String> departureDateTimes = new ArrayList<>();
                                List<Double> flightCosts = new ArrayList<>();
                                System.out.println("+---------+----------------------+-------------------------+-----------------------+");
                                System.out.println("| Opt. nu.| Flight Number        | Departure Date Time     | Flight Cost           |");
                                System.out.println("+---------+----------------------+-------------------------+-----------------------+");
                                int i = 0;
                                while (resultSet.next()) {
                                    i++; // Increment the counter
                                    String flightNumber = resultSet.getString("flight_number");
                                    String departureDateTime = resultSet.getString("departure_date_time");
                                    double flightcost = 0.0;
                                    switch (fare) {
                                        case "economy_cost":
                                            flightcost = resultSet.getDouble("economy_cost");
                                            break;
                                        case "business_cost":
                                            flightcost = resultSet.getDouble("business_cost");
                                            break;
                                        case "first_class_cost":
                                            flightcost = resultSet.getDouble("first_class_cost");
                                            break;
                                        case "premium_economy_cost":
                                            flightcost = resultSet.getDouble("premium_economy_cost");
                                            break;
                                    }
                                    flightNumbers.add(flightNumber);
                                    departureDateTimes.add(departureDateTime);
                                    flightCosts.add(flightcost);
                                    System.out.printf("| %-7s | %-20s | %-23s | %-21.2f |\n", i, flightNumber, departureDateTime, flightcost);
                                }
                                System.out.println("+---------+----------------------+-------------------------+-----------------------+");
                                // Get user input for flight option
                                System.out.print("Please Enter Your Option Number: ");
                                if (!scanner.hasNextInt()) {
                                    System.out.println("Invalid option. Please try again.");
                                    scanner.next();
                                    continue;
                                }
                                int flightOption = scanner.nextInt();
                                if (flightOption < 1 || flightOption > flightNumbers.size()) {
                                    System.out.println("Invalid option. Please try again.");
                                    continue;
                                }
                                flag3 = false;
                                // Book flight by getting user input for booking info (user ID, passenger names) 
                                //passenger names
                                scanner.nextLine(); // Consume the newline character
                                System.out.print("Enter the passenger names (format: name, name2...): ");
                                String passengerNames = scanner.nextLine();
                                if (passengerNames.length() > 150) {
                                    System.out.println("Passenger names are too long. Please try again.");
                                    continue;
                                }
                                // and other info from the flight selected (flight number, departure date time, flight cost given fare class), 
                                String flight_number = flightNumbers.get(flightOption-1);
                                String departure_date_time = departureDateTimes.get(flightOption-1);
                                double flight_ticket_cost = flightCosts.get(flightOption-1);
                                // calculate costs (flight total cost, plane ticket cost, plane ticket surcharge, plane ticket tax, flight booking fees, flight booking date),
                                double plane_ticket_surcharge = 0.05 * flight_ticket_cost;
                                double plane_ticket_tax = 0.15 * flight_ticket_cost;
                                double flight_booking_fees = 15;
                                double flight_total_cost = flight_ticket_cost + plane_ticket_surcharge + plane_ticket_tax + flight_booking_fees;
                                String flight_booking_date = java.time.LocalDate.now().toString();
                                // and generate a flight reference number, 
                                ResultSet flightRefNumber = statement.executeQuery("SELECT MAX(flight_reference_number) FROM FlightBooking");
                                flightRefNumber.next();
                                int flightReferenceNumber = flightRefNumber.getInt(1) + 1;
                                // and insert into FlightBooking table
                                String insertFlightQuery = "INSERT INTO FlightBooking VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
                                Random rand = new Random();
                                int seatnum = rand.nextInt(60);
                                ArrayList<String> seats = new ArrayList<>();
                                seats.add("A");
                                seats.add("B");
                                seats.add("C");
                                seats.add("D");
                                seats.add("E");
                                seats.add("F");
                                seats.add("G");
                                seats.add("H");
                                seats.add("J");
                                seats.add("K");
                                int seatletter = rand.nextInt(seats.size());
                                String seat = Integer.toString(seatnum) + seats.get(seatletter);
                                try (PreparedStatement insertFlightPrepStatement = con.prepareStatement(insertFlightQuery)) {
                                    insertFlightPrepStatement.setInt(1, flightReferenceNumber);
                                    insertFlightPrepStatement.setInt(2, userID);
                                    insertFlightPrepStatement.setString(3, passengerNames);
                                    insertFlightPrepStatement.setString(4, flight_number);
                                    insertFlightPrepStatement.setString(5, departure_date_time);
                                    insertFlightPrepStatement.setDouble(6, flight_total_cost);
                                    insertFlightPrepStatement.setString(7, fareClass);
                                    insertFlightPrepStatement.setString(8, seat);
                                    insertFlightPrepStatement.setDouble(9, flight_ticket_cost);
                                    insertFlightPrepStatement.setDouble(10, plane_ticket_surcharge);
                                    insertFlightPrepStatement.setDouble(11, plane_ticket_tax);
                                    insertFlightPrepStatement.setDouble(12, flight_booking_fees);
                                    insertFlightPrepStatement.setString(13, flight_booking_date);
                                    insertFlightPrepStatement.executeUpdate();
                                }
                                return bookingType;
                            }
                        }
                    }
                case 2:
                    // Hotel booking
                    // Get hotel info from user: check-in date, check-out date, city, country
                    LocalDate indate = LocalDate.of(2024, 03, 14);
                    LocalDate outdate = LocalDate.of(2024, 03, 15);
                    String City = "";
                    String Country = "";
                    String hotel_address = "";
                    String brand_affiliation = "";
                    int room_number = 0;
                    double room_price = 0;
                    while(true) {
                        //select a pickup date
                        System.out.println("Choose the checkin date: ");
                        System.out.println("    2024");
                        System.out.print("Please Enter Your Option Number: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        year = scanner.nextInt();
                        if (year != 2024) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        //select a month
                        System.out.println("Choose the month: ");
                        System.out.println("    1. January");
                        System.out.println("    2. February");
                        System.out.println("    3. March");
                        System.out.println("    4. April");
                        System.out.println("    5. May");
                        System.out.println("    6. June");
                        System.out.println("    7. July");
                        System.out.println("    8. August");
                        System.out.println("    9. September");
                        System.out.println("    10. October");
                        System.out.println("    11. November");
                        System.out.println("    12. December");
                        System.out.print("Please Enter Your Option Number: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        month = scanner.nextInt();
                        if (month < 1 || month > 12) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        //select a day
                        System.out.print("Choose the day: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        day = scanner.nextInt();
                        if (day < 1 || day > 31) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        String dday = "";
                        if (day >= 1 && day <= 9) {
                            //add a 0 in front of the day
                            dday = "0" + day;
                        }
                        else {
                            dday = "" + day;
                        }
                        String mmonth = "";
                        if (month >= 1 && month <= 9) {
                            //add a 0 in front of the month
                            mmonth = "0" + month;
                        }
                        else {
                            mmonth = "" + month;
                        }
                        date = year + "-" + mmonth + "-" + dday;
                        indate = LocalDate.of(year, month, day);
                        //get return date time
                        System.out.println("Choose the checkout date: ");
                        System.out.println("    2024");
                        System.out.print("Please Enter Your Option Number: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        ryear = scanner.nextInt();
                        if (ryear != 2024) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        //select a month
                        System.out.println("Choose the month: ");
                        System.out.println("    1. January");
                        System.out.println("    2. February");
                        System.out.println("    3. March");
                        System.out.println("    4. April");
                        System.out.println("    5. May");
                        System.out.println("    6. June");
                        System.out.println("    7. July");
                        System.out.println("    8. August");
                        System.out.println("    9. September");
                        System.out.println("    10. October");
                        System.out.println("    11. November");
                        System.out.println("    12. December");
                        System.out.print("Please Enter Your Option Number: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        rmonth = scanner.nextInt();
                        if (rmonth < 1 || rmonth > 12) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        //select a day
                        System.out.print("Choose the day: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        rday = scanner.nextInt();
                        if (day < 1 || day > 31) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        String rdday = "";
                        if (rday >= 1 && rday <= 9) {
                            //add a 0 in front of the day
                            rdday = "0" + rday;
                        }
                        else {
                            rdday = "" + rday;
                        }
                        String rmmonth = "";
                        if (rmonth >= 1 && rmonth <= 9) {
                            //add a 0 in front of the month
                            rmmonth = "0" + rmonth;
                        }
                        else {
                            rmmonth = "" + rmonth;
                        }
                        rdate = ryear + "-" + rmmonth + "-" + rdday;
                        outdate = LocalDate.of(ryear, rmonth, rday);
                        if (indate.isAfter(outdate)) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        boolean flag13 = true;
                        while(flag13) {
                            //get the location 
                            String inAvail = "SELECT DISTINCT city_name, country FROM Hotel";
                            try (PreparedStatement inPrepStatement = con.prepareStatement(inAvail)) {
                                try (ResultSet resultSet = inPrepStatement.executeQuery()) {
                                    List<String> inCities = new ArrayList<>();
                                    List<String> inCountries = new ArrayList<>();
                                    while (resultSet.next()) {
                                        inCities.add(resultSet.getString("city_name"));
                                        inCountries.add(resultSet.getString("country"));
                                    }
                                    System.out.println("Choose the pickup location: ");
                                    for (int i = 0; i < inCities.size(); i++) {
                                        System.out.println("    " + (i+1) + ". " + inCities.get(i) + ", " + inCountries.get(i));
                                    }
                                    System.out.print("Please Enter Your Option Number: ");
                                    if (!scanner.hasNextInt()) {
                                        System.out.println("Invalid option. Please try again.");
                                        scanner.next();
                                        continue;
                                    }
                                    int pickupOption = scanner.nextInt();
                                    if (pickupOption < 1 || pickupOption > inCities.size()) {
                                        System.out.println("Invalid option. Please try again.");
                                        continue;
                                    }
                                    City = inCities.get(pickupOption-1);
                                    Country = inCountries.get(pickupOption-1);
                                    flag13 = false;
                                }
                            }
                        } 
                        //check if there are any rooms available, if there isnt then return to the date choosing
                        String roomAvail = "SELECT room_number FROM Room JOIN Hotel ON room.hotel_address = hotel.hotel_address AND room.brand_affiliation = hotel.brand_affiliation WHERE city_name = ? AND country = ? AND room_number NOT IN (SELECT room_number FROM HotelBooking WHERE (checkin_date BETWEEN ? AND ?) OR (checkout_date BETWEEN ? AND ?) OR (checkin_date < ? AND checkout_date > ?))";
                        try (PreparedStatement roomPrepStatement = con.prepareStatement(roomAvail)) {
                            roomPrepStatement.setString(1, City);
                            roomPrepStatement.setString(2, Country);
                            roomPrepStatement.setString(3, date);
                            roomPrepStatement.setString(4, rdate);
                            roomPrepStatement.setString(5, date);
                            roomPrepStatement.setString(6, rdate);
                            roomPrepStatement.setString(7, date);
                            roomPrepStatement.setString(8, rdate);
                            try (ResultSet resultSet = roomPrepStatement.executeQuery()) {
                                if (!resultSet.next()) {
                                    System.out.println("There are no available rooms on those days. Please try again.");
                                    continue;
                                }
                            }
                        }
                        break;
                    }
                    // Query for hotel options using the given info
                    String hotelOptionQuery = "SELECT brand_affiliation, hotel_address FROM Hotel WHERE city_name = ? AND country = ?";
                    // Display hotel options that have available rooms as a sub menu to choose from 
                    try (PreparedStatement hotelPreparedStatement = con.prepareStatement(hotelOptionQuery)) {
                        hotelPreparedStatement.setString(1, City);
                        hotelPreparedStatement.setString(2, Country);
                        try (ResultSet resultSet = hotelPreparedStatement.executeQuery()) {
                            List<String> brandAffiliations = new ArrayList<>();
                            List<String> hotelAddresses = new ArrayList<>();
                            System.out.println("+---------+----------------------+------------------------------------------+");
                            System.out.println("| Opt. no.| Brand Affiliation    | Hotel Address                            |");
                            System.out.println("+---------+----------------------+------------------------------------------+");
                            int i = 0;
                            while (resultSet.next()) {
                                i++;
                                String brandAffiliation = resultSet.getString("brand_affiliation");
                                String hotelAddress = resultSet.getString("hotel_address");
                                brandAffiliations.add(brandAffiliation);
                                hotelAddresses.add(hotelAddress);
                                System.out.printf("| %-7d | %-20s | %-40s |\n", i, brandAffiliation, hotelAddress);
                            }
                            System.out.println("+---------+----------------------+------------------------------------------+");
                            // Get user input for hotel option
                            System.out.print("Please Enter Your Option Number: ");
                            if (!scanner.hasNextInt()) {
                                System.out.println("Invalid option. Please try again.");
                                scanner.next();
                                continue;
                            }
                            int hotelOption = scanner.nextInt();
                            if (hotelOption < 1 || hotelOption > brandAffiliations.size()) {
                                System.out.println("Invalid option. Please try again.");
                                continue;
                            }
                            brand_affiliation = brandAffiliations.get(hotelOption-1);
                            hotel_address = hotelAddresses.get(hotelOption-1);
                        }
                    }
                    // Display room options as a sub menu to choose from
                    String roomOptionQuery = "SELECT room_number, room_name, beds, room_capacity, beds, room_price, size, free_wifi, view, minibar, private_bathroom, smoking FROM Room JOIN Hotel ON room.brand_affiliation = hotel.brand_affiliation AND room.hotel_address = hotel.hotel_address WHERE city_name = ? AND country = ? AND room_number NOT IN (SELECT room_number FROM HotelBooking WHERE (checkin_date BETWEEN ? AND ?) OR (checkout_date BETWEEN ? AND ?) OR (checkin_date < ? AND checkout_date > ?))";
                    boolean flag14 = true;
                    while(flag14) {
                        try (PreparedStatement roomPreparedStatement = con.prepareStatement(roomOptionQuery)) {
                            roomPreparedStatement.setString(1, City);
                            roomPreparedStatement.setString(2, Country);
                            roomPreparedStatement.setString(3, date);
                            roomPreparedStatement.setString(4, rdate);
                            roomPreparedStatement.setString(5, date);
                            roomPreparedStatement.setString(6, rdate);
                            roomPreparedStatement.setString(7, date);
                            roomPreparedStatement.setString(8, rdate);
                            try (ResultSet resultSet = roomPreparedStatement.executeQuery()) {
                                List<Integer> roomNumbers = new ArrayList<>();
                                List<String> roomNames = new ArrayList<>();
                                List<Integer> roomCapacities = new ArrayList<>();
                                List<String> roomBeds = new ArrayList<>();
                                List<Double> roomPrices = new ArrayList<>();
                                List<String> roomSizes = new ArrayList<>();
                                List<String> freeWifis = new ArrayList<>();
                                List<String> views = new ArrayList<>();
                                List<String> minibars = new ArrayList<>();
                                List<String> privateBathrooms = new ArrayList<>();
                                List<String> smokings = new ArrayList<>();
                                System.out.println("+---------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+-------------+----------------------+---------+------------------+---------+");
                                System.out.println("| Opt. no.| Room Number          | Room Name            | Room Capacity        | Beds                 | Room Price           | Size                 | Free Wifi   | View                 | Minibar | Private Bathroom | Smoking |");
                                System.out.println("+---------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+-------------+----------------------+---------+------------------+---------+");
                                int i = 0;
                                while (resultSet.next()) {
                                    i++;
                                    int roomNumber = resultSet.getInt("room_number");
                                    String roomName = resultSet.getString("room_name");
                                    int roomCapacity = resultSet.getInt("room_capacity");
                                    String beds = resultSet.getString("beds");
                                    double roomPrice = resultSet.getDouble("room_price");
                                    String roomSize = resultSet.getString("size");
                                    String freeWifi = resultSet.getString("free_wifi");
                                    String view = resultSet.getString("view");
                                    String minibar = resultSet.getString("minibar");
                                    String privateBathroom = resultSet.getString("private_bathroom");
                                    String smoking = resultSet.getString("smoking");
                                    roomNumbers.add(roomNumber);
                                    roomNames.add(roomName);
                                    roomCapacities.add(roomCapacity);
                                    roomBeds.add(beds);
                                    roomPrices.add(roomPrice);
                                    roomSizes.add(roomSize);
                                    freeWifis.add(freeWifi);
                                    views.add(view);
                                    minibars.add(minibar);
                                    privateBathrooms.add(privateBathroom);
                                    smokings.add(smoking);
                                    System.out.printf("| %-7d | %-20d | %-20s | %-20d | %-20s | %-20.2f | %-20s | %-11s | %-20s | %-7s | %-16s | %-7s |\n", i, roomNumber, roomName, roomCapacity, beds, roomPrice, roomSize, freeWifi, view, minibar, privateBathroom, smoking);
                                }
                                System.out.println("+---------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+-------------+----------------------+---------+------------------+---------+");
                                // Get user input for room option
                                System.out.print("Please Enter Your Option Number: ");
                                if (!scanner.hasNextInt()) {
                                    System.out.println("Invalid option. Please try again.");
                                    scanner.next();
                                    continue;
                                }
                                int roomOption = scanner.nextInt();
                                if (roomOption < 1 || roomOption > roomNumbers.size()) {
                                    System.out.println("Invalid option. Please try again.");
                                    continue;
                                }
                                room_number = roomNumbers.get(roomOption-1);
                                room_price = roomPrices.get(roomOption-1);
                                flag14 = false;
                            }
                        }
                    }
                    // Book hotel room by getting user input for booking info (user ID, checkin date, chekout date)
                    // and info from room selected (room number),
                    // and info from hotel selected (brand affiliation, hotel address)
                    // calculate costs (hotel toatal cost, hotel tax, hotel booking fees, hotel booking date),
                    double room_cost = (double) ChronoUnit.DAYS.between(indate, outdate) * room_price;
                    double hotel_tax = 0.15 * room_cost;
                    double hotel_booking_fees = 15;
                    double hotel_total_cost = room_cost + hotel_tax + hotel_booking_fees;
                    String hotel_booking_date = java.time.LocalDate.now().toString();
                    // generate a hotel reference number,
                    ResultSet roomRef = statement.executeQuery("SELECT MAX(hotel_reference_number) FROM HotelBooking");
                    roomRef.next();
                    int hotel_reference_number = roomRef.getInt(1) + 1;
                    // and insert into HotelBooking table
                    String insertHotelQuery = "INSERT INTO HotelBooking VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
                    try (PreparedStatement insertHotelPrepStatement = con.prepareStatement(insertHotelQuery)) {
                        insertHotelPrepStatement.setInt(1, hotel_reference_number);
                        insertHotelPrepStatement.setInt(2, userID);
                        insertHotelPrepStatement.setInt(3, room_number);
                        insertHotelPrepStatement.setString(4, brand_affiliation);
                        insertHotelPrepStatement.setString(5, hotel_address);
                        insertHotelPrepStatement.setString(6, date);
                        insertHotelPrepStatement.setString(7, rdate);
                        insertHotelPrepStatement.setDouble(8, hotel_total_cost);
                        insertHotelPrepStatement.setDouble(9, room_cost);
                        insertHotelPrepStatement.setDouble(10, hotel_tax);
                        insertHotelPrepStatement.setDouble(11, hotel_booking_fees);
                        insertHotelPrepStatement.setString(12, hotel_booking_date);
                        insertHotelPrepStatement.executeUpdate();
                    }
                    return bookingType;
                case 3:
                    // Car rental booking
                    // Get car rental info from user: pickup date time, return date time, pickup location, return location
                    LocalDate pickupdate = LocalDate.of(2024, 03, 14);
                    LocalDate returndate = LocalDate.of(2024, 03, 15);
                    String carOptionQuery = "SELECT car_license_plate, number_of_seats, car_rental_agency, transmission_type, car_model, car_engine_type, car_daily_cost, company_policy, AC, carplay FROM Car WHERE city_name = ? AND country = ? AND car_license_plate NOT IN (SELECT car_license_plate FROM CarRentalBooking WHERE (pickup_date_time BETWEEN ? AND ?) OR (return_date_time BETWEEN ? AND ?) OR (pickup_date_time < ? AND return_date_time > ?))";
                    while(true) {
                        //select a pickup date
                        System.out.println("Choose the pickup date: ");
                        System.out.println("    2024");
                        System.out.print("Please Enter Your Option Number: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        year = scanner.nextInt();
                        if (year != 2024) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        //select a month
                        System.out.println("Choose the month: ");
                        System.out.println("    1. January");
                        System.out.println("    2. February");
                        System.out.println("    3. March");
                        System.out.println("    4. April");
                        System.out.println("    5. May");
                        System.out.println("    6. June");
                        System.out.println("    7. July");
                        System.out.println("    8. August");
                        System.out.println("    9. September");
                        System.out.println("    10. October");
                        System.out.println("    11. November");
                        System.out.println("    12. December");
                        System.out.print("Please Enter Your Option Number: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        month = scanner.nextInt();
                        if (month < 1 || month > 12) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        //select a day
                        System.out.print("Choose the day: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        day = scanner.nextInt();
                        if (day < 1 || day > 31) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        String dday = "";
                        if (day >= 1 && day <= 9) {
                            //add a 0 in front of the day
                            dday = "0" + day;
                        }
                        else {
                            dday = "" + day;
                        }
                        String mmonth = "";
                        if (month >= 1 && month <= 9) {
                            //add a 0 in front of the month
                            mmonth = "0" + month;
                        }
                        else {
                            mmonth = "" + month;
                        }
                        date = year + "-" + mmonth + "-" + dday;
                        pickupdate = LocalDate.of(year, month, day);
                        //get return date time
                        System.out.println("Choose the return date: ");
                        System.out.println("    2024");
                        System.out.print("Please Enter Your Option Number: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        ryear = scanner.nextInt();
                        if (ryear != 2024) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        //select a month
                        System.out.println("Choose the month: ");
                        System.out.println("    1. January");
                        System.out.println("    2. February");
                        System.out.println("    3. March");
                        System.out.println("    4. April");
                        System.out.println("    5. May");
                        System.out.println("    6. June");
                        System.out.println("    7. July");
                        System.out.println("    8. August");
                        System.out.println("    9. September");
                        System.out.println("    10. October");
                        System.out.println("    11. November");
                        System.out.println("    12. December");
                        System.out.print("Please Enter Your Option Number: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        rmonth = scanner.nextInt();
                        if (rmonth < 1 || rmonth > 12) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        //select a day
                        System.out.print("Choose the day: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        rday = scanner.nextInt();
                        if (day < 1 || day > 31) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        String rdday = "";
                        if (rday >= 1 && rday <= 9) {
                            //add a 0 in front of the day
                            rdday = "0" + rday;
                        }
                        else {
                            rdday = "" + rday;
                        }
                        String rmmonth = "";
                        if (rmonth >= 1 && rmonth <= 9) {
                            //add a 0 in front of the month
                            rmmonth = "0" + rmonth;
                        }
                        else {
                            rmmonth = "" + rmonth;
                        }
                        rdate = ryear + "-" + rmmonth + "-" + rdday;
                        returndate = LocalDate.of(ryear, rmonth, rday);
                        if (pickupdate.isAfter(returndate)) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        boolean flag9 = true;
                        while(flag9) {
                            //get the pickup location 
                            String pickupAvail = "SELECT DISTINCT city_name, country FROM Car";
                            try (PreparedStatement pickupPrepStatement = con.prepareStatement(pickupAvail)) {
                                try (ResultSet resultSet = pickupPrepStatement.executeQuery()) {
                                    List<String> pickupCities = new ArrayList<>();
                                    List<String> pickupCountries = new ArrayList<>();
                                    while (resultSet.next()) {
                                        pickupCities.add(resultSet.getString("city_name"));
                                        pickupCountries.add(resultSet.getString("country"));
                                    }
                                    System.out.println("Choose the pickup location: ");
                                    for (int i = 0; i < pickupCities.size(); i++) {
                                        System.out.println("    " + (i+1) + ". " + pickupCities.get(i) + ", " + pickupCountries.get(i));
                                    }
                                    System.out.print("Please Enter Your Option Number: ");
                                    if (!scanner.hasNextInt()) {
                                        System.out.println("Invalid option. Please try again.");
                                        scanner.next();
                                        continue;
                                    }
                                    int pickupOption = scanner.nextInt();
                                    if (pickupOption < 1 || pickupOption > pickupCities.size()) {
                                        System.out.println("Invalid option. Please try again.");
                                        continue;
                                    }
                                    pickupCity = pickupCities.get(pickupOption-1);
                                    pickupCountry = pickupCountries.get(pickupOption-1);
                                    flag9=false;
                                }
                            }
                        }
                        //get return location
                        boolean flag10 = true;
                        while(flag10) {
                            //get the pickup location 
                            String returnAvail = "SELECT DISTINCT city_name, country FROM Car";
                            try (PreparedStatement returnPrepStatement = con.prepareStatement(returnAvail)) {
                                try (ResultSet resultSet = returnPrepStatement.executeQuery()) {
                                    List<String> returnCities = new ArrayList<>();
                                    List<String> returnCountries = new ArrayList<>();
                                    while (resultSet.next()) {
                                        returnCities.add(resultSet.getString("city_name"));
                                        returnCountries.add(resultSet.getString("country"));
                                    }
                                    System.out.println("Choose the pickup location: ");
                                    for (int i = 0; i < returnCities.size(); i++) {
                                        System.out.println("    " + (i+1) + ". " + returnCities.get(i) + ", " + returnCountries.get(i));
                                    }
                                    System.out.print("Please Enter Your Option Number: ");
                                    if (!scanner.hasNextInt()) {
                                        System.out.println("Invalid option. Please try again.");
                                        scanner.next();
                                        continue;
                                    }
                                    int pickupOption = scanner.nextInt();
                                    if (pickupOption < 1 || pickupOption > returnCities.size()) {
                                        System.out.println("Invalid option. Please try again.");
                                        continue;
                                    }
                                    returnCity = returnCities.get(pickupOption-1);
                                    flag10 = false;
                                }
                            }
                        } 
                        //check if there are any, if there isnt then return to the date choosing
                        try (PreparedStatement carOptionPrepStatement = con.prepareStatement(carOptionQuery)) {
                            carOptionPrepStatement.setString(1, pickupCity);
                            carOptionPrepStatement.setString(2, pickupCountry);
                            carOptionPrepStatement.setString(3, date);
                            carOptionPrepStatement.setString(4, rdate);
                            carOptionPrepStatement.setString(5, date);
                            carOptionPrepStatement.setString(6, rdate);
                            carOptionPrepStatement.setString(7, date);
                            carOptionPrepStatement.setString(8, rdate);
                            try (ResultSet resultSet = carOptionPrepStatement.executeQuery()) {
                                if (!resultSet.next()) {
                                    System.out.println("There are no available cars for that date. Please try again.");
                                    continue;
                                }
                            }
                        } break;
                    }
                    // Query for car rental options using the given info
                    boolean flag11 = true;
                    while(flag11) {
                        // Display car rental options as a sub menu to choose from
                        try (PreparedStatement carOptionPrepStatement = con.prepareStatement(carOptionQuery)) {
                            carOptionPrepStatement.setString(1, pickupCity);
                            carOptionPrepStatement.setString(2, pickupCountry);
                            carOptionPrepStatement.setString(3, date);
                            carOptionPrepStatement.setString(4, rdate);
                            carOptionPrepStatement.setString(5, date);
                            carOptionPrepStatement.setString(6, rdate);
                            carOptionPrepStatement.setString(7, date);
                            carOptionPrepStatement.setString(8, rdate);
                            try (ResultSet resultSet = carOptionPrepStatement.executeQuery()) {
                                List<String> carLicensePlates = new ArrayList<>();
                                List<Integer> numberOfSeats = new ArrayList<>();
                                List<String> carRentalAgencies = new ArrayList<>();
                                List<String> transmissionTypes = new ArrayList<>();
                                List<String> carModels = new ArrayList<>();
                                List<String> carEngineTypes = new ArrayList<>();
                                List<Double> carDailyCosts = new ArrayList<>();
                                List<String> companyPolicies = new ArrayList<>();
                                List<String> ACs = new ArrayList<>();
                                List<String> carplays = new ArrayList<>();
                                System.out.println("+---------+----------------------+----------------------+----------------------+----------------------+---------------------------+----------------------+----------------------+-----------------------------------------------+--------+---------+");
                                System.out.println("| Opt. nu.| Car License Plate    | Number of Seats      | Car Rental Agency    | Transmission Type    | Car Model                 | Car Engine Type      | Car Daily Cost       | Company Policy                                | AC     | Carplay |");
                                System.out.println("+---------+----------------------+----------------------+----------------------+----------------------+---------------------------+----------------------+----------------------+-----------------------------------------------+--------+---------+");
                                int i = 0;
                                while (resultSet.next()) {
                                    i++; // Increment the counter
                                    String carLicensePlate = resultSet.getString("car_license_plate");
                                    int numberOfSeat = resultSet.getInt("number_of_seats");
                                    String carRentalAgency = resultSet.getString("car_rental_agency");
                                    String transmissionType = resultSet.getString("transmission_type");
                                    String carModel = resultSet.getString("car_model");
                                    String carEngineType = resultSet.getString("car_engine_type");
                                    double carDailyCost = resultSet.getDouble("car_daily_cost");
                                    String companyPolicy = resultSet.getString("company_policy");
                                    String AC = resultSet.getString("AC");
                                    String carplay = resultSet.getString("carplay");
                                    carLicensePlates.add(carLicensePlate);
                                    numberOfSeats.add(numberOfSeat);
                                    carRentalAgencies.add(carRentalAgency);
                                    transmissionTypes.add(transmissionType);
                                    carModels.add(carModel);
                                    carEngineTypes.add(carEngineType);
                                    carDailyCosts.add(carDailyCost);
                                    companyPolicies.add(companyPolicy);
                                    ACs.add(AC);
                                    carplays.add(carplay);
                                    System.out.printf("| %-7d | %-20s | %-20d | %-20s | %-20s | %-25s | %-20s | %-20.2f | %-45s | %-6s | %-7s |\n", i, carLicensePlate, numberOfSeat, carRentalAgency, transmissionType, carModel, carEngineType, carDailyCost, companyPolicy, AC, carplay);
                                }
                                System.out.println("+---------+----------------------+----------------------+----------------------+----------------------+---------------------------+----------------------+----------------------+-----------------------------------------------+--------+---------+");
                                // Get user input for car rental option
                                System.out.print("Please Enter Your Option Number: ");
                                if (!scanner.hasNextInt()) {
                                    System.out.println("Invalid option. Please try again.");
                                    scanner.next();
                                    continue;
                                }
                                int carOption = scanner.nextInt();
                                if (carOption < 1 || carOption > carLicensePlates.size()) {
                                    System.out.println("Invalid option. Please try again.");
                                    continue;
                                }
                                flag11 = false;
                                // get the car_license_plate
                                car_license_plate = carLicensePlates.get(carOption-1);
                                car_daily_cost = carDailyCosts.get(carOption-1);
                                car_rental_agency = carRentalAgencies.get(carOption-1);
                                insurance = companyPolicies.get(carOption-1);
                            }
                        }
                    }
                    // Book car rental by getting user input for booking info (user ID, pickup date time, return date time, pickup location, return location)
                    // and info from car rental selected (car ar license plate, insurance)
                    // calculate costs (car rental total cost, car rental tax, car rental booking fees, car rental booking date),
                    //car rental cost = (return date time - pickup date time) * car daily cost
                    double car_rental_cost = (double) ChronoUnit.DAYS.between(pickupdate, returndate) * car_daily_cost;
                    double car_rental_tax = 0.15 * car_rental_cost;
                    double car_rental_booking_fees = 15;
                    double car_rental_total_cost = car_rental_cost + car_rental_tax + car_rental_booking_fees;
                    String car_rental_booking_date = java.time.LocalDate.now().toString();
                    // generate a car rental reference number,
                    ResultSet carRef = statement.executeQuery("SELECT MAX(car_rental_reference_number) FROM CarRentalBooking");
                    carRef.next();
                    int car_rental_reference_number = carRef.getInt(1) + 1;
                    // and insert into CarRentalBooking table
                    String insertCarQuery = "INSERT INTO CarRentalBooking VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
                    try (PreparedStatement insertCarPrepStatement = con.prepareStatement(insertCarQuery)) {
                        insertCarPrepStatement.setInt(1, car_rental_reference_number);
                        insertCarPrepStatement.setInt(2, userID);
                        insertCarPrepStatement.setString(3, car_license_plate);
                        insertCarPrepStatement.setString(4, car_rental_agency + " " + pickupCity);
                        insertCarPrepStatement.setString(5, car_rental_agency + " " + returnCity);
                        insertCarPrepStatement.setString(6, pickupdate.toString() + " 10:00:00");
                        insertCarPrepStatement.setString(7, returndate.toString() + " 18:00:00");
                        insertCarPrepStatement.setString(8, car_rental_booking_date);
                        insertCarPrepStatement.setDouble(9, car_rental_cost);
                        insertCarPrepStatement.setDouble(10, car_rental_tax);
                        insertCarPrepStatement.setDouble(11, car_rental_booking_fees);
                        insertCarPrepStatement.setDouble(12, car_rental_total_cost);
                        insertCarPrepStatement.setString(13, insurance);
                        insertCarPrepStatement.executeUpdate();
                    }
                    return bookingType;
                default:
                    System.out.println("Invalid option. Please try again.");
                    break;
            }
        }
    }

    // Method to update data
    //query for user //update
    static void updateData(Connection con, Statement statement, Scanner scanner) throws SQLException {
        boolean flag = true;
        scanner.nextLine(); // Consume the newline character
        try {    
            while (flag) {
                // Taking user input for username and password
                System.out.print("Enter the username: ");
                String userName = scanner.nextLine();
                if (userName.length() > 10) {
                    System.out.println("Username is too long. Please try again.");
                    continue;
                }
                //check if user exists
                //using prepared statemtne to prevent injection attacks
                String userQuery = "SELECT username FROM Registered WHERE username = ?"; 
                try (PreparedStatement userPrepStatement = con.prepareStatement(userQuery)) {
                    userPrepStatement.setString(1, userName);
                    try (ResultSet resultSet = userPrepStatement.executeQuery()) {
                        if (!resultSet.next()) {
                            System.out.println("User does not exist or is not registered. Please try again.");
                            continue;
                        }
                        else {
                            //check password
                            boolean goodpass = false;
                            for (int i = 0; i < 3; i++) {
                                System.out.print("Enter the password: ");
                                String password = scanner.nextLine();
                                if (password.length() > 10) {
                                    System.out.println("Password is too long. Please try again.");
                                    i--;
                                    continue;
                                }
                                String passQuery = "SELECT password FROM Registered WHERE username = ? AND password = ?";
                                try (PreparedStatement passPrepStatement = con.prepareStatement(passQuery)) {
                                    passPrepStatement.setString(1, userName);
                                    passPrepStatement.setString(2, password);
                                    try (ResultSet resultSet2 = passPrepStatement.executeQuery()) {
                                        if (!resultSet2.next()) {
                                            System.out.println("Password is incorrect. Please try again.");
                                            continue;
                                        }
                                        else {
                                            goodpass = true;
                                            break;
                                        }
                                    }
                                }
                            }
                            if (!goodpass) {
                                System.out.println("You have entered the wrong password too many times. Please try again later.");
                                return;
                            }
                            // Query for user -> resultSet
                            String userQuery2 = "SELECT u.user_id, u.name, u.email, u.phone_number, u.address, u.credit_card_information, r.language FROM Users u JOIN Registered r ON u.user_id = r.user_id WHERE u.user_id = (SELECT user_id FROM Registered WHERE username = ?)";
                            try (PreparedStatement userPrepStatement2 = con.prepareStatement(userQuery2)) {
                                userPrepStatement2.setString(1, userName);
                                try (ResultSet resultSet3 = userPrepStatement2.executeQuery()) {
                                    // Process and display user info
                                    System.out.println("User info: ");
                                    System.out.println("+------------+----------+---------------------+--------------------------------+----------------------+---------------------------------------------------+--------------------------------------+");
                                    System.out.println("| User ID    | Language | Name                | Email                          | Phone Number         | Address                                           | Credit Card Information              |");
                                    System.out.println("+------------+----------+---------------------+--------------------------------+----------------------+---------------------------------------------------+--------------------------------------+");
                                    while (resultSet3.next()) {
                                        int userID = resultSet3.getInt("user_id");
                                        String language = resultSet3.getString("language");
                                        String name = resultSet3.getString("name");
                                        String email = resultSet3.getString("email");
                                        String phoneNumber = resultSet3.getString("phone_number");
                                        String address = resultSet3.getString("address");
                                        String creditCardInfo = resultSet3.getString("credit_card_information");
                                        System.out.printf("| %-10d | %-8s | %-19s | %-30s | %-20s | %-49s | %-36s |\n", userID, language, name, email, phoneNumber, address, creditCardInfo);   
                                    }
                                    System.out.println("+------------+----------+---------------------+--------------------------------+----------------------+---------------------------------------------------+--------------------------------------+");
                                    boolean flag3 = true;
                                    while(flag3) {
                                        // Ask user for which info to update
                                        System.out.println("Which information would you like to update?");
                                        System.out.println("    1. Language");
                                        System.out.println("    2. Name");
                                        System.out.println("    3. Email");
                                        System.out.println("    4. Phone Number");
                                        System.out.println("    5. Address");
                                        System.out.println("    6. Credit Card Information");
                                        System.out.println("    7. Quit");
                                        System.out.print("Please Enter Your Option Number: ");
                                        if (!scanner.hasNextInt()) {
                                            System.out.println("Invalid option. Please try again.");
                                            scanner.next();
                                            continue;
                                        }
                                        int option = scanner.nextInt();
                                        switch (option) {
                                            case 1:
                                                // Update language
                                                String language="";
                                                while (true) {
                                                    // get user input for new language
                                                    System.out.println("Choose the new language: ");
                                                    System.out.println("    1. English");
                                                    System.out.println("    2. French");
                                                    System.out.print("Please Enter Your Option Number: ");
                                                    if (!scanner.hasNextInt()) {
                                                        System.out.println("Invalid option. Please try again.");
                                                        scanner.next();
                                                        continue;
                                                    }
                                                    int languageOption = scanner.nextInt();
                                                    if (languageOption == 1) {
                                                        // set language to English
                                                        language = "en";
                                                        break;
                                                    }
                                                    else if (languageOption == 2) {
                                                        // set language to French
                                                        language = "fr";
                                                        break;
                                                    }
                                                    else {
                                                        System.out.println("Invalid option. Please try again.");
                                                        continue;
                                                    }
                                                }
                                                String updateLanguageQuery = "UPDATE Registered SET language = ? WHERE user_id = (SELECT user_id FROM Registered WHERE username = ?)";
                                                try (PreparedStatement updateLanguagePrepStatement = con.prepareStatement(updateLanguageQuery)) {
                                                    updateLanguagePrepStatement.setString(1, language);
                                                    updateLanguagePrepStatement.setString(2, userName);
                                                    updateLanguagePrepStatement.executeUpdate();
                                                    System.out.println("Data updated successfully");
                                                }
                                                break;
                                            case 2:
                                                // Update name
                                                String newname="";
                                                while (true) {
                                                    // get user input for new name
                                                    scanner.nextLine(); // Consume the newline character
                                                    System.out.print("Enter the new name: ");
                                                    newname = scanner.nextLine();
                                                    if (newname.length() > 25) {
                                                        System.out.println("Name is too long. Please try again.");
                                                        continue;
                                                    }
                                                    else {
                                                        break;
                                                    }
                                                }
                                                // Execute update statement
                                                String updateNameQuery = "UPDATE Users SET name = ? WHERE user_id = (SELECT user_id FROM Registered WHERE username = ?)";
                                                try (PreparedStatement updateNamePrepStatement = con.prepareStatement(updateNameQuery)) {
                                                    updateNamePrepStatement.setString(1, newname);
                                                    updateNamePrepStatement.setString(2, userName);
                                                    updateNamePrepStatement.executeUpdate();
                                                    System.out.println("Data updated successfully");
                                                }
                                                break;
                                            case 3:
                                                // Update email
                                                String newEmail = "";
                                                while (true) {
                                                    // get user input for new email
                                                    scanner.nextLine(); // Consume the newline character
                                                    System.out.print("Enter the new email: ");
                                                    newEmail = scanner.nextLine();
                                                    if (newEmail.length() > 40) {
                                                        System.out.println("Email is too long. Please try again.");
                                                        continue;
                                                    }
                                                    else {
                                                        break;
                                                    }
                                                }
                                                // Execute update statement
                                                String updateEmailQuery = "UPDATE Users SET email = ? WHERE user_id = (SELECT user_id FROM Registered WHERE username = ?)";
                                                try (PreparedStatement updateEmailPrepStatement = con.prepareStatement(updateEmailQuery)) {
                                                    updateEmailPrepStatement.setString(1, newEmail);
                                                    updateEmailPrepStatement.setString(2, userName);
                                                    updateEmailPrepStatement.executeUpdate();
                                                    System.out.println("Data updated successfully");
                                                }
                                                break;
                                            case 4:
                                                // Update phone number
                                                String newPhoneNumber = "";
                                                while (true) {
                                                    // get user input for new phone number
                                                    scanner.nextLine(); // Consume the newline character
                                                    System.out.print("Enter the new phone number: ");
                                                    newPhoneNumber = scanner.nextLine();
                                                    if (newPhoneNumber.length() > 22) {
                                                        System.out.println("Phone number is too long. Please try again.");
                                                        continue;
                                                    }
                                                    else {
                                                        break;
                                                    }
                                                }
                                                // Execute update statement
                                                String updatePhoneNumberQuery = "UPDATE Users SET phone_number = ? WHERE user_id = (SELECT user_id FROM Registered WHERE username = ?)";
                                                try (PreparedStatement updatePhoneNumberPrepStatement = con.prepareStatement(updatePhoneNumberQuery)) {
                                                    updatePhoneNumberPrepStatement.setString(1, newPhoneNumber);
                                                    updatePhoneNumberPrepStatement.setString(2, userName);
                                                    updatePhoneNumberPrepStatement.executeUpdate();
                                                    System.out.println("Data updated successfully");
                                                }
                                                break;
                                            case 5:
                                                // Update address
                                                String newAddress = "";
                                                while (true) {
                                                    // get user input for new address
                                                    scanner.nextLine(); // Consume the newline character
                                                    System.out.print("Enter the new address: ");
                                                    newAddress = scanner.nextLine();
                                                    if (newAddress.length() > 50) {
                                                        System.out.println("Address is too long. Please try again.");
                                                        continue;
                                                    }
                                                    else {
                                                        break;
                                                    }
                                                }
                                                // Execute update statement
                                                String updateAddressQuery = "UPDATE Users SET address = ? WHERE user_id = (SELECT user_id FROM Registered WHERE username = ?)";
                                                try (PreparedStatement updateAddressPrepStatement = con.prepareStatement(updateAddressQuery)) {
                                                    updateAddressPrepStatement.setString(1, newAddress);
                                                    updateAddressPrepStatement.setString(2, userName);
                                                    updateAddressPrepStatement.executeUpdate();
                                                    System.out.println("Data updated successfully");
                                                }
                                                break;
                                            case 6:
                                                // Update credit card information
                                                scanner.nextLine(); // Consume the newline character
                                                System.out.print("Enter the new credit card information: ");
                                                String newCreditCardInfo = scanner.nextLine();
                                                // Execute update statement
                                                String updateCreditCardInfoQuery = "UPDATE Users SET credit_card_information = ? WHERE user_id = (SELECT user_id FROM Registered WHERE username = ?)";
                                                try (PreparedStatement updateCreditCardInfoPrepStatement = con.prepareStatement(updateCreditCardInfoQuery)) {
                                                    updateCreditCardInfoPrepStatement.setString(1, newCreditCardInfo);
                                                    updateCreditCardInfoPrepStatement.setString(2, userName);
                                                    updateCreditCardInfoPrepStatement.executeUpdate();
                                                    System.out.println("Data updated successfully");
                                                }
                                                break;
                                            case 7:
                                                flag3 = false;
                                                break;
                                            default:
                                                System.out.println("Invalid option. Please try again.");
                                                break;
                                            }
                                        }
                                        System.out.println("Updates Done");
                                        flag = false;
                                    }
                                }
                            }
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

    // Method to delete data using multiple sql statements
    //get flight reference number for cancelled flight //query for flight bookings with that flight //query for next available flight closest date to same location //update bookings for all users who had the cancelled flight to the next available one //delete cancelled flight
    static void deleteData(Statement statement, Scanner scanner) {
        //FOR GRADING
        System.out.println("FOR GRADING PURPOSES ONLY, THE PASSWORD FOR ADMINS IS 'admin000'");
        try {
            //get the password
            System.out.print("Enter the password: ");
            String password = System.console().readLine();
            if (!password.equals("admin000")) {
                System.out.println("Incorrect password. This option is only for admins.");
                return;
            }
            while (true) {
                //get the flight number and departure datetime
                System.out.println("Choose the flight number and departure date of the flight to be cancelled: ");
                // Fetch flights from database
                int i = 1;
                try (ResultSet resultSet0 = statement.executeQuery("SELECT flight_number, DATE(departure_date_time) AS departure_date FROM Flights")) {
                    System.out.println("Available Flights: ");
                    while (resultSet0.next()) {
                        String flightNumber = resultSet0.getString("flight_number");
                        String departureDate = resultSet0.getString("departure_date");
                        System.out.println("    " + i + ". " + flightNumber + " on " + departureDate);
                        i++;
                    }
                }
                int option = 0;
                while (true) {
                    System.out.print("Please Enter Your Option Number for the Flight to Cancel: ");
                    if (!scanner.hasNextInt()) {
                        System.out.println("Invalid option. Please try again.");
                        scanner.next();
                        continue;
                    }
                    else {
                        option = scanner.nextInt();
                        if (option < 1 || option > i) {
                            System.out.println("Invalid option. Please try again.");
                            continue;
                        }
                        else {
                            break;
                        }
                    } 
                }
                //get the flight number and departure date
                String flightNumber = "";
                String departureDate = "";
                try (ResultSet resultSet5 = statement.executeQuery("SELECT flight_number, DATE(departure_date_time) AS departure_date FROM Flights")) {
                    int count = 1;
                    while (resultSet5.next()) {
                        if (count == option) {
                            flightNumber = resultSet5.getString("flight_number");
                            departureDate = resultSet5.getString("departure_date");
                            break;
                        }
                        count++;
                    }
                }
                // Check if the flight exists
                try (ResultSet resultSet = statement.executeQuery("SELECT flight_number FROM Flights WHERE flight_number = '" + flightNumber + "' AND DATE(departure_date_time) = '" + departureDate + "'")) {
                    if (!resultSet.next()) {
                        System.out.println("Flight does not exist. Please try again.");
                        resultSet.close();
                        continue;
                    }
                }
                // Check if there are any bookings for the flight
                ResultSet resultSet1 = statement.executeQuery("SELECT flight_reference_number FROM FlightBooking WHERE flight_number = '" + flightNumber + "' AND DATE(departure_date_time) = '" + departureDate + "'");
                if (!resultSet1.next()) {
                    // No bookings, just cancel the flight. Delete the flight from the flight table
                    statement.executeUpdate("DELETE FROM Flights WHERE flight_number = '" + flightNumber + "' AND DATE(departure_date_time) = '" + departureDate + "'");
                    System.out.println("Flight cancelled successfully");
                    resultSet1.close();
                    return;
                }
                else {
                    // Print available flights for rebooking
                    resultSet1.close();
                    System.out.println("Available Flights for Rebooking: ");
                    int k = 1;
                    try (ResultSet resultSet2 = statement.executeQuery("SELECT flight_number, DATE(departure_date_time) AS departure_date FROM Flights WHERE departure_city = (SELECT departure_city FROM Flights WHERE flight_number = '" + flightNumber + "' AND DATE(departure_date_time) = '" + departureDate + "') AND arrival_city = (SELECT arrival_city FROM Flights WHERE flight_number = '" + flightNumber + "' AND DATE(departure_date_time) = '" + departureDate + "') AND DATE(departure_date_time) != '" + departureDate + "'")) {
                        while (resultSet2.next()) {
                            String flightNumber2 = resultSet2.getString("flight_number");
                            String departureDate2 = resultSet2.getString("departure_date");
                            System.out.println("    " + k + ". " + flightNumber2 + " on " + departureDate2);
                            k++;
                        }
                    }
                    // Prompt for rebooking option
                    int option2 = 0;
                    while (true) {
                        System.out.print("Please Enter Your Option Number for the Flight you would like to Book: ");
                        if (!scanner.hasNextInt()) {
                            System.out.println("Invalid option. Please try again.");
                            scanner.next();
                            continue;
                        }
                        else {
                            option2 = scanner.nextInt();
                            if (option2 < 1 || option2 > k) {
                                System.out.println("Invalid option. Please try again.");
                                continue;
                            }
                            else {
                                break;
                            }
                        }
                    }
                    String flightNumber2 = "";
                    String departureDate2 = "";
                    // Get the flight number and departure date for rebooking
                    try (ResultSet resultSet6 = statement.executeQuery("SELECT flight_number, departure_date_time FROM Flights WHERE departure_city = (SELECT departure_city FROM Flights WHERE flight_number = '" + flightNumber + "' AND DATE(departure_date_time) = '" + departureDate + "') AND arrival_city = (SELECT arrival_city FROM Flights WHERE flight_number = '" + flightNumber + "' AND DATE(departure_date_time) = '" + departureDate + "') AND DATE(departure_date_time) != '" + departureDate + "'")) {                        int count = 1;
                        flightNumber2 = "";
                        departureDate2 = "";
                        while (resultSet6.next()){
                            if (count == option2) {
                                flightNumber2 = resultSet6.getString("flight_number");
                                departureDate2 = resultSet6.getString("departure_date_time");
                                break;
                            }
                            count++;
                        }
                    }
                    // Get the flight reference number for the cancelled flight
                    // Update the flight booking and delete the cancelled flight
                    // for each user who had the cancelled flight
                    ResultSet resultSet4 = statement.executeQuery("SELECT flight_reference_number FROM FlightBooking WHERE flight_number = '" + flightNumber + "' AND DATE(departure_date_time) = '" + departureDate + "'");
                    List<Integer> flightReferenceNumbers = new ArrayList<>();
                    // Retrieve all flight reference numbers first
                    while (resultSet4.next()) {
                        int flightRefNumber = resultSet4.getInt("flight_reference_number");
                        flightReferenceNumbers.add(flightRefNumber);
                    }
                    resultSet4.close(); // Close the ResultSet after retrieving all data
                    // Iterate through the list of flight reference numbers and perform the update
                    for (int refNumber : flightReferenceNumbers) {
                        statement.executeUpdate("UPDATE FlightBooking SET flight_number = '" + flightNumber2 + "', departure_date_time = '" + departureDate2 + "' WHERE flight_reference_number = " + refNumber);
                    }
                    System.out.println("Bookings updated successfully");
                    // Delete the cancelled flight
                    statement.executeUpdate("DELETE FROM Flights WHERE flight_number = '" + flightNumber + "' AND DATE(departure_date_time) = '" + departureDate + "'");
                    System.out.println("Flight cancelled successfully");
                    return;
                }            
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    // Method for querying Find all bookings for a given user (booking history)
    static void userHistory(Statement statement) throws SQLException {
        boolean flag = true;
        while (flag) {
            // Taking user input for user id
            System.out.print("Enter the user id: ");
            int userId = Integer.parseInt(System.console().readLine());
            //check if user exists
            ResultSet resultSet = statement.executeQuery("SELECT user_id FROM User WHERE user_id = " + userId);
            if (!resultSet.next()) {
                System.out.println("User does not exist. Please try again.");
                resultSet.close();
                continue;
            }
            else {
                // Query for user bookings. in each bookings table, get all bookings for the user and display
                // Process and display query results
                while (resultSet.next()) {
                    // Process each row of the result set
                    // Example: String data = resultSet.getString("columnName");
                }
                flag = false;
                resultSet.close(); 
            }
        }
    }
}
