import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/food_cart_model.dart';
import '../model/food_model.dart';
import 'food_detail_page.dart';

class FoodDeliveryPage extends StatefulWidget {
  const FoodDeliveryPage({super.key});

  @override
  State<FoodDeliveryPage> createState() => _FoodDeliveryPageState();
}

class _FoodDeliveryPageState extends State<FoodDeliveryPage> {
  String selectedFilter = "All";

  final List<FoodProduct> foods = List.generate(
    20,
        (index) => FoodProduct(
      name: index % 2 == 0
          ? "Veg Meal ${index + 1}"
          : "Chicken Meal ${index + 1}",
      image: "https://picsum.photos/500?food=$index",
      price: "₹${199 + index * 5}",
      description:
      "Delicious healthy meal packed with protein and nutrients.",
      category: index % 2 == 0 ? "Veg" : "Non-Veg",
    ),
  );

  @override
  Widget build(BuildContext context) {
    final filteredFoods = selectedFilter == "All"
        ? foods
        : foods.where((f) => f.category == selectedFilter).toList();

    final cart = Provider.of<FoodCartModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Food Delivery")),
      body: Column(
        children: [

          // FILTER
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: ["All", "Veg", "Non-Veg"]
                  .map(
                    (e) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(e),
                    selected: selectedFilter == e,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = e;
                      });
                    },
                  ),
                ),
              )
                  .toList(),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                final food = filteredFoods[index];
                final isAdded = cart.isInCart(food);

                return Card(
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [

                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          food.image,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      food.price,
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  food.category == "Veg"
                                      ? Icons.eco
                                      : Icons.restaurant,
                                  color: food.category == "Veg"
                                      ? Colors.green
                                      : Colors.red,
                                )
                              ],
                            ),

                            const SizedBox(height: 10),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                isAdded ? Colors.red : Colors.black,
                              ),
                              onPressed: () {
                                if (isAdded) {
                                  cart.remove(food);
                                } else {
                                  cart.add(food);
                                }
                              },
                              child: Text(
                                isAdded ? "Remove" : "Add to Cart",
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: cart.items.isEmpty
          ? null
          : FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, "/food-cart");
        },
        label: Text("Cart (${cart.count})"),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }
}