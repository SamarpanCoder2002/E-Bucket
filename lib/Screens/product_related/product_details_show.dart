import 'package:e_bucket/Screens/Common%20Screens/common_product_screen.dart';
import 'package:e_bucket/global_uses/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

class ProductDetailsShow extends StatefulWidget {
  final Map<String,dynamic> productDetails;

  ProductDetailsShow({Key? key, required this.productDetails}) : super(key: key);

  @override
  _ProductDetailsShowState createState() => _ProductDetailsShowState();
}

class _ProductDetailsShowState extends State<ProductDetailsShow> {
  @override
  Widget build(BuildContext context) {
    print(widget.productDetails);
    return CommonProductScreen(
      elevation: 5.0,
      pageTitle: 'E-Bucket',
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(12.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * (1/7),
              color: Colors.red,
              child: Center(),
            ),
            Container(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width-24,
              margin: EdgeInsets.only(top: 30.0),
              child: PhotoView(
                imageProvider: NetworkImage(
                    widget.productDetails[productMainImageUrl]),
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, obj, stackTrace) => Center(
                    child: Text(
                      'X',
                      style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.red,
                        fontFamily: 'Lora',
                        letterSpacing: 1.0,
                      ),
                    )),
                enableRotation: false,
                backgroundDecoration: BoxDecoration(
                  color: Colors.white,
                ),
                //minScale: PhotoViewComputedScale.covered,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
