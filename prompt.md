# Flutter Sandwich Shop - Cart Modification Feature

## Overview
Add functionality to modify items in the cart on the cart screen. Users should be able to change quantities and remove individual items.

## Current Architecture
- **Models**: Sandwich (type, size, bread type), Cart (add/remove/clear methods, total price calculation)
- **Repository**: Pricing (calculates prices based on quantity and size; price is independent of sandwich type and bread)

## Features to Implement

### 1. Change Item Quantity
**Description**: Allow users to modify the quantity of a sandwich already in their cart.

**User Actions**:
- User taps increment/decrement buttons next to a cart item
- User can manually enter a quantity value

**Expected Behavior**:
- Quantity updates immediately
- Total price recalculates based on new quantity using the Pricing repository
- If quantity is reduced to 0, the item is removed from the cart
- UI disables decrement button when quantity is 1

### 2. Remove Item from Cart
**Description**: Allow users to delete individual items from their cart.

**User Actions**:
- User taps a delete/remove button on a cart item
- User can swipe to delete (optional)

**Expected Behavior**:
- Item is removed from the cart immediately
- Total price updates
- Empty state message displays if cart becomes empty

### 3. Update Cart Total Display
**Description**: Ensure the total price updates dynamically as items are modified.

**Expected Behavior**:
- Total recalculates after each modification
- Uses existing Pricing repository for accurate calculations
- Displays with proper currency formatting

## Implementation Notes
- Maintain consistency with existing Cart model methods
- Use the Pricing repository for all price calculations
- Consider animation/transitions for better UX