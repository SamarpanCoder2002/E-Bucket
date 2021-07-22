import 'package:e_bucket/Screens/Menu_Screens/sell_product.dart';
import 'package:e_bucket/Screens/Menu_Screens/seller_new_profile_create.dart';
import 'package:e_bucket/cloud_store_data/cloud_data_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CommonProductScreen extends StatefulWidget {
  final Widget body;
  final double elevation;
  final bool actionsAndMenu;
  final String pageTitle;

  CommonProductScreen({
    Key? key,
    required this.body,
    required this.elevation,
    this.actionsAndMenu = true,
    this.pageTitle = 'E-Bucket',
  }) : super(key: key);

  @override
  _CommonProductScreenState createState() => _CommonProductScreenState();
}

class _CommonProductScreenState extends State<CommonProductScreen> {
  final CloudDataStore _cloudDataStore = CloudDataStore();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: this.widget.actionsAndMenu
          ? LoadingOverlay(
              isLoading: this._isLoading,
              child: Drawer(
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
                        child: Text(
                          'Hello',
                          style: TextStyle(
                              fontSize: 25.0,
                              fontFamily: 'Lora',
                              color: Colors.white),
                        ),
                        color: Theme.of(context).accentColor,
                      ),
                      TextButton(
                        onPressed: () async {


                          if (mounted) {
                            setState(() {
                              this._isLoading = true;
                            });
                          }

                          final bool sellerExistence =
                              await _cloudDataStore.alreadySellerAccountPresent(
                                  FirebaseAuth.instance.currentUser!.email
                                      .toString());

                          if (!sellerExistence)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SellOnEBucket()));
                          else {
                            final List<dynamic>? storeNameAndAddress =
                                await _cloudDataStore.getStoreNameAndAddress(
                                    email: FirebaseAuth
                                        .instance.currentUser!.email
                                        .toString());

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SellProductAsSeller(
                                          companyName: storeNameAndAddress![0].toString(),
                                          companyAddress:
                                              storeNameAndAddress[1].toString(),
                                        )));
                          }

                          if (mounted) {
                            setState(() {
                              this._isLoading = false;
                            });
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50.0,
                          padding: EdgeInsets.only(
                              top: 10.0, left: 40.0, bottom: 10.0),
                          child: Text(
                            'Sell on E-Bucket',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Lora',
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      appBar: AppBar(
        elevation: this.widget.elevation,
        backgroundColor: const Color.fromRGBO(4, 123, 213, 1),
        title: Text(
          this.widget.pageTitle,
          style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
        ),
        actions: this.widget.actionsAndMenu
            ? [
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
              ]
            : null,
      ),
      body: widget.body,
    );
  }
}
