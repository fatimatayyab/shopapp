import 'dart:convert';
import 'package:ecommerce/views/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce/models/products.dart'; // Assuming you have a Product model

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<Product>> _products;
   late List<Product> _allProducts;
  List<Product> _filteredProducts = [];
  String _searchQuery = '';

  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products?limit=100'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> productList = jsonData['products'];
      return productList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    _products = fetchProducts();
  _products.then((products) => setState(() {
      _allProducts = products; // Original list
      _filteredProducts = products; // Filtered list
    }));
  }

 void _filterProducts(String query) {
  setState(() {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredProducts = _allProducts; // Reset to full list
    } else {
      _filteredProducts = _allProducts
          .where((product) =>
              product.title.toLowerCase().contains(_searchQuery) ||
              product.brand.toLowerCase().contains(_searchQuery) ||
              product.category.toLowerCase().contains(_searchQuery))
          .toList();
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  centerTitle: true,
  title: const Text(
    'Products',
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  ),
),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical:4.0),
        child: Column(
          children: [
            // Search bar
           TextField(
  onChanged: _filterProducts,
  decoration: InputDecoration(
    hintText: 'Search products...',
    prefixIcon: const Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.black), // Set border color to black
    ),
    filled: true,
    fillColor: Colors.white,
  ),
),

            const SizedBox(height: 16),
                 Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Align(
    alignment: Alignment.centerLeft, // Left-align the text
    child: Text(
      '${_filteredProducts.length} results found',
      style: const TextStyle(color: Colors.grey),
    ),
  ),
),
          
          const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found'));
                  } else {
                    final products = _searchQuery.isNotEmpty
                        ? _filteredProducts
                        : snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                            onTap: () {

             Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductDetails(product: product.toMap()),
  ),
);

                          },
                          child: Card(
                              color: Colors.white,
                              elevation: 0,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                           
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    product.thumbnail,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                            width: MediaQuery.of(context).size.width / 2, // Constrains the width to half of the screen
                            child: Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1, // Limits to a single line
                              overflow: TextOverflow.ellipsis, // Adds "..." for overflow
                            ),
                          ),
                                      Text(
                                            '\$${product.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                     ],) ,
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          
                                             Row(
                                      children: [
                                        Text(
                                          product.rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        ...List.generate(5, (index) {
                                          final isFilledStar = index < product.rating.floor();
                                          return Icon(
                                            isFilledStar ? Icons.star : Icons.star_border,
                                            color: Colors.amber,
                                            size: 16,
                                          );
                                        }),
                                      ],
                                    ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 8),
                                      Text(
                                        'By ${product.brand}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        'In ${product.category}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
