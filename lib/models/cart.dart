import 'sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class Cart {
  final Map<Sandwich, int> _items = {};
  static const int maxQuantityPerItem = 99;

  // Returns a read-only copy of the items and their quantities
  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  void add(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    
    if (_items.containsKey(sandwich)) {
      final newQuantity = _items[sandwich]! + quantity;
      _items[sandwich] = newQuantity > maxQuantityPerItem ? maxQuantityPerItem : newQuantity;
    } else {
      _items[sandwich] = quantity > maxQuantityPerItem ? maxQuantityPerItem : quantity;
    }
  }

  void remove(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      final currentQty = _items[sandwich]!;
      if (currentQty > quantity) {
        _items[sandwich] = currentQty - quantity;
      } else {
        _items.remove(sandwich);
      }
    }
  }

  // New method: Update quantity to a specific value
  void updateQuantity(Sandwich sandwich, int quantity) {
    if (quantity <= 0) {
      _items.remove(sandwich);
    } else if (quantity > maxQuantityPerItem) {
      _items[sandwich] = maxQuantityPerItem;
    } else {
      _items[sandwich] = quantity;
    }
  }

  // New method: Remove item completely from cart
  void removeItem(Sandwich sandwich) {
    _items.remove(sandwich);
  }

  void clear() {
    _items.clear();
  }

  double get totalPrice {
    final pricingRepository = PricingRepository();
    double total = 0.0;

    for (Sandwich sandwich in _items.keys) {
      int quantity = _items[sandwich]!;
      total += pricingRepository.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );
    }

    return total;
  }

  // New method: Get price for a specific item in the cart
  double getItemPrice(Sandwich sandwich) {
    final pricingRepository = PricingRepository();
    final quantity = getQuantity(sandwich);
    return pricingRepository.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;

  int get countOfItems {
    int total = 0;
    for (Sandwich sandwich in _items.keys) {
      total += _items[sandwich]!;
    }
    return total;
  }

  int getQuantity(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      return _items[sandwich]!;
    }
    return 0;
  }
}
