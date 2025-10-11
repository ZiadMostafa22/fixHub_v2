# 🚀 Deployment Instructions - Account Deactivation Feature

## ⚠️ Important: Deploy Firestore Rules

The account deactivation feature requires updated Firestore security rules. You **MUST** deploy these rules for the feature to work correctly.

### Option 1: Deploy via Firebase CLI (Recommended)

```bash
# Make sure you're in the project directory
cd d:\car_maintenance_system_new

# Deploy only the Firestore rules
firebase deploy --only firestore:rules
```

If the command fails, try:
```bash
# Login to Firebase first
firebase login

# Then deploy
firebase deploy --only firestore:rules
```

### Option 2: Deploy via Firebase Console

If the CLI doesn't work, you can manually update the rules:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Firestore Database** → **Rules**
4. Copy the contents from `firestore.rules` file
5. Paste into the rules editor
6. Click **Publish**

### Verify Deployment

After deploying, test the rules:

1. **Test as inactive user** (should be blocked):
   ```
   Simulate: authenticated user with isActive: false
   Path: /bookings/{bookingId}
   Operation: read
   Result: Should be DENIED ❌
   ```

2. **Test as active user** (should work):
   ```
   Simulate: authenticated user with isActive: true
   Path: /bookings/{bookingId}
   Operation: read
   Result: Should be ALLOWED ✅
   ```

3. **Test as admin** (should always work):
   ```
   Simulate: admin user
   Path: any path
   Operation: any operation
   Result: Should be ALLOWED ✅
   ```

## 📝 What Changed in Rules

### New Helper Functions
- `isActive()` - Checks if user's isActive field is true
- `isAuthenticatedAndActive()` - Checks both authentication and active status

### Updated Collections
All collections now check `isActive` status:
- ✅ Users
- ✅ Cars
- ✅ Bookings
- ✅ Services
- ✅ Notifications
- ✅ Reviews

## ⚙️ Post-Deployment Tasks

### 1. Update Existing Users (Optional)

If you have existing users in the database that don't have the `isActive` field, run this script in Firebase Console:

```javascript
// Go to Firebase Console → Firestore → Run Query
const db = firebase.firestore();

db.collection('users').get().then(snapshot => {
  const batch = db.batch();
  let count = 0;
  
  snapshot.docs.forEach(doc => {
    const data = doc.data();
    // Add isActive field if it doesn't exist
    if (!data.hasOwnProperty('isActive')) {
      batch.update(doc.ref, { isActive: true });
      count++;
    }
  });
  
  console.log(`Updating ${count} users...`);
  return batch.commit();
}).then(() => {
  console.log('✅ All users updated successfully!');
}).catch(error => {
  console.error('❌ Error:', error);
});
```

### 2. Test the Feature

#### Test Account Deactivation:

1. **Create Test Technician**
   - Generate an invite code as admin
   - Register a new technician using the code

2. **Verify Active Account**
   - Login as the technician
   - Verify all features work
   - Check that bookings, cars, etc. are accessible

3. **Deactivate Account**
   - Login as admin
   - Go to "Invite Codes" page
   - Find the code used by the technician
   - Click menu → "Deactivate"
   - Choose "Yes, Deactivate Users"

4. **Verify Deactivation**
   - Try to login as the technician
   - Should see: "Your account has been disabled by the administrator"
   - Account should be signed out
   - Cannot access any data

5. **Reactivate (Optional Test)**
   - Go to Firebase Console
   - Find the user document
   - Change `isActive` to `true`
   - Technician can login again

## 🐛 Troubleshooting

### Issue: Firebase CLI not working

**Solution**: Use Firebase Console to deploy rules manually (see Option 2 above)

### Issue: Users can still login after deactivation

**Check:**
1. Were Firestore rules deployed? 
2. Is the `isActive` field set to `false` in the database?
3. Try clearing app cache and restarting

### Issue: Admin cannot deactivate codes

**Check:**
1. Is the admin user's `role` field set to `'admin'` in Firestore?
2. Are admin permissions working for other features?

### Issue: Technician names not showing

**Check:**
1. Is the `usedBy` array populated in the invite code document?
2. Do the user IDs in the array match actual user documents?

## ✅ Verification Checklist

Before considering deployment complete:

- [ ] Firestore rules deployed successfully
- [ ] Existing users have `isActive: true` field
- [ ] Test technician account can login
- [ ] Admin can see technician name on invite code
- [ ] Admin can deactivate invite code
- [ ] Deactivated technician cannot login
- [ ] Error message shows correctly
- [ ] Admin can still access all features
- [ ] Security rules prevent inactive user data access

## 📞 Support

If you encounter any issues:

1. Check the `ACCOUNT_DEACTIVATION_FEATURE.md` file for detailed implementation docs
2. Review Firebase Console for error messages
3. Check Firestore rules simulator for rule issues
4. Verify user documents have correct structure

---

**⚠️ CRITICAL: Deploy the Firestore rules before using this feature in production!**

Without the updated rules, inactive users may still be able to access data through the database directly.

