import 'package:ecommerce/views/categories.dart';
import 'package:ecommerce/views/favorites.dart';
import 'package:ecommerce/views/products.dart';
import 'package:ecommerce/views/user_settings.dart';
import 'package:flutter/material.dart';

class ShopApp extends StatefulWidget {
  const ShopApp({super.key});

  @override
  _ShopAppState createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
          toolbarHeight: 0.0, 
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'Categories'),
            Tab(text: 'Favourite'),
            Tab(text: 'User Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProductScreen(),
          CategoryScreen(),
          FavouritesScreen(),
          AccountScreen(),
        ],
      ),
bottomNavigationBar: 
   new Theme(
    data: Theme.of(context).copyWith(
      canvasColor: Colors.black,
      primaryColor: Colors.white,
  
    ),
     child: BottomNavigationBar(
      currentIndex: _tabController.index,
      onTap: (index) {
        setState(() {
          _tabController.animateTo(index);
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/product.png',
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/category.png',
            width: 24,
            height: 24,
             color: Colors.white,
          ),
          label: 'Categories',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline, color: Colors.white,),
          label: 'Favourites',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/person.png',
             color: Colors.white,
          ),
          label:  
            'Mitt Konto'
          ,
        ),
      ],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white, // Changed to improve contrast
      selectedLabelStyle: const TextStyle(color: Colors.white), // Label for selected item
    unselectedLabelStyle: const TextStyle(color: Colors.white), // Label for unselected items
    showUnselectedLabels: true,
       ),
   ),
);
    
  }
}
