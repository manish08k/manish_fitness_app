import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import 'gym_page.dart';
import 'yoga_page.dart';
import 'cardio_page.dart';
import 'profile_page.dart';
import 'martial_arts_page.dart';
import 'screen_ai/chatbot_screen.dart';
import 'analytics_page.dart';
import 'camera_page.dart';
import 'pages/notes_page.dart';
import 'pages/timer_page.dart';
import 'pages/music_page.dart';
import 'pages/gallery_page.dart';
import 'pages/calendar_page.dart';
import 'pages/gym_nearby_page.dart';
import 'pages/shop_page.dart';
import 'pages/premium_page.dart';
import 'pages/food_delivery_page.dart';
import 'pages/supplements_page.dart';
import 'pages/clients_page.dart';
import 'model/cart_model.dart';
import 'pages/cart_page.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {

  int streak = 0;
  DateTime? lastDate;

  final List<Map<String, dynamic>> topFeatureItems = [
    {"title": "Music", "icon": Icons.music_note},
    {"title": "Gallery", "icon": Icons.photo_library},
    {"title": "Clients", "icon": Icons.people},
    {"title": "Gyms Nearby", "icon": Icons.location_on},
    {"title": "Food Delivery", "icon": Icons.fastfood},
    {"title": "Scan Pose", "icon": Icons.camera_alt},
    {"title": "Supplements", "icon": Icons.medical_services},
    {"title": "Schedules", "icon": Icons.calendar_month},
    {"title": "Shop", "icon": Icons.store},
  ];

  final List<Map<String, dynamic>> statCards = [
    {"title": "Steps", "value": "1240", "icon": Icons.directions_walk},
    {"title": "Calories", "value": "320", "icon": Icons.local_fire_department},
    {"title": "Heart Rate", "value": "82 bpm", "icon": Icons.favorite},
    {"title": "Water", "value": "1.2 L", "icon": Icons.water_drop},
    {"title": "Sleep", "value": "6.5 h", "icon": Icons.nightlight_round},
  ];

  @override
  void initState() {
    super.initState();
    loadStreak();
  }

  Future<void> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    streak = prefs.getInt("streak") ?? 0;
    String? savedDate = prefs.getString("lastDate");

    DateTime today = DateTime.now();
    DateTime cleanToday = DateTime(today.year, today.month, today.day);

    if (savedDate != null) {
      lastDate = DateTime.parse(savedDate);
      DateTime cleanLast =
      DateTime(lastDate!.year, lastDate!.month, lastDate!.day);

      int difference = cleanToday.difference(cleanLast).inDays;

      if (difference == 1) {
        streak += 1;
      } else if (difference > 1) {
        streak = 1;
      }
    } else {
      streak = 1;
    }

    await prefs.setInt("streak", streak);
    await prefs.setString("lastDate", cleanToday.toIso8601String());

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const SizedBox(),
        actions: [

          const Icon(Icons.local_fire_department, color: Colors.orange),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Center(
              child: Text(
                "$streak",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Consumer<CartModel>(
            builder: (context, cart, child) {
              return badges.Badge(
                showBadge: cart.items.isNotEmpty,
                badgeContent: Text(
                  cart.items.length.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CartPage()),
                    );
                  },
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ChatBotScreen()),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Menu",
                  style: TextStyle(
                      color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount: topFeatureItems.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        return buildTopCard(
                            topFeatureItems[index]['title'],
                            topFeatureItems[index]['icon']);
                      },
                    ),

                    const SizedBox(height: 20),

                    buildOptionBox(context, "Gym",
                        Icons.fitness_center, const GymPage(),
                        Colors.blue.shade100),

                    buildOptionBox(context, "Yoga",
                        Icons.self_improvement, const YogaPage(),
                        Colors.green.shade100),

                    buildOptionBox(context, "Cardio",
                        Icons.run_circle, const CardioPage(),
                        Colors.red.shade100),

                    buildOptionBox(context, "Martial Arts",
                        Icons.sports_mma, const MartialArtsPage(),
                        Colors.purple.shade100),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: statCards.length,
                        itemBuilder: (context, index) {
                          return buildStatCard(
                              statCards[index]['title'],
                              statCards[index]['value'],
                              statCards[index]['icon']);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              height: 70,
              color: Colors.white,
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.store, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShopPage(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.auto_graph, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const AnalyticsPage(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon:
                    const Icon(Icons.camera_alt, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const CameraPage(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                        Icons.workspace_premium,
                        size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const PremiumPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopCard(String title, IconData icon) {
    return GestureDetector(
      onTap: () {

        if (title == "Music") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const MusicPage()));
        }

        if (title == "Gallery") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const GalleryPage()));
        }

        if (title == "Scan Pose") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CameraPage()));
        }

        if (title == "Schedules") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CalendarPage()));
        }

        if (title == "Gyms Nearby") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const GymNearbyPage()));
        }

        if (title == "Shop") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ShopPage()));
        }

        // 🔥 ADD THESE 3 (THIS IS WHAT WAS MISSING)

        if (title == "Food Delivery") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const FoodDeliveryPage()));
        }

        if (title == "Supplements") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SupplementsPage()));
        }

        if (title == "Clients") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ClientsPage()));
        }
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3))
          ],
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 6),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget buildStatCard(
      String title, String value, IconData icon) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold)),
          Text(value,
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget buildOptionBox(BuildContext context,
      String title,
      IconData icon,
      Widget page,
      Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        margin:
        const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40),
            const SizedBox(width: 15),
            Text(title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
