package com.busbooking;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class TestConnection {
    public static void main(String[] args) {
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            if (con != null) {
                System.out.println("==========================================");
                System.out.println("   MYSQL DATABASE CONNECTED SUCCESSFULLY  ");
                System.out.println("==========================================");

                st = con.createStatement();

                // 1. BUSES அட்டவணையைச் சோதித்தல்
                System.out.println("\n[1] --- BUSES LIST IN DATABASE ---");
                rs = st.executeQuery("SELECT * FROM buses");
                int busCount = 0;
                while (rs.next()) {
                    busCount++;
                    System.out.println("Bus ID: " + rs.getInt("id") 
                            + " | Bus No: " + rs.getString("bus_number")
                            + " | Route: " + rs.getString("source") + " -> " + rs.getString("destination")
                            + " | Time: " + rs.getString("departure_time")
                            + " | Fare: Rs. " + rs.getDouble("fare")
                            + " | Seats Available: " + rs.getInt("available_seats"));
                }
                if (busCount == 0) {
                    System.out.println("No buses found in 'buses' table!");
                }

                rs.close();

                // 2. BOOKINGS அட்டவணையைச் சோதித்தல் (Dynamic Column Viewer)
                System.out.println("\n[2] --- BOOKINGS LIST IN DATABASE ---");
                rs = st.executeQuery("SELECT * FROM bookings");
                ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();

                int bookingCount = 0;
                while (rs.next()) {
                    bookingCount++;
                    StringBuilder row = new StringBuilder("Booking #" + bookingCount + ": ");
                    for (int i = 1; i <= columnCount; i++) {
                        String colName = metaData.getColumnName(i);
                        Object val = rs.getObject(i);
                        row.append(colName).append("=").append(val).append(" | ");
                    }
                    System.out.println(row.toString());
                }

                if (bookingCount == 0) {
                    System.out.println("-> 'bookings' table is currently EMPTY (0 records).");
                    System.out.println("-> Let's insert a test booking record now...");

                    // சாம்பிள் முன்பதிவு ஒன்றைச் சேர்ப்பது (Insert Test Record)
                    try {
                        String insertTest = "INSERT INTO bookings (user_id, bus_id, seats_booked, total_fare) "
                                          + "SELECT u.id, b.id, 2, 1300.00 FROM users u, buses b LIMIT 1";
                        int inserted = st.executeUpdate(insertTest);
                        if (inserted > 0) {
                            System.out.println("-> Successfully inserted a test booking into MySQL!");
                        }
                    } catch (Exception insertEx) {
                        System.out.println("Note on auto-insert: " + insertEx.getMessage());
                    }
                }

                System.out.println("\n==========================================");
                System.out.println("           TEST COMPLETED                ");
                System.out.println("==========================================");
            }
        } catch (Exception e) {
            System.err.println("Database Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (con != null) con.close();
            } catch (Exception e) {
                // Ignore
            }
        }
    }
}