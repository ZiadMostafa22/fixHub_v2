# Discount System Test Guide

## Step 1: Create a Discount Offer (Admin Account)

1. **Login as Admin**
2. **Click the Offers icon** (🎁) in the top-right corner of admin dashboard
3. **Click the + button** to create a new offer
4. **Fill in the form:**
   - **Title**: "20% Spring Discount"
   - **Description**: "Get 20% off on all services this spring!"
   - **Type**: Select "Discount"
   - **Discount Percentage**: Enter `20`
   - **Discount Code**: Enter `SPRING20` (this is what customers will use)
   - **Start Date**: Select today's date
   - **End Date**: Select a future date (e.g., 30 days from now)
   - **Active**: Keep toggled ON (blue)
   - **Terms**: (Optional) "Valid on all services"
5. **Click "Create"**

✅ You should see a success message "Offer created!"

---

## Step 2: View the Offer (Customer Account)

1. **Login as Customer**
2. **Click the "Offers" tab** in the bottom navigation bar
3. **You should see** the offer you created
4. **Click on the offer** to see details
5. **You should see** the discount code displayed prominently: `SPRING20`

---

## Step 3: Apply Discount Code When Booking

1. **Still logged in as Customer**
2. **Click "Book Service"** from the dashboard
3. **Fill in the booking form:**
   - Select a car
   - Select a service
   - Select maintenance type
   - Pick a date and time
   - (Optional) Add description
4. **Scroll down to "Discount Code" section**
5. **Enter the code**: `SPRING20`
6. **Click "Apply"**

### Expected Behavior:
- You should see a **loading indicator** briefly
- You should see a **green success message**: "Discount code applied successfully! 20% off"
- The code input should be **replaced** with a green confirmation box showing:
  - ✅ "20% Spring Discount"
  - "20% off applied"
  - An ❌ button to remove the code

7. **Click "Create Booking"**

✅ The booking is created with the discount saved

---

## Step 4: Check the Console for Debug Messages

If the Apply button doesn't work or shows an error, check the console/debug output for messages like:

```
🔍 Validating discount code: SPRING20
🔍 Searching for code: SPRING20
🔍 Found 1 matching offers
🔍 Offer data: {title: 20% Spring Discount, ...}
🔍 Offer parsed: 20% Spring Discount, discount: 20%
✅ Discount code valid! 20% off
```

If you see errors like:
- `❌ Error validating code: ...` - There's a Firebase error
- `🔍 Found 0 matching offers` - The code doesn't exist or is inactive
- `🔍 Offer expired` - The end date has passed
- `🔍 No discount percentage` - The offer doesn't have a discount percentage

---

## Common Issues & Solutions

### Issue 1: "Invalid discount code"
**Cause**: The code doesn't exist in Firestore or is inactive
**Solution**: 
- Make sure you created the offer as admin
- Check that the code field was filled in
- Verify the offer is marked as "Active"
- Make sure you're entering the code exactly (codes are case-insensitive)

### Issue 2: Nothing happens when clicking "Apply"
**Cause**: Possible Firestore rules or connection issue
**Solution**:
- Check your internet connection
- Make sure you deployed the Firestore rules that allow reading offers:
  ```
  firebase deploy --only firestore:rules
  ```
- Check the console for error messages

### Issue 3: "This code is not valid for discounts"
**Cause**: The offer exists but has no discount percentage
**Solution**:
- Edit the offer and add a discount percentage value

### Issue 4: Create Booking button doesn't work
**Cause**: Form validation errors
**Solution**:
- Make sure all required fields are filled (car, service, date, time)
- Check the console for error messages

---

## Testing the Complete Flow

1. **Admin creates** offer with code "TEST20" and 20% discount
2. **Customer views** offer in Offers tab and sees code
3. **Customer books** service and applies "TEST20" code
4. **Booking is created** with discount information stored
5. **Technician completes** the service and adds costs (e.g., $100)
6. **Customer views** invoice/PDF showing:
   - Subtotal: $100.00
   - Discount (20%): -$20.00 (Code: TEST20)
   - Tax (10%): $8.00
   - **TOTAL: $88.00**

---

## Next Steps

After testing, if everything works:
- Remove the debug print statements from `lib/core/utils/discount_validator.dart`
- Create real offers for your customers
- Consider adding usage limits or one-time codes (future enhancement)

If something doesn't work:
- Share the console error messages
- Let me know which step failed
- I'll help you fix it!

