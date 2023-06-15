import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'home_page.dart';

class DeletedCarritoPage extends StatefulWidget {
  final User user;
  const DeletedCarritoPage({super.key, required this.user});

  @override
  State<DeletedCarritoPage> createState() => _DeletedCarritoPageState();
}

class _DeletedCarritoPageState extends State<DeletedCarritoPage> {
  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    user: widget.user,
                  )));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.check_circle_outline_rounded,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            const Text(
              '¡PRODUCTO BORRADO!',
              style: TextStyle(fontSize: 24, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
