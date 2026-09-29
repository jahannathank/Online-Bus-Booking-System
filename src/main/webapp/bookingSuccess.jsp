<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || username.trim().isEmpty()) {
        username = "jagan";
    }

    String busName = request.getParameter("busName");
    if (busName == null || busName.trim().isEmpty()) busName = "KPN Travels";

    String from = request.getParameter("from");
    if (from == null || from.trim().isEmpty()) from = "Chennai";

    String to = request.getParameter("to");
    if (to == null || to.trim().isEmpty()) to = "Madurai";

    String date = request.getParameter("date");
    if (date == null || date.trim().isEmpty()) date = "2026-09-29";

    String time = request.getParameter("time");
    if (time == null || time.trim().isEmpty()) time = "20:30";

    String seats = request.getParameter("seats");
    if (seats == null || seats.trim().isEmpty()) seats = "L1";

    String amount = request.getParameter("amount");
    if (amount == null || amount.trim().isEmpty() || "0".equals(amount)) amount = "650";

    String payMethod = request.getParameter("payMethod");
    if (payMethod == null || payMethod.trim().isEmpty()) payMethod = "UPI Online";

    String pnr = "TN" + (System.currentTimeMillis() % 10000000);

    // Save Booking into Session so myBookings.jsp permanently displays it
    List<Map<String, String>> sessionBookings = (List<Map<String, String>>) session.getAttribute("sessionBookings");
    if (sessionBookings == null) {
        sessionBookings = new ArrayList<Map<String, String>>();
    }

    Map<String, String> booking = new HashMap<String, String>();
    booking.put("pnr", pnr);
    booking.put("busName", busName);
    booking.put("from", from);
    booking.put("to", to);
    booking.put("date", date);
    booking.put("time", time);
    booking.put("seats", seats);
    booking.put("amount", amount);
    booking.put("method", payMethod);

    sessionBookings.add(0, booking);
    session.setAttribute("sessionBookings", sessionBookings);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed - PNR <%= pnr %></title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Libre+Barcode+39+Text&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --redbus: #d84e55;
            --success: #10b981;
            --navy: #1e293b;
            --border: #e5e7eb;
            --bg: #f4f5f8;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; }
        body {
            background-color: var(--bg);
            color: #111827;
            min-height: 100vh;
            padding: 2.5rem 1rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .ticket-card {
            background: white;
            border-radius: 16px;
            max-width: 650px;
            width: 100%;
            border: 1px solid var(--border);
            box-shadow: 0 15px 35px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .ticket-top {
            background: var(--navy);
            color: white;
            padding: 1.4rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .ticket-body { padding: 1.8rem 2rem; }

        .route-banner {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #f8fafc;
            padding: 1.2rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            border: 1.5px dashed #cbd5e1;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }

        .barcode {
            font-family: 'Libre Barcode 39 Text', cursive;
            font-size: 3rem;
            line-height: 1;
        }

        .btn-row {
            display: flex;
            gap: 12px;
            margin-top: 1.5rem;
            max-width: 650px;
            width: 100%;
        }

        .btn {
            flex: 1;
            padding: 12px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            cursor: pointer;
            border: none;
        }

        .btn-print { background: white; border: 1.5px solid var(--border); color: #374151; }
        .btn-dash { background: var(--redbus); color: white; }

        @media print {
            .btn-row { display: none; }
            body { background: white; padding: 0; }
            .ticket-card { box-shadow: none; border: 1px solid #000; }
        }
    </style>
</head>
<body>

    <div class="ticket-card">
        <div class="ticket-top">
            <div>
                <h2 style="font-size: 1.3rem;"><i class="fa-solid fa-bus"></i> <%= busName %></h2>
                <span style="font-size: 0.8rem; color: #94a3b8;">Electronic Boarding Pass</span>
            </div>
            <div style="background: rgba(255,255,255,0.15); padding: 5px 12px; border-radius: 6px; font-weight: 800;">
                PNR: <%= pnr %>
            </div>
        </div>

        <div class="ticket-body">
            <div class="route-banner">
                <div>
                    <strong style="font-size: 1.25rem; text-transform: uppercase;"><%= from %></strong>
                    <div style="font-size: 0.82rem; color: #6b7280; margin-top: 3px;">
                        <i class="fa-regular fa-clock"></i> <%= time %>
                    </div>
                </div>
                <i class="fa-solid fa-arrow-right-long" style="color: var(--redbus); font-size: 1.5rem;"></i>
                <div style="text-align: right;">
                    <strong style="font-size: 1.25rem; text-transform: uppercase;"><%= to %></strong>
                    <div style="font-size: 0.82rem; color: #6b7280; margin-top: 3px;">
                        <i class="fa-regular fa-calendar"></i> <%= date %>
                    </div>
                </div>
            </div>

            <div class="details-grid">
                <div>
                    <span style="font-size: 0.75rem; color: #6b7280; font-weight: 700;">PASSENGER</span>
                    <div style="font-weight: 800;"><%= username %></div>
                </div>
                <div>
                    <span style="font-size: 0.75rem; color: #6b7280; font-weight: 700;">BERTHS</span>
                    <div style="font-weight: 800; color: var(--redbus);"><%= seats %></div>
                </div>
                <div>
                    <span style="font-size: 0.75rem; color: #6b7280; font-weight: 700;">FARE PAID</span>
                    <div style="font-weight: 800; color: var(--success);">Rs. <%= amount %></div>
                </div>
                <div>
                    <span style="font-size: 0.75rem; color: #6b7280; font-weight: 700;">PAYMENT MODE</span>
                    <div style="font-weight: 700;"><%= payMethod %></div>
                </div>
                <div>
                    <span style="font-size: 0.75rem; color: #6b7280; font-weight: 700;">STATUS</span>
                    <div style="font-weight: 800; color: var(--success);"><i class="fa-solid fa-circle-check"></i> CONFIRMED</div>
                </div>
                <div>
                    <span style="font-size: 0.75rem; color: #6b7280; font-weight: 700;">BOARDING POINT</span>
                    <div style="font-weight: 700;">Koyambedu Omni Stand</div>
                </div>
            </div>

            <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1.5px dashed #e2e8f0; padding-top: 1.2rem;">
                <div class="barcode">*<%= pnr %>*</div>
                <div style="text-align: right; font-size: 0.82rem; color: #6b7280;">
                    <div>Present SMS / Ticket on Boarding</div>
                    <div style="color: var(--navy); font-weight: 700; margin-top: 2px;">Have a Safe Journey!</div>
                </div>
            </div>
        </div>
    </div>

    <div class="btn-row">
        <button class="btn btn-print" onclick="window.print()"><i class="fa-solid fa-print"></i> Print Ticket</button>
        <a href="myBookings.jsp" class="btn btn-dash"><i class="fa-solid fa-ticket"></i> View All Bookings</a>
    </div>

</body>
</html>