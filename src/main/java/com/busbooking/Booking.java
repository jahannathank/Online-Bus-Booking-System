package com.busbooking;

import java.sql.Timestamp;

public class Booking {
    private int bookingId;
    private int userId;
    private int busId;
    private int seatsBooked;
    private double totalFare;
    private Timestamp bookingDate;

    public Booking() {}

    public Booking(int userId, int busId, int seatsBooked, double totalFare) {
        this.userId = userId;
        this.busId = busId;
        this.seatsBooked = seatsBooked;
        this.totalFare = totalFare;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getBusId() {
        return busId;
    }

    public void setBusId(int busId) {
        this.busId = busId;
    }

    public int getSeatsBooked() {
        return seatsBooked;
    }

    public void setSeatsBooked(int seatsBooked) {
        this.seatsBooked = seatsBooked;
    }

    public double getTotalFare() {
        return totalFare;
    }

    public void setTotalFare(double totalFare) {
        this.totalFare = totalFare;
    }

    public Timestamp getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Timestamp bookingDate) {
        this.bookingDate = bookingDate;
    }
}