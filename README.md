# Material Cashier

A mobile cashier application built with Flutter and Supabase, following a minimalist-first philosophy.

## Getting Started

Set up your [Supabase](https://supabase.com/) dashboard and retrieve a copy of the database schema from `supauser`.

## Tickets

## Transactions Page
- [x] Make item field searchable and yield matching items
- [x] Make item field autocomplete
- [x] Guard against empty transactions in prod
- [x] Guard against `quantity <= 0` scenarios
- [x] Replace mocked data with calls to backend API

## Home Page
- [x] Implement quit button
- [x] Make quit button exit() instead of Navigator.pop()
- [ ] Make quit button behave the same across platforms

## Auth
- [x] Implement user authentication before home page
- [x] Persist cashier credentials across application lifespan
- [x] Stamp transactions with cashier credentials
- [x] Terminate user sessions, allowing only one session per user
      
## Checkout Page
- [x] Design checkout page
- [x] Record transactions in database
- [x] Return to home upon a successful transaction
- [ ] Subtract transacted items from `stock`?
      
## Provider
- [x] Implement state management with provider
- [x] Pass data from transactions to checkout
- [x] Sanitize data on exit and upon successful transaction
- [x] Persist available supply across application lifespan to avoid repeated queries

## Database
- [x] Design database schema
- [x] Integrate database with client
- [x] Listen to supplies to implement real-time databasing
