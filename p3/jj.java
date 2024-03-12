//package p3; //remove when submitting

import java.sql.* ;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

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
                            newBooking(statement);
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
/* 
        // Creating a table
        try
        {
          String createSQL = "CREATE TABLE " + tableName + " (id INTEGER, name VARCHAR (25)) ";
          System.out.println (createSQL ) ;
          statement.executeUpdate (createSQL ) ;
          System.out.println ("DONE");
        }
        catch (SQLException e)
        {
          sqlCode = e.getErrorCode(); // Get SQLCODE
          sqlState = e.getSQLState(); // Get SQLSTATE
                
          // Your code to handle errors comes here;
          // something more meaningful than a print would be good
          System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
          System.out.println(e);
         }

        // Inserting Data into the table
        try
        {
          String insertSQL = "INSERT INTO " + tableName + " VALUES ( 1 , \'Vicki\' ) " ;
          System.out.println ( insertSQL ) ;
          statement.executeUpdate ( insertSQL ) ;
          System.out.println ( "DONE" ) ;

          insertSQL = "INSERT INTO " + tableName + " VALUES ( 2 , \'Vera\' ) " ;
          System.out.println ( insertSQL ) ;
          statement.executeUpdate ( insertSQL ) ;
          System.out.println ( "DONE" ) ;
          insertSQL = "INSERT INTO " + tableName + " VALUES ( 3 , \'Franca\' ) " ;
          System.out.println ( insertSQL ) ;
          statement.executeUpdate ( insertSQL ) ;
          System.out.println ( "DONE" ) ;

        }
        catch (SQLException e)
        {
          sqlCode = e.getErrorCode(); // Get SQLCODE
          sqlState = e.getSQLState(); // Get SQLSTATE
                
          // Your code to handle errors comes here;
          // something more meaningful than a print would be good
          System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
          System.out.println(e);
        }

        // Querying a table
        try
        {
          String querySQL = "SELECT id, name from " + tableName + " WHERE NAME = \'Vicki\'";
          System.out.println (querySQL) ;
          java.sql.ResultSet rs = statement.executeQuery ( querySQL ) ;

          while ( rs.next ( ) )
          {
            int id = rs.getInt ( 1 ) ;
            String name = rs.getString (2);
            System.out.println ("id:  " + id);
            System.out.println ("name:  " + name);
          }
         System.out.println ("DONE");
        }
        catch (SQLException e)
        {
          sqlCode = e.getErrorCode(); // Get SQLCODE
          sqlState = e.getSQLState(); // Get SQLSTATE
                
          // Your code to handle errors comes here;
          // something more meaningful than a print would be good
          System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
          System.out.println(e);
        }

      //Updating a table
      try
      {
        String updateSQL = "UPDATE " + tableName + " SET NAME = \'Mimi\' WHERE id = 3";
        System.out.println(updateSQL);
        statement.executeUpdate(updateSQL);
        System.out.println("DONE");

        // Dropping a table
        String dropSQL = "DROP TABLE " + tableName;
        System.out.println ( dropSQL ) ;
        statement.executeUpdate ( dropSQL ) ;
        System.out.println ("DONE");
      }
      catch (SQLException e)
      {
        sqlCode = e.getErrorCode(); // Get SQLCODE
        sqlState = e.getSQLState(); // Get SQLSTATE
                
        // Your code to handle errors comes here;
        // something more meaningful than a print would be good
        System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
        System.out.println(e);
      }

      // Finally but importantly close the statement and connection
      statement.close ( ) ;
      con.close ( ) ;
      */
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
    static void newBooking(Statement statement) throws SQLException {
        try {
            boolean flag2 = false;
                while(!flag2) {
                    // get user info
                    // user or registered
                    System.out.println("Are you a registered user?");
                    System.out.println("    1. Yes");
                    System.out.println("    2. No");
                    System.out.print("Please Enter Your Option Number: ");
                    int option = Integer.parseInt(System.console().readLine());
                    switch (option) {
                        case 1:
                            // Registered user
                            // Get user info from user: username, password
                            // Taking user input for username and password
                            while (true) {
                                System.out.print("Enter the username: ");
                                String userName = System.console().readLine();
                                if (userName.length() > 10) {
                                    System.out.println("Username is too long. Please try again.");
                                    continue;
                                }
                                // check if user exists
                                try (ResultSet resultSet = statement.executeQuery("SELECT username FROM Registered WHERE username = '" + userName + "'")) {
                                    if (!resultSet.next()) {
                                        System.out.println("User does not exist or is not registered. Please try again.");
                                        continue;
                                    } else {
                                        // check password
                                        boolean goodpass = false;
                                        for (int i = 0; i < 3; i++) {
                                            System.out.print("Enter the password: ");
                                            String password = System.console().readLine();
                                            if (password.length() > 10) {
                                                System.out.println("Password is too long. Please try again.");
                                                i--;
                                                continue;
                                            }
                                            try (ResultSet resultSet2 = statement.executeQuery("SELECT password FROM Registered WHERE username = '" + userName + "' AND password = '" + password + "'")) {
                                                if (!resultSet2.next()) {
                                                    System.out.println("Password is incorrect. Please try again.");
                                                    continue;
                                                } else {
                                                    goodpass = true;
                                                    break;
                                                }
                                            }
                                        }
                                        if (!goodpass) {
                                            System.out.println("You have entered the wrong password too many times. Please try again later.");
                                            return;
                                        }
                                    }
                                }
                            }
                            // Query for user_id using the given username and password
                            // Get user input for booking type
                            //bookanything(statement);
                            //flag2 = true;
                            //break;
                        case 2:
                            // New user
                            // Get user info from user: name, email, phone number, address, credit card information, language
                            // create a unique user_id
                            // Insert into Users table
                            // Get user info from user: booking type
                            bookanything(statement);
                            flag2 = true;
                            break;
                        default:
                            System.out.println("Invalid option. Please try again.");
                            break;
                    }
                }
                if (flag2) {
                    // Query for booking info
                    try (ResultSet resultSet = statement.executeQuery("SELECT * FROM TableName WHERE condition")) {
                        // Process and display query results
                        while (resultSet.next()) {
                            // Process each row of the result set
                            // Example: String data = resultSet.getString("columnName");
                        }
                        // Print booking success message
                        System.out.println("Booking successful");
                    }
                }
            }   
            catch (SQLException e) {
                e.printStackTrace(); 
        }
    }
    //helper to book
    static void bookanything(Statement statement) throws SQLException {
        // Get user input for booking type
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
                break;
            default:
                System.out.println("Invalid option. Please try again.");
                break;
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
                                                    System.out.println("Please Enter Your Option Number: ");
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
