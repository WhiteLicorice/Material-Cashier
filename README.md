# Material Cashier

A mobile cashier application built with Flutter and Supabase, following a minimalist-first philosophy.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Setup

Grab a copy of environment keys from `superuser`.

## Tickets

## Transactions Page
- [x] Make item field searchable and yield matching items
- [x] Make item field autocomplete
- [x] Guard against empty transactions in prod
- [ ] Guard against `amount <= 0` scenarios
- [x] Replace mocked data with calls to backend API

## Home Page
- [x] Implement quit button
- [x] Make quit button exit() instead of Navigator.pop()
- [ ] Make quit button behave the same across platforms

## Auth
- [ ] Implement user authentication before home page
- [ ] Persist cashier credentials across application lifespan
- [ ] Stamp transactions with cashier credentials

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
