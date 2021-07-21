import 'package:e_bucket/Screens/Menu_Screens/sell_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CommonProductScreen extends StatelessWidget {
  final Widget body;
  final double elevation;
  final bool actionsAndMenu;

  CommonProductScreen({Key? key, required this.body, required this.elevation, this.actionsAndMenu = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: this.actionsAndMenu?Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: double.maxFinite,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Text('Hello', style: TextStyle(fontSize: 25.0, fontFamily: 'Lora', color: Colors.white),),
                color: Theme.of(context).accentColor,
              ),
              TextButton(
                onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SellOnEBucket()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  padding: EdgeInsets.only(top: 10.0, left: 40.0, bottom: 10.0),
                  child: Text('Sell on E-Bucket', style: TextStyle(fontSize: 20.0, fontFamily: 'Lora', color: Colors.black),),
                ),
              ),
            ],
          ),
        ),
      ):null,
      appBar: AppBar(
        elevation: this.elevation,
        backgroundColor: const Color.fromRGBO(4, 123, 213, 1),
        title: Text(
          'E-Bucket',
          style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
        ),
        actions: this.actionsAndMenu?[
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
        ]:null,
      ),
      body: body,
    );
  }
}
