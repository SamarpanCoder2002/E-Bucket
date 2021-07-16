import 'package:e_bucket/Screens/Common%20Screens/common_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

  @override
  Widget build(BuildContext context) {
    return CommonProductScreen(
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
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.search_outlined,
                  size: 20.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          color: Colors.white,
          child: ListView(
            shrinkWrap: true,
            children: [
              _categoryOption(),
              _autoSlider(),
              _storiesSection(),
              _interestedSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryOption() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
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
        options: CarouselOptions(autoPlay: true, height: 180),
        items: [0, 1, 2, 3].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
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

  Widget _storiesSection() {
    return Container(
      margin: EdgeInsets.only(top: 15.0, left: 5.0),
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 85.0 + 40.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Stories',
                style: TextStyle(fontSize: 18.0),
              )),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 100.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.black12,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _interestedSection() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
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
                _interestedImageDivider(
                  firstBlockImageUrl: 'https://4.imimg.com/data4/NY/QG/ANDROID-14827240/product-500x500.jpeg',
                  secondBlockImageUrl: 'https://www.gizmochina.com/wp-content/uploads/2020/10/Apple-iPhone-12-Mini-500x500.jpg',
                  firstBlockImageCaption: 'Sunglass',
                  secondBlockImageCaption: 'IPhone',),
                _interestedImageDivider(
                  firstBlockImageUrl: 'https://ik.imagekit.io/sqhmihmlh/http:/debenhams.scene7.com/is/image/Debenhams/54510_230553207?wid=800&hei=800&qlt=95&ik-sdk-version=javascript-1.3.6&tr=c-limit%2Cw-500%2Ch-%2Cdefault+image-https%3A%2F%2Fik.imagekit.io%2Fsqhmihmlh%2Fmissing_image.jpg',
                  secondBlockImageUrl: 'https://img.pngio.com/these-12-laptops-deliver-the-best-battery-life-page-6-zdnet-hd-nature-png-for-laptop-514_428.png',
                    firstBlockImageCaption: 'Dress',
                  secondBlockImageCaption: 'Laptops'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _interestedImageDivider(
      {required String firstBlockImageUrl, required String secondBlockImageUrl, required String firstBlockImageCaption, required String secondBlockImageCaption}) {
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
                  child: Image.network(
                    firstBlockImageUrl,
                  ),
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
                  child: Image.network(
                    secondBlockImageUrl,
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
}
