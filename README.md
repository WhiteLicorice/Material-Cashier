# brm_cashier

A mobile cashier application built with Flutter and a minimalist-first approach.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Tickets

## Transactions Page
- [x] Make item field searchable and yield matching items
- [x] Make item field autocomplete
- [ ] Guard against empty transactions in prod
- [ ] Replace mocked data with calls to backend API

## Home Page
- [x] Implement quit button
- [ ] Make quit button exit() instead of Navigator.pop()

## Auth
- [ ] Implement user authentication before home page
- [ ] Persist cashier credentials across application lifespan
- [ ] Stamp transactions with cashier credentials

## Checkout Page
- [x] Design checkout page
- [ ] Make calls to database
- [x] Return to home upon a successful transaction

## Provider
- [x] Implement state management with provider
- [x] Pass data from transactions to checkout
- [ ] Sanitize data on exit and upon successful transaction
- [x] Persist available supply across application lifespan to avoid repeated queries

## Database
- [ ] Design database schema
- [ ] Integrate database with client
- [ ] Listen to supplies to implement real-time databasing
