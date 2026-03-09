import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/shop_product_model.dart';
import '../model/shop_cart_model.dart';
import '../services/payment_service.dart';
import 'shop_page.dart';

class ProductDetailPage extends StatefulWidget {
  final ShopProduct product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() =>
      _ProductDetailPageState();
}

class _ProductDetailPageState
    extends State<ProductDetailPage> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final similarProducts = ShopPage.products
        .where((p) => p.name != product.name)
        .take(6)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Hero(
                  tag: product.name,
                  child: Image.network(
                    product.image,
                    height: 320,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(
                        top:
                        Radius.circular(
                            25)),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        product.name,
                        style:
                        const TextStyle(
                          fontSize: 22,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 10),

                      Text(
                        product.price,
                        style:
                        const TextStyle(
                          fontSize: 20,
                          color:
                          Colors.green,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 15),

                      Text(
                        product.description,
                      ),

                      const SizedBox(
                          height: 25),

                      Row(
                        children: [

                          /// ADD TO CART
                          Expanded(
                            child:
                            ElevatedButton(
                              style:
                              ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                Colors.orange,
                              ),
                              onPressed: () {
                                Provider.of<
                                    ShopCartModel>(
                                    context,
                                    listen:
                                    false)
                                    .add(product);

                                ScaffoldMessenger
                                    .of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Added to Cart"),
                                  ),
                                );
                              },
                              child:
                              const Text(
                                  "Add to Cart"),
                            ),
                          ),

                          const SizedBox(
                              width: 12),

                          /// BUY NOW
                          Expanded(
                            child:
                            ElevatedButton(
                              style:
                              ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                Colors.black,
                              ),
                              onPressed: () {
                                _buyNow(product);
                              },
                              child:
                              const Text(
                                "Buy Now",
                                style: TextStyle(
                                    color:
                                    Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 30),

                      const Text(
                        "Similar Products",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 15),

                      SizedBox(
                        height: 220,
                        child:
                        ListView.builder(
                          scrollDirection:
                          Axis.horizontal,
                          itemCount:
                          similarProducts
                              .length,
                          itemBuilder:
                              (context,
                              index) {
                            final item =
                            similarProducts[
                            index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailPage(
                                          product:
                                          item,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 160,
                                margin:
                                const EdgeInsets
                                    .only(
                                    right:
                                    14),
                                decoration:
                                BoxDecoration(
                                  color:
                                  Colors
                                      .white,
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      15),
                                ),
                                child:
                                Column(
                                  children: [
                                    Expanded(
                                      child:
                                      ClipRRect(
                                        borderRadius:
                                        const BorderRadius
                                            .vertical(
                                            top:
                                            Radius.circular(
                                                15)),
                                        child:
                                        Image.network(
                                          item.image,
                                          fit: BoxFit
                                              .cover,
                                          width: double
                                              .infinity,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets
                                          .all(
                                          6),
                                      child: Text(
                                        item.name,
                                        maxLines:
                                        1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                      ),
                                    ),
                                    Text(
                                      item.price,
                                      style:
                                      const TextStyle(
                                          color:
                                          Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black
                  .withOpacity(0.4),
              child: const Center(
                child:
                CircularProgressIndicator(
                  color:
                  Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _buyNow(ShopProduct product) {
    final payment = PaymentService();

    setState(() => isLoading = true);

    payment.init(
      onSuccess: (response) async {
        final user =
            FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection("orders")
            .add({
          "userId": user?.uid,
          "product": product.name,
          "amount": product.price,
          "type": "shop",
          "createdAt":
          Timestamp.now(),
        });

        if (!mounted) return;

        setState(() => isLoading = false);

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
              content: Text(
                  "Payment Successful 🎉")),
        );
      },
      onFailure: (_) {
        if (!mounted) return;

        setState(() => isLoading = false);

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
              content:
              Text("Payment Failed ❌")),
        );
      },
      onWallet: (_) {},
    );

    final amount =
        double.parse(product.price
            .replaceAll("₹", "")) *
            100;

    payment.openCheckout(
      amount: amount.toInt(),
      name: product.name,
      description:
      "Product Purchase",
    );
  }
}
