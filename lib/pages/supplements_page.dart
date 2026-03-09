import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/shop_product_model.dart';
import '../model/shop_cart_model.dart';

class SupplementsPage extends StatelessWidget {
  const SupplementsPage({super.key});

  static final List<ShopProduct> supplements = [
    ShopProduct(
      name: "Whey Protein",
      image: "https://picsum.photos/400?protein",
      price: "₹1999",
      description: "Premium whey protein.",
    ),
    ShopProduct(
      name: "Creatine Monohydrate",
      image: "https://picsum.photos/400?creatine",
      price: "₹799",
      description: "Boost strength & power.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Supplements")),
      body: Consumer<ShopCartModel>(
        builder: (context, cart, child) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: supplements.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final product = supplements[index];
              final isAdded = cart.isInCart(product);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      product.price,
                      style: const TextStyle(color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isAdded ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        if (isAdded) {
                          cart.remove(product);
                        } else {
                          cart.add(product);
                        }
                      },
                      child: Text(
                        isAdded ? "Remove" : "Add",
                        style:
                        const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}