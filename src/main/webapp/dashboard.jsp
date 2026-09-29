<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || username.trim().isEmpty()) {
        username = "jagan";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuickBus - Search Buses</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --redbus: #d84e55;
            --redbus-dark: #b8363d;
            --navy: #1f2937;
            --surface: #ffffff;
            --bg: #f4f5f8;
            --border: #e5e7eb;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; }
        body { background-color: var(--bg); color: #111827; min-height: 100vh; }
        
        .navbar {
            background: #ffffff;
            border-bottom: 1px solid var(--border);
            padding: 0.85rem 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.03);
        }
        .brand { font-size: 1.4rem; font-weight: 800; color: var(--redbus); text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .nav-links { display: flex; align-items: center; gap: 1.2rem; }
        .user-tag { background: #f3f4f6; padding: 6px 14px; border-radius: 999px; font-weight: 700; font-size: 0.88rem; display: flex; align-items: center; gap: 6px; }
        .btn-nav { text-decoration: none; font-weight: 700; font-size: 0.88rem; color: #4b5563; display: flex; align-items: center; gap: 6px; }
        .btn-nav:hover { color: var(--redbus); }

        .hero-banner {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            padding: 3.5rem 1.5rem 6.5rem;
            text-align: center;
            color: white;
        }
        .hero-banner h1 { font-size: 2.3rem; font-weight: 800; margin-bottom: 6px; }
        .hero-banner p { color: #94a3b8; font-size: 1rem; }

        .search-container { max-width: 1050px; margin: -3.5rem auto 3rem; padding: 0 1rem; }
        .search-card {
            background: var(--surface);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 15px 35px rgba(0,0,0,0.08);
            border: 1px solid var(--border);
        }
        .search-form {
            display: grid;
            grid-template-columns: 1fr auto 1fr 1fr auto;
            gap: 14px;
            align-items: center;
        }
        .field-group label { display: block; font-size: 0.72rem; font-weight: 800; color: #6b7280; text-transform: uppercase; margin-bottom: 6px; }
        .field-wrap { position: relative; }
        .field-wrap i { position: absolute; left: 14px; top: 16px; color: var(--redbus); }
        .field-wrap input {
            width: 100%; height: 48px; border: 1.5px solid var(--border); border-radius: 8px;
            padding: 0 12px 0 40px; font-size: 0.95rem; font-weight: 700; outline: none; background: #fafafa;
        }
        .field-wrap input:focus { border-color: var(--redbus); background: #ffffff; }

        .swap-btn {
            width: 44px; height: 44px; border-radius: 50%; background: #f3f4f6; border: 1px solid var(--border);
            cursor: pointer; margin-top: 22px; display: flex; align-items: center; justify-content: center;
            color: #6b7280; transition: all 0.2s;
        }
        .swap-btn:hover { background: #fee2e2; color: var(--redbus); transform: rotate(180deg); }

        .btn-search {
            height: 48px; margin-top: 22px; padding: 0 2rem; background: var(--redbus); color: white;
            border: none; border-radius: 8px; font-size: 1rem; font-weight: 800; cursor: pointer;
            box-shadow: 0 6px 15px rgba(216, 78, 85, 0.25); transition: background 0.2s;
        }
        .btn-search:hover { background: var(--redbus-dark); }

        /* Quick Routes */
        .route-shortcuts { margin-top: 2rem; display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 15px; }
        .shortcut-card {
            background: white; border: 1px solid var(--border); border-radius: 10px; padding: 1rem;
            cursor: pointer; transition: all 0.2s;
        }
        .shortcut-card:hover { border-color: var(--redbus); transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }

        @media (max-width: 850px) {
            .search-form { grid-template-columns: 1fr; }
            .swap-btn { margin: 0 auto; transform: rotate(90deg); }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="dashboard.jsp" class="brand"><i class="fa-solid fa-bus"></i> QuickBus</a>
        <div class="nav-links">
            <div class="user-tag"><i class="fa-solid fa-circle-user" style="color: var(--redbus);"></i> <%= username %></div>
            <a href="myBookings.jsp" class="btn-nav"><i class="fa-solid fa-ticket"></i> My Bookings</a>
            <a href="login.jsp" class="btn-nav" style="color: #ef4444;"><i class="fa-solid fa-power-off"></i> Logout</a>
        </div>
    </nav>

    <div class="hero-banner">
        <h1>Book Bus Tickets Online</h1>
        <p>Tamil Nadu's Safest & Fastest Bus Booking Portal</p>
    </div>

    <div class="search-container">
        <div class="search-card">
            <!-- Redirects directly to bookTicket.jsp -->
            <form action="bookTicket.jsp" method="GET" class="search-form">
                <div class="field-group">
                    <label>From Station</label>
                    <div class="field-wrap">
                        <i class="fa-solid fa-location-dot"></i>
                        <input type="text" id="fromCity" name="from" value="Chennai" required>
                    </div>
                </div>

                <button type="button" class="swap-btn" onclick="swap()"><i class="fa-solid fa-arrow-right-arrow-left"></i></button>

                <div class="field-group">
                    <label>To Destination</label>
                    <div class="field-wrap">
                        <i class="fa-solid fa-map-pin"></i>
                        <input type="text" id="toCity" name="to" value="Madurai" required>
                    </div>
                </div>

                <div class="field-group">
                    <label>Journey Date</label>
                    <div class="field-wrap">
                        <i class="fa-regular fa-calendar-days"></i>
                        <input type="date" id="travelDate" name="date" required>
                    </div>
                </div>

                <button type="submit" class="btn-search">Search Buses</button>
            </form>
        </div>

        <h3 style="margin-top: 2rem; font-size: 1.1rem; color: #4b5563;">Popular Travel Routes</h3>
        <div class="route-shortcuts">
            <div class="shortcut-card" onclick="setRoute('Chennai', 'Madurai')">
                <strong>Chennai &rarr; Madurai</strong>
                <p style="font-size: 0.8rem; color: #6b7280; margin-top: 3px;">Starting from Rs. 480</p>
            </div>
            <div class="shortcut-card" onclick="setRoute('Chennai', 'Coimbatore')">
                <strong>Chennai &rarr; Coimbatore</strong>
                <p style="font-size: 0.8rem; color: #6b7280; margin-top: 3px;">Starting from Rs. 550</p>
            </div>
            <div class="shortcut-card" onclick="setRoute('Bangalore', 'Chennai')">
                <strong>Bangalore &rarr; Chennai</strong>
                <p style="font-size: 0.8rem; color: #6b7280; margin-top: 3px;">Starting from Rs. 400</p>
            </div>
        </div>
    </div>

    <script>
        const today = new Date().toISOString().split('T')[0];
        const dateInput = document.getElementById('travelDate');
        dateInput.value = today;
        dateInput.min = today;

        function swap() {
            const f = document.getElementById('fromCity');
            const t = document.getElementById('toCity');
            const tmp = f.value; f.value = t.value; t.value = tmp;
        }

        function setRoute(f, t) {
            document.getElementById('fromCity').value = f;
            document.getElementById('toCity').value = t;
            window.scrollTo({ top: 120, behavior: 'smooth' });
        }
    </script>
</body>
</html>