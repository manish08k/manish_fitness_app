import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  // Load saved image paths
  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? imagePaths = prefs.getStringList("saved_images");

    if (imagePaths != null) {
      setState(() {
        _images = imagePaths.map((path) => File(path)).toList();
      });
    }
  }

  // Save image paths
  Future<void> _saveImages() async {
    final prefs = await SharedPreferences.getInstance();
    final paths = _images.map((file) => file.path).toList();
    await prefs.setStringList("saved_images", paths);
  }

  // Pick Image
  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source);

    if (picked != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String newPath =
          "${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png";

      final File newImage = await File(picked.path).copy(newPath);

      setState(() {
        _images.add(newImage);
      });

      _saveImages();
    }
  }

  // Delete image
  void _deleteImage(int index) async {
    await _images[index].delete();

    setState(() {
      _images.removeAt(index);
    });

    _saveImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text("My Progress Gallery"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text("Pick from Gallery"),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text("Take Photo"),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      body: _images.isEmpty
          ? const Center(
        child: Text(
          "No Images Yet\nAdd your transformation photos 💪",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: _images.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () => _deleteImage(index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.file(
                        _images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: const Text(
                          "Progress Shot",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
