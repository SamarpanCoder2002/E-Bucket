import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_bucket/Screens/Common%20Screens/common_product_screen.dart';
import 'package:e_bucket/Screens/product_related/product_collection_show.dart';
import 'package:e_bucket/cloud_store_data/cloud_data_management.dart';
import 'package:e_bucket/global_uses/static_types.dart';
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
  final HorizontalProductCategory _horizontalProductCategory =
      HorizontalProductCategory();
  final FeedPageProductSugession _feedPageProductSugession =
      FeedPageProductSugession();

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
    }

    if (mounted) {
      setState(() {
        this._isLoading = false;
      });
    }

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ProductCollection(
        findProducts: this._findProducts,
        title: this._searchedKeyWord.toString(),
      );
    }));
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
            child: ListView(
              shrinkWrap: true,
              children: [
                _categoryOption(),
                _autoSlider(),
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
          return GestureDetector(
            onTap: () => _makeSearchableKeyword(
                this._horizontalProductCategory.categoryProductKeyword[index]),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 10.0, right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    this._horizontalProductCategory.allCategoryImages[index],
                    width: 35.0,
                  ),
                  Text(this._horizontalProductCategory.allCategoryName[index]),
                ],
              ),
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
                  image: ExactAssetImage(
                      this._horizontalProductCategory.images[i]),
                )),
              );
            },
          );
        }).toList(),
      ),
    );
  }

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
                      'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2Fproduct-500x500.jpg?alt=media&token=6252eb29-a6a3-4c78-bb20-3201b7b8f577',
                  secondBlockImageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2FApple-iPhone-12-Mini-500x500.webp?alt=media&token=c47a3c12-00d8-4370-95ab-8d7ed7e38440',
                  firstBlockImageCaption: 'Sunglass',
                  secondBlockImageCaption: 'IPhone',
                  searchKeywordSecond:
                      this._feedPageProductSugession.interested[0].toString(),
                  searchKeywordFirst:
                      this._feedPageProductSugession.interested[1].toString(),
                ),
                productImageDivider(
                    firstBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2F54510_230553207.jpg?alt=media&token=5779dfeb-a91e-449a-8b5a-74672b18155e',
                    secondBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2Fthese-12-laptops-deliver-the-best-battery-life-page-6-zdnet-hd-nature-png-for-laptop-514_428.png?alt=media&token=7a870a49-5373-4382-805e-28076dcd861b',
                    firstBlockImageCaption: 'Dress',
                    secondBlockImageCaption: 'Laptops',
                    searchKeywordFirst:
                        this._feedPageProductSugession.interested[2].toString(),
                    searchKeywordSecond: this
                        ._feedPageProductSugession
                        .interested[3]
                        .toString()),
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
      required String secondBlockImageCaption,
      required String searchKeywordFirst,
      required String searchKeywordSecond}) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              print(searchKeywordSecond);
              await _makeSearchableKeyword(searchKeywordFirst);
            },
            child: Container(
              width: double.maxFinite / 2,
              height: (270 - 20) / 2,
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
                          child: Image.asset(
                        'assets/images/error_image.jpg',
                        width: 80.0,
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
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              await _makeSearchableKeyword(searchKeywordSecond);
            },
            child: Container(
              width: double.maxFinite / 2,
              height: (270 - 20) / 2,
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
                  Text(secondBlockImageCaption),
                ],
              ),
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
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2Fmens-cotton-shirts-500x500.jpg?alt=media&token=4ab15042-c48b-4d0e-a0e3-e01a005429c0',
                    secondBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2F41k3qq-x5CL.jpg?alt=media&token=38f031ad-afd3-41bd-82f0-7ce7bc510d5f',
                    firstBlockImageCaption: 'T-Shirt',
                    secondBlockImageCaption: 'Smart Watch',
                    searchKeywordSecond: this
                        ._feedPageProductSugession
                        .topDiscount[0]
                        .toString(),
                    searchKeywordFirst: this
                        ._feedPageProductSugession
                        .topDiscount[1]
                        .toString()),
                productImageDivider(
                    firstBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2FCanon-EOS-250D-DSLR-Camera-with-18-55mm-IS-STM-Lens-2-Black.jpg?alt=media&token=72991992-5dd8-4dec-bdd1-40af3e10b40d',
                    secondBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2Fglider-football-500x500.jpg?alt=media&token=7e368aa8-df61-435c-a89f-a20dd0929e99',
                    firstBlockImageCaption: 'Camera',
                    secondBlockImageCaption: 'Football',
                    searchKeywordFirst: this
                        ._feedPageProductSugession
                        .topDiscount[2]
                        .toString(),
                    searchKeywordSecond: this
                        ._feedPageProductSugession
                        .topDiscount[3]
                        .toString()),
                productImageDivider(
                    firstBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2F41a0powQqYL.jpg?alt=media&token=1628f2e3-af56-4e48-89b2-1f79c6fd6012',
                    secondBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2Fwooden-cupboard-500x500.jpg?alt=media&token=050bf4d4-4071-434a-bae8-5ea0be8f05bf',
                    firstBlockImageCaption: 'Binocular',
                    secondBlockImageCaption: 'WarDrobe',
                    searchKeywordSecond: this
                        ._feedPageProductSugession
                        .topDiscount[4]
                        .toString(),
                    searchKeywordFirst: this
                        ._feedPageProductSugession
                        .topDiscount[5]
                        .toString()),
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
                      'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2F3103miMj8mL.jpg?alt=media&token=661b15bb-ca59-4e39-b0da-710b6c654396',
                  secondBlockImageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2Ffc7a09d8ab8bb854f93f956b4d76ee1b.jpg?alt=media&token=e06481a7-f327-4117-ba6c-ef601545aa09',
                  firstBlockImageCaption: 'IPhone',
                  secondBlockImageCaption: 'Headset',
                  searchKeywordSecond:
                      this._feedPageProductSugession.popularPicks[0].toString(),
                  searchKeywordFirst:
                      this._feedPageProductSugession.popularPicks[1].toString(),
                ),
                productImageDivider(
                    firstBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2Frgb-gaming-desktop-500x500.jpg?alt=media&token=08c10419-34f7-4cdc-839d-0a5bee67516d',
                    secondBlockImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/e-bucket-da8c0.appspot.com/o/feedpage_suggession%2Fecho-show-8-500x500.jpg?alt=media&token=de2557a1-191f-4c83-a649-1db0175398c4',
                    firstBlockImageCaption: 'Gaming Computer',
                    secondBlockImageCaption: 'Amazon Alexa',
                    searchKeywordSecond: this
                        ._feedPageProductSugession
                        .popularPicks[2]
                        .toString(),
                    searchKeywordFirst: this
                        ._feedPageProductSugession
                        .popularPicks[3]
                        .toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
