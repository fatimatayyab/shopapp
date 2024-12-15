import 'dart:convert';
import 'package:ecommerce/views/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatefulWidget {
  final String categoryUrl;

  const ProductDetailScreen({
    super.key,
    required this.categoryUrl,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isLoading = true;
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
    String? categoryName; 
  String? errorMessage;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategoryDetails();
  }

  Future<void> fetchCategoryDetails() async {
    try {
      final response = await http.get(Uri.parse(widget.categoryUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
  products = data['products'] ?? [];
  // Access category from the first product (if available)
  categoryName = products.isNotEmpty ? products[0]['category'] ?? 'Unknown Category' : 'Unknown Category';
  filteredProducts = products; // Initially display all products
  isLoading = false;
});

      } else {
        setState(() {
          errorMessage =
              'Failed to load data. Status Code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = products;
      });
    } else {
      setState(() {
      filteredProducts = products.where((product) {
        final title = product['title'].toString().toLowerCase();
        final brand = product['brand'].toString().toLowerCase();
        final searchQuery = query.toLowerCase();
        return title.contains(searchQuery) || brand.contains(searchQuery);
      }).toList();
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
      categoryName ?? 'Product Details',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: filterProducts,
            ),
          ),

          // Results Found Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '${filteredProducts.length} results found',
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 8),

          // Product List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text(errorMessage!))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            color: Colors.white,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Clickable Product Image
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetails(product: product),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        product['thumbnail'] ?? '',
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.broken_image,
                                            size: 100,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Product Title and Price Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          product['title'] ?? 'Unknown',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '\$${product['price'] ?? '0.00'}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Rating Row with Stars
                                  Row(
                                    children: [
                                      Text(
                                        (product['rating'] ?? 0.0)
                                            .toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      ...List.generate(5, (index) {
                                        final isFilledStar =
                                            index < (product['rating'] ?? 0.0).floor();
                                        return Icon(
                                          isFilledStar
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 16,
                                        );
                                      }),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Brand Name
                                  Text(
                                    'By ${product['brand'] ?? 'Unknown'}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Category Name
                                  Text(
                                    'In ${product['category'] ?? 'Unknown'}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
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
    );
  }
}
