package com.busbooking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SearchBusServlet")
public class SearchBusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String date = request.getParameter("date");

        if (from == null || from.trim().isEmpty()) from = "Chennai";
        if (to == null || to.trim().isEmpty()) to = "Madurai";
        if (date == null || date.trim().isEmpty()) date = "2026-09-29";

        List<Bus> busList = new ArrayList<>();

        // 1. Database-ல் பஸ்களைத் தேட முயற்சிப்பது
        try {
            Connection con = DBConnection.getConnection();
            if (con != null) {
                String sql = "SELECT * FROM buses WHERE LOWER(from_city) LIKE LOWER(?) AND LOWER(to_city) LIKE LOWER(?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, "%" + from.trim() + "%");
                ps.setString(2, "%" + to.trim() + "%");
                ResultSet rs = ps.executeQuery();
                
                while (rs.next()) {
                    Bus b = new Bus();
                    b.setId(rs.getInt("id"));
                    b.setBusName(rs.getString("bus_name"));
                    b.setBusType(rs.getString("bus_type"));
                    b.setFromCity(rs.getString("from_city"));
                    b.setToCity(rs.getString("to_city"));
                    b.setDepartureTime(rs.getString("departure_time"));
                    b.setArrivalTime(rs.getString("arrival_time"));
                    b.setPrice(rs.getDouble("price"));
                    b.setAvailableSeats(rs.getInt("available_seats"));
                    busList.add(b);
                }
                con.close();
            }
        } catch (Exception e) {
            System.out.println("DB Search notice (fallback will be used): " + e.getMessage());
        }

        // 2. டேட்டாபேஸில் தரவு இல்லையெனில் உடனே இயங்குவதற்காக மாதிரி பஸ்களைச் சேர்த்தல்
        if (busList.isEmpty()) {
            busList.add(new Bus(101, "KPN Travels", "AC Sleeper 2+1", from, to, "20:30", "05:00", 650.0, 18));
            busList.add(new Bus(102, "SRS Travels", "Non-AC Push Back 2+2", from, to, "21:15", "06:15", 480.0, 24));
            busList.add(new Bus(103, "Parveen Travels", "Scania AC Multi-Axle", from, to, "22:00", "06:30", 790.0, 12));
            busList.add(new Bus(104, "VRL Travels", "Volvo A/C Semi-Sleeper", from, to, "23:00", "07:15", 550.0, 20));
        }

        // Data-வை bookTicket.jsp பக்கத்திற்கு அனுப்புகிறோம்
        request.setAttribute("busList", busList);
        request.setAttribute("searchFrom", from);
        request.setAttribute("searchTo", to);
        request.setAttribute("searchDate", date);

        request.getRequestDispatcher("bookTicket.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}