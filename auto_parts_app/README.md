# Auto Parts Store Flutter App

This minimal Flutter application demonstrates integration with Firebase Authentication, Firestore and Storage for an Auto Parts Store.

## Features
- Filter car parts by brand, model, year range and part group.
- Product listing with image, name, price and description fetched from Firestore.
- Cart system with add/remove and total price calculation.
- Phone number authentication (OTP) for checkout and chat support.
- Real-time chat with store support including image upload.
- Admin panel (phone login) for adding new products with image upload.

## Firebase Security Rules
See `firebase_security_rules.txt` for example rules allowing public part browsing, authenticated chat and admin-only product management.

This code is a skeleton and may require further configuration (e.g. `firebase_options.dart`) to run in your environment.
