import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('Cart model', () {
    late Cart cart;

    setUp(() {
      cart = Cart();
    });

    test('initializes with empty items', () {
      expect(cart.items, isEmpty);
    });

    test('initializes with zero total price', () {
      expect(cart.totalPrice, 0.0);
    });

    test('availableItems returns one sandwich per SandwichType', () {
      final available = cart.availableItems;
      expect(available.length, SandwichType.values.length);
      expect(available[0].type, SandwichType.veggieDelight);
      expect(available[1].type, SandwichType.chickenTeriyaki);
      expect(available[2].type, SandwichType.tunaMelt);
      expect(available[3].type, SandwichType.meatballMarinara);
    });

    group('add', () {
      test('adds a new sandwich to cart', () {
        final sandwich = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.wheat,
        );
        cart.add(sandwich);
        expect(cart.items.length, 1);
        expect(cart.items[0].sandwich.type, SandwichType.chickenTeriyaki);
        expect(cart.items[0].quantity, 1);
      });

      test('adds multiple sandwiches with custom quantity', () {
        final sandwich = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.wholemeal,
        );
        cart.add(sandwich, quantity: 3);
        expect(cart.items.length, 1);
        expect(cart.items[0].quantity, 3);
      });

      test('increments quantity for identical sandwich', () {
        final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        );
        cart.add(sandwich, quantity: 2);
        cart.add(sandwich, quantity: 1);
        expect(cart.items.length, 1);
        expect(cart.items[0].quantity, 3);
      });

      test('keeps separate items for different sandwich specs', () {
        final sandwich1 = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        );
        final sandwich2 = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
        );
        cart.add(sandwich1);
        cart.add(sandwich2);
        expect(cart.items.length, 2);
      });

      test('ignores add with zero quantity', () {
        final sandwich = Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: false,
          breadType: BreadType.white,
        );
        cart.add(sandwich, quantity: 0);
        expect(cart.items.length, 0);
      });

      test('ignores add with negative quantity', () {
        final sandwich = Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: false,
          breadType: BreadType.white,
        );
        cart.add(sandwich, quantity: -5);
        expect(cart.items.length, 0);
      });
    });

    group('changeQuantity', () {
      test('updates quantity for existing sandwich', () {
        final sandwich = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.wheat,
        );
        cart.add(sandwich, quantity: 2);
        cart.changeQuantity(sandwich, 5);
        expect(cart.items[0].quantity, 5);
      });

      test('removes item when quantity set to zero', () {
        final sandwich = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.wholemeal,
        );
        cart.add(sandwich);
        cart.changeQuantity(sandwich, 0);
        expect(cart.items, isEmpty);
      });

      test('removes item when quantity set to negative', () {
        final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        );
        cart.add(sandwich);
        cart.changeQuantity(sandwich, -1);
        expect(cart.items, isEmpty);
      });

      test('ignores changeQuantity for non-existent sandwich', () {
        final sandwich = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.wheat,
        );
        cart.changeQuantity(sandwich, 5);
        expect(cart.items, isEmpty);
      });
    });

    group('remove', () {
      test('removes existing sandwich from cart', () {
        final sandwich = Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: false,
          breadType: BreadType.white,
        );
        cart.add(sandwich);
        cart.remove(sandwich);
        expect(cart.items, isEmpty);
      });

      test('removes only matching sandwich', () {
        final sandwich1 = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        );
        final sandwich2 = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.white,
        );
        cart.add(sandwich1);
        cart.add(sandwich2);
        cart.remove(sandwich1);
        expect(cart.items.length, 1);
        expect(cart.items[0].sandwich.type, SandwichType.chickenTeriyaki);
      });

      test('ignores remove for non-existent sandwich', () {
        final sandwich1 = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        );
        final sandwich2 = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.white,
        );
        cart.add(sandwich1);
        cart.remove(sandwich2);
        expect(cart.items.length, 1);
        expect(cart.items[0].sandwich.type, SandwichType.veggieDelight);
      });
    });

    group('totalPrice', () {
      test('calculates zero for empty cart', () {
        expect(cart.totalPrice, 0.0);
      });

      test('calculates price for single six-inch sandwich', () {
        final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        );
        cart.add(sandwich, quantity: 1);
        // 6-inch = £7.00
        expect(cart.totalPrice, 7.0);
      });

      test('calculates price for single footlong sandwich', () {
        final sandwich = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.wheat,
        );
        cart.add(sandwich, quantity: 1);
        // footlong = £11.00
        expect(cart.totalPrice, 11.0);
      });

      test('calculates price for multiple six-inch sandwiches', () {
        final sandwich = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wholemeal,
        );
        cart.add(sandwich, quantity: 3);
        // 3 × £7.00 = £21.00
        expect(cart.totalPrice, 21.0);
      });

      test('calculates price for multiple footlong sandwiches', () {
        final sandwich = Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: true,
          breadType: BreadType.white,
        );
        cart.add(sandwich, quantity: 2);
        // 2 × £11.00 = £22.00
        expect(cart.totalPrice, 22.0);
      });

      test('calculates total price for mixed sandwiches', () {
        final sixInch = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        );
        final footlong = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.wheat,
        );
        cart.add(sixInch, quantity: 2);
        cart.add(footlong, quantity: 1);
        // (2 × £7.00) + (1 × £11.00) = £14.00 + £11.00 = £25.00
        expect(cart.totalPrice, 25.0);
      });

      test('updates total price after removing item', () {
        final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        );
        cart.add(sandwich, quantity: 3);
        expect(cart.totalPrice, 21.0);
        cart.changeQuantity(sandwich, 1);
        expect(cart.totalPrice, 7.0);
      });
    });

    group('items getter', () {
      test('returns unmodifiable list', () {
        final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        );
        cart.add(sandwich);
        final items = cart.items;
        expect(() => items.add(CartItem(sandwich: sandwich, quantity: 1)), throwsUnsupportedError);
      });

      test('reflects cart state after modifications', () {
        final sandwich = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.wheat,
        );
        expect(cart.items.length, 0);
        cart.add(sandwich);
        expect(cart.items.length, 1);
        cart.remove(sandwich);
        expect(cart.items.length, 0);
      });
    });

    group('custom PricingRepository', () {
      test('uses injected PricingRepository for price calculation', () {
        final mockPricing = PricingRepository();
        final customCart = Cart(pricingRepository: mockPricing);
        final sandwich = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        );
        customCart.add(sandwich, quantity: 2);
        // Uses same pricing logic: 2 × £7.00 = £14.00
        expect(customCart.totalPrice, 14.0);
      });
    });
  });
}
