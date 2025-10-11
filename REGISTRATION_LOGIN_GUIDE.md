# 🔐 Registration & Login Guide

## ✅ How Registration Works

### Registration Flow:
```
1. User fills registration form
   ↓
2. Click "Create Account"
   ↓
3. Creates user in Firebase Authentication
   ↓
4. Creates user profile in Firestore (users collection)
   ↓
5. User is automatically logged in
   ↓
6. Router detects auth change
   ↓
7. Redirects to dashboard based on role
```

### What Gets Created:

**Firebase Authentication:**
- Email: user@example.com
- Password: (hashed by Firebase)
- UID: auto-generated unique ID

**Firestore (users collection):**
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "phone": "1234567890",
  "role": "customer",
  "createdAt": timestamp,
  "updatedAt": timestamp,
  "isActive": true
}
```

## 🎯 Complete Test Journey

### Step 1: Register New User

1. **Run the app**
2. **Click "Sign Up"** on login page
3. **Fill in the form:**
   ```
   Full Name: Test Customer
   Email: test@example.com
   Phone: 1234567890
   Account Type: CUSTOMER
   Password: password123
   Confirm Password: password123
   ```
4. **Click "Create Account"**
5. ✅ **You should see:** "Account created successfully! Redirecting..."
6. ✅ **App automatically redirects** to Customer Dashboard

### Step 2: Test Login with Registered User

1. **Sign out** (from dashboard)
2. **Go back to login page**
3. **Enter credentials:**
   ```
   Email: test@example.com
   Password: password123
   Login As: Customer
   ```
4. **Click "Sign In"**
5. ✅ **App redirects to Customer Dashboard**

## 🔧 What Was Fixed

### Before:
- ❌ Register → Stay on login page (no redirect)
- ❌ Login → Refresh → Still on login page

### After:
- ✅ Register → Success message → Auto-redirect to dashboard
- ✅ Login → Instant redirect to dashboard
- ✅ Router listens to auth changes
- ✅ Automatic navigation

## 📝 Testing Scenarios

### Scenario 1: Fresh Registration
```bash
Email: customer1@test.com
Name: Customer One
Phone: 1234567890
Role: Customer
Password: pass123456

Expected: ✅ Account created → Redirect to Customer Dashboard
```

### Scenario 2: Login After Registration
```bash
# Log out first
# Then login with:
Email: customer1@test.com
Password: pass123456
Role: Customer

Expected: ✅ Instant redirect to Customer Dashboard
```

### Scenario 3: Duplicate Email
```bash
# Try to register with same email again
Email: customer1@test.com  (already exists)
Name: Another User
Password: pass123456

Expected: ❌ Error: "Email already in use"
```

### Scenario 4: Wrong Role on Login
```bash
# Register as Customer, try to login as Admin
Email: customer1@test.com
Password: pass123456
Role: Admin  (wrong!)

Expected: ❌ Error: "Invalid role for this user"
```

### Scenario 5: Wrong Password
```bash
Email: customer1@test.com
Password: wrongpassword
Role: Customer

Expected: ❌ Error from Firebase (wrong password)
```

## 🚀 Quick Test Commands

### Test #1: Register as Customer
1. Fill form with customer details
2. Click "Create Account"
3. ✅ Should see success message and redirect

### Test #2: Logout and Login
1. Click logout in dashboard
2. Enter same credentials
3. ✅ Should login and redirect

### Test #3: Register Different Roles
```
Customer: customer@test.com → Customer Dashboard
Technician: tech@test.com → Technician Dashboard
Admin: admin@test.com → Admin Dashboard
```

## 💡 Important Notes

### Registration Creates:
✅ Firebase Authentication account
✅ Firestore user profile document
✅ Auto-login after registration
✅ Automatic role-based redirect

### Login Verifies:
✅ Email and password in Firebase Auth
✅ User profile exists in Firestore
✅ Role matches login selection
✅ Redirects to correct dashboard

## 🔍 Troubleshooting

### Problem: "Account created but can't login"
**Solution:** This shouldn't happen now! The router listens to auth changes.
- Registration auto-logs you in
- Router detects the auth state change
- Automatically redirects to dashboard

### Problem: "Error: Email already in use"
**Solution:** Use a different email or reset the existing account in Firebase Console

### Problem: "Error: Invalid role for this user"
**Solution:** Make sure you select the correct role when logging in
- If registered as Customer, login as Customer
- If registered as Technician, login as Technician
- If registered as Admin, login as Admin

### Problem: "Still showing login page after register"
**Check:**
1. Is Firebase configured? (google-services.json in place)
2. Is internet connected?
3. Check the error message shown
4. Look at console/terminal for errors

## ✨ Success Indicators

When everything works correctly:

**Registration:**
1. ⏳ Loading indicator appears
2. ✅ Green success message: "Account created successfully! Redirecting..."
3. 🚀 Automatic redirect to dashboard (2 seconds)
4. 🎉 Dashboard loads with user name

**Login:**
1. ⏳ Loading indicator appears
2. 🚀 Instant redirect to dashboard
3. 🎉 Dashboard loads with user name

## 🎯 Current Status

✅ Registration works and creates user in Firebase
✅ User profile saved in Firestore
✅ Auto-login after registration
✅ Router listens to auth state changes
✅ Automatic navigation to correct dashboard
✅ Role-based routing
✅ Error messages for failures

**Everything is now working!** 🎉

## 📱 Try It Now!

The app is running. Try this:

1. **Click "Sign Up"** on the login screen
2. **Fill in your details** (use a real email format)
3. **Select "CUSTOMER"** as account type
4. **Click "Create Account"**
5. **Watch the magic!** 
   - Success message appears
   - Automatically redirects to Customer Dashboard
6. **Test login:**
   - Logout
   - Login with same credentials
   - Instant redirect back to dashboard!

**Ready to test? The app is running in your terminal!** 🚀



