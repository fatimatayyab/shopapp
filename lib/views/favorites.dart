import 'package:ecommerce/bloc/bloc_event/event.dart';
import 'package:ecommerce/bloc/bloc_state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> filteredFavourites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Favourites',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: BlocBuilder<FavouritesBloc, FavouritesState>(
        builder: (context, state) {
          if (state is FavouritesUpdated) {
            final favourites = state.favourites;

            // Filter the favourites list based on the search query
            if (searchController.text.isNotEmpty) {
              filteredFavourites = favourites.where((product) {
                final title = product.title.toLowerCase();
                final searchQuery = searchController.text.toLowerCase();
                return title.contains(searchQuery);
              }).toList();
            } else {
              filteredFavourites = favourites; // If search is empty, show all
            }

            return Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Favourites',
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                    onChanged: (query) {
                      setState(() {
                        // Filter the products whenever the search query changes
                      });
                    },
                  ),
                ),
                // Results Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${filteredFavourites.length} result${filteredFavourites.length == 1 ? '' : 's'} found',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
                // List of Favourites
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredFavourites.length,
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      final product = filteredFavourites[index];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Thumbnail
                              CircleAvatar(
                                backgroundColor: const Color.fromARGB(255, 246, 238, 238),
                                radius: 40,
                                backgroundImage: NetworkImage(product.thumbnail),
                                onBackgroundImageError: (_, __) => const Icon(Icons.broken_image, size: 80),
                              ),
                              const SizedBox(width: 16),
                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Row 1: Product Title
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // Row 2: Price and Favourite Icon
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${product.price}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.favorite, color: Colors.red),
                                          onPressed: () {
                                            context
                                                .read<FavouritesBloc>()
                                                .add(ToggleFavourite(product));
                                          },
                                        ),
                                      ],
                                    ),
                                    // Row 3: Rating Value and Stars
                                    Row(
                                      children: [
                                        Text(
                                          '${product.rating.toStringAsFixed(1)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (starIndex) => Icon(
                                              Icons.star,
                                              size: 16,
                                              color: starIndex < product.rating.round()
                                                  ? Colors.amber
                                                  : Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
            );
          } else if (state is FavouritesUpdated && state.favourites.isEmpty) {
            return const Center(
              child: Text(
                'No favourites yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
