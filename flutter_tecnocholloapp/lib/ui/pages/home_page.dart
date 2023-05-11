import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/config/locator.dart';
import 'package:flutter_tecnocholloapp/repositories/repositories.dart';
import 'package:flutter_tecnocholloapp/services/category_service.dart';
import 'package:flutter_tecnocholloapp/services/product_service.dart';
import '../../blocs/blocs.dart';
import '../../blocs/category/category.dart';
import '../../blocs/productUser/product_user.dart';
import '../../models/user.dart';
import '../widget/widget.dart';
import 'change_password_page.dart';

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
        ChollosScreen(),
        HomeScreen(
          homePage: this.widget,
        ),
        // FavouriteScreen(),
        CategoryScreen(homePage: this.widget),
        CarritoScreen(),
        VentasScreen(),
        ProfileScreen(
          homePage: this.widget,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TECNOCHOLLOAPP'),
        backgroundColor: Color.fromARGB(211, 244, 67, 54),
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
            label: 'Chollos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_mall),
            label: 'Publicaciones',
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
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Ventas',
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocProvider(
          create: (context) {
            final productService = getIt<ProductService>();
            return ProductUserBloc(productService)..add(ProductUserFetched());
          },
          child: ProductUserList(
            user: homePage.user,
          ),
        );
      },
    );
  }
}

class ChollosScreen extends StatelessWidget {
  ChollosScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final productService = getIt<ProductService>();
        return ProductBloc(productService)..add(ProductFetched());
      },
      child: ProductList(),
    );
  }
}

// class FavouriteScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) {
//         final productService = getIt<ProductService>();
//         return FavouriteBloc(productService)..add(FavouriteFetched());
//       },
//       child: FavouriteList(),
//     );
//   }
// }

class CategoryScreen extends StatelessWidget {
  final HomePage homePage;
  CategoryScreen({required this.homePage});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final categoryService = getIt<CategoryService>();
        return CategoryBloc(categoryService)..add(CategoryFetched());
      },
      child: CategoryList(
        user: homePage.user,
      ),
    );
  }
}

class CarritoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text("AQUI VA EL CARRITO")],
    );
  }
}

class VentasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text("AQUI VAN LAS VENTAS")],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final HomePage homePage;

  ProfileScreen({required this.homePage});
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 600;
    final TextStyle? titleTextStyle = Theme.of(context).textTheme.headlineSmall;
    final TextStyle? subtitleTextStyle =
        Theme.of(context).textTheme.titleMedium;
    final Widget profileImage = CircleAvatar(
      radius: isMobile ? 50 : 75,
      backgroundImage: NetworkImage(homePage.user.avatar == null
          ? "https://electronicssoftware.net/wp-content/uploads/user.png"
          : "http://localhost:8080/download/${homePage.user.avatar}"),
    );

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      authBloc.add(UserLoggedOut());
                    },
                    icon: Icon(Icons.logout),
                  ),
                ],
              ),
              Center(
                child: profileImage,
              ),
              SizedBox(height: isMobile ? 16 : 32),
              Text(
                'Username:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                "${homePage.user.username}",
                style: subtitleTextStyle,
              ),
              SizedBox(height: isMobile ? 16 : 32),
              Text(
                'Nombre completo:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                "${homePage.user.fullName}",
                style: subtitleTextStyle,
              ),
              SizedBox(height: isMobile ? 16 : 32),
              Text(
                'Email:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                "${homePage.user.email}",
                style: subtitleTextStyle,
              ),
              SizedBox(height: isMobile ? 16 : 32),
              Text(
                'Fecha de creación:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                "${homePage.user.createdAt}",
                style: subtitleTextStyle,
              ),
              SizedBox(height: isMobile ? 32 : 64),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: isMobile ? 40 : 50,
                    width: isMobile ? double.infinity : 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(210, 228, 222, 222)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.black)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Cambiar contraseña',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 16 : 32),
                  SizedBox(
                    height: isMobile ? 40 : 50,
                    width: isMobile ? double.infinity : 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(211, 244, 67, 54)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.black)),
                        ),
                      ),
                      onPressed: () {
                        authBloc.add(UserLoggedOut());
                      },
                      child: Text(
                        'Borrar Cuenta',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: isMobile ? 40 : 50,
                  //   width: isMobile ? double.infinity : 150,
                  //   child: Padding(
                  //     padding: EdgeInsets.all(8),
                  //     child: ElevatedButton(
                  //       style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all<Color>(
                  //             Color.fromARGB(211, 244, 67, 54)),
                  //         shape:
                  //             MaterialStateProperty.all<RoundedRectangleBorder>(
                  //           RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //         ),
                  //       ),
                  //       onPressed: () {},
                  //       child: Text(
                  //         'Borrar cuenta',
                  //         style: TextStyle(fontSize: 16, color: Colors.black),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
