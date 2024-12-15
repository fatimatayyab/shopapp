import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../bloc/bloc_event/event.dart';
import '../bloc/bloc_state/state.dart';
import '../models/products.dart';

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productModel = Product(
      title: product['title'],
      price: product['price'],
      rating: product['rating'],
      brand: product['brand'],
      thumbnail: product['thumbnail'],
      category: product['category'],
      description: product['description'],
      stock: product['stock'],
      images: product['images'],
      
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product['thumbnail'],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Product Details Heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ const Text(
                "Product Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
               BlocBuilder<FavouritesBloc, FavouritesState>(
      builder: (context, state) {
        final isFavourite = state is FavouritesUpdated &&
            state.favourites.contains(productModel);

        return IconButton(
          icon: Icon(
            isFavourite ? Icons.favorite : Icons.favorite_border,
            color: isFavourite ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            context.read<FavouritesBloc>().add(ToggleFavourite(productModel));
          },
        );
      },
    ),],),
             
              const SizedBox(height: 8),

              // Product Title
              _buildRow("Name", product['title']),
              _buildRow("Price", "\$${product['price']}"),
              _buildRow("Category", product['category']),
              _buildRow("Brand", product['brand']),
              Row(
            children: [
             const Text(
            "Rating:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
              Text(
                product['rating'].toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              ...List.generate(5, (index) {
                final isFilledStar = index < product['rating'].floor();
                return Icon(
                  isFilledStar ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                );
              }),
            ],
          ),
              _buildRow("Stock", product['stock'].toString()),

              const SizedBox(height: 16),

              // Description
              const Text(
                "Description",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                product['description'] ?? 'No description available.',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Photo Gallery Heading
              const Text(
                "Photo Gallery",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Photo Gallery
              if (product['images'] != null)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: product['images'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product['images'][index],
                            width: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8,),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
