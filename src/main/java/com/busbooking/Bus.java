package com.busbooking;

public class Bus {
    private int id;
    private String busName;
    private String busType;
    private String fromCity;
    private String toCity;
    private String departureTime;
    private String arrivalTime;
    private double price;
    private int availableSeats;

    // 1. Default Constructor
    public Bus() {
    }

    // 2. 7 Parameters Constructor (BusDAO.java line 23-ல் அழைப்பது)
    public Bus(int id, String busName, String fromCity, String toCity, String departureTime, double price, int availableSeats) {
        this.id = id;
        this.busName = busName;
        this.busType = "AC Sleeper";
        this.fromCity = fromCity;
        this.toCity = toCity;
        this.departureTime = departureTime;
        this.arrivalTime = "06:00 AM";
        this.price = price;
        this.availableSeats = availableSeats;
    }

    // 3. 9 Parameters Constructor
    public Bus(int id, String busName, String busType, String fromCity, String toCity, 
               String departureTime, String arrivalTime, double price, int availableSeats) {
        this.id = id;
        this.busName = busName;
        this.busType = busType;
        this.fromCity = fromCity;
        this.toCity = toCity;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.price = price;
        this.availableSeats = availableSeats;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getBusName() { return busName; }
    public void setBusName(String busName) { this.busName = busName; }

    public String getBusType() { return busType; }
    public void setBusType(String busType) { this.busType = busType; }

    public String getFromCity() { return fromCity; }
    public void setFromCity(String fromCity) { this.fromCity = fromCity; }

    public String getToCity() { return toCity; }
    public void setToCity(String toCity) { this.toCity = toCity; }

    public String getDepartureTime() { return departureTime; }
    public void setDepartureTime(String departureTime) { this.departureTime = departureTime; }

    public String getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(String arrivalTime) { this.arrivalTime = arrivalTime; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }
}