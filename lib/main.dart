import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(ShoeStoreApp());
}

class ShoeStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoe Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
