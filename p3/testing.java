//package p3; //remove when submitting

import java.sql.* ;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import javax.lang.model.type.NullType;

import java.util.Random;

class test //find better name
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
                            registerUser(con, statement, scanner0);
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
                            userHistory(con, statement, scanner0);
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
    
    static void registerUser(Connection con, Statement statement, Scanner scanner){
        boolean flag1 = true;
        boolean flag2 = true;
        boolean flag3 = true;
        boolean flag4 = true;
        boolean flag5 = true;
        boolean flag6 = true;
        boolean flag7 = true;
        boolean flag8 = true;

        String name = null;
        String email = null;
        String phoneNum = null;
        String address = null;
        String creditInfo = null;
        String username = null;
        String password = null;
        String selectedLanguage = null;

        try {
            while (flag1){
                // Taking user input for name
                System.out.print("Enter your name: ");
                name = scanner.nextLine();
                //Check if name is within the length limit
                if (name.length() > 25 || name.length() < 1){
                    System.out.println("Invalid name length. Please try again.");
                    continue;
                } 
                else {
                    System.out.println("Registered name: " + name);
                    flag1 = false;
                }
            }
            while (flag2){
                // Taking user input for email
                System.out.print("Enter your email: ");
                email = scanner.nextLine();
                //Check if email is within the length limit
                if (email.length() > 40 || email.length() < 1){
                    System.out.println("Invalid email length. Please try again.");
                    continue;
                } 
                else {
                    System.out.println("Registered email: " + email);
                    flag2 = false;
                }
            }
            while (flag3){
                // Taking user input for phone number
                System.out.print("Enter your phone number: ");
                phoneNum = scanner.nextLine();
                //Check if phone number is within the length limit
                if (phoneNum.length() > 22 || phoneNum.length() < 1){
                    System.out.println("Invalid phone number length. Please try again.");
                    continue;
                } 
                else {
                    System.out.println("Registered phone number: " + phoneNum);
                    flag3 = false;
                    
                }
            }
            while (flag4){
                // Taking user input for address
                System.out.print("Enter your address: ");
                address = scanner.nextLine();
                //Check if address is within the length limit
                if (address.length() > 50 || address.length() < 1){
                    System.out.println("Invalid address length. Please try again.");
                    continue;
                } 
                else {
                    System.out.println("Registered address: " + address);
                    flag4 = false;
                }
            }
            while (flag5){
                // Taking user input for credit card info
                System.out.print("Enter your credit card info: ");
                creditInfo = scanner.nextLine();
                //Check if credit card info is within the length limit
                if (creditInfo.length() > 28 || creditInfo.length() < 1){
                    System.out.println("Invalid credit card info length. Please try again.");
                    continue;
                } 
                else {
                    System.out.println("Registered credit card info: " + creditInfo);
                    flag5 = false;
                }
            }
            while (flag6){
                // Taking user input for username
                System.out.print("Choose a username: ");
                username = scanner.nextLine();

                if (username.length() > 10 || username.length() < 1){
                    System.out.println("Invalid username length. Please try again.");
                    continue;
                }

                String query = "SELECT username FROM Registered WHERE username = '?'";
                try (PreparedStatement preparedStatement = con.prepareStatement(query)){
                    preparedStatement.setString(1, username);
                    try (ResultSet resultSet1 = preparedStatement.executeQuery()){
                        
                        if (resultSet1.next()) {
                            System.out.println("Username already exists. Please try again.");
                            continue;
                        }
                        else {
                            flag6 = false;
                        }
                        
                    }
                }
            }
            while (flag7){
                // Taking user input for password
                System.out.print("Choose a password: ");
                password = scanner.nextLine();
                //Check if password is within the length limit
                if (password.length() > 10 || password.length() < 1) {
                    System.out.println("Invalid password length. Please try again.");
                    continue;
                }
                System.out.print("Re-enter password: ");
                String password2 = scanner.nextLine();
                if (!password.equals(password2)) {
                    System.out.println("Passwords do not match. Please try again.");
                    continue;
                }
                else {
                    flag7 = false;
                }
            }
            while (flag8){
                //Choose language
                System.out.println("Choose a language: ");
                System.out.println("    1. English");
                System.out.println("    2. French");
                System.out.print("Please Enter Your Option Number: ");
                int language = scanner.nextInt();

                switch (language) {
                    case 1:
                        selectedLanguage = "en";
                        flag8 = false;
                        break;
                
                    case 2:
                        selectedLanguage = "fr";
                        flag8 = false;
                        break;
                    default:
                        System.out.println("Invalid option. Please try again.");
                        break;
                }
            }
            //Generate a user id by getting the max user id from the Users table and adding 1
            int userId = 0;
            String query = "SELECT MAX(user_id) FROM Users";
            try (PreparedStatement preparedStatement = con.prepareStatement(query)){
                try (ResultSet resultSet2 = preparedStatement.executeQuery()){
                    if (resultSet2.next()) {
                        userId = resultSet2.getInt(1) + 1;
                    }
                }
            }
            //Insert user info into Users and Registered tables
            query = "INSERT INTO Users (user_id, name, email, phone_number, address, credit_card_info) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement preparedStatement = con.prepareStatement(query)){
                preparedStatement.setInt(1, userId);
                preparedStatement.setString(2, name);
                preparedStatement.setString(3, email);
                preparedStatement.setString(4, phoneNum);
                preparedStatement.setString(5, address);
                preparedStatement.setString(6, creditInfo);
                preparedStatement.executeUpdate();
            }
            query = "INSERT INTO Registered (user_id, username, password, language) VALUES (?, ?, ?, ?)";
            try (PreparedStatement preparedStatement = con.prepareStatement(query)){
                preparedStatement.setInt(1, userId);
                preparedStatement.setString(2, username);
                preparedStatement.setString(3, password);
                preparedStatement.setString(4, selectedLanguage);
                preparedStatement.executeUpdate();
            }
            System.out.println("User registered successfully");

        }catch (SQLException e) {
            e.printStackTrace();
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
                                    System.out.println("+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+-----------------------+---------------------+");
                                    System.out.println("| Hotel Reference No.  | User ID              | Room Number          | Brand Affiliation    | Hotel Address        | Checkin Date         | Checkout Date        | Hotel Total Cost     | Room Cost            | Hotel Tax            | Hotel Booking Fees    | Hotel Booking Date  |");
                                    System.out.println("+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+-----------------------+---------------------+");
                                    System.out.printf("| %-20d | %-20d | %-20d | %-20s | %-20s | %-20s | %-20s | %-20.2f | %-20.2f | %-20.2f | %-20.2f | %-20s |\n", hotelReferenceNumber, user_id, roomNumber, brandAffiliation, hotelAddress, checkinDate, checkoutDate, hotelTotalCost, roomCost, hotelTax, hotelBookingFees, hotelBookingDate);
                                }
                                System.out.println("+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+-----------------------+---------------------+");
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
                                    System.out.println("+--------------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+-------------------------+----------------------+----------------------+-------------------------+-----------------------+----------------------+");
                                    System.out.println("| Car Rental Reference No. | User ID              | Car License Plate    | Pickup Location      | Return Location      | Pickup Date Time     | Return Date Time     | Car Rental Booking Date | Car Rental Cost      | Car Rental Tax       | Car Rental Booking Fees | Car Rental Total Cost | Insurance            |");
                                    System.out.println("+--------------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+-------------------------+----------------------+----------------------+-------------------------+-----------------------+----------------------+");
                                    System.out.printf("| %-25d | %-20d | %-20s | %-20s | %-20s | %-20s | %-20s | %-20s | %-20.2f | %-20.2f | %-20.2f | %-20.2f | %-20s |\n", carRentalReferenceNumber, user_id, carLicensePlate, pickupLocation, returnLocation, pickupDateTime, returnDateTime, carRentalBookingDate, carRentalCost, carRentalTax, carRentalBookingFees, carRentalTotalCost, insurance);
                                }
                                System.out.println("+--------------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+-------------------------+----------------------+----------------------+-------------------------+-----------------------+----------------------+");
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
            switch (bookingType) {
                case 1:
                    // Flight booking
                    String fareClass = "";
                    int year = 0;
                    int month = 0;
                    int day = 0;
                    String departureCity ="";
                    String departureCountry = "";
                    String arrivalCity = "";
                    String arrivalCountry = "";
                    String airline = "";
                    String date = "";
                    String flightQuery = "";
                    String fare="";
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
                                        arrivalCity = arrivalCities.get(arrivalCityOption-1);
                                        arrivalCountry = arrivalCountries.get(arrivalCityOption-1);
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
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }                                                       
                    }
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
                case 2:
                    // Hotel booking
                    // Get hotel info from user: check-in date, check-out date, city, country, number of rooms, number of guests
                    // Query for hotel options using the given info
                    // Display hotel options as a sub menu to choose from
                    // Get user input for hotel option
                    // Display room options as a sub menu to choose from
                    // Get user input for room option
                    // Book hotel room by getting user input for booking info (user ID, checkin date, chekout date)
                    // and info from room selected (room number),
                    // and info from hotel selected (brand affiliation, hotel address)
                    // calculate costs (hotel toatal cost, hotel tax, hotel booking fees, hotel booking date),
                    // generate a hotel reference number,
                    // and insert into HotelBooking table
                    return bookingType;
                case 3:
                    // Car rental booking
                    // Get car rental info from user: pickup date time, return date time, pickup location, return location
                    // Query for car rental options using the given info
                    // Display car rental options as a sub menu to choose from
                    // Get user input for car rental option
                    // Book car rental by getting user input for booking info (user ID, pickup date time, return date time, pickup location, return location)
                    // and info from car rental selected (car ar license plate, insurance)
                    // calculate costs (car rental total cost, car rental tax, car rental booking fees, car rental booking date),
                    // generate a car rental reference number,
                    // and insert into CarRentalBooking table
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
   
    static void userHistory(Connection connection, Statement statement, Scanner scanner) throws SQLException{
        boolean flag1 = true;
        scanner.nextLine();
        int userId = 0;

        try {
            while (flag1) {
                System.out.println("Enter username: ");
                String username = scanner.nextLine();
                if (username.length() > 10) {
                    System.out.println("Invalid username. Please try again.");
                    continue;
                }
                String query = "SELECT username FROM Registered WHERE username = ?";
                try (PreparedStatement preparedStatement = connection.prepareStatement(query)){
                    preparedStatement.setString(1, username);
                    try (ResultSet resultSet1 = preparedStatement.executeQuery()){
                        
                        if (!resultSet1.next()) {
                            System.out.println("Username not found. Please try again.");
                            continue;
                        }
                        else {
                            //flag1 = false;
                            boolean valid = false;

                            for (int i=0; i<3; i++){
                                System.out.println("Enter password: ");
                                String password = scanner.nextLine();

                                if (password.length() > 10 || password.length() < 1){
                                    System.out.println("Invalid password. Please try again.");
                                    i--;
                                    continue;
                                }
                                String query2 = "SELECT user_id FROM Registered WHERE username = ? AND password = ?";
                                try (PreparedStatement preparedStatement2 = connection.prepareStatement(query2)){
                                    preparedStatement2.setString(1, username);
                                    preparedStatement2.setString(2, password);
                                    try (ResultSet resultSet2 = preparedStatement2.executeQuery()){
                                        if (!resultSet2.next()){
                                            System.out.println("Wrong password. Please try again.");
                                        } else {
                                            valid = true;
                                            userId = resultSet2.getInt("user_id");
                                            break;
                                        }
                                
                                    }
                                }
                            }
                            if (!valid){
                                System.out.println("You have entered the wrong password too many times. Please try again later.");
                                return;
                            }
                            flag1 = false;
        
                        }
                    }
                }
            }
            System.out.println("User ID: " + userId); //REMOVE THIS LATER
            String query1 = "SELECT * FROM FlightBooking WHERE user_id = ?";
            String query2 = "SELECT * FROM HotelBooking WHERE user_id = ?";
            String query3 = "SELECT * FROM CarRentalBooking WHERE user_id = ?";
            try (PreparedStatement preparedStatement = connection.prepareStatement(query1)){
                preparedStatement.setInt(1, userId);
                try (ResultSet resultSet = preparedStatement.executeQuery()){
                    // Display flight_ref_number, flight_number, hotel_ref_number, brand_affiliation, car_rental_ref_number, car_license_plate
                    // Split into 3 tables for each booking type
                    System.out.println("+---------------------------------+-------------------+");
                    System.out.println("| Flight Booking Reference Number | Flight Number     |");    
                    System.out.println("+---------------------------------+-------------------+");
                    while (resultSet.next()) {
                        int flightRefNumber = resultSet.getInt("flight_reference_number");
                        String flightNumber = resultSet.getString("flight_number");
                        System.out.printf("| %-31d | %-17s |\n", flightRefNumber, flightNumber);
                        //System.out.printf("| %-31d | %-17d |\n", flightRefNumber, flightNumber);
                    }
                    System.out.println("+---------------------------------+-------------------+");
                }
            }
            try (PreparedStatement preparedStatement = connection.prepareStatement(query2)){
                preparedStatement.setInt(1, userId);
                try (ResultSet resultSet = preparedStatement.executeQuery()){
                    // Display hotel_ref_number, brand_affiliation
                    System.out.println("+--------------------------+-------------------+");
                    System.out.println("| Hotel Booking Reference  | Brand Affiliation |");
                    System.out.println("+--------------------------+-------------------+");
                    while (resultSet.next()) {
                        int hotelRefNumber = resultSet.getInt("hotel_reference_number");
                        String brandAffiliation = resultSet.getString("brand_affiliation");
                        System.out.printf("| %-24d | %-17s |\n", hotelRefNumber, brandAffiliation);
                    }
                    System.out.println("+--------------------------+-------------------+");
                }
            }
            try (PreparedStatement preparedStatement = connection.prepareStatement(query3)){
                preparedStatement.setInt(1, userId);
                try (ResultSet resultSet = preparedStatement.executeQuery()){
                    // Display car_rental_ref_number, car_license_plate
                    System.out.println("+--------------------------+-------------------+");
                    System.out.println("| Car Rental Reference     | Car License Plate |");
                    System.out.println("+--------------------------+-------------------+");
                    while (resultSet.next()) {
                        int carRentalRefNumber = resultSet.getInt("car_rental_reference_number");
                        String carLicensePlate = resultSet.getString("car_license_plate");
                        System.out.printf("| %-24d | %-17s |\n", carRentalRefNumber, carLicensePlate);
                    }
                    System.out.println("+--------------------------+-------------------+");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
   
    }
}
