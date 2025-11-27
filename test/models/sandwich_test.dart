import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name getter returns correct display name', () {
      final s1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      expect(s1.name, 'Veggie Delight');

      final s2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.white,
      );
      expect(s2.name, 'Chicken Teriyaki');
    });

    test('image getter returns correct asset path for sizes', () {
      final footlong = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );
      expect(footlong.image, 'assets/images/tunaMelt_footlong.png');

      final sixInch = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: false,
        breadType: BreadType.white,
      );
      expect(sixInch.image, 'assets/images/meatballMarinara_six_inch.png');
    });
  });
}
