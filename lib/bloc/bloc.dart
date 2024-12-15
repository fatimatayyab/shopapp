import 'package:ecommerce/bloc/bloc_event/event.dart';
import 'package:ecommerce/bloc/bloc_state/state.dart';
import 'package:ecommerce/models/products.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  List<Product> _favourites = [];

  FavouritesBloc() : super(FavouritesInitial()) {
    on<ToggleFavourite>((event, emit) {
      if (_favourites.contains(event.product)) {
        _favourites.remove(event.product);
      } else {
        _favourites.add(event.product);
      }
      emit(FavouritesUpdated(List.from(_favourites))); // Emit updated state
    });
  }
}