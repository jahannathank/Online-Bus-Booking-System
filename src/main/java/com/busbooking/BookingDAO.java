package com.busbooking;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class BookingDAO {

    public static boolean bookTicket(Booking booking) {
        boolean status = false;
        String insertBookingQuery = "INSERT INTO bookings (user_id, bus_id, seats_booked, total_fare) VALUES (?, ?, ?, ?)";
        String updateSeatsQuery = "UPDATE buses SET available_seats = available_seats - ? WHERE id = ? AND available_seats >= ?";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Transaction தொடக்கம்

            // 1. இருக்கைகளைக் குறைக்கும் Query
            try (PreparedStatement psUpdate = con.prepareStatement(updateSeatsQuery)) {
                psUpdate.setInt(1, booking.getSeatsBooked());
                psUpdate.setInt(2, booking.getBusId());
                psUpdate.setInt(3, booking.getSeatsBooked());

                int seatsUpdated = psUpdate.executeUpdate();
                if (seatsUpdated > 0) {
                    // 2. Booking டேபிளில் சேர்க்கும் Query
                    try (PreparedStatement psInsert = con.prepareStatement(insertBookingQuery)) {
                        psInsert.setInt(1, booking.getUserId());
                        psInsert.setInt(2, booking.getBusId());
                        psInsert.setInt(3, booking.getSeatsBooked());
                        psInsert.setDouble(4, booking.getTotalFare());

                        int bookingInserted = psInsert.executeUpdate();
                        if (bookingInserted > 0) {
                            con.commit();
                            status = true;
                        } else {
                            con.rollback();
                        }
                    }
                } else {
                    con.rollback();
                }
            }

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return status;
    }
 // பயனரின் முந்தைய முன்பதிவுகளைப் பெறுதல்
    public static java.util.List<BookingDetails> getBookingsByUserId(int userId) {
        java.util.List<BookingDetails> list = new java.util.ArrayList<>();
        String query = "SELECT b.booking_id, bus.bus_number, bus.source, bus.destination, " +
                       "bus.departure_time, b.seats_booked, b.total_fare, b.booking_date " +
                       "FROM bookings b " +
                       "JOIN buses bus ON b.bus_id = bus.id " +
                       "WHERE b.user_id = ? ORDER BY b.booking_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, userId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingDetails details = new BookingDetails(
                        rs.getInt("booking_id"),
                        rs.getString("bus_number"),
                        rs.getString("source"),
                        rs.getString("destination"),
                        rs.getString("departure_time"),
                        rs.getInt("seats_booked"),
                        rs.getDouble("total_fare"),
                        rs.getTimestamp("booking_date")
                    );
                    list.add(details);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}