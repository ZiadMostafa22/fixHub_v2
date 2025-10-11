# Firebase Setup Guide

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select an existing project
3. Enable Google Analytics (optional)

## Step 2: Enable Firebase Authentication

1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Enable **Email/Password** authentication

## Step 3: Create Firestore Database

1. Go to **Firestore Database** → **Create database**
2. Start in **test mode** (or production mode with proper security rules)
3. Choose a location close to your users

## Step 4: Firestore Security Rules

Go to **Firestore Database** → **Rules** and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Cars collection
    match /cars/{carId} {
      allow read, write: if request.auth != null && resource.data.userId == request.auth.uid;
      allow read: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'technician'];
    }
    
    // Bookings collection
    match /bookings/{bookingId} {
      allow read, write: if request.auth != null && resource.data.customerId == request.auth.uid;
      allow read, write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'technician'];
    }
    
    // Invoices collection
    match /invoices/{invoiceId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'technician'];
    }
  }
}
```

## Step 5: Add Android App

1. In Firebase Console, click the **Android icon**
2. Enter package name: `com.example.car_maintenance_system_new`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

## Step 6: Add iOS App (Optional)

1. Click the **iOS icon**
2. Enter bundle ID: `com.example.carMaintenanceSystemNew`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

## Step 7: Enable Firebase Services

1. **Cloud Storage** (for images):
   - Go to **Storage** → **Get started**
   - Use test mode or set proper security rules

2. **Cloud Messaging** (for notifications):
   - Already enabled by default

## Step 8: Run the App

```bash
flutter clean
flutter pub get
flutter run
```

## Default Test Users

After setting up Firebase, you can create test users:

- **Admin**: admin@test.com / password123
- **Technician**: tech@test.com / password123
- **Customer**: customer@test.com / password123

## Firestore Collections Structure

The app will automatically create these collections:

- `users` - User profiles (customer, technician, admin)
- `cars` - Customer vehicles
- `bookings` - Service appointments
- `invoices` - Service invoices
- `services` - Available maintenance services


