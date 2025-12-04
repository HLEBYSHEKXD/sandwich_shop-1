# Requirements Document for Cart Modification Feature

## 1. Feature Description
The Cart Modification Feature allows users to manage their sandwich selections within the cart screen of the Flutter Sandwich Shop application. This feature enables users to change the quantity of items, remove individual items from the cart, and ensures that the total price is updated dynamically based on these modifications. The purpose of this feature is to enhance user experience by providing flexibility and control over their cart contents.

## 2. User Stories

### User Story 1: Change Item Quantity
**As a** user,  
**I want** to modify the quantity of a sandwich in my cart,  
**So that** I can adjust my order based on my needs.

#### Acceptance Criteria:
- Users can tap increment and decrement buttons to change the quantity.
- Users can manually enter a quantity value.
- The total price updates immediately after any change in quantity.
- If the quantity is reduced to 0, the item is removed from the cart.
- The decrement button is disabled when the quantity is 1.

### User Story 2: Remove Item from Cart
**As a** user,  
**I want** to remove individual items from my cart,  
**So that** I can easily manage my selections.

#### Acceptance Criteria:
- Users can tap a delete/remove button to remove an item.
- Users can swipe to delete an item (optional feature).
- The item is removed from the cart immediately upon action.
- The total price updates accordingly.
- An empty state message is displayed if the cart becomes empty.

### User Story 3: Update Cart Total Display
**As a** user,  
**I want** to see the total price of my cart updated in real-time,  
**So that** I can understand the cost of my selections as I modify them.

#### Acceptance Criteria:
- The total price recalculates after each modification (quantity change or item removal).
- The Pricing repository is used for accurate price calculations.
- The total price is displayed with proper currency formatting.

## 3. Acceptance Criteria for Feature Completion
- All user stories are implemented and tested.
- The UI reflects changes in quantity and item removal immediately.
- The total price is accurate and formatted correctly.
- The feature is consistent with existing Cart model methods.
- The feature is tested for usability, ensuring a smooth user experience.
- Documentation is updated to reflect the new functionality and usage instructions.

---

# Requirements Document for Profile/Sign-In Screen Feature

## 1. Feature Description
The Profile/Sign-In Screen allows users to enter and view their personal details within the Flutter Sandwich Shop application. This screen provides a simple form for users to input their name and email address, and displays these details back to the user. No authentication or data persistence is required at this stage; the goal is to establish the UI and navigation flow.

## 2. User Stories

### User Story 1: Enter Profile Details
**As a** user,  
**I want** to enter my name and email address,  
**So that** I can personalize my experience in the app.

#### Acceptance Criteria:
- Users can enter their name and email in text fields.
- Users can submit the form to view their entered details.

### User Story 2: View Profile Details
**As a** user,  
**I want** to see my entered profile information,  
**So that** I can confirm my details are correct.

#### Acceptance Criteria:
- After submitting, the screen displays the user's name and email.
- The user can return to the order screen.

### User Story 3: Navigation to Profile Screen
**As a** user,  
**I want** to access the profile/sign-in screen from the order screen,  
**So that** I can easily update or view my details.

#### Acceptance Criteria:
- A link or button is present at the bottom of the order screen to navigate to the profile/sign-in screen.
- Navigation uses named routes for consistency.

## 3. Acceptance Criteria for Feature Completion
- The profile/sign-in screen is accessible from the order screen.
- Users can enter and view their name and email.
- No authentication or data persistence is required.
- The UI is clear and user-friendly.
- Documentation is updated to reflect the new functionality.