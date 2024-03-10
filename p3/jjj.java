//package p3; //remove when submitting

import java.sql.* ;

class jjj //find better name
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
        try {
            boolean run = true;
            while(run) {
                //Add argument validity check (such as string lenghts)
                System.out.println("\nBookings Main Menu: ");
                System.out.println("    1. Find all booking total costs for a given user"); //query //Change to register User
                System.out.println("    2. Add a new booking for a user"); //choose type (fight, hotel, car) //get info //query for options //book (create booking and insert) 
                System.out.println("    3. Update a user's profile information"); //query for user //update
                System.out.println("    4. Flight Cancellation"); //query for flight bookings //query for next available flight //update bookings for all users //delete flight 
                System.out.println("    5. Find all bookings for a given user (booking history)"); //Change the displayed fields through subqueries later
                System.out.println("    6. Quit");
                System.out.print("Please Enter Your Option Number: ");

                int option = Integer.parseInt(System.console().readLine());

                switch (option) {
                    case 1:
                        registerUser(statement);
                        //bookingTotalCosts(statement);
                        break;
                    case 2:
                        newBooking(statement);
                        break;
                    case 3:
                        updateData(statement);
                        break;
                    case 4:
                        deleteData(statement);
                        break;
                    case 5:
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
    
    static void registerUser(Statement statement) throws SQLException {
        boolean flag = true;
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

        while (flag4){
            // Taking user input for name
            System.out.print("Enter your name: ");
            name = System.console().readLine();
            //Check if name is within the length limit
            if (name.length() > 25 || name.length() < 1){
                System.out.println("Invalid name length. Please try again.");
                continue;
            } 
            else {
                flag4 = false;
            }
        }

        while (flag5) {
            // Taking user input for email
            System.out.print("Enter your email: ");
            email = System.console().readLine();
            //Check if email is within the length limit
            if (email.length() > 40 || email.length() < 1){
                System.out.println("Invalid email length. Please try again.");
                continue;
            } 
            else {
                flag5 = false;
            }
        }

        while (flag6) {
            // Taking user input for phone number
            System.out.print("Enter your phone number: ");
            phoneNum = System.console().readLine();
            //Check if phone number is within the length limit
            if (phoneNum.length() > 22 || phoneNum.length() < 1){
                System.out.println("Invalid phone number length. Please try again.");
                continue;
            } 
            else {
                flag6 = false;
            }
        }

        while (flag7) {
            // Taking user input for address
            System.out.print("Enter your address: ");
            address = System.console().readLine();
            //Check if address is within the length limit
            if (address.length() > 50 || address.length() < 1){
                System.out.println("Invalid address length. Please try again.");
                continue;
            } 
            else {
                flag7 = false;
            }
        }

        while (flag8) {
            // Taking user input for credit card info
            System.out.print("Enter your credit card info: ");
            creditInfo = System.console().readLine();
            //Check if credit card info is within the length limit
            if (creditInfo.length() > 28 || creditInfo.length() < 1){
                System.out.println("Invalid credit card info length. Please try again.");
                continue;
            } 
            else {
                flag8 = false;
            }
        }
    
        while (flag) {
            // Taking user input for username
            System.out.print("Choose a username: ");
            username = System.console().readLine();
            //Check if username is within the length limit
            if (username.length() > 10 || username.length() < 1){
                System.out.println("Invalid username length. Please try again.");
                continue;
            } 
            //check if username already exists
            ResultSet resultSet = statement.executeQuery("SELECT username FROM Registered WHERE username = " + "'" + username + "'");
            if (resultSet.next()) {
                System.out.println("Username already exists. Please try again.");
                resultSet.close();
                continue;
            }
            else {
                
                while (flag2) {
                    System.out.print("Choose a password: ");
                    password = System.console().readLine();
                    //Check if password is within the length limit
                    if (password.length() > 10 || password.length() < 1) {
                        System.out.println("Invalid password length. Please try again.");
                        continue;
                    }
                    System.out.print("Re-enter password: ");
                    String password2 = System.console().readLine();
                    if (!password.equals(password2)) {
                        System.out.println("Passwords do not match. Please try again.");
                        continue;
                    }
                    else {
                        flag2 = false;
                    }
                }    
                
                while (flag3) {
                    
                    //Choose language
                    System.out.println("Choose a language: ");
                    System.out.println("    1. English");
                    System.out.println("    2. French");
                    System.out.print("Please Enter Your Option Number: ");
                    int language = Integer.parseInt(System.console().readLine());

                    
                    switch (language) {
                        case 1:
                            selectedLanguage = "en";
                            flag3 = false;
                            break;
                    
                        case 2:
                            selectedLanguage = "fr";
                            flag3 = false;
                            break;
                        default:
                            System.out.println("Invalid option. Please try again.");
                            break;
                    }
                }
                flag = false;
                resultSet.close();
            }
        }

        //From the Users table, retrie


        // Insert user info into Users and Registered tables





    }

    // Method to insert data
    //choose type (fight, hotel, car) //get info //query for options //book (create booking and insert) 
    static void newBooking(Statement statement) throws SQLException {
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
                boolean flag2 = false;
                while(!flag2) {
                    // Taking user input for booking type
                    System.out.println("Choose the booking type: ");
                    System.out.println("    1. Flight");
                    System.out.println("    2. Hotel");
                    System.out.println("    3. Car Rental");
                    System.out.print("Please Enter Your Option Number: ");
                    int bookingType = Integer.parseInt(System.console().readLine());
            
                    switch (bookingType) {
                        case 1:
                            // Flight booking
                            // Get flight info from user: departure date time, airline, fare class, departure city and country, arrival city and country, departure date
                            // Query for flight options using the given info
                            // Display flight options as a sub menu to choose from
                            // Get user input for flight option
                            // Book flight by getting user input for booking info (user ID, passenger names) 
                            // and other info from the flight selected (flight number, departure date time, flight cost given fare class), 
                            // and calculate the costs (flight total cost, plane ticket cost, plane ticket surcharge, plane ticket tax, flight booking fees, flight booking date),
                            // and generate a flight reference number, 
                            // and insert into FlightBooking table
                            
                            flag2 = true;
                            break;
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
            
                            flag2 = true;
                            break;
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
            
                            flag2 = true;
                            break;
                        default:
                            System.out.println("Invalid option. Please try again.");
                            break;
                    }
                }
                // Query for booking info
                resultSet = statement.executeQuery("SELECT * FROM TableName WHERE condition");
                // Process and display query results
                while (resultSet.next()) {
                    // Process each row of the result set
                    // Example: String data = resultSet.getString("columnName");
                }
                // Print booking success message
                System.out.println("Booking successful");

                flag = false;
                resultSet.close(); 
            }
        }    
    }

    // Method to update data
    //query for user //update
    static void updateData(Statement statement) throws SQLException {
        // Taking user input for user id
        System.out.print("Enter the user id: ");
        int userId = Integer.parseInt(System.console().readLine());
        // Query for user
        ResultSet resultSet = statement.executeQuery("SELECT * FROM TableName WHERE user_id = " + userId);
        // Process and display query results
        while (resultSet.next()) {
            // Process each row of the result set
            // Example: String data = resultSet.getString("columnName");
        }
        //ask for new info
        // Update user info
        // Execute update statement
        statement.executeUpdate("UPDATE TableName SET columnName = value WHERE condition");
        System.out.println("Data updated successfully");
        resultSet.close();
    }

    // Method to delete data using multiple sql statements
    //get flight reference number for cancelled flight //query for flight bookings with that flight //query for next available flight closest date to same location //update bookings for all users who had the cancelled flight to the next available one //delete cancelled flight
    static void deleteData(Statement statement) throws SQLException {
        // Taking user input for flight reference number
        System.out.print("Enter the flight reference number: ");
        int flightReferenceNumber = Integer.parseInt(System.console().readLine());
        // Query for flight bookings with that flight
        ResultSet resultSet = statement.executeQuery("SELECT * FROM TableName WHERE flight_reference_number = " + flightReferenceNumber);
        // Process and display query results
        while (resultSet.next()) {
            // Process each row of the result set
            // Example: String data = resultSet.getString("columnName");
        }
        resultSet.close();
        // Query for next available flight closest date to same location
        resultSet = statement.executeQuery("SELECT * FROM TableName WHERE condition");
        // Process and display query results
        while (resultSet.next()) {
            // Process each row of the result set
            // Example: String data = resultSet.getString("columnName");
        }
        resultSet.close();
        // Update bookings for all users who had the cancelled flight to the next available one
        // Execute update statement
        statement.executeUpdate("UPDATE TableName SET columnName = value WHERE condition");
        System.out.println("Data updated successfully");
        // Delete cancelled flight
        // Execute delete statement
        statement.executeUpdate("DELETE FROM TableName WHERE condition");
        System.out.println("Data deleted successfully");
    }

    // Method for querying Find all bookings for a given user (booking history)
    static void userHistory(Statement statement) throws SQLException {
        boolean flag = true;
        while (flag) {
            // Taking user input for user id
            System.out.print("Enter username: ");
            String username = System.console().readLine();
            //Check if username is within the length limit
            if (username.length() > 10) {
                System.out.println("Invalid username. Please try again.");
                continue;
            } 

            ResultSet resultSet = statement.executeQuery("SELECT user_id FROM Registered WHERE username = " + "'" + username + "'");
            if (!resultSet.next()) {
                System.out.println("User does not exist. Please try again.");
                continue;
            }
            else {
                //Validate password
                boolean valid = false;
                for (int i = 0; i < 3; i++) {
                    System.out.print("Enter password: ");
                    String password = System.console().readLine();
                    //Check if password is within the length limit
                    if (password.length() > 10) {
                        System.out.println("Invalid password. Please try again.");
                        i--;
                        continue;
                    }
                    resultSet = statement.executeQuery("SELECT user_id FROM Registered WHERE username = " + "'" + username + "'" + " AND password = " + "'" + password + "'");
                    if (!resultSet.next()) {
                        System.out.println("Invalid password. Please try again.");
                        continue;
                    } else {
                        valid = true;
                        break;
                    }
                }
                if (!valid) {
                    System.out.println("You have entered the wrong password too many times. Please try again later.");
                    return;
                }
                
                // Query for user bookings. in each bookings table, get all bookings for the user and display
                // Process and display query results
                flag = false;
                //get user id
                int userId = resultSet.getInt("user_id");
                System.out.println("User ID: " + userId); //REMOVE THIS LATER 
                String query = "SELECT * FROM FlightBooking WHERE user_id = " + userId + " UNION SELECT * FROM HotelBooking WHERE user_id = " + userId + " UNION SELECT * FROM CarRentalBooking WHERE user_id = " + userId;
                resultSet = statement.executeQuery(query);
                // Display flight_ref_number, flight_number, hotel_ref_number, brand_affiliation, car_rental_ref_number, car_license_plate
                // Split into 3 tables for each booking type
                System.out.println("+---------------------------------+-------------------+");
                System.out.println("| Flight Booking Reference Number | Flight Number     |");    
                System.out.println("+---------------------------------+-------------------+");
                while (resultSet.next()) {
                    int flightRefNumber = resultSet.getInt("flight_ref_number");
                    int flightNumber = resultSet.getInt("flight_number");
                    System.out.printf("| %-31d | %-17d |\n", flightRefNumber, flightNumber);
                }
                System.out.println("+---------------------------------+-------------------+");
                // Display hotel_ref_number, brand_affiliation
                System.out.println("+--------------------------+-------------------+");
                System.out.println("| Hotel Booking Reference  | Brand Affiliation |");
                System.out.println("+--------------------------+-------------------+");
                while (resultSet.next()) {
                    int hotelRefNumber = resultSet.getInt("hotel_ref_number");
                    String brandAffiliation = resultSet.getString("brand_affiliation");
                    System.out.printf("| %-24d | %-17s |\n", hotelRefNumber, brandAffiliation);
                }
                System.out.println("+--------------------------+-------------------+");
                // Display car_rental_ref_number, car_license_plate
                System.out.println("+--------------------------+-------------------+");
                System.out.println("| Car Rental Reference     | Car License Plate  |");
                System.out.println("+--------------------------+-------------------+");
                while (resultSet.next()) {
                    int carRentalRefNumber = resultSet.getInt("car_rental_ref_number");
                    String carLicensePlate = resultSet.getString("car_license_plate");
                    System.out.printf("| %-24d | %-17s |\n", carRentalRefNumber, carLicensePlate);
                }
                System.out.println("+--------------------------+-------------------+");
                resultSet.close();
            }
        }
    }

            


            /* 
            //check if user exists
            ResultSet resultSet = statement.executeQuery("SELECT user_id FROM Users WHERE user_id = " + userId);
            if (!resultSet.next()) {
                System.out.println("User does not exist. Please try again.");
                continue;
            }
            else {
                // Query for user bookings. in each bookings table, get all bookings for the user and display
                // Process and display query results
                flag = false;
                //String query = 
                while (resultSet.next()) {
                    // Process each row of the result set
                    // Example: String data = resultSet.getString("columnName");
                }
                flag = false;
                resultSet.close(); 
            }*/
        
    
    
    

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
}
