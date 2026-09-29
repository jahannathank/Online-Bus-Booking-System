package com.busbooking;

import java.sql.Timestamp;

public class BookingDetails {
    private int bookingId;
    private String busNumber;
    private String source;
    private String destination;
    private String departureTime;
    private int seatsBooked;
    private double totalFare;
    private Timestamp bookingDate;

    public BookingDetails(int bookingId, String busNumber, String source, String destination, 
                          String departureTime, int seatsBooked, double totalFare, Timestamp bookingDate) {
        this.bookingId = bookingId;
        this.busNumber = busNumber;
        this.source = source;
        this.destination = destination;
        this.departureTime = departureTime;
        this.seatsBooked = seatsBooked;
        this.totalFare = totalFare;
        this.bookingDate = bookingDate;
    }

    public int getBookingId() { return bookingId; }
    public String getBusNumber() { return busNumber; }
    public String getSource() { return source; }
    public String getDestination() { return destination; }
    public String getDepartureTime() { return departureTime; }
    public int getSeatsBooked() { return seatsBooked; }
    public double getTotalFare() { return totalFare; }
    public Timestamp getBookingDate() { return bookingDate; }
}