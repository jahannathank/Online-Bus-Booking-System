package com.busbooking;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BusDAO {

    public List<Bus> searchBuses(String fromCity, String toCity) {
        List<Bus> busList = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            if (con != null) {
                String sql = "SELECT * FROM buses WHERE LOWER(from_city) LIKE LOWER(?) AND LOWER(to_city) LIKE LOWER(?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, "%" + (fromCity != null ? fromCity.trim() : "") + "%");
                ps.setString(2, "%" + (toCity != null ? toCity.trim() : "") + "%");
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    Bus b = new Bus();
                    b.setId(rs.getInt("id"));
                    b.setBusName(rs.getString("bus_name"));
                    
                    try { b.setBusType(rs.getString("bus_type")); } catch(Exception e) { b.setBusType("AC Sleeper"); }
                    
                    b.setFromCity(rs.getString("from_city"));
                    b.setToCity(rs.getString("to_city"));
                    b.setDepartureTime(rs.getString("departure_time"));
                    
                    try { b.setArrivalTime(rs.getString("arrival_time")); } catch(Exception e) { b.setArrivalTime("06:00 AM"); }
                    
                    b.setPrice(rs.getDouble("price"));
                    b.setAvailableSeats(rs.getInt("available_seats"));
                    busList.add(b);
                }
                con.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // DB-யில் பஸ் இல்லையென்றால் மாதிரி பஸ்களை அனுப்பும்
        if (busList.isEmpty()) {
            Bus b1 = new Bus();
            b1.setId(101);
            b1.setBusName("KPN Travels");
            b1.setBusType("AC Sleeper 2+1");
            b1.setFromCity(fromCity != null ? fromCity : "Chennai");
            b1.setToCity(toCity != null ? toCity : "Madurai");
            b1.setDepartureTime("20:30");
            b1.setArrivalTime("05:00");
            b1.setPrice(650.0);
            b1.setAvailableSeats(18);
            busList.add(b1);

            Bus b2 = new Bus();
            b2.setId(102);
            b2.setBusName("SRS Travels");
            b2.setBusType("Non-AC Semi-Sleeper");
            b2.setFromCity(fromCity != null ? fromCity : "Chennai");
            b2.setToCity(toCity != null ? toCity : "Madurai");
            b2.setDepartureTime("21:15");
            b2.setArrivalTime("06:15");
            b2.setPrice(480.0);
            b2.setAvailableSeats(24);
            busList.add(b2);
        }

        return busList;
    }
}