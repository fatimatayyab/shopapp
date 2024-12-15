import 'package:ecommerce/models/products.dart';

abstract class FavouritesEvent {}

class ToggleFavourite extends FavouritesEvent {
  final Product product;
  ToggleFavourite(this.product);
}