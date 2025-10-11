# Debug Guide: Buttons Not Working

I've added debug logging to help identify why the buttons aren't working. Here's what to do:

## Step 1: Run the App with Console Visible

Make sure you can see the console output when running the app. In VS Code or Android Studio, the debug console should show print statements.

## Step 2: Test the Booking Button

1. Login as customer
2. Click "Book Service"
3. Fill in all fields:
   - Select a car
   - Select a service  
   - Pick date and time
   - (Optional) Enter a discount code and click Apply
4. Click "Create Booking"

**Watch the console for these messages:**

```
📝 Submit booking called
✅ Form validated
👤 User: [user_id]
🚗 Car: [car_id]
🛠️ Service: [service_name]
💰 Discount: [code] ([percentage]%)
📤 Creating booking...
📥 Booking result: true/false
🏠 Widget still mounted
✅ Booking created successfully, closing page
```

### If you see:
- `❌ Form validation failed` - One or more required fields are empty
- `❌ User is null` - User is not logged in
- `📥 Booking result: false` - Firestore write failed, check the error message
- `❌ Widget not mounted anymore` - Page was closed before operation completed

## Step 3: Test the Complete Job Button

1. Login as technician
2. Go to a booking (either from Today's Jobs or My Jobs)
3. Click "Start Job" if not started
4. Add service items or labor cost
5. Click "Complete Job"

**Watch the console for these messages:**

```
🔧 Complete job called
💰 Labor: $X, Tax: $Y
📦 Service items: N
📝 Notes: [notes text]
📤 Updating booking [booking_id]...
📥 Complete job result: true/false
🏠 Widget still mounted
✅ Job completed successfully, closing page
```

### If you see:
- `❌ Validation failed: No service items or labor cost` - Need to add items/cost
- `📥 Complete job result: false` - Firestore update failed
- `❌ Widget not mounted anymore` - Page was closed

## Common Issues:

### Issue 1: Nothing happens when clicking (no console messages)
**Cause**: The button's `onPressed` handler isn't being called
**Check**:
- Is the button disabled (grayed out)?
- Is there a loading indicator showing?
- Check if `bookingState.isLoading` is stuck at true

### Issue 2: Console shows "false" result
**Cause**: Firestore operation failed
**Check**:
- Internet connection
- Firestore rules (did you deploy them?)
- Console for Firebase errors
- Check the error message in the red SnackBar

### Issue 3: Button click but no "called" message
**Cause**: Button is disabled or handler not connected
**Check**:
- `bookingState.isLoading ? null : _submitBooking` - if loading is true, button is disabled
- Make sure hot reload/restart the app after code changes

## What to Share:

When reporting the issue, please share:
1. **All console messages** from when you click the button
2. **What you see on screen** (any error messages, loading indicators)
3. **Which button** (Create Booking or Complete Job)
4. **Any red error messages** in the SnackBar

This will help me identify exactly what's failing!

