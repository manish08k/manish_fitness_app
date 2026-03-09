import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/shop_cart_model.dart';
import '../services/payment_service.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<ShopCartModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: cart.items.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];

                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.price),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      cart.remove(item);
                    },
                  ),
                );
              },
            ),
          ),

          /// TOTAL + CHECKOUT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Total: ₹${cart.totalPrice}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _startPayment(context, cart);
                  },
                  child: const Text("Checkout"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startPayment(BuildContext context, ShopCartModel cart) {
    final payment = PaymentService();

    payment.init(
      onSuccess: (response) async {
        final user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection("orders").add({
          "userId": user?.uid,
          "amount": cart.totalPrice,
          "products": cart.items.map((e) => e.name).toList(),
          "paymentId": response.paymentId,
          "createdAt": Timestamp.now(),
        });

        /// PREMIUM UNLOCK LOGIC
        if (cart.items.any((item) => item.name.contains("Premium"))) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user?.uid)
              .update({"isPremium": true});
        }

        cart.clear();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Payment Success")),
          );
        }
      },
      onFailure: (response) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Payment Failed")),
          );
        }
      },
      onWallet: (response) {},
    );

    payment.openCheckout(
      amount: (cart.totalPrice * 100).toInt(),
      name: "Manish Fitness",
      description: "Cart Payment",
    );
  }
}
