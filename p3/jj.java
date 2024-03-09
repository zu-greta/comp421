//package p3; //remove when submitting

import java.sql.* ;

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
        String your_userid = null;
        String your_password = null;
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
                System.out.println("\nBookings Main Menu: ");
                System.out.println("    1. Find all booking total costs for a given user"); //query
                System.out.println("    2. Add a new booking for a user"); //choose type (fight, hotel, car) //get info //query for options //book (create booking and insert) 
                System.out.println("    3. Update a user's profile information"); //query for user //update
                System.out.println("    4. Flight Cancellation"); //query for flight bookings //query for next available flight //update bookings for all users //delete flight 
                System.out.println("    5. Find all bookings for a given user (booking history)"); //query
                System.out.println("    6. Quit");
                System.out.print("Please Enter Your Option Number: ");

                int option = Integer.parseInt(System.console().readLine());

                switch (option) {
                    case 1:
                        bookingTotalCosts(statement);
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
        ResultSet resultSet = statement.executeQuery("SELECT user_id FROM User WHERE user_id = " + userId);
        if (!resultSet.next()) {
            System.out.println("User does not exist. Please try again.");
            resultSet.close();
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
            while (resultSet.next()) {
                int resultUserId = resultSet.getInt("user_id");
                double flightTotalCost = resultSet.getDouble("flight_total_cost");
                double hotelTotalCost = resultSet.getDouble("hotel_total_cost");
                double carRentalTotalCost = resultSet.getDouble("car_rental_total_cost");
                System.out.printf("| %-10d | %-17.2f | %-16.2f | %-21.2f |\n", resultUserId, flightTotalCost, hotelTotalCost, carRentalTotalCost);
            }
            System.out.println("+------------+-------------------+------------------+-----------------------+");
            resultSet.close(); 
            resultSet2.close();
        }
    }   
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
