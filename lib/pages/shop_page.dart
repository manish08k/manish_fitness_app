import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/shop_product_model.dart';
import '../model/shop_cart_model.dart';
import 'product_detail_page.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  static final List<ShopProduct> products = List.generate(
    20,
        (index) => ShopProduct(
      name: "Fitness Product ${index + 1}",
      image: "https://picsum.photos/300?random=$index",
      price: "₹${999 + index * 10}",
      description:
      "High quality fitness product designed to improve your workouts and performance.",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Fitness Shop"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final product = products[index];

          return Consumer<ShopCartModel>(
            builder: (context, cart, child) {
              final isAdded =
              cart.isInCart(product);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    /// IMAGE
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(
                                      product:
                                      product),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius:
                          const BorderRadius
                              .vertical(
                            top:
                            Radius.circular(
                                15),
                          ),
                          child: Image.network(
                            product.image,
                            fit: BoxFit.cover,
                            width:
                            double.infinity,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding:
                      const EdgeInsets.all(
                          8),
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    Padding(
                      padding:
                      const EdgeInsets
                          .symmetric(
                          horizontal:
                          8),
                      child: Text(
                        product.price,
                        style:
                        const TextStyle(
                          color:
                          Colors.green,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding:
                      const EdgeInsets
                          .symmetric(
                          horizontal:
                          8),
                      child:
                      ElevatedButton(
                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          isAdded
                              ? Colors.red
                              : Colors.black,
                          minimumSize:
                          const Size
                              .fromHeight(
                              40),
                        ),
                        onPressed: () {
                          if (isAdded) {
                            cart.remove(
                                product);
                          } else {
                            cart.add(
                                product);
                          }
                        },
                        child: Text(
                          isAdded
                              ? "Remove"
                              : "Add to Cart",
                          style:
                          const TextStyle(
                            color:
                            Colors.white,
                          ),
                        ),
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
