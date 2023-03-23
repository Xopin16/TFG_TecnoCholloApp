import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/config/locator.dart';
import 'package:flutter_tecnocholloapp/repositories/repositories.dart';
import '../../models/user.dart';
import '../../services/services.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final ProductRepository productRepository = ProductRepository();
  late final int id;

  List<Widget> _pages(BuildContext context) => [
        HomeScreen(
          homePage: this.widget,
        ),
        ChollosScreen(),
        // FavouriteScreen(),
        CategoryScreen(homePage: this.widget),
        ProfileScreen(
          homePage: this.widget,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TECNOCHOLLOAPP'),
        backgroundColor: Color.fromARGB(104, 86, 159, 192),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(50),
        child: _pages(context)[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Color.fromARGB(104, 86, 159, 192),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Publicaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_mall),
            label: 'Chollos',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.favorite),
          //   label: 'Favoritos',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categoría',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final HomePage homePage;
  HomeScreen({super.key, required this.homePage});

  @override
  Widget build(BuildContext context) {
    return Text("SCREEN");
  }
}

class ChollosScreen extends StatelessWidget {
  ChollosScreen();

  @override
  Widget build(BuildContext context) {
    return Text("SCREEN");
  }
}

class CategoryScreen extends StatelessWidget {
  final HomePage homePage;
  CategoryScreen({required this.homePage});
  @override
  Widget build(BuildContext context) {
    return Text("SCREEN");
  }
}

class ProfileScreen extends StatelessWidget {
  final HomePage homePage;

  ProfileScreen({required this.homePage});
  @override
  Widget build(BuildContext context) {
    return Text("SCREEN");
  }
}
