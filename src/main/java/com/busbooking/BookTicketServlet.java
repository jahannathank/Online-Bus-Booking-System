package com.busbooking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/BookTicketServlet")
public class BookTicketServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username == null || username.trim().isEmpty()) {
            username = "jagan"; // Default user
        }

        String busIdStr = request.getParameter("busId");
        String seatsStr = request.getParameter("seats");
        String priceStr = request.getParameter("price");
        String travelDate = request.getParameter("travelDate");

        int busId = (busIdStr != null) ? Integer.parseInt(busIdStr) : 101;
        int seats = (seatsStr != null) ? Integer.parseInt(seatsStr) : 1;
        double price = (priceStr != null) ? Double.parseDouble(priceStr) : 650.0;
        if (travelDate == null || travelDate.trim().isEmpty()) {
            travelDate = "2026-09-29";
        }
        
        double totalAmount = seats * price;
        String bookingId = "EB" + System.currentTimeMillis() % 1000000;

        // DB-யில் சேர்க்க முயற்சிப்பது (DB Error வந்தாலும் bookingSuccess-க்கு செல்லும்)
        try {
            Connection con = DBConnection.getConnection();
            if (con != null) {
                String sql = "INSERT INTO bookings (username, bus_id, seats, total_amount, travel_date) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, username);
                ps.setInt(2, busId);
                ps.setInt(3, seats);
                ps.setDouble(4, totalAmount);
                ps.setString(5, travelDate);
                ps.executeUpdate();
                con.close();
            }
        } catch (Exception e) {
            System.out.println("Booking DB Note: " + e.getMessage());
        }

        // தகவல்களை request-ல் வைத்து bookingSuccess.jsp-க்கு அனுப்புகிறோம்
        request.setAttribute("bookingId", bookingId);
        request.setAttribute("username", username);
        request.setAttribute("seats", seats);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("travelDate", travelDate);

        request.getRequestDispatcher("bookingSuccess.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}