# brm_cashier

A mobile cashier application built with Flutter and Material Design.

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
- [ ] Replace mocked data with calls to backend API

## Home Page
- [x] Implement quit button

## Auth
- [ ] Implement user authentication before home page
- [ ] Persist cashier credentials across application lifespan
- [ ] Stamp transactions with cashier credentials

## Checkout Page
- [ ] Design checkout page
- [ ] Make calls to database
- [ ] Return back to transactions upon a successful transaction

## Provider
- [ ] Implement state management with provider
- [ ] Pass data from transactions to checkout
- [ ] Sanitize data on exit and upon successful transaction
- [ ] Persist available supply across application lifespan to avoid repeated queries

## Database
- [ ] Design database schema
- [ ] Integrate database with client
- [ ] Listen to supplies to implement real-time databasing
