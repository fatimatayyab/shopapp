import 'package:ecommerce/models/products.dart';

abstract class FavouritesState {}

class FavouritesInitial extends FavouritesState {}

class FavouritesUpdated extends FavouritesState {
  final List<Product> favourites;
  FavouritesUpdated(this.favourites);
}