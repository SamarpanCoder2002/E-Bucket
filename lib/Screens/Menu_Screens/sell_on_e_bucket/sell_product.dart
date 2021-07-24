import 'dart:io';

import 'package:currency_picker/currency_picker.dart';
import 'package:e_bucket/Screens/Common%20Screens/common_product_screen.dart';
import 'package:e_bucket/Screens/Menu_Screens/sell_on_e_bucket/common_textfield_for_upload_new_product.dart';
import 'package:e_bucket/Screens/Menu_Screens/sell_on_e_bucket/upload_product_screen.dart';
import 'package:e_bucket/cloud_store_data/cloud_data_management.dart';
import 'package:e_bucket/global_uses/net_connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SellProductAsSeller extends StatefulWidget {
  final String companyName;
  final String companyAddress;

  SellProductAsSeller(
      {Key? key, required this.companyName, required this.companyAddress})
      : super(key: key);

  @override
  _SellProductAsSellerState createState() => _SellProductAsSellerState();
}

class _SellProductAsSellerState extends State<SellProductAsSeller> {
  List<String> _allCategory = [];
  List<dynamic> _subCategorySpecification = [];
  Map<String, dynamic> _allCategoryMap = {};

  String _subCategoryName = '';
  String _mainCategoryName = '';

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productDescription = TextEditingController();
  final TextEditingController _keyPoints = TextEditingController();
  final TextEditingController _actualPrice = TextEditingController();
  final TextEditingController _discountPrice = TextEditingController();
  final TextEditingController _quantity = TextEditingController();

  final CloudDataStore _cloudDataStore = CloudDataStore();

  String _currency = 'USD';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<int, String> _productImageContainer = Map<int, String>();

  bool _isLoading = false;

  void _getCategoryList() async {
    this._allCategoryMap = await _cloudDataStore.allCategoryFetch();

    if (mounted) {
      setState(() {
        this._allCategory = this._allCategoryMap.keys.toList();
        this._allCategory.sort();
      });
    }
  }

  @override
  void initState() {
    _getCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: this._isLoading,
      child: CommonProductScreen(
        elevation: 5.0,
        actionsAndMenu: false,
        pageTitle: 'Upload Your Product Info',
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: this._formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                textFormFieldForProduct(
                    context: context,
                    textEditingController: this._productName,
                    validator: (inputVal) {
                      if (inputVal!.isEmpty)
                        return "Product Name Can't be Empty";
                      return null;
                    },
                    labelText: 'Product Name'),
                SizedBox(
                  height: 30.0,
                ),
                _mainCategorySelection(),
                SizedBox(
                  height: 30.0,
                ),
                _subCategorySelection(),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(4, 123, 213, 1),
                    ),
                    child: Text(
                      'Upload Product Images',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onPressed: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UploadProducts(
                                  uploadPictureContainer:
                                      this._productImageContainer)));

                      print('List is: ${this._productImageContainer}');
                    },
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                textFormFieldForProduct(
                    context: context,
                    textEditingController: this._productDescription,
                    labelText: 'Product Description',
                    validator: (inputVal) {
                      if (inputVal!.isEmpty)
                        return "Product Description Can't be Empty";
                      return null;
                    },
                    maxLines: 5),
                SizedBox(
                  height: 30.0,
                ),
                textFormFieldForProduct(
                    context: context,
                    textEditingController: this._keyPoints,
                    maxLines: 3,
                    validator: (inputVal) {
                      if (inputVal!.isEmpty) return "Key Points Can't be Empty";
                      return null;
                    },
                    labelText: 'Key Points'),
                SizedBox(
                  height: 30.0,
                ),
                textFormFieldForProduct(
                    context: context,
                    textEditingController: this._quantity,
                    labelText: 'Total Products',
                    validator: (inputVal) {
                      if (inputVal!.isEmpty)
                        return "Total Products Can't be Empty";
                      return null;
                    },
                    textInputType: TextInputType.number),
                SizedBox(
                  height: 10.0,
                ),
                _priceSection(),
                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(4, 123, 213, 1),
                  ),
                  child: Text(
                    'Upload Product Info',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () async {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');

                    final bool netConnectivityExist =
                        await checkCurrentConnectivity();

                    netConnectivityExist
                        ? await _saveProductData()
                        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Net Connection Not Stable....Can't Save Product Details")));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getCurrency() {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        print('Select currency: ${currency.name}   ${currency.flag}');
        if (mounted) {
          setState(() {
            this._currency = currency.flag;
          });
        }
      },
    );
  }

  Widget _mainCategorySelection() {
    return DropdownButtonFormField<String>(
      elevation: 16,
      style: const TextStyle(fontSize: 16.0, color: Colors.black),
      icon: Icon(
        Icons.arrow_drop_down_outlined,
        size: 30.0,
        color: Theme.of(context).accentColor,
      ),
      value: null,
      decoration: InputDecoration(
        labelText: 'Product Category',
        labelStyle: TextStyle(
            color: Theme.of(context).accentColor, fontWeight: FontWeight.w400),
        focusedBorder: inputBorder(fieldState: true, outLineBorder: true),
        enabledBorder: inputBorder(fieldState: true, outLineBorder: true),
        errorBorder: inputBorder(fieldState: false, outLineBorder: true),
        focusedErrorBorder: inputBorder(fieldState: false, outLineBorder: true),
      ),
      validator: (inputValue) {
        if (this._mainCategoryName == '')
          return 'Please Provide a Category Name';
        return null;
      },
      onChanged: (String? newValue) async {
        if (mounted) {
          setState(() {
            this._mainCategoryName = newValue.toString();
            this._subCategorySpecification =
                this._allCategoryMap[newValue.toString()] as List<dynamic>;

            this._subCategorySpecification.sort();

            this._subCategoryName = this._subCategorySpecification[0];
          });
        }

        print(this._subCategorySpecification);
      },
      items: this._allCategory.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
    );
  }

  Widget _subCategorySelection() {
    return DropdownButtonFormField<dynamic>(
      elevation: 16,
      style: const TextStyle(fontSize: 16.0, color: Colors.black),
      icon: Icon(
        Icons.arrow_drop_down_outlined,
        size: 30.0,
        color: Theme.of(context).accentColor,
      ),
      value:
          this._subCategorySpecification.isEmpty ? null : this._subCategoryName,
      decoration: InputDecoration(
        labelText: 'Product Sub-Category',
        labelStyle: TextStyle(
            color: Theme.of(context).accentColor, fontWeight: FontWeight.w400),
        focusedBorder: inputBorder(fieldState: true, outLineBorder: true),
        enabledBorder: inputBorder(fieldState: true, outLineBorder: true),
        errorBorder: inputBorder(fieldState: false, outLineBorder: true),
        focusedErrorBorder: inputBorder(fieldState: false, outLineBorder: true),
      ),
      validator: (inputVal) {
        if (this._subCategoryName == '')
          return 'Please Provide a Sub-Category Name';
        return null;
      },
      onChanged: (dynamic newValue) async {
        if (mounted) {
          setState(() {
            this._subCategoryName = newValue.toString();
          });
        }
      },
      items: this
          ._subCategorySpecification
          .map<DropdownMenuItem<dynamic>>((dynamic value) {
        return DropdownMenuItem<dynamic>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
    );
  }

  Widget _priceSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GestureDetector(
            onTap: _getCurrency,
            child: Row(
              children: [
                Text(
                  this._currency,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_outlined,
                  size: 30.0,
                  color: Theme.of(context).accentColor,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 120.0,
          child: textFormFieldForProduct(
            context: context,
            textEditingController: this._actualPrice,
            labelText: 'Actual Price',
            labelFontSize: 14.0,
            textInputType: TextInputType.number,
            outLineBorder: false,
            validator: (inputVal) {
              if (inputVal!.isEmpty) return "Enter Price";
              return null;
            },
          ),
        ),
        SizedBox(
          width: 120.0,
          child: textFormFieldForProduct(
            context: context,
            textEditingController: this._discountPrice,
            labelText: 'Discount',
            labelFontSize: 14.0,
            textInputType: TextInputType.number,
            outLineBorder: false,
            validator: (inputVal) {
              if (inputVal!.isEmpty)
                return "Enter Price";
              else if (int.parse(inputVal) >= int.parse(this._actualPrice.text))
                return "Invalid Discount";
              return null;
            },
          ),
        ),
      ],
    );
  }

  Future<void> _saveProductData() async {
    if (this._formKey.currentState!.validate()) {
      print('Validated');

      this._productImageContainer.length == 4
          ? await _eligibleUpload()
          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('All Product Images Not Uploaded'),
            ));
    }
  }

  Future<void> _eligibleUpload() async {
    final List<String> _productLoadingImageUrl = [];

    await Future.forEach(this._productImageContainer.values,
        (localImagePath) async {
      if (mounted) {
        setState(() {
          this._isLoading = true;
        });
      }
      final String getDownloadUrl = await _cloudDataStore.uploadMediaToStorage(
          File(localImagePath.toString()),
          reference:
              '${widget.companyName}/${this._mainCategoryName}/${this._subCategoryName}/${this._productName.text}/');
      _productLoadingImageUrl.add(getDownloadUrl);
    }).whenComplete(() async {
      await _cloudDataStore.newProductDataStoreInFireStore(
          productNameLocal: this._productName.text,
          categoryNameLocal: this._mainCategoryName,
          subCategoryNameLocal: this._subCategoryName,
          actualPriceLocal: this._actualPrice.text,
          discountPriceLocal: this._discountPrice.text,
          productImagesLinksLocal: _productLoadingImageUrl,
          productQuantityLocal: this._quantity.text,
          productDescriptionLocal: this._productDescription.text,
          productKeyPointsLocal: this._keyPoints.text,
          priceCurrencyLocal: this._currency,
          storeAddressLocal: widget.companyAddress,
          storeNameLocal: widget.companyName,
          mainProductImageUrlLocal: _productLoadingImageUrl[0]);

      if (mounted) {
        setState(() {
          this._isLoading = false;
        });
      }
    }).whenComplete(() {
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Center(child: Text('Congrats')),
            content:
            Text('Product Details Updated...\nYour Product is Live Now', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0),),
          ));
    });
  }
}
