import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_bucket/Screens/Common%20Screens/common_product_screen.dart';
import 'package:e_bucket/cloud_store_data/cloud_data_management.dart';
import 'package:e_bucket/global_uses/product_details_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ProductDetailsShow extends StatefulWidget {
  final Map<String, dynamic> productDetails;

  ProductDetailsShow({Key? key, required this.productDetails})
      : super(key: key);

  @override
  _ProductDetailsShowState createState() => _ProductDetailsShowState();
}

class _ProductDetailsShowState extends State<ProductDetailsShow> {
  List<dynamic> _productImages = [];
  String _dropDownText = 'Qty: 1';

  final CloudDataStore _cloudDataStore = CloudDataStore();
  final Razorpay _razorpay = Razorpay();

  _productSlider() {
    if (mounted) {
      setState(() {
        this._productImages = widget.productDetails[productImagesLink];
      });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('For External Wallet: ${response.walletName}');
  }

  Future<void> _makePayment() async {
    print('Link: ${widget.productDetails[productMainImageUrl].toString()}');
    var options = {
      'key': 'RAzorpay Key',
      'amount':
          '${_getMinimumPrice() * int.parse(this._dropDownText.toString().split(' ')[1]) * 100}',
      "currency": widget.productDetails[priceCurrency].toString(),
      'email': FirebaseAuth.instance.currentUser!.email.toString(),
      'name': widget.productDetails[productName],
      'description':
          'Total Products ${this._dropDownText.toString().split(' ')[1]}',
      'prefill': {'email': FirebaseAuth.instance.currentUser!.email.toString()}
    };

    try {
      this._razorpay.open(options);
    } catch (e) {
      print('Razorpay Error is: ${e.toString()}');
    }
  }

  @override
  void initState() {
    _productSlider();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    this._razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.productDetails);
    return CommonProductScreen(
      elevation: 5.0,
      pageTitle: 'E-Bucket',
      bottomWidget: Container(
        height: 45.0,
        decoration: BoxDecoration(
          color: Colors.red,
          boxShadow: [
            BoxShadow(blurRadius: 3.0, color: Colors.grey),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 100.0,
                child: TextButton(
                  style: TextButton.styleFrom(
                    elevation: 10.0,
                    backgroundColor: Colors.white,
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    final bool response =
                        await _cloudDataStore.addNewItemToCart(
                            email: FirebaseAuth.instance.currentUser!.email
                                .toString(),
                            productMap: widget.productDetails);

                    final String msg = response
                        ? 'Added to Cart'
                        : 'Not added in cart...Try Again';

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(msg)));
                  },
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 100.0,
                child: TextButton(
                  style: TextButton.styleFrom(
                    elevation: 10.0,
                    backgroundColor: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  child: Text(
                    'Buy Now',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    await _makePayment();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.all(12.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            _productTitle(),
            _productImageSlide(),
            _productPriceDetails(),
            _productQuantity(),
            _productSellerName(),
            _productDetails(),
            _productKeyPoints(),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _productTitle() {
    return SizedBox(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * (1 / 6),
      child: Text(
        widget.productDetails[productName],
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _productImageSlide() {
    return Stack(
      children: [
        CarouselSlider.builder(
            options: CarouselOptions(
              autoPlay: true,
              height: MediaQuery.of(context).size.height / 2.5,
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 1500),
              viewportFraction: 0.8,
            ),
            itemCount: this._productImages.length,
            itemBuilder: (sliderContext, itemIndex, realIndex) => Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width - 24,
                  margin: EdgeInsets.only(top: 30.0),
                  child: PhotoView(
                    imageProvider: NetworkImage(
                        widget.productDetails[productImagesLink][itemIndex]),
                    loadingBuilder: (context, event) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorBuilder: (context, obj, stackTrace) => Center(
                      child: Image.asset(
                        'assets/images/error_image.jpg',
                        width: 300,
                      ),
                    ),
                    enableRotation: false,
                    backgroundDecoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    //minScale: PhotoViewComputedScale.covered,
                  ),
                )),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 45.0,
            height: 45.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Text(
              '${_getDiscountPercentage()}%\nOff',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _productPriceDetails() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60.0,
      margin: EdgeInsets.only(top: 30.0),
      //color: Colors.red,
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '${_getMinimumPrice()} ${widget.productDetails[priceCurrency]}',
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Text(
                    'MRP: ',
                    style: TextStyle(color: Colors.black45),
                  ),
                  Text(
                    '${widget.productDetails[productActualPrice]} ${widget.productDetails[priceCurrency]}',
                    style: TextStyle(
                        fontSize: 14.0,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.black45),
                  ),
                  Text(
                    '       Save ${widget.productDetails[productDiscountPrice]} ${widget.productDetails[priceCurrency]}',
                    style: TextStyle(
                        color: Colors.red, fontStyle: FontStyle.italic),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  int _getMinimumPrice() => (double.parse(
              widget.productDetails[productActualPrice].toString()) -
          double.parse(widget.productDetails[productDiscountPrice].toString()))
      .toInt();

  String _getDiscountPercentage() {
    final double savePercentage = double.parse(
        ((double.parse(widget.productDetails[productDiscountPrice].toString()) /
                    double.parse(
                        widget.productDetails[productActualPrice].toString())) *
                100.0)
            .toStringAsFixed(1));

    if (int.parse(savePercentage.toString().split('.')[1]) > 0)
      return savePercentage.toString();
    return savePercentage.toString().split('.')[0];
  }

  Widget _productQuantity() {
    return Container(
      height: 40.0,
      margin: EdgeInsets.only(
          right: MediaQuery.of(context).size.width / 1.5, top: 10.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).backgroundColor,
          side: BorderSide(width: 0.5, color: Colors.grey),
          shadowColor: Colors.grey,
        ),
        onPressed: () {},
        child: DropdownButton<String>(
          elevation: 16,
          style: const TextStyle(fontSize: 16.0, color: Colors.black),
          icon: Icon(
            Icons.arrow_drop_down_outlined,
            size: 30.0,
            color: Colors.black,
          ),
          underline: Container(
            color: Colors.red,
          ),
          value: this._dropDownText,
          onChanged: (String? newValue) async {
            if (mounted) {
              setState(() {
                this._dropDownText = newValue.toString();
              });
            }
          },
          items: ['Qty: 1', 'Qty: 2', 'Qty: 3', 'Qty: 4', 'Qty: 5']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _productSellerName() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: EdgeInsets.only(top: 20.0),
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Text('Sold by '),
          Text(
            '${widget.productDetails[storeName]}',
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ],
      ),
    );
  }

  Widget _productDetails() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: EdgeInsets.only(top: 30.0),
      //color: Colors.red,
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Product Details',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              )),
          SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.productDetails[productDescription],
              textAlign: TextAlign.justify,
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productKeyPoints() {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Key Points',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              )),
          SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.productDetails[productKeyPoints],
              textAlign: TextAlign.justify,
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
