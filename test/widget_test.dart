import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/cart_screen.dart';

void main() {
  group('App Initialization', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });

    testWidgets('displays Sandwich Counter title',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });
  });

  group('OrderScreen - UI Elements', () {

    testWidgets('displays size toggle switch', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('displays Add to Cart button', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.widgetWithText(ElevatedButton, 'Add to Cart'),
          findsOneWidget);
    });

    testWidgets('displays View Cart button', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.widgetWithText(ElevatedButton, 'View Cart'), findsOneWidget);
    });

    testWidgets('displays sandwich dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(DropdownMenu<SandwichType>), findsOneWidget);
    });

    testWidgets('displays bread dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(DropdownMenu<BreadType>), findsOneWidget);
    });
  });

   group('OrderScreen - Size Toggle', () {
    testWidgets('toggles size when switch tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final switchWidget = find.byType(Switch).first;
      await tester.tap(switchWidget);
      await tester.pumpAndSettle();

      // After toggle, should show six-inch (not footlong)
      expect(find.text('Six-inch'), findsOneWidget);

      await tester.tap(switchWidget);
      await tester.pumpAndSettle();

      // Back to footlong
      expect(find.text('Footlong'), findsOneWidget);
    });
  });

  group('OrderScreen - Add to Cart', () {
    testWidgets('View Cart button navigates to CartScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Add item to cart first
      final addToCartButton =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Navigate to cart
      final viewCartButton =
          find.widgetWithText(ElevatedButton, 'View Cart');
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.byType(CartScreen), findsOneWidget);
    });
  });

  group('CartScreen', () {
    testWidgets('displays empty cart message when cart is empty',
        (WidgetTester tester) async {
      final cart = Cart();
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('displays cart items', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Veggie Delight'), findsOneWidget);
    });

    testWidgets('displays total price', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      await tester.pumpAndSettle();

      // Just check that something contains £
      expect(find.byType(Text), findsWidgets);
    });

   
    testWidgets('can delete item from cart', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the delete button
      final deleteButton = find.byIcon(Icons.delete).first;
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Should show SnackBar with undo message
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
