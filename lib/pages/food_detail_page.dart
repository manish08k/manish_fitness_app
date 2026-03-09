import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/food_cart_model.dart';
import '../model/food_model.dart';

class FoodDetailPage extends StatelessWidget {
  final FoodProduct food;

  const FoodDetailPage({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<FoodCartModel>(context);

    final isAdded = cart.isInCart(food);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  food.image,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        food.price,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        food.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ADD / REMOVE BUTTON
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: isAdded ? Colors.red : Colors.black,
              onPressed: () {
                if (isAdded) {
                  cart.remove(food);
                } else {
                  cart.add(food);
                }
              },
              child: Icon(isAdded ? Icons.remove : Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
