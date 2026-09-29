<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || username.trim().isEmpty()) {
        username = "jagan";
    }

    List<Map<String, String>> sessionBookings = (List<Map<String, String>>) session.getAttribute("sessionBookings");
    int totalBookings = (sessionBookings != null) ? sessionBookings.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - QuickBus</title>
    
    <!-- Google Fonts & Font Awesome Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Libre+Barcode+39+Text&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --redbus: #d84e55;
            --redbus-dark: #b8363d;
            --navy: #1e293b;
            --success: #10b981;
            --surface: #ffffff;
            --bg: #f4f5f8;
            --border: #e5e7eb;
            --text-main: #111827;
            --text-muted: #6b7280;
            --radius-lg: 16px;
            --radius-md: 10px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; }
        body { background-color: var(--bg); color: var(--text-main); min-height: 100vh; padding-bottom: 4rem; }

        /* Top Navigation */
        .navbar {
            background: #ffffff;
            border-bottom: 1px solid var(--border);
            padding: 0.85rem 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 4px rgba(0,0,0,0.03);
        }
        .brand {
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--redbus);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .nav-links { display: flex; align-items: center; gap: 1rem; }
        .user-tag {
            background: #f3f4f6;
            padding: 6px 14px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 0.88rem;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .btn-home {
            background: #fee2e2;
            color: var(--redbus);
            padding: 7px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.88rem;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }
        .btn-home:hover { background: var(--redbus); color: white; }

        /* Page Layout */
        .container { max-width: 980px; margin: 2.5rem auto 0; padding: 0 1.2rem; }
        
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 1.8rem;
            flex-wrap: wrap;
            gap: 12px;
        }
        .header-section h1 { font-size: 1.6rem; font-weight: 800; color: var(--navy); }
        .header-section p { font-size: 0.88rem; color: var(--text-muted); margin-top: 2px; }

        /* Filter Tabs */
        .filter-tabs {
            display: flex;
            gap: 8px;
            background: #e5e7eb;
            padding: 4px;
            border-radius: 10px;
        }
        .tab-btn {
            background: transparent;
            border: none;
            padding: 6px 16px;
            border-radius: 7px;
            font-size: 0.85rem;
            font-weight: 700;
            color: #4b5563;
            cursor: pointer;
            transition: all 0.2s;
        }
        .tab-btn.active {
            background: #ffffff;
            color: var(--text-main);
            box-shadow: 0 2px 5px rgba(0,0,0,0.06);
        }

        /* Modern Ticket Card */
        .ticket-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            margin-bottom: 1.4rem;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .ticket-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.06);
        }

        .ticket-head {
            background: #f8fafc;
            border-bottom: 1px dashed var(--border);
            padding: 1rem 1.6rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .pnr-pill {
            font-weight: 800;
            font-size: 0.88rem;
            color: var(--navy);
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .status-confirmed {
            background: #dcfce7;
            color: #15803d;
            font-size: 0.75rem;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .ticket-body {
            padding: 1.6rem;
            display: grid;
            grid-template-columns: 2fr 1.2fr 1fr;
            align-items: center;
            gap: 20px;
        }

        .operator-title { font-size: 1.25rem; font-weight: 800; color: var(--navy); }
        .route-path {
            font-size: 1rem;
            font-weight: 700;
            color: #374151;
            margin: 6px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .route-path i { color: var(--redbus); font-size: 0.9rem; }

        .time-date-box {
            font-size: 0.88rem;
            color: var(--text-muted);
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .time-date-box strong { color: var(--text-main); }

        .price-col {
            text-align: right;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            justify-content: center;
        }
        .fare-amount { font-size: 1.45rem; font-weight: 800; color: var(--success); }
        .fare-sub { font-size: 0.75rem; color: var(--text-muted); margin-top: 2px; }

        /* Card Footer Actions */
        .ticket-footer {
            border-top: 1px solid var(--border);
            padding: 0.9rem 1.6rem;
            background: #fafafa;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.85rem;
        }
        .boarding-info { color: #4b5563; font-weight: 600; }
        .boarding-info i { color: var(--redbus); margin-right: 4px; }

        .action-btns { display: flex; gap: 8px; }
        .btn-action {
            border: 1px solid var(--border);
            background: white;
            color: #374151;
            padding: 6px 14px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 0.82rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }
        .btn-action:hover {
            border-color: var(--redbus);
            color: var(--redbus);
            background: #fef2f2;
        }

        /* Empty State */
        .empty-card {
            background: white;
            border: 2px dashed #cbd5e1;
            border-radius: var(--radius-lg);
            padding: 4rem 2rem;
            text-align: center;
            margin-top: 1rem;
        }
        .empty-icon-wrap {
            width: 80px;
            height: 80px;
            background: #fef2f2;
            color: var(--redbus);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            margin: 0 auto 1.2rem;
        }
        .empty-card h3 { font-size: 1.3rem; font-weight: 800; color: var(--navy); margin-bottom: 6px; }
        .empty-card p { color: var(--text-muted); font-size: 0.92rem; max-width: 400px; margin: 0 auto 1.5rem; }
        .btn-book-now {
            background: var(--redbus);
            color: white;
            padding: 12px 26px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 800;
            font-size: 0.95rem;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(216, 78, 85, 0.25);
            transition: background 0.2s;
        }
        .btn-book-now:hover { background: var(--redbus-dark); }

        @media (max-width: 768px) {
            .navbar { padding: 0.85rem 1.5rem; }
            .ticket-body { grid-template-columns: 1fr; gap: 12px; }
            .price-col { text-align: left; align-items: flex-start; }
            .ticket-footer { flex-direction: column; align-items: flex-start; gap: 10px; }
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <nav class="navbar">
        <a href="dashboard.jsp" class="brand">
            <i class="fa-solid fa-bus"></i> QuickBus
        </a>
        <div class="nav-links">
            <div class="user-tag">
                <i class="fa-solid fa-circle-user" style="color: var(--redbus);"></i> <%= username %>
            </div>
            <a href="dashboard.jsp" class="btn-home">
                <i class="fa-solid fa-compass"></i> Book Another Bus
            </a>
        </div>
    </nav>

    <!-- Main Content Area -->
    <div class="container">
        
        <div class="header-section">
            <div>
                <h1>My Booked Tickets</h1>
                <p>Manage, print, and view details of all your bus reservations</p>
            </div>

            <!-- Filter Tabs -->
            <div class="filter-tabs">
                <button class="tab-btn active">All (<%= totalBookings %>)</button>
                <button class="tab-btn">Upcoming</button>
                <button class="tab-btn">Completed</button>
            </div>
        </div>

        <%
            if (sessionBookings != null && !sessionBookings.isEmpty()) {
                for (Map<String, String> b : sessionBookings) {
                    String pnr = b.get("pnr");
                    String busName = b.get("busName");
                    String from = b.get("from");
                    String to = b.get("to");
                    String date = b.get("date");
                    String time = b.get("time");
                    String seats = b.get("seats");
                    String amount = b.get("amount");
                    String method = b.get("method");
        %>
            <!-- Single Confirmed Ticket Card -->
            <div class="ticket-card">
                <div class="ticket-head">
                    <div class="pnr-pill">
                        <i class="fa-solid fa-ticket-simple" style="color: var(--redbus);"></i>
                        PNR: <span><%= pnr %></span>
                    </div>
                    <span class="status-confirmed">
                        <i class="fa-solid fa-circle-check"></i> CONFIRMED
                    </span>
                </div>

                <div class="ticket-body">
                    <div>
                        <div class="operator-title"><%= busName %></div>
                        <div class="route-path">
                            <span><%= from %></span>
                            <i class="fa-solid fa-arrow-right-long"></i>
                            <span><%= to %></span>
                        </div>
                        <div style="font-size: 0.85rem; color: #4b5563;">
                            Reserved Berth(s): <strong style="color: var(--redbus);"><%= seats %></strong>
                        </div>
                    </div>

                    <div class="time-date-box">
                        <div><i class="fa-regular fa-calendar-days" style="width: 18px;"></i> Date: <strong><%= date %></strong></div>
                        <div><i class="fa-regular fa-clock" style="width: 18px;"></i> Departure: <strong><%= time %></strong></div>
                        <div style="font-size: 0.8rem; color: var(--text-muted);"><i class="fa-solid fa-shield-halved" style="width: 18px;"></i> Paid via: <%= method %></div>
                    </div>

                    <div class="price-col">
                        <div class="fare-amount">Rs. <%= amount %></div>
                        <div class="fare-sub">Total Fare Paid</div>
                    </div>
                </div>

                <div class="ticket-footer">
                    <div class="boarding-info">
                        <i class="fa-solid fa-location-dot"></i> Boarding Point: <strong>Koyambedu Omni Bus Stand</strong>
                    </div>

                    <div class="action-btns">
                        <button class="btn-action" onclick="window.print()">
                            <i class="fa-solid fa-print"></i> Print
                        </button>
                        <a href="bookingSuccess.jsp?busName=<%= busName %>&from=<%= from %>&to=<%= to %>&date=<%= date %>&time=<%= time %>&seats=<%= seats %>&amount=<%= amount %>" class="btn-action" style="background: var(--navy); color: white; border-color: var(--navy);">
                            <i class="fa-solid fa-qrcode"></i> View Pass
                        </a>
                    </div>
                </div>
            </div>
        <%
                }
            } else {
        %>
            <!-- Empty State Layout -->
            <div class="empty-card">
                <div class="empty-icon-wrap">
                    <i class="fa-solid fa-ticket"></i>
                </div>
                <h3>No Booked Tickets Found</h3>
                <p>You haven't made any bus reservations yet. Explore routes and travel comfortably across Tamil Nadu!</p>
                <a href="dashboard.jsp" class="btn-book-now">
                    <i class="fa-solid fa-magnifying-glass"></i> Search & Book Buses
                </a>
            </div>
        <%
            }
        %>

    </div>

</body>
</html>