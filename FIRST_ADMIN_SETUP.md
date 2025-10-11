# 🔐 First Admin Setup Guide

## Quick Setup: Create Your First Admin Account

Choose one of the methods below to create your first admin account:

---

## Method 1: Manual Firestore Entry (Recommended)

### Step 1: Register as Customer First
1. Run your app
2. Go to registration page
3. Fill in your details:
   ```
   Full Name: Your Name
   Email: admin@yourcompany.com
   Phone: Your Phone
   Password: Strong Password
   Account Type: Customer (select this)
   ```
4. Complete registration
5. You'll be logged in as a customer

### Step 2: Upgrade to Admin via Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Firestore Database**
4. Go to the **users** collection
5. Find your user document (search by email)
6. Click on the document to open it
7. Find the **role** field
8. Change the value from `"customer"` to `"admin"`
9. Click **Update**
10. **Restart your app**
11. Login again - you're now an admin! 🎉

---

## Method 2: Create Invite Code First

### Step 1: Add Invite Code to Firestore
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Firestore Database**
4. Click **Start collection** (or add document if collection exists)
5. Collection ID: `invite_codes`
6. Click **Next** or **Add document**
7. Document ID: **Auto-ID** (let Firebase generate it)
8. Add these fields:

   | Field Name | Field Type | Value |
   |------------|------------|-------|
   | code | string | `ADMIN2024` (or any 8+ character code) |
   | role | string | `admin` |
   | maxUses | number | `1` |
   | usedCount | number | `0` |
   | isActive | boolean | `true` |
   | createdAt | timestamp | Click "Now" |
   | createdBy | string | `system` |
   | usedBy | array | (leave empty) |

9. Click **Save**

### Step 2: Register with Invite Code
1. Run your app
2. Go to registration page
3. Select **Technician Account** (this shows invite code field)
4. Fill in your details:
   ```
   Full Name: Your Name
   Email: admin@yourcompany.com
   Phone: Your Phone
   Invite Code: ADMIN2024 (or your code)
   Password: Strong Password
   ```
5. Register
6. You'll be registered as a technician

### Step 3: Upgrade to Admin
1. Go to Firebase Console → Firestore Database
2. Go to the **users** collection
3. Find your user document
4. Change **role** from `"technician"` to `"admin"`
5. Click **Update**
6. Restart app and login
7. You're now an admin! 🎉

---

## Method 3: Using Firebase Authentication + Manual Entry

### Step 1: Create User in Firebase Auth
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Authentication**
4. Click **Add user**
5. Enter:
   ```
   Email: admin@yourcompany.com
   Password: (create a strong password)
   ```
6. Click **Add user**
7. Copy the **UID** (User ID) shown

### Step 2: Create User Profile in Firestore
1. Navigate to **Firestore Database**
2. Go to **users** collection (or create it)
3. Click **Add document**
4. Document ID: **Paste the UID** you copied
5. Add these fields:

   | Field Name | Field Type | Value |
   |------------|------------|-------|
   | id | string | (paste the UID again) |
   | name | string | `Your Name` |
   | email | string | `admin@yourcompany.com` |
   | phone | string | `Your Phone Number` |
   | role | string | `admin` |
   | isActive | boolean | `true` |
   | createdAt | timestamp | Click "Now" |
   | updatedAt | timestamp | Click "Now" |

6. Click **Save**
7. Login to the app with your email and password
8. You're an admin! 🎉

---

## Verification Steps

After creating your admin account, verify it works:

### ✅ Test 1: Check Dashboard Access
1. Login with your admin credentials
2. You should see the **Admin Dashboard**
3. You should see statistics and overview

### ✅ Test 2: Check Admin Features
1. Click on bottom navigation items:
   - Users (view all users)
   - Technicians (manage technicians)
   - Bookings (view all bookings)
   - Analytics (view analytics)
2. All should be accessible

### ✅ Test 3: Check Invite Code Access
1. In Admin Dashboard
2. Click the **key icon (🔑)** in the app bar
3. You should see the **Invite Codes** page
4. Try generating a technician invite code
5. It should create successfully

---

## Next Steps: Create Technician Accounts

Once you have admin access:

### Generate Technician Invite Codes

1. Login as admin
2. Click the key icon (🔑) in the admin dashboard
3. In the "Generate New Invite Code" section:
   - Role: Select **Technician**
   - Max Uses: Enter `1` (for single use) or more for multiple technicians
4. Click **Generate Code**
5. A code like `ABC12345` will be displayed
6. Click the copy icon to copy it
7. Share this code with your technician (via secure channel)

### Technician Registration Process

Share these instructions with your technician:

1. Open the app
2. Go to registration page
3. Select **Technician Account**
4. Fill in details:
   ```
   Full Name: Technician Name
   Email: technician@yourcompany.com
   Phone: Technician Phone
   Invite Code: [The code you provided]
   Password: [Their password]
   ```
5. Click **Create Account**
6. They will be registered as a technician
7. They can now login and access technician features

---

## Security Notes

### 🔒 Important Security Practices

1. **Protect Admin Credentials**: Never share admin login details
2. **Secure Invite Codes**: Share invite codes through secure channels (encrypted messaging, in-person, etc.)
3. **Single-Use Codes**: Use `maxUses: 1` for better security and tracking
4. **Deactivate Old Codes**: Regularly review and deactivate unused invite codes
5. **Multiple Admins**: Create at least 2 admin accounts for redundancy
6. **Regular Audits**: Check user list regularly for unauthorized accounts

### 🚨 If You Lose Admin Access

If you lose access to all admin accounts:

1. Go to Firebase Console
2. Navigate to Firestore Database
3. Find any user document
4. Change their role to `admin`
5. Login with that user's credentials
6. Immediately create a new proper admin account
7. Consider revoking the temporary admin access

---

## Troubleshooting

### "Permission Denied" Error
- Make sure Firestore security rules are published
- Verify the role field is exactly `"admin"` (lowercase)
- Check that isActive is `true`
- Clear app cache and restart

### "Invalid Invite Code" Error
- Check code exists in Firestore
- Verify isActive is `true`
- Check usedCount < maxUses
- Ensure role matches (admin code for admin registration)

### Can't See Admin Features
- Verify role is `admin` in Firestore
- Logout and login again
- Clear app cache
- Check Firebase Console for user role

### Invite Codes Page Not Accessible
- Only admins can access this page
- Verify you're logged in as admin
- Check the route `/admin/invite-codes`
- Verify security rules are published

---

## Quick Reference: Firestore Collections

### users collection
```
users/
  ├─ {userId}/
      ├─ id: string
      ├─ name: string
      ├─ email: string
      ├─ phone: string
      ├─ role: "customer" | "technician" | "admin"
      ├─ isActive: boolean
      ├─ createdAt: timestamp
      └─ updatedAt: timestamp
```

### invite_codes collection
```
invite_codes/
  ├─ {codeId}/
      ├─ code: string (e.g., "ABC12345")
      ├─ role: "technician" | "admin"
      ├─ maxUses: number
      ├─ usedCount: number
      ├─ isActive: boolean
      ├─ createdAt: timestamp
      ├─ createdBy: string (userId)
      ├─ lastUsedAt: timestamp (optional)
      └─ usedBy: array of userIds
```

---

## Summary Checklist

- [ ] Firebase project is set up
- [ ] Firestore security rules are published
- [ ] First admin account is created
- [ ] Admin can login and access admin dashboard
- [ ] Admin can access invite codes page
- [ ] Admin can generate invite codes
- [ ] Technician invite code is generated
- [ ] Technician can register with invite code
- [ ] Customer can register without invite code

---

## Need Help?

If you encounter issues:

1. Check Firebase Console for error logs
2. Verify Firestore security rules are published
3. Check app console for error messages
4. Verify data structure in Firestore matches expected format
5. Ensure internet connection is stable

**Your security system is now fully operational!** 🎉🔒


