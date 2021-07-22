import 'package:currency_picker/currency_picker.dart';
import 'package:e_bucket/Screens/Common%20Screens/common_product_screen.dart';
import 'package:e_bucket/Screens/Menu_Screens/common_textfield_for_upload_new_product.dart';
import 'package:e_bucket/Screens/Menu_Screens/upload_product_screen.dart';
import 'package:e_bucket/cloud_store_data/cloud_data_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
    return CommonProductScreen(
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
                    if (inputVal!.isEmpty) return "Product Name Can't be Empty";
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
                  if (this._formKey.currentState!.validate()) {
                    print('Validated');
                    await _cloudDataStore.newProductDataStoreInFireStore(
                        productName: this._productName.text,
                        categoryName: this._mainCategoryName,
                        subCategoryName: this._subCategoryName,
                        actualPrice: this._actualPrice.text,
                        discountPrice: this._discountPrice.text,
                        productImagesLinks: [],
                        productQuantity: this._quantity.text,
                        productDescription: this._productDescription.text,
                        productKeyPoints: this._keyPoints.text,
                        priceCurrency: this._currency,
                        storeAddress: widget.companyAddress,
                        storeName: widget.companyName);
                  }
                },
              ),
            ],
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
}
