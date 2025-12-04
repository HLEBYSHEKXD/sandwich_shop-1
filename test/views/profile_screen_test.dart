import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

void main() {
  group('ProfileScreen Widget Tests', () {
    Widget createProfileScreen() {
      return const MaterialApp(
        home: ProfileScreen(),
      );
    }

    testWidgets('shows form fields and submit button', (WidgetTester tester) async {
      await tester.pumpWidget(createProfileScreen());

      expect(find.text('Enter your details'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('shows validation errors if fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(createProfileScreen());

      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(find.text('Enter your name'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('submits form and displays entered details', (WidgetTester tester) async {
      await tester.pumpWidget(createProfileScreen());

      await tester.enterText(find.byType(TextFormField).at(0), 'Alice');
      await tester.enterText(find.byType(TextFormField).at(1), 'alice@example.com');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(find.text('Your Details'), findsOneWidget);
      expect(find.text('Name: Alice'), findsOneWidget);
      expect(find.text('Email: alice@example.com'), findsOneWidget);
      expect(find.text('Back to Order'), findsOneWidget);
    });

    testWidgets('back button pops the screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: ProfileScreen(),
      ));

      await tester.enterText(find.byType(TextFormField).at(0), 'Bob');
      await tester.enterText(find.byType(TextFormField).at(1), 'bob@example.com');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      // Tap the back button
      await tester.tap(find.text('Back to Order'));
      await tester.pumpAndSettle();

      // Should pop the screen (no more ProfileScreen widgets)
      expect(find.text('Profile / Sign-In'), findsNothing);
    });
  });
}
