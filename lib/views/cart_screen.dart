import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  void _goBack() {
    Navigator.pop(context);
  }

  void _incrementQuantity(Sandwich sandwich, int currentQuantity) {
    setState(() {
      if (currentQuantity >= Cart.maxQuantityPerItem) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Maximum quantity of ${Cart.maxQuantityPerItem} reached'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        widget.cart.updateQuantity(sandwich, currentQuantity + 1);
      }
    });
  }

  void _decrementQuantity(Sandwich sandwich, int currentQuantity) {
    setState(() {
      if (currentQuantity > 1) {
        widget.cart.updateQuantity(sandwich, currentQuantity - 1);
      }
    });
  }

  void _removeItem(Sandwich sandwich) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: Text('Remove ${sandwich.name} from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  widget.cart.removeItem(sandwich);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${sandwich.name} removed from cart'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text(
          'Cart View',
          style: heading1,
        ),
      ),
      body: widget.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your cart is empty',
                    style: heading2.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Add some delicious sandwiches!',
                    style: normalText.copyWith(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 30),
                  StyledButton(
                    onPressed: _goBack,
                    icon: Icons.arrow_back,
                    label: 'Back to Order',
                    backgroundColor: Colors.grey,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  for (MapEntry<Sandwich, int> entry
                      in widget.cart.items.entries)
                    CartItemWidget(
                      sandwich: entry.key,
                      quantity: entry.value,
                      onIncrement: () =>
                          _incrementQuantity(entry.key, entry.value),
                      onDecrement: () =>
                          _decrementQuantity(entry.key, entry.value),
                      onRemove: () => _removeItem(entry.key),
                    ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: Colors.blue[50],
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: heading1,
                            ),
                            Text(
                              '£${widget.cart.totalPrice.toStringAsFixed(2)}',
                              style: heading1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  StyledButton(
                    onPressed: _goBack,
                    icon: Icons.arrow_back,
                    label: 'Back to Order',
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
