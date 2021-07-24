import 'package:animations/animations.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_bucket/Screens/Common%20Screens/common_product_screen.dart';
import 'package:e_bucket/Screens/product_related/product_details_show.dart';
import 'package:e_bucket/cloud_store_data/cloud_data_management.dart';
import 'package:e_bucket/global_uses/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:photo_view/photo_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> items = [
    '',
    '',
    '',
    '',
  ];

  final List<String> images = [
    'assets/images/cr1.jpg',
    'assets/images/cr2.jpg',
    'assets/images/cr3.jpg',
    'assets/images/cr4.png',
  ];

  final List<String> allCategoryImages = [
    'assets/images/c2.png',
    'assets/images/c3.png',
    'assets/images/c4.png',
    'assets/images/c5.png',
    'assets/images/c6.png',
    'assets/images/c7.png',
  ];

  final List<String> allCategoryName = [
    'Mobiles',
    'Electronics',
    'Fashion',
    'Toys',
    'Sports',
    'Jewellery',
  ];

  final Map<String, dynamic> _productMap = {};
  final List<String> _searchKeyword = [];
  List<dynamic> _findProducts = [];

  bool _isLoading = false;

  String? _searchedKeyWord = '';
  bool _searchClearButton = false;

  final CloudDataStore _cloudDataStore = CloudDataStore();

  _getAllCategoryAndSubCategory() async {
    final Map<String, dynamic> _categoryAndSubCategoryCollection =
        await _cloudDataStore.allCategoryFetch();

    _categoryAndSubCategoryCollection.forEach((mainCategory, subCategoryList) {
      subCategoryList.forEach((subCategory) {
        if (mounted) {
          setState(() {
            this._productMap.addAll({
              subCategory: mainCategory,
            });
            this._searchKeyword.add(subCategory);
          });
        }
      });
    });

    if (mounted) {
      setState(() {
        this._searchKeyword.sort();
      });
    }
  }

  _makeSearchableKeyword(String? clickedSearchKeyword) async {
    if (mounted) {
      setState(() {
        this._isLoading = true;
        this._searchedKeyWord = clickedSearchKeyword;
        this._searchClearButton = true;
      });
    }
    final Map<String, dynamic>? take = await _cloudDataStore.getAllThings(
        mainCategory: this._productMap[clickedSearchKeyword.toString()],
        subCategory: clickedSearchKeyword.toString());

    if (mounted) {
      setState(() {
        if (this._findProducts.isNotEmpty) this._findProducts.clear();
      });
    }

    if (take == null) {
      print("That's null");
    } else {
      List<dynamic> listValues = take.values.toList()[0];
      if (mounted) {
        setState(() {
          this._findProducts = listValues;
        });
      }

      print(this._findProducts);
    }

    if (mounted) {
      setState(() {
        this._isLoading = false;
      });
    }
  }

  Widget _dropDownSearch() {
    return DropdownSearch<String>(
      mode: Mode.BOTTOM_SHEET,
      maxHeight: MediaQuery.of(context).size.height - 300,
      showSelectedItem: true,
      items: this._searchKeyword,
      hint: "Search in E-Bucket",
      popupItemDisabled: (String s) => s.startsWith('I'),
      onChanged: _makeSearchableKeyword,
      showAsSuffixIcons: true,
      dropdownBuilderSupportsNullItem: true,
      showClearButton: this._searchClearButton,
      showSearchBox: true,
      autoFocusSearchBox: true,
      emptyBuilder: (_, __) {
        return Scaffold(
            body: Center(
          child: Text(
            'Sorry, not Found',
            style: TextStyle(fontSize: 30.0, color: Colors.red),
          ),
        ));
      },
      clearButtonBuilder: (_) {
        return IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (mounted) {
              setState(() {
                this._searchedKeyWord = '';
                this._searchClearButton = false;
              });
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    _getAllCategoryAndSubCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: this._isLoading,
      child: CommonProductScreen(
        elevation: 0.0,
        body: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: const Color.fromRGBO(4, 123, 213, 1),
            flexibleSpace: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: _dropDownSearch(),
            ),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            padding: EdgeInsets.all(this._searchedKeyWord != '' ? 12.0 : 0.0),
            child: this._searchedKeyWord != ''
                ? _uponProductSearch()
                : ListView(
                    shrinkWrap: true,
                    children: [
                      _categoryOption(),
                      _autoSlider(),

                      ///_storiesSection(),
                      _interestedSection(),
                      _topDiscountSection(),
                      _popularPicks(),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _categoryOption() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70.0,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  this.allCategoryImages[index],
                  width: 35.0,
                ),
                Text(this.allCategoryName[index]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _autoSlider() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          height: 180,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 1500),
          viewportFraction: 0.8,
        ),
        items: [0, 1, 2, 3].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: ExactAssetImage(images[i]),
                )),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  // Widget _storiesSection() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 15.0, left: 5.0),
  //     width: MediaQuery.of(context).size.width,
  //     height: 85.0 + 40.0,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Container(
  //             alignment: Alignment.centerLeft,
  //             padding: EdgeInsets.only(left: 10.0),
  //             child: Text(
  //               'Stories',
  //               style: TextStyle(fontSize: 18.0),
  //             )),
  //         Container(
  //           padding: EdgeInsets.only(left: 10.0, right: 10.0),
  //           width: MediaQuery.of(context).size.width,
  //           height: 100.0,
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: 10,
  //             itemBuilder: (context, index) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(right: 20.0),
  //                 child: CircleAvatar(
  //                   radius: 40.0,
  //                   backgroundColor: Colors.black12,
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _interestedSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 310.0,
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 5.0),
      //color: Colors.redAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'May You Be Interested',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 270,
            //color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                productImageDivider(
                  firstBlockImageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/product-500x500.jpeg?alt=media&token=f757c5f6-7c8d-44b0-86e2-f6266e95b160',
                  secondBlockImageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/Apple-iPhone-12-Mini-500x500.webp?alt=media&token=b1654451-3e2a-45ed-a1c0-5b570e744083',
                  firstBlockImageCaption: 'Sunglass',
                  secondBlockImageCaption: 'IPhone',
                ),
                productImageDivider(
                    firstBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/54510_230553207.jfif?alt=media&token=8412bf0d-a3d4-47d9-889c-c4764620db7f',
                    secondBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/these-12-laptops-deliver-the-best-battery-life-page-6-zdnet-hd-nature-png-for-laptop-514_428.png?alt=media&token=b13e2893-d762-427d-8c84-d7e90809b0df',
                    firstBlockImageCaption: 'Dress',
                    secondBlockImageCaption: 'Laptops'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productImageDivider(
      {required String firstBlockImageUrl,
      required String secondBlockImageUrl,
      required String firstBlockImageCaption,
      required String secondBlockImageCaption}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: double.maxFinite / 2,
            height: (270 - 20) / 2,
            //color: Colors.deepPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.maxFinite / 2,
                  height: (270 - 10) / 2 - 30,
                  child: PhotoView(
                    imageProvider: NetworkImage(firstBlockImageUrl),
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

                  // Image.network(
                  //   firstBlockImageUrl,
                  // ),
                ),
                Text(firstBlockImageCaption),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Container(
            width: double.maxFinite / 2,
            height: (270 - 20) / 2,
            //color: Colors.deepPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.maxFinite / 2,
                  height: (270 - 10) / 2 - 30,
                  child: PhotoView(
                    imageProvider: NetworkImage(secondBlockImageUrl),
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
                Text(secondBlockImageCaption),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _topDiscountSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 470,

      ///color: Colors.red,
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Discount',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Discount Upto 40-60%',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          Container(
            width: double.maxFinite,
            height: 420,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                productImageDivider(
                    firstBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/mens-cotton-shirts-500x500.jpg?alt=media&token=2beada69-e6af-4efd-ace5-b7817c9fc48c',
                    secondBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/41k3qq-x5CL.jpg?alt=media&token=50cae35a-8a20-483f-94e8-9bda0cf066e2',
                    firstBlockImageCaption: 'T-Shirt',
                    secondBlockImageCaption: 'Smart Watch'),
                productImageDivider(
                    firstBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/Canon-EOS-250D-DSLR-Camera-with-18-55mm-IS-STM-Lens-2-Black.jpg?alt=media&token=bf6eabb4-8a66-492a-b6b9-e244d9893964',
                    secondBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/glider-football-500x500.jpg?alt=media&token=6db85caf-5190-436c-bf04-e3a9ebc0a824',
                    firstBlockImageCaption: 'Camera',
                    secondBlockImageCaption: 'Football'),
                productImageDivider(
                    firstBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/41a0powQqYL.jpg?alt=media&token=7d9a16fa-6fef-46f1-9d30-434a16e020bb',
                    secondBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/wooden-cupboard-500x500.jpg?alt=media&token=4634c69f-8d15-4f3a-89d7-05ac66dbf344',
                    firstBlockImageCaption: 'Binocular',
                    secondBlockImageCaption: 'WarDrobe'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _popularPicks() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 310.0,
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Popular Picks',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 270,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                productImageDivider(
                  firstBlockImageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/3103miMj8mL.jpg?alt=media&token=7d0754e3-dc9c-4c0f-a0b0-68559b35eaa0',
                  secondBlockImageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/fc7a09d8ab8bb854f93f956b4d76ee1b.jpg?alt=media&token=9cc34b28-353c-4c68-acfc-ba46ba0a531c',
                  firstBlockImageCaption: 'IPhone',
                  secondBlockImageCaption: 'Headset',
                ),
                productImageDivider(
                    firstBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/rgb-gaming-desktop-500x500.jpg?alt=media&token=36d9d714-3f0b-4a03-a3b7-604ff4cca1b3',
                    secondBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/echo-show-8-500x500.jpg?alt=media&token=eb4b41cf-8308-4fc8-85c8-885ca072199f',
                    firstBlockImageCaption: 'Gaming Computer',
                    secondBlockImageCaption: 'Amazon Alexa'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _uponProductSearch() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: this._findProducts.length,
      itemBuilder: (itemContext, index) {
        print(this._findProducts);
        return OpenContainer(
          closedColor: Colors.white,
          middleColor: Colors.white,
          openColor: Colors.white,
          closedElevation: 0.0,
          transitionDuration: Duration(milliseconds: 500),
          openBuilder: (openBuilderContext, openWidget) =>
              ProductDetailsShow(productDetails: this._findProducts[index]),
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
                        this._findProducts[index]['ProductMainImageUrl']),
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
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          _getProductTitle(
                              this._findProducts[index]['ProductName']),
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
                              '${_getMinimumPrice(index)}${this._findProducts[index]['Currency']}',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              '${this._findProducts[index]['ProductActualPrice']} ${this._findProducts[index][priceCurrency]}',
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
    if (productTitle.split(" ").length >= 16) {
      final List<String> afterSplitting = productTitle.split(" ");
      afterSplitting.replaceRange(16, afterSplitting.length, ['...']);
      final String afterModified = afterSplitting.join(" ");
      return afterModified;
    }
    return productTitle;
  }

  int _getMinimumPrice(int index) => (double.parse(
              this._findProducts[index]['ProductActualPrice'].toString()) -
          double.parse(
              this._findProducts[index]['ProductDiscountPrice'].toString()))
      .toInt();

  String _getDiscountPercentage(int index) {
    final double savePercentage = double.parse(((double.parse(this
                    ._findProducts[index][productDiscountPrice]
                    .toString()) /
                double.parse(
                    this._findProducts[index][productActualPrice].toString())) *
            100.0)
        .toStringAsFixed(1));

    if (int.parse(savePercentage.toString().split('.')[1]) > 0)
      return savePercentage.toString();
    return savePercentage.toString().split('.')[0];
  }
}
