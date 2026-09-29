<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || username.trim().isEmpty()) username = "jagan";

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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuickBus - Secure Payment Gateway</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --redbus: #d84e55;
            --success: #10b981;
            --border: #e5e7eb;
            --bg: #f4f5f8;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; }
        body { background-color: var(--bg); color: #111827; min-height: 100vh; padding: 2.5rem 1rem; }
        
        .pay-wrapper { max-width: 800px; margin: 0 auto; }
        .back-nav { display: inline-flex; align-items: center; gap: 6px; text-decoration: none; color: var(--redbus); font-weight: 700; margin-bottom: 1.5rem; font-size: 0.9rem; }
        
        .grid-pay { display: grid; grid-template-columns: 1.3fr 1fr; gap: 20px; }
        .card { background: white; border: 1px solid var(--border); border-radius: 14px; padding: 1.8rem; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
        .title { font-size: 1.15rem; font-weight: 800; margin-bottom: 1.2rem; display: flex; align-items: center; gap: 8px; }

        .method-tab {
            display: flex; align-items: center; justify-content: space-between; padding: 14px;
            border: 2px solid var(--border); border-radius: 10px; margin-bottom: 12px; cursor: pointer; transition: all 0.2s;
        }
        .method-tab.active { border-color: var(--redbus); background: #fef2f2; }
        .method-tab input { accent-color: var(--redbus); transform: scale(1.2); }

        .summary-row { display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 10px; }
        .summary-row .label { color: #6b7280; font-weight: 600; }
        .summary-row .val { font-weight: 700; }
        .divider { height: 1px; background: var(--border); margin: 12px 0; }
        .total-price { font-size: 1.3rem; font-weight: 800; color: var(--success); }

        .btn-pay {
            width: 100%; height: 50px; background: var(--success); color: white; border: none; border-radius: 8px;
            font-size: 1.05rem; font-weight: 800; cursor: pointer; display: flex; align-items: center; justify-content: center;
            gap: 10px; margin-top: 1.4rem; transition: background 0.2s;
        }
        .btn-pay:hover { background: #059669; }

        @media (max-width: 768px) { .grid-pay { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

<div class="pay-wrapper">
    <a href="bookTicket.jsp" class="back-nav"><i class="fa-solid fa-arrow-left"></i> Change Seat Selection</a>

    <div class="grid-pay">
        <!-- Gateway Modes -->
        <div class="card">
            <div class="title"><i class="fa-solid fa-shield-halved" style="color: var(--redbus);"></i> Payment Gateway</div>

            <!-- Form handles GET to avoid any HTTP Method 405 error -->
            <form action="bookingSuccess.jsp" method="GET" id="payForm">
                <input type="hidden" name="busName" value="<%= busName %>">
                <input type="hidden" name="from" value="<%= from %>">
                <input type="hidden" name="to" value="<%= to %>">
                <input type="hidden" name="date" value="<%= date %>">
                <input type="hidden" name="time" value="<%= time %>">
                <input type="hidden" name="seats" value="<%= seats %>">
                <input type="hidden" name="amount" value="<%= amount %>">

                <label class="method-tab active" onclick="setMode(this)">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="fa-brands fa-google-pay" style="font-size: 1.5rem; color: #2563eb;"></i>
                        <div>
                            <strong style="font-size: 0.92rem;">UPI / QR Code</strong>
                            <div style="font-size: 0.75rem; color: #6b7280;">Google Pay, PhonePe, Paytm</div>
                        </div>
                    </div>
                    <input type="radio" name="payMethod" value="UPI Online" checked>
                </label>

                <label class="method-tab" onclick="setMode(this)">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="fa-solid fa-credit-card" style="font-size: 1.3rem; color: #f59e0b;"></i>
                        <div>
                            <strong style="font-size: 0.92rem;">Debit / Credit Card</strong>
                            <div style="font-size: 0.75rem; color: #6b7280;">Visa, MasterCard, RuPay</div>
                        </div>
                    </div>
                    <input type="radio" name="payMethod" value="Debit / Credit Card">
                </label>

                <label class="method-tab" onclick="setMode(this)">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="fa-solid fa-building-columns" style="font-size: 1.2rem; color: #8b5cf6;"></i>
                        <div>
                            <strong style="font-size: 0.92rem;">Net Banking</strong>
                            <div style="font-size: 0.75rem; color: #6b7280;">All Major Indian Banks</div>
                        </div>
                    </div>
                    <input type="radio" name="payMethod" value="Net Banking">
                </label>

                <button type="submit" class="btn-pay" id="submitBtn">
                    <i class="fa-solid fa-lock"></i> Pay Rs. <%= amount %> & Book Ticket
                </button>
            </form>
        </div>

        <!-- Order Summary -->
        <div class="card">
            <div class="title"><i class="fa-solid fa-receipt" style="color: var(--redbus);"></i> Fare Summary</div>
            <div class="summary-row"><span class="label">Operator</span><span class="val"><%= busName %></span></div>
            <div class="summary-row"><span class="label">Route</span><span class="val"><%= from %> &rarr; <%= to %></span></div>
            <div class="summary-row"><span class="label">Journey Date</span><span class="val"><%= date %></span></div>
            <div class="summary-row"><span class="label">Departure</span><span class="val"><%= time %></span></div>
            <div class="summary-row"><span class="label">Berths</span><span class="val"><%= seats %></span></div>
            
            <div class="divider"></div>
            
            <div class="summary-row total-price">
                <span>Total Amount</span>
                <span>Rs. <%= amount %></span>
            </div>
            
            <p style="font-size: 0.75rem; color: #9ca3af; margin-top: 15px; text-align: center;">
                <i class="fa-solid fa-shield-cat"></i> 100% Secure 256-bit Encrypted Transaction
            </p>
        </div>
    </div>
</div>

<script>
    function setMode(elem) {
        const tabs = document.querySelectorAll('.method-tab');
        for(let i = 0; i < tabs.length; i++) tabs[i].classList.remove('active');
        elem.classList.add('active');
        elem.querySelector('input').checked = true;
    }
</script>

</body>
</html>