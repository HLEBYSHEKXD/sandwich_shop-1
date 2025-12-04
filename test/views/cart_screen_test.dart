import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/widgets/cart_item_widget.dart';

void main() {
  group('CartScreen Widget Tests', () {
    late Cart cart;
    late Sandwich testSandwich1;
    late Sandwich testSandwich2;

    setUp(() {
      cart = Cart();
      testSandwich1 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        breadType: BreadType.white,
        isFootlong: true,
      );
      testSandwich2 = Sandwich(
        type: SandwichType.tunaMelt,
        breadType: BreadType.wheat,
        isFootlong: false,
      );
    });

    Widget createCartScreen() {
      return MaterialApp(
        home: CartScreen(cart: cart),
      );
    }

    testWidgets('displays empty state when cart is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createCartScreen());

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Add some delicious sandwiches!'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.text('Back to Order'), findsOneWidget);
    });

    testWidgets('displays cart items when cart has items', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 2);
      cart.add(testSandwich2, quantity: 1);

      await tester.pumpWidget(createCartScreen());

      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Tuna Melt'), findsOneWidget);
      expect(find.byType(CartItemWidget), findsNWidgets(2));
    });

    testWidgets('displays correct total price', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 2); // 2 * £11 = £22
      cart.add(testSandwich2, quantity: 1); // 1 * £7 = £7
      // Total = £29.00

      await tester.pumpWidget(createCartScreen());

      expect(find.text('Total:'), findsOneWidget);
      expect(find.text('£29.00'), findsOneWidget);
    });

    testWidgets('increments quantity when increment button is pressed', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 1);

      await tester.pumpWidget(createCartScreen());

      // Find and tap the increment button
      final incrementButton = find.byIcon(Icons.add_circle_outline).first;
      await tester.tap(incrementButton);
      await tester.pump();

      // Verify quantity increased
      expect(cart.getQuantity(testSandwich1), 2);
    });

    testWidgets('decrements quantity when decrement button is pressed', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 3);

      await tester.pumpWidget(createCartScreen());

      // Find and tap the decrement button
      final decrementButton = find.byIcon(Icons.remove_circle_outline).first;
      await tester.tap(decrementButton);
      await tester.pump();

      // Verify quantity decreased
      expect(cart.getQuantity(testSandwich1), 2);
    });

    testWidgets('decrement button is disabled when quantity is 1', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 1);

      await tester.pumpWidget(createCartScreen());

      // Find the CartItemWidget and check if decrement button is disabled
      final cartItemWidgets = find.byType(CartItemWidget);
      expect(cartItemWidgets, findsOneWidget);
      
      final CartItemWidget widget = tester.widget(cartItemWidgets);
      expect(widget.quantity, 1);
      
      // Try to tap decrement - it should do nothing since quantity is 1
      final decrementButton = find.byIcon(Icons.remove_circle_outline).first;
      await tester.tap(decrementButton);
      await tester.pump();
      
      // Quantity should still be 1
      expect(cart.getQuantity(testSandwich1), 1);
    });

    testWidgets('shows confirmation dialog when remove button is pressed', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 2);

      await tester.pumpWidget(createCartScreen());

      // Tap the delete button
      final deleteButton = find.byIcon(Icons.delete).first;
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Verify confirmation dialog appears
      expect(find.text('Remove Item'), findsOneWidget);
      expect(find.text('Remove Chicken Teriyaki from your cart?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);
    });

    testWidgets('removes item when confirmed in dialog', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 2);

      await tester.pumpWidget(createCartScreen());

      // Tap the delete button
      final deleteButton = find.byIcon(Icons.delete).first;
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Confirm removal
      final removeButton = find.text('Remove');
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      // Verify item was removed
      expect(cart.getQuantity(testSandwich1), 0);
      expect(find.text('Chicken Teriyaki removed from cart'), findsOneWidget);
    });

    testWidgets('does not remove item when cancel is pressed in dialog', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 2);

      await tester.pumpWidget(createCartScreen());

      // Tap the delete button
      final deleteButton = find.byIcon(Icons.delete).first;
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Cancel removal
      final cancelButton = find.text('Cancel');
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Verify item was NOT removed
      expect(cart.getQuantity(testSandwich1), 2);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('shows empty state after removing last item', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 1);

      await tester.pumpWidget(createCartScreen());

      // Remove the item
      final deleteButton = find.byIcon(Icons.delete).first;
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      final removeButton = find.text('Remove');
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      // Verify empty state is shown
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('shows snackbar when maximum quantity is reached', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: Cart.maxQuantityPerItem);

      await tester.pumpWidget(createCartScreen());

      // Try to increment beyond max
      final incrementButton = find.byIcon(Icons.add_circle_outline).first;
      await tester.tap(incrementButton);
      await tester.pumpAndSettle(); // Changed from pump() to pumpAndSettle()

      // Verify snackbar appears
      expect(find.text('Maximum quantity of ${Cart.maxQuantityPerItem} reached'), findsOneWidget);
      
      // Verify quantity didn't increase
      expect(cart.getQuantity(testSandwich1), Cart.maxQuantityPerItem);
    });

    testWidgets('increment button is disabled at maximum quantity', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: Cart.maxQuantityPerItem);

      await tester.pumpWidget(createCartScreen());

      // Find the CartItemWidget and check if increment button is disabled
      final cartItemWidgets = find.byType(CartItemWidget);
      expect(cartItemWidgets, findsOneWidget);
      
      final CartItemWidget widget = tester.widget(cartItemWidgets);
      expect(widget.quantity, Cart.maxQuantityPerItem);
      
      // Try to tap increment - it should do nothing since at max
      final incrementButton = find.byIcon(Icons.add_circle_outline).first;
      await tester.tap(incrementButton);
      await tester.pump();
      
      // Quantity should still be at max
      expect(cart.getQuantity(testSandwich1), Cart.maxQuantityPerItem);
    });

    testWidgets('total price updates correctly after multiple modifications', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 2); // 2 * £11 = £22
      cart.add(testSandwich2, quantity: 1); // 1 * £7 = £7
      // Initial total = £29.00

      await tester.pumpWidget(createCartScreen());

      expect(find.text('£29.00'), findsOneWidget);

      // Increment testSandwich2 (now 2 * £7 = £14, total = £36)
      final incrementButtons = find.byIcon(Icons.add_circle_outline);
      await tester.tap(incrementButtons.last);
      await tester.pump();

      expect(find.text('£36.00'), findsOneWidget);

      // Decrement testSandwich1 (now 1 * £11 = £11, total = £25)
      final decrementButtons = find.byIcon(Icons.remove_circle_outline);
      await tester.tap(decrementButtons.first);
      await tester.pump();

      expect(find.text('£25.00'), findsOneWidget);
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 1);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
              ),
              child: const Text('Go to Cart'),
            ),
          ),
        ),
      ));

      // Navigate to cart
      await tester.tap(find.text('Go to Cart'));
      await tester.pumpAndSettle();

      // Verify we're on cart screen
      expect(find.text('Cart View'), findsOneWidget);

      // Tap back button
      await tester.tap(find.text('Back to Order'));
      await tester.pumpAndSettle();

      // Verify we navigated back
      expect(find.text('Go to Cart'), findsOneWidget);
    });

    testWidgets('displays correct sandwich details', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 1);

      await tester.pumpWidget(createCartScreen());

      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      // The price £11.00 appears twice: once as item price, once as total
      expect(find.text('£11.00'), findsNWidgets(2));
      // Verify we have the Total label
      expect(find.text('Total:'), findsOneWidget);
    });

    testWidgets('handles multiple items correctly', (WidgetTester tester) async {
      cart.add(testSandwich1, quantity: 2);
      cart.add(testSandwich2, quantity: 3);

      await tester.pumpWidget(createCartScreen());

      // Verify both items are displayed
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Tuna Melt'), findsOneWidget);
      
      // Verify quantities are correct
      expect(cart.getQuantity(testSandwich1), 2);
      expect(cart.getQuantity(testSandwich2), 3);
      
      // Verify total (2 * £11 + 3 * £7 = £43)
      expect(find.text('£43.00'), findsOneWidget);
    });
  });
}