import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: heading1,
        ),
      ),
      body: widget.cart.items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: heading2,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = widget.cart.items[index];
                      final sandwich = cartItem.sandwich;

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sandwich.name,
                                          style: heading2,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${sandwich.breadType.name} bread • ${sandwich.isFootlong ? 'Footlong' : 'Six-inch'}',
                                          style: normalText,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.cart.remove(sandwich);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${sandwich.name} removed from cart'),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Quantity:',
                                    style: normalText,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: cartItem.quantity > 1
                                            ? () {
                                                setState(() {
                                                  widget.cart.changeQuantity(
                                                    sandwich,
                                                    cartItem.quantity - 1,
                                                  );
                                                });
                                              }
                                            : null,
                                        icon: const Icon(Icons.remove_circle),
                                      ),
                                      SizedBox(
                                        width: 40,
                                        child: Center(
                                          child: Text(
                                            '${cartItem.quantity}',
                                            style: heading2,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.cart.changeQuantity(
                                              sandwich,
                                              cartItem.quantity + 1,
                                            );
                                          });
                                        },
                                        icon: const Icon(Icons.add_circle),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Price:',
                            style: heading1,
                          ),
                          Text(
                            '£${widget.cart.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[600],
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                'Continue Shopping',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Order placed successfully!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Text(
                                'Checkout',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
