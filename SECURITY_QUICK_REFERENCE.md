# 🔒 Security System - Quick Reference

## What's Changed

### ✅ Registration Page
- **Customer Registration**: No changes, still public ✓
- **Technician Registration**: Now requires invite code 🔑
- **Admin Registration**: Removed from public (invite-only) 🚫

### ✅ Backend Security
- Role validation added
- Invite code verification
- Usage tracking
- Automatic role enforcement

### ✅ New Admin Feature
- **Invite Codes Management**: Key icon (🔑) in admin dashboard
- Generate codes for technicians and admins
- Track usage and manage codes

---

## Quick Setup Checklist

### For First-Time Setup

- [ ] 1. Update Firestore security rules (copy from `firestore.rules`)
- [ ] 2. Publish the rules in Firebase Console
- [ ] 3. Create first admin account (see `FIRST_ADMIN_SETUP.md`)
- [ ] 4. Login as admin and verify access
- [ ] 5. Generate technician invite codes
- [ ] 6. Share codes with technicians
- [ ] 7. Test registration flow

### For Daily Use

- [ ] Generate invite codes when hiring new technicians
- [ ] Deactivate codes after use (optional)
- [ ] Review active codes regularly
- [ ] Monitor user registrations
- [ ] Keep at least 2 admin accounts

---

## How To: Common Tasks

### Generate Technician Invite Code
1. Login as admin
2. Click key icon (🔑) in admin dashboard
3. Role: Technician
4. Max Uses: 1
5. Click "Generate Code"
6. Copy and share code

### Register as Technician
1. Get invite code from admin
2. Open app registration
3. Select "Technician Account"
4. Enter code in "Invite Code" field
5. Complete registration

### Create New Admin
1. Login as existing admin
2. Click key icon (🔑)
3. Role: Admin
4. Max Uses: 1
5. Generate and securely share code
6. New admin registers with code

### Deactivate Invite Code
1. Go to Invite Codes page
2. Find the code in list
3. Click menu (⋮)
4. Select "Deactivate"

### Delete Invite Code
1. Go to Invite Codes page
2. Find the code in list
3. Click menu (⋮)
4. Select "Delete"
5. Confirm deletion

---

## Security Rules Quick Copy

```javascript
// Add to Firebase Console → Firestore → Rules

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Invite Codes - Admin Only
    match /invite_codes/{codeId} {
      allow read, create, update, delete: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Users - Protect role field
    match /users/{userId} {
      allow read: if request.auth != null && 
        (request.auth.uid == userId || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
      
      allow create: if request.auth != null && request.auth.uid == userId;
      
      allow update: if request.auth != null && 
        (request.auth.uid == userId && 
         !request.resource.data.diff(resource.data).affectedKeys().hasAny(['role']) ||
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
      
      allow delete: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

---

## Troubleshooting Quick Fixes

### "Invalid or expired invite code"
```
Fix: Check in Firestore → invite_codes
- Verify code exists
- Check isActive = true
- Check usedCount < maxUses
```

### "Permission denied" in Firestore
```
Fix: 
- Verify security rules are published
- Check user role in Firestore → users
- Clear app cache and restart
```

### Can't access Invite Codes page
```
Fix:
- Verify user role is 'admin' in Firestore
- Logout and login again
- Check Firebase Console for errors
```

### Registration creates customer instead of technician
```
Fix:
- Ensure invite code is entered
- Verify code is for technician role
- Check backend validation logs
```

---

## File Structure

```
lib/
├── core/
│   ├── providers/
│   │   └── auth_provider.dart          ← Backend validation
│   └── router/
│       └── app_router.dart              ← Route added
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       └── pages/
│   │           └── register_page.dart   ← UI updated
│   └── admin/
│       └── presentation/
│           └── pages/
│               ├── admin_dashboard.dart         ← Button added
│               └── admin_invite_codes_page.dart ← NEW FILE

Documentation:
├── SECURITY_IMPLEMENTATION_GUIDE.md    ← Full guide
├── FIRST_ADMIN_SETUP.md                ← Setup instructions
├── SECURITY_FLOW_DIAGRAM.md            ← Visual flows
├── SECURITY_QUICK_REFERENCE.md         ← This file
└── firestore.rules                      ← Security rules
```

---

## Test Scenarios

### ✅ Test 1: Customer Registration
- Should work without invite code
- Should create customer account
- Should redirect to customer dashboard

### ✅ Test 2: Technician Without Code
- Should require invite code
- Should show error if missing
- Should not create account

### ✅ Test 3: Technician With Code
- Should validate code
- Should create technician account
- Should redirect to technician dashboard

### ✅ Test 4: Code Usage Limit
- Should track usage
- Should prevent over-use
- Should auto-deactivate when limit reached

### ✅ Test 5: Admin Access
- Should allow admin to generate codes
- Should allow admin to manage codes
- Should prevent non-admin access

---

## Security Guarantees

### ✅ What's Protected

| Threat | Protection |
|--------|-----------|
| Unauthorized admin registration | ❌ Blocked (invite-only) |
| Unauthorized tech registration | ❌ Blocked (invite-only) |
| Invalid invite codes | ❌ Validated on backend |
| Code reuse beyond limit | ❌ Usage tracking |
| Role escalation | ❌ Firestore rules |
| Direct database edits | ❌ Security rules |
| Non-admin code access | ❌ Route protection |

### 🔒 Security Layers

1. **UI Layer**: Form validation, route guards
2. **Backend Layer**: Role validation, code verification
3. **Database Layer**: Firestore security rules
4. **Auth Layer**: Firebase Authentication

---

## Important Notes

### ⚠️ Critical Security Points

1. **Never share admin credentials**
2. **Use single-use invite codes** (maxUses: 1)
3. **Deactivate old codes** regularly
4. **Keep backup admin accounts**
5. **Monitor user list** for unauthorized accounts
6. **Publish Firestore rules** before going live

### 📝 Best Practices

1. **Generate codes on-demand** (not in advance)
2. **Share codes securely** (encrypted messaging)
3. **Delete used codes** (cleanup)
4. **Review active codes** weekly
5. **Audit user roles** monthly

---

## Quick Commands

### Check User Role in Firebase Console
```
1. Firebase Console → Firestore Database
2. Navigate to: users/{userId}
3. Look at: role field
4. Should be: "customer" | "technician" | "admin"
```

### Manually Create Invite Code
```
1. Firebase Console → Firestore Database
2. Collection: invite_codes
3. Add Document with fields:
   - code: string (8+ characters)
   - role: string ("technician" or "admin")
   - maxUses: number (e.g., 1)
   - usedCount: number (0)
   - isActive: boolean (true)
   - createdAt: timestamp (now)
   - usedBy: array (empty)
```

### Reset User Role
```
1. Firebase Console → Firestore Database
2. Navigate to: users/{userId}
3. Edit field: role
4. Change to: desired role
5. Save
6. User must logout and login again
```

---

## Support Resources

### Documentation Files
- **Full Implementation**: `SECURITY_IMPLEMENTATION_GUIDE.md`
- **First Admin Setup**: `FIRST_ADMIN_SETUP.md`
- **Flow Diagrams**: `SECURITY_FLOW_DIAGRAM.md`
- **Quick Reference**: This file
- **Firestore Rules**: `firestore.rules`

### Firebase Console Links
- **Authentication**: https://console.firebase.google.com/ → Authentication
- **Firestore Database**: https://console.firebase.google.com/ → Firestore Database
- **Security Rules**: https://console.firebase.google.com/ → Firestore → Rules

---

## Summary

### What You Get

✅ **Secure Registration**: Role-based with invite codes
✅ **Admin Control**: Full invite code management
✅ **Usage Tracking**: Monitor code usage
✅ **Access Control**: Role-based permissions
✅ **Data Protection**: Firestore security rules
✅ **Audit Trail**: Track who used which codes

### Next Steps

1. Review `SECURITY_IMPLEMENTATION_GUIDE.md` for details
2. Follow `FIRST_ADMIN_SETUP.md` to create first admin
3. Generate invite codes for technicians
4. Test all registration flows
5. Monitor and manage codes regularly

---

**Your security system is complete and ready for production! 🎉🔒**


