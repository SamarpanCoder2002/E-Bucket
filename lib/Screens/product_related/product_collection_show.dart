import 'package:animations/animations.dart';
import 'package:e_bucket/Screens/Common%20Screens/common_product_screen.dart';
import 'package:e_bucket/Screens/product_related/product_details_show.dart';
import 'package:e_bucket/global_uses/product_details_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

class ProductCollection extends StatefulWidget {
  final String title;
  final List<dynamic> findProducts;

  ProductCollection({Key? key, required this.title, required this.findProducts}) : super(key: key);

  @override
  _ProductCollectionState createState() => _ProductCollectionState();
}

class _ProductCollectionState extends State<ProductCollection> {
  @override
  Widget build(BuildContext context) {
    return CommonProductScreen(
      body: _uponProductSearch(),
      elevation: 5.0,
      pageTitle: widget.title,
      actionsAndMenu: false,
    );
  }

  Widget _uponProductSearch() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.findProducts.length,
      itemBuilder: (itemContext, index) {
        print(widget.findProducts);
        return OpenContainer(
          closedColor: Colors.white,
          middleColor: Colors.white,
          openColor: Colors.white,
          closedElevation: 0.0,
          transitionDuration: Duration(milliseconds: 500),
          openBuilder: (openBuilderContext, openWidget) =>
              ProductDetailsShow(productDetails: widget.findProducts[index]),
          closedBuilder: (closeBuilderContext, closeWidget) => Container(
            width: double.maxFinite,
            height: 140.0,
            margin: EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: PhotoView(
                    imageProvider: NetworkImage(
                        widget.findProducts[index]['ProductMainImageUrl']),
                    loadingBuilder: (context, event) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorBuilder: (context, obj, stackTrace) => Center(
                        child: Center(
                            child: Image.asset(
                      'assets/images/error_image.jpg',
                      width: 80.0,
                    ))),
                    enableRotation: false,
                    backgroundDecoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    //minScale: PhotoViewComputedScale.covered,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          _getProductTitle(
                              widget.findProducts[index]['ProductName']),
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 12.0, left: 12.0, right: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_getMinimumPrice(index)}${widget.findProducts[index]['Currency']}',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              '${widget.findProducts[index]['ProductActualPrice']} ${widget.findProducts[index][priceCurrency]}',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                                child: Text(
                              '${_getDiscountPercentage(index)}% Off',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getProductTitle(String productTitle) {
    if (productTitle.split(" ").length >= 14) {
      final List<String> afterSplitting = productTitle.split(" ");
      afterSplitting.replaceRange(14, afterSplitting.length, ['...']);
      final String afterModified = afterSplitting.join(" ");
      return afterModified;
    }
    return productTitle;
  }

  int _getMinimumPrice(int index) => (double.parse(
              widget.findProducts[index]['ProductActualPrice'].toString()) -
          double.parse(
              widget.findProducts[index]['ProductDiscountPrice'].toString()))
      .toInt();

  String _getDiscountPercentage(int index) {
    final double savePercentage = double.parse(((double.parse(widget.findProducts[index][productDiscountPrice]
                    .toString()) /
                double.parse(
                    widget.findProducts[index][productActualPrice].toString())) *
            100.0)
        .toStringAsFixed(1));

    if (int.parse(savePercentage.toString().split('.')[1]) > 0)
      return savePercentage.toString();
    return savePercentage.toString().split('.')[0];
  }
}
