# Billiard Club Management System (BI_DA) - Project Overview

## Project Purpose
A comprehensive billiard club management system designed for multi-tenant operations. The system manages table bookings, time tracking, F&B orders, billing, loyalty programs, and operational reporting for billiard clubs.

## Key Features
- **Table Management**: Real-time table status (available/occupied/reserved)
- **Booking System**: Table reservations with no-show rules and deposits
- **Time Tracking**: Start/stop/pause with 15'/30' rounding and surcharges
- **F&B Orders**: Menu management and order processing per table/session
- **Billing**: Split/merge/transfer tables, promotions, vouchers, e-receipts
- **Loyalty Program**: Points accumulation, tiers, time-based promotions
- **Multi-tenancy**: Company → multiple Clubs → multiple Tables (10-100 tables per club)
- **Internationalization**: Vietnamese (vi-VN) and English (en-US) support
- **Real-time Updates**: WebSocket/STOMP for live table status updates
- **Payment Integration**: Momo, ZaloPay with webhook confirmation

## Business Model
- Multi-tenant architecture supporting multiple companies and clubs
- Time-based pricing (peak/off-peak/holiday rates)
- F&B revenue integration
- Loyalty and promotional programs
- Comprehensive operational reporting

## Target Users
- **Staff App**: Club staff for table management and orders
- **User App**: Customers for bookings and loyalty
- **Admin Web**: Company/club management and reporting