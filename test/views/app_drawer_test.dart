import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/app_drawer.dart';

void main() {
  group('AppDrawer Widget Tests', () {
    Widget createDrawerTestApp() {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Test')),
          drawer: const AppDrawer(),
          body: const Center(child: Text('Test Screen')),
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/about':
              return MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('About Screen')),
              );
            case '/profile':
              return MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('Profile Screen')),
              );
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('Cart Screen')),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('Home Screen')),
              );
          }
        },
      );
    }

    testWidgets('drawer displays header with logo and title', (WidgetTester tester) async {
      await tester.pumpWidget(createDrawerTestApp());

      final ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Shop'), findsOneWidget);
      expect(find.byIcon(Icons.fastfood), findsOneWidget);
    });

    testWidgets('drawer contains all navigation items', (WidgetTester tester) async {
      await tester.pumpWidget(createDrawerTestApp());

      final ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('About Us'), findsOneWidget);
      expect(find.text('Profile / Sign-In'), findsOneWidget);
    });

    testWidgets('drawer items have correct icons', (WidgetTester tester) async {
      await tester.pumpWidget(createDrawerTestApp());

      final ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('tapping about navigates to about screen', (WidgetTester tester) async {
      await tester.pumpWidget(createDrawerTestApp());

      final ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('About Us'));
      await tester.pumpAndSettle();

      expect(find.text('About Screen'), findsOneWidget);
    });

    testWidgets('tapping profile navigates to profile screen', (WidgetTester tester) async {
      await tester.pumpWidget(createDrawerTestApp());

      final ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile / Sign-In'));
      await tester.pumpAndSettle();

      expect(find.text('Profile Screen'), findsOneWidget);
    });

    testWidgets('tapping cart navigates to cart screen', (WidgetTester tester) async {
      await tester.pumpWidget(createDrawerTestApp());

      final ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cart'));
      await tester.pumpAndSettle();

      expect(find.text('Cart Screen'), findsOneWidget);
    });

    testWidgets('drawer header has correct structure', (WidgetTester tester) async {
      await tester.pumpWidget(createDrawerTestApp());

      final ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      final DrawerHeader header = tester.widget(find.byType(DrawerHeader));
      expect(header, isNotNull);
    });

    testWidgets('drawer closes after navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createDrawerTestApp());

      final ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('About Us'));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsNothing);
    });

    testWidgets('drawer is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(createDrawerTestApp());

      final ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      final ListView listView = tester.widget(find.byType(ListView));
      expect(listView, isNotNull);
    });
  });
}
