import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('OrderScreen Widget Tests', () {
    testWidgets('OrderScreen displays initial state correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Verify initial UI elements are present
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Sandwich Type'), findsOneWidget);
      expect(find.text('Bread Type'), findsOneWidget);
      expect(find.text('Quantity: '), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);

      // Verify initial sandwich type is displayed
      expect(find.text('Veggie Delight'), findsWidgets);

      // Verify initial quantity is 1
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Can increase quantity using add button',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Initial quantity is 1
      expect(find.text('1'), findsOneWidget);

      // Find and tap the add button (plus icon)
      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Quantity should be 2
      expect(find.text('2'), findsOneWidget);

      // Tap again
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Quantity should be 3
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('Can decrease quantity using remove button',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Increase quantity first
      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Now quantity is 3
      expect(find.text('3'), findsOneWidget);

      // Find and tap the remove button (minus icon)
      final removeButton = find.byIcon(Icons.remove);
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      // Quantity should be 2
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('Remove button is disabled when quantity is 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Initial quantity is 1, so we need to decrease once
      final removeButton = find.byIcon(Icons.remove).first;
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      // Quantity should be 0
      expect(find.text('0'), findsOneWidget);

      // Try to tap remove button again - should be disabled
      final removeButtonWidget =
          find.ancestor(of: find.byIcon(Icons.remove), matching: find.byType(IconButton));
      expect(tester.widget<IconButton>(removeButtonWidget.first).onPressed, isNull);
    });

    testWidgets('Can change sandwich type from dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Open sandwich type dropdown
      await tester.tap(find.byType(DropdownMenu<SandwichType>).first);
      await tester.pumpAndSettle();

      // Select Chicken Teriyaki
      await tester.tap(find.text('Chicken Teriyaki'));
      await tester.pumpAndSettle();

      // Verify Chicken Teriyaki is now selected
      expect(find.text('Chicken Teriyaki'), findsWidgets);
    });

    testWidgets('Can toggle between six-inch and footlong',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Initial state should show "Footlong" (value is true)
      expect(find.text('Six-inch'), findsOneWidget);
      expect(find.text('Footlong'), findsOneWidget);

      // Find and tap the Switch
      final switchWidget = find.byType(Switch);
      await tester.tap(switchWidget);
      await tester.pumpAndSettle();

      // Switch should now be in six-inch position (value is false)
      // The text remains the same, but the switch value changed
      final switchState = tester.widget<Switch>(switchWidget);
      expect(switchState.value, false);
    });

    testWidgets('Can change bread type from dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Find the second dropdown (bread type)
      final dropdowns = find.byType(DropdownMenu<BreadType>);
      await tester.tap(dropdowns);
      await tester.pumpAndSettle();

      // Select Wheat bread
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      // Verify wheat is now selected (should be visible in the dropdown)
      expect(find.text('wheat'), findsWidgets);
    });

    testWidgets('Can add items to cart with selected options',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Set quantity to 2
      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Verify quantity is 2
      expect(find.text('2'), findsOneWidget);

      // Tap Add to Cart button
      await tester.tap(find.byIcon(Icons.add_shopping_cart));
      await tester.pumpAndSettle();

      // Verify quantity resets to 1 after adding to cart
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Multiple items can be added to cart sequentially',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Add first item (quantity 1)
      await tester.tap(find.byIcon(Icons.add_shopping_cart));
      await tester.pumpAndSettle();

      // Change sandwich type
      await tester.tap(find.byType(DropdownMenu<SandwichType>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chicken Teriyaki'));
      await tester.pumpAndSettle();

      // Increase quantity to 2
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Add second item (quantity 2)
      await tester.tap(find.byIcon(Icons.add_shopping_cart));
      await tester.pumpAndSettle();

      // Verify quantity is back to 1
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Add to Cart button is disabled with zero quantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Decrease quantity to 0
      final removeButton = find.byIcon(Icons.remove).first;
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      // Verify quantity is 0
      expect(find.text('0'), findsOneWidget);

      // Add to Cart button should be disabled
      final addToCartButton = find.byIcon(Icons.add_shopping_cart);
      expect(
        tester.widget<ElevatedButton>(find.ancestor(
          of: addToCartButton,
          matching: find.byType(ElevatedButton),
        )).onPressed,
        isNull,
      );
    });

    testWidgets('Can change all options before adding to cart',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Change sandwich type
      await tester.tap(find.byType(DropdownMenu<SandwichType>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tuna Melt'));
      await tester.pumpAndSettle();

      // Toggle to six-inch
      final switchWidget = find.byType(Switch);
      await tester.tap(switchWidget);
      await tester.pumpAndSettle();

      // Change bread type
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wholemeal').last);
      await tester.pumpAndSettle();

      // Increase quantity to 3
      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Verify all options are set
      expect(find.text('Tuna Melt'), findsWidgets);
      expect(find.text('3'), findsOneWidget);

      // Add to cart with all custom options
      await tester.tap(find.byIcon(Icons.add_shopping_cart));
      await tester.pumpAndSettle();

      // Verify quantity resets
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Image displays for selected sandwich',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Find Image widget
      final imageWidget = find.byType(Image);
      expect(imageWidget, findsOneWidget);

      // Verify it's trying to load an asset (even if it fails due to missing asset)
      final image = tester.widget<Image>(imageWidget);
      expect(image.image, isNotNull);
    });

    testWidgets('Changing sandwich type updates image path',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Get initial image source
      var image = tester.widget<Image>(find.byType(Image));
      final initialImageSource = image.image.toString();

      // Change sandwich type
      await tester.tap(find.byType(DropdownMenu<SandwichType>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chicken Teriyaki'));
      await tester.pumpAndSettle();

      // Get updated image source
      image = tester.widget<Image>(find.byType(Image));
      final updatedImageSource = image.image.toString();

      // Image path should be different
      expect(initialImageSource, isNot(equals(updatedImageSource)));
    });

    testWidgets('All sandwich types can be selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final sandwichTypes = ['Veggie Delight', 'Chicken Teriyaki', 'Tuna Melt', 'Meatball Marinara'];

      for (final sandwichType in sandwichTypes) {
        // Open dropdown
        await tester.tap(find.byType(DropdownMenu<SandwichType>).first);
        await tester.pumpAndSettle();

        // Select sandwich type
        await tester.tap(find.text(sandwichType));
        await tester.pumpAndSettle();

        // Verify it's selected
        expect(find.text(sandwichType), findsWidgets);
      }
    });

    testWidgets('All bread types can be selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final breadTypes = ['white', 'wheat', 'wholemeal'];

      for (final breadType in breadTypes) {
        // Open dropdown
        await tester.tap(find.byType(DropdownMenu<BreadType>));
        await tester.pumpAndSettle();

        // Select bread type
        await tester.tap(find.text(breadType).last);
        await tester.pumpAndSettle();

        // Verify it's selected
        expect(find.text(breadType), findsWidgets);
      }
    });
  });
}
