# 🚨 Firestore Users Collection Deleted - How to Fix

## The Problem
You deleted the `users` collection from Firestore, but the accounts still exist in Firebase Authentication. When users try to login:
- ✅ Firebase Authentication recognizes them (email/password correct)
- ❌ No user profile found in Firestore
- ❌ System doesn't know what role they should have (admin/technician/customer)

## Why This Happens
Firebase has two separate systems:
1. **Firebase Authentication** - Stores login credentials (email/password)
2. **Firestore Database** - Stores user profile data (name, role, phone, etc.)

When you deleted the `users` collection, you only deleted #2, but #1 still exists.

## Solution: Re-Create All Users

You have **TWO OPTIONS**:

---

### **Option 1: Delete Auth Users & Re-Register (RECOMMENDED)**

This is the cleanest solution.

#### Step 1: Delete Firebase Auth Users
1. Go to Firebase Console → Authentication → Users
2. **Delete ALL users** (click the 3 dots on each user → Delete user)
3. This ensures a clean slate

#### Step 2: Re-Register Admin
1. Run your app
2. Go to Registration page
3. Register admin using the **first admin registration process**:
   - Go to Firebase Console → Firestore Database
   - Create a collection: `inviteCodes`
   - Add a document with these fields:
     ```
     code: "ADMIN2024"
     role: "admin"
     isActive: true
     maxUses: 1
     usedCount: 0
     createdAt: [current timestamp]
     ```
   - In your app, register with this invite code

#### Step 3: Re-Register Other Users
- **Technicians**: Admin creates invite codes from admin panel
- **Customers**: Register normally (no invite code needed)

---

### **Option 2: Manually Restore Firestore Documents**

If you know the UIDs and roles of existing users:

#### Step 1: Get User UIDs
1. Go to Firebase Console → Authentication → Users
2. Copy the UID of each user

#### Step 2: Create Firestore Documents Manually
1. Go to Firebase Console → Firestore Database
2. Create collection: `users`
3. For EACH user, create a document:
   - **Document ID**: Use the UID from Authentication
   - **Fields**:
     ```
     name: "User Name"
     email: "user@example.com"
     phone: "+1234567890"
     role: "admin"  // or "technician" or "customer"
     isActive: true
     createdAt: [current timestamp]
     updatedAt: [current timestamp]
     ```

#### Example Admin Document:
```
Document ID: abc123xyz (copy from Firebase Auth)

Fields:
name: "Admin User"
email: "admin@example.com"
phone: "1234567890"
role: "admin"
isActive: true
createdAt: January 11, 2025 at 12:00:00 AM
updatedAt: January 11, 2025 at 12:00:00 AM
```

#### Example Technician Document:
```
Document ID: def456uvw

Fields:
name: "John Mechanic"
email: "john@example.com"
phone: "0987654321"
role: "technician"
isActive: true
inviteCode: "TECH001"
inviteCodeId: "xxxxxxxxx"
createdAt: January 11, 2025 at 12:00:00 AM
updatedAt: January 11, 2025 at 12:00:00 AM
```

---

## Quick Test

After fixing, test each role:

1. **Login as Admin**
   - Should route to `/admin` dashboard
   - Should see "Manage Services", "All Bookings", "Invite Codes"

2. **Login as Technician**
   - Should route to `/technician` dashboard
   - Should see "Today's Jobs", "My Jobs"

3. **Login as Customer**
   - Should route to `/customer` dashboard
   - Should see "Book Service", "My Cars"

---

## Prevention

To prevent this in future:
- ✅ Use Firebase Console carefully
- ✅ Test deletions in a development project first
- ✅ Keep backups of Firestore data
- ✅ Use Firebase Emulator for testing destructive operations

---

## What I Changed in Code

I updated `lib/core/providers/auth_provider.dart` to:
- **Before**: Auto-created missing user documents (with wrong roles)
- **After**: Rejects login and shows clear error message

This prevents users from being auto-created with incorrect roles.

