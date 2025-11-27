import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// Simple container representing an entry in the cart.
class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({required this.sandwich, required this.quantity});
}

/// Cart model that holds added sandwiches, allows changing quantities,
/// removing items and computing the total price via [PricingRepository].
class Cart {
  final PricingRepository pricingRepository;

  final List<CartItem> _items = [];

  Cart({PricingRepository? pricingRepository})
      : pricingRepository = pricingRepository ?? PricingRepository();

  /// Returns catalogue of sandwiches that can be added to the cart.
  /// By default this provides one example per SandwichType with default
  /// bread and size; callers can modify the returned Sandwiches when adding.
  List<Sandwich> get availableItems => SandwichType.values
      .map((t) => Sandwich(type: t, isFootlong: false, breadType: BreadType.white))
      .toList();

  /// Unmodifiable view of cart items.
  List<CartItem> get items => List.unmodifiable(_items);

  void add(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    final existingIndex = _items.indexWhere((it) => _sameSandwich(it.sandwich, sandwich));

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Change the quantity for a specific sandwich in the cart. If [quantity]
  /// is less than or equal to zero the item is removed.
  void changeQuantity(Sandwich sandwich, int quantity) {
    final existingIndex = _items.indexWhere((it) => _sameSandwich(it.sandwich, sandwich));
    if (existingIndex == -1) return;

    if (quantity <= 0) {
      _items.removeAt(existingIndex);
    } else {
      _items[existingIndex].quantity = quantity;
    }
  }

  /// Remove an item from the cart entirely.
  void remove(Sandwich sandwich) {
    _items.removeWhere((it) => _sameSandwich(it.sandwich, sandwich));
  }

  /// Total price for all items in the cart, calculated via
  /// [PricingRepository.calculatePrice].
  double get totalPrice {
    double total = 0.0;
    for (final it in _items) {
      total += pricingRepository.calculatePrice(quantity: it.quantity, isFootlong: it.sandwich.isFootlong);
    }
    return total;
  }

  bool _sameSandwich(Sandwich a, Sandwich b) {
    return a.type == b.type && a.isFootlong == b.isFootlong && a.breadType == b.breadType;
  }
}
