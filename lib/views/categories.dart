import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import 'category_detail.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> categories = [];
  List<Category> _filteredCategories = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void _filterCategories(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredCategories = categories; // Reset to full list
      } else {
        _filteredCategories = categories
            .where((category) => category.name!.toLowerCase().contains(_searchQuery))
            .toList();
      }
    });
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products/categories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        categories = jsonResponse.map((data) => Category.fromJson(data)).toList();
        _filteredCategories = categories; // Initialize filtered list
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<String?> fetchCategoryThumbnail(String categoryUrl) async {
    final response = await http.get(Uri.parse(categoryUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final products = data['products'] as List;
      if (products.isNotEmpty) {
        final firstProduct = products[0] as Map<String, dynamic>;
        return firstProduct['thumbnail'] as String?;
      }
    }
    return null; // Handle cases where no products are found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Categories'),
        elevation: 0, // No title bar elevation
        backgroundColor: Colors.white,
      ),
      body: categories.isEmpty
          ? const Center(child: Text('No categories found'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _filterCategories,
                    decoration: InputDecoration(
                      hintText: 'Search Categories',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_filteredCategories.length} result${_filteredCategories.length == 1 ? '' : 's'} found',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                    ),
                    itemCount: _filteredCategories.length, // Use filtered list here
                    itemBuilder: (context, index) {
                      final category = _filteredCategories[index];
                      return FutureBuilder<String?>(
                        future: fetchCategoryThumbnail(category.url!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            final thumbnailUrl = snapshot.data;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      categoryUrl: category.url!,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 0,
                                color: Colors.white,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Image
                                    Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: FittedBox(
                                          child: Image.network(
                                            thumbnailUrl!,
                                            fit: BoxFit.fill,
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image, size: 50),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Overlay with category name
                                    Positioned(
                                      bottom: 25,
                                      left: 30,
                                      child: Container(
                                        color: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        child: Text(
                                          category.name!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else {
                            return const Center(child: Text('Error loading image'));
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
