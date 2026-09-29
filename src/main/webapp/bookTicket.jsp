<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.busbooking.Bus" %>
<%
    String from = request.getParameter("from");
    if (from == null || from.trim().isEmpty()) from = "Chennai";

    String to = request.getParameter("to");
    if (to == null || to.trim().isEmpty()) to = "Madurai";

    String date = request.getParameter("date");
    if (date == null || date.trim().isEmpty()) date = "2026-09-29";

    List<Bus> busList = new ArrayList<Bus>();
    busList.add(new Bus(101, "KPN Travels", "AC Sleeper (2+1)", from, to, "20:30", "05:00", 650.0, 16));
    busList.add(new Bus(102, "SRS Travels", "Capella AC Multi-Axle", from, to, "21:15", "06:15", 580.0, 20));
    busList.add(new Bus(103, "Parveen Travels", "Scania AC Multi-Axle", from, to, "22:00", "06:30", 790.0, 10));
    busList.add(new Bus(104, "VRL Travels", "Volvo A/C Sleeper", from, to, "22:45", "07:15", 720.0, 14));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Buses - <%= from %> to <%= to %></title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --redbus: #d84e55;
            --redbus-dark: #b8363d;
            --border: #e5e7eb;
            --bg: #f4f5f8;
            --berth-avail: #ffffff;
            --berth-booked: #d1d5db;
            --berth-selected: #10b981;
            --berth-ladies: #fbcfe8;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; }
        body { background-color: var(--bg); color: #111827; padding-bottom: 4rem; }

        .navbar { background: #ffffff; border-bottom: 1px solid var(--border); padding: 0.85rem 3rem; display: flex; justify-content: space-between; align-items: center; }
        .brand { font-size: 1.4rem; font-weight: 800; color: var(--redbus); text-decoration: none; }
        .btn-back { text-decoration: none; color: var(--redbus); font-weight: 700; font-size: 0.9rem; }

        .container { max-width: 1050px; margin: 2rem auto; padding: 0 1rem; }
        .trip-header {
            background: white; border: 1px solid var(--border); border-radius: 12px; padding: 1.2rem 1.8rem;
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;
        }

        .bus-card {
            background: white; border: 1px solid var(--border); border-radius: 12px; margin-bottom: 1.2rem;
            overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }
        .bus-summary {
            padding: 1.4rem; display: grid; grid-template-columns: 2fr 1.2fr 1fr 1.2fr; align-items: center; gap: 15px;
        }
        .bus-name { font-size: 1.2rem; font-weight: 800; }
        .bus-type { font-size: 0.82rem; color: #6b7280; font-weight: 600; margin: 3px 0 6px; }
        .star-pill { background: #10b981; color: white; padding: 2px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: 800; }
        .fare-price { font-size: 1.4rem; font-weight: 800; text-align: right; }
        .btn-view-seats {
            background: var(--redbus); color: white; border: none; padding: 9px 18px; border-radius: 6px;
            font-weight: 800; font-size: 0.9rem; cursor: pointer; transition: background 0.2s;
        }
        .btn-view-seats:hover { background: var(--redbus-dark); }

        /* Cabin Drawer */
        .cabin-drawer {
            background: #fcfcfd; border-top: 2px dashed var(--border); padding: 1.8rem; display: none;
        }
        .cabin-drawer.active { display: block; }
        .cabin-grid {
            display: grid; grid-template-columns: auto 1fr auto; gap: 20px; background: white;
            border: 2px solid var(--border); border-radius: 14px; padding: 1.5rem;
        }
        .front-indicator { display: flex; flex-direction: column; align-items: center; justify-content: center; border-right: 2px dashed var(--border); padding-right: 1.5rem; color: #6b7280; }
        .decks-wrap { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .deck-box { background: #f9fafb; border: 1px solid var(--border); border-radius: 10px; padding: 1rem; }
        .deck-title { font-size: 0.75rem; font-weight: 800; color: #4b5563; text-transform: uppercase; margin-bottom: 12px; }

        .berth-double, .berth-single { display: flex; gap: 10px; }
        .aisle { height: 12px; border-top: 1px dashed var(--border); margin: 4px 0; }

        .berth {
            width: 60px; height: 32px; background: var(--berth-avail); border: 1.5px solid #cbd5e1; border-radius: 5px;
            position: relative; cursor: pointer; display: flex; align-items: center; justify-content: center;
            font-size: 0.72rem; font-weight: 700; color: #475569;
        }
        .berth::after { content: ''; position: absolute; right: 3px; top: 4px; bottom: 4px; width: 6px; background: #e2e8f0; border-radius: 2px; }
        .berth.booked { background: var(--berth-booked); color: #9ca3af; cursor: not-allowed; }
        .berth.booked::after { background: #cbd5e1; }
        .berth.ladies { background: var(--berth-ladies); border-color: #f472b6; color: #9d174d; }
        .berth.selected { background: var(--berth-selected) !important; border-color: #059669 !important; color: white !important; }
        .berth.selected::after { background: #047857; }

        .legend-box { border-left: 2px dashed var(--border); padding-left: 1.5rem; display: flex; flex-direction: column; justify-content: space-between; }
        .legend-tag { display: flex; align-items: center; gap: 8px; font-size: 0.78rem; font-weight: 600; margin-bottom: 6px; }
        .legend-sample { width: 16px; height: 12px; border-radius: 2px; border: 1px solid #cbd5e1; }

        .booking-bar {
            margin-top: 1.2rem; background: white; border: 1px solid var(--border); border-radius: 10px;
            padding: 1rem 1.4rem; display: flex; justify-content: space-between; align-items: center;
        }

        @media (max-width: 850px) {
            .bus-summary { grid-template-columns: 1fr; }
            .cabin-grid { grid-template-columns: 1fr; }
            .decks-wrap { grid-template-columns: 1fr; }
            .legend-box { border-left: none; border-top: 2px dashed var(--border); padding: 1rem 0 0; }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="dashboard.jsp" class="brand"><i class="fa-solid fa-bus"></i> QuickBus</a>
        <a href="dashboard.jsp" class="btn-back"><i class="fa-solid fa-arrow-left"></i> Modify Search</a>
    </nav>

    <div class="container">
        <div class="trip-header">
            <div>
                <h2 style="text-transform: capitalize;"><%= from %> &rarr; <%= to %></h2>
                <span style="font-size: 0.85rem; color: #6b7280;">Travel Date: <strong><%= date %></strong></span>
            </div>
            <a href="dashboard.jsp" style="color: var(--redbus); text-decoration: none; font-weight: 700; font-size: 0.88rem;"><i class="fa-solid fa-pen-to-square"></i> Change</a>
        </div>

        <h3 style="font-size: 1.1rem; margin-bottom: 1rem; color: #374151;">Available Buses (<%= busList.size() %>)</h3>

        <%
            for (Bus bus : busList) {
        %>
            <div class="bus-card">
                <div class="bus-summary">
                    <div>
                        <div class="bus-name"><%= bus.getBusName() %></div>
                        <div class="bus-type"><%= bus.getBusType() %></div>
                        <span class="star-pill"><i class="fa-solid fa-star"></i> 4.5</span>
                    </div>
                    <div>
                        <div style="font-weight: 800; font-size: 1.05rem;"><%= bus.getDepartureTime() %> &mdash; <%= bus.getArrivalTime() %></div>
                        <div style="font-size: 0.8rem; color: #6b7280; margin-top: 2px;">8h 30m Duration</div>
                    </div>
                    <div>
                        <div style="font-size: 0.8rem; color: var(--redbus); font-weight: 700; text-align: right;"><%= bus.getAvailableSeats() %> Seats Left</div>
                        <div class="fare-price">Rs. <%= Math.round(bus.getPrice()) %></div>
                    </div>
                    <div style="text-align: right;">
                        <button class="btn-view-seats" onclick="toggleDeck(<%= bus.getId() %>)">Select Seats</button>
                    </div>
                </div>

                <!-- 2+1 Sleeper Layout Deck -->
                <div class="cabin-drawer" id="drawer-<%= bus.getId() %>">
                    <div class="cabin-grid">
                        <div class="front-indicator">
                            <i class="fa-solid fa-dharmachakra" style="font-size: 2rem;"></i>
                            <span style="font-size: 0.65rem; font-weight: 800; margin-top: 4px;">FRONT</span>
                        </div>
                        <div class="decks-wrap">
                            <div class="deck-box">
                                <div class="deck-title">Lower Deck</div>
                                <div class="berth-double">
                                    <div class="berth" onclick="pickSeat(<%= bus.getId() %>, 'L1', this, <%= bus.getPrice() %>)">L1</div>
                                    <div class="berth booked">L3</div>
                                    <div class="berth" onclick="pickSeat(<%= bus.getId() %>, 'L5', this, <%= bus.getPrice() %>)">L5</div>
                                    <div class="berth ladies" onclick="pickSeat(<%= bus.getId() %>, 'L7', this, <%= bus.getPrice() %>)">L7</div>
                                </div>
                                <div class="aisle"></div>
                                <div class="berth-single">
                                    <div class="berth" onclick="pickSeat(<%= bus.getId() %>, 'L2', this, <%= bus.getPrice() %>)">L2</div>
                                    <div class="berth" onclick="pickSeat(<%= bus.getId() %>, 'L4', this, <%= bus.getPrice() %>)">L4</div>
                                    <div class="berth booked">L6</div>
                                    <div class="berth" onclick="pickSeat(<%= bus.getId() %>, 'L8', this, <%= bus.getPrice() %>)">L8</div>
                                </div>
                            </div>

                            <div class="deck-box">
                                <div class="deck-title">Upper Deck</div>
                                <div class="berth-double">
                                    <div class="berth" onclick="pickSeat(<%= bus.getId() %>, 'U1', this, <%= bus.getPrice() %>)">U1</div>
                                    <div class="berth" onclick="pickSeat(<%= bus.getId() %>, 'U3', this, <%= bus.getPrice() %>)">U3</div>
                                    <div class="berth booked">U5</div>
                                    <div class="berth" onclick="pickSeat(<%= bus.getId() %>, 'U7', this, <%= bus.getPrice() %>)">U7</div>
                                </div>
                                <div class="aisle"></div>
                                <div class="berth-single">
                                    <div class="berth" onclick="pickSeat(<%= bus.getId() %>, 'U2', this, <%= bus.getPrice() %>)">U2</div>
                                    <div class="berth" onclick="pickSeat(<%= bus.getId() %>, 'U4', this, <%= bus.getPrice() %>)">U4</div>
                                    <div class="berth" onclick="pickSeat(<%= bus.getId() %>, 'U6', this, <%= bus.getPrice() %>)">U6</div>
                                    <div class="berth booked">U8</div>
                                </div>
                            </div>
                        </div>

                        <div class="legend-box">
                            <div>
                                <div class="legend-tag"><div class="legend-sample" style="background:#fff;"></div> Available</div>
                                <div class="legend-tag"><div class="legend-sample" style="background:var(--berth-booked);"></div> Booked</div>
                                <div class="legend-tag"><div class="legend-sample" style="background:var(--berth-ladies);"></div> Ladies</div>
                                <div class="legend-tag"><div class="legend-sample" style="background:var(--berth-selected);"></div> Selected</div>
                            </div>
                            <div style="font-size: 0.8rem; color: #6b7280;">Boarding: <strong>Koyambedu Omni Stand</strong></div>
                        </div>
                    </div>

                    <!-- Redirect Form to payment.jsp -->
                    <form action="payment.jsp" method="GET" class="booking-bar">
                        <input type="hidden" name="busName" value="<%= bus.getBusName() %>">
                        <input type="hidden" name="from" value="<%= from %>">
                        <input type="hidden" name="to" value="<%= to %>">
                        <input type="hidden" name="date" value="<%= date %>">
                        <input type="hidden" name="time" value="<%= bus.getDepartureTime() %>">
                        <input type="hidden" name="seats" id="inputSeats-<%= bus.getId() %>" value="">
                        <input type="hidden" name="amount" id="inputAmount-<%= bus.getId() %>" value="0">

                        <div>
                            <div style="font-size: 0.85rem; color: #4b5563;">Selected Berths: <strong id="lblSeats-<%= bus.getId() %>">None</strong></div>
                            <h3 style="color: #10b981; font-weight: 800;" id="lblAmount-<%= bus.getId() %>">Rs. 0</h3>
                        </div>

                        <button type="submit" class="btn-view-seats" style="background: #10b981;" onclick="return validatePick(<%= bus.getId() %>)">
                            Proceed to Payment &rarr;
                        </button>
                    </form>
                </div>
            </div>
        <%
            }
        %>
    </div>

    <script>
        let chosenSeatsMap = {};

        function toggleDeck(id) {
            const el = document.getElementById('drawer-' + id);
            const isOpen = el.classList.contains('active');
            
            const allDrawers = document.querySelectorAll('.cabin-drawer');
            for(let i=0; i<allDrawers.length; i++) allDrawers[i].classList.remove('active');

            if (!isOpen) {
                el.classList.add('active');
                chosenSeatsMap[id] = [];
            }
        }

        function pickSeat(busId, berth, elem, price) {
            if (!chosenSeatsMap[busId]) chosenSeatsMap[busId] = [];
            const list = chosenSeatsMap[busId];
            const idx = list.indexOf(berth);

            if (idx > -1) {
                list.splice(idx, 1);
                elem.classList.remove('selected');
            } else {
                list.push(berth);
                elem.classList.add('selected');
            }

            const total = list.length * price;
            document.getElementById('lblSeats-' + busId).innerText = list.length ? list.join(', ') : 'None';
            document.getElementById('lblAmount-' + busId).innerText = 'Rs. ' + total;
            document.getElementById('inputSeats-' + busId).value = list.join(', ');
            document.getElementById('inputAmount-' + busId).value = total;
        }

        function validatePick(busId) {
            const list = chosenSeatsMap[busId];
            if (!list || !list.length) {
                alert('Please select at least 1 seat before proceeding!');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
</html>