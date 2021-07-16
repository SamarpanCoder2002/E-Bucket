import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CommonProductScreen extends StatelessWidget {
  final Widget body;
  final double elevation;

  CommonProductScreen({Key? key, required this.body, required this.elevation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(

      ),
      appBar: AppBar(
        elevation: this.elevation,
        backgroundColor: const Color.fromRGBO(4, 123, 213, 1),
        title: Text(
          'E-Bucket',
          style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_outlined,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: body,
    );
  }
}
