import 'package:ecommerce/bloc/bloc.dart';
import 'package:ecommerce/views/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => FavouritesBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce',
      theme: ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF000000),
    // Other bottom navigation bar properties like selectedItemColor, etc.
  ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home:  const ShopApp()
    );
  }
}

