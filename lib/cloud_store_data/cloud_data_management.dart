import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class CloudDataStore {
  final String _consumerPath = 'consumers';
  final String _sellerPath = 'sellers';
  final String _categoryPath = 'category';
  final String _productName = 'ProductName';

  final String _storeName = 'StoreName';
  final String _storeAddress = 'StoreAddress';

  final String _productMainCategory = 'ProductMainCategory';
  final String _productSubCategory = 'ProductSubCategory';
  final String _productImagesLink = 'ProductImagesLinks';
  final String _productDescription = 'ProductDescription';
  final String _productKeyPoints = 'ProductKeyPoints';
  final String _productQuantity = 'TotalProducts';
  final String _productActualPrice = 'ProductActualPrice';
  final String _priceCurrency = 'Currency';
  final String _productDiscountPrice = 'ProductDiscountPrice';

  Future<void> dataStoreForConsumers(String email) async {
    try {
      await FirebaseFirestore.instance.doc('$_consumerPath/$email').set({
        'email': '$email',
      });
    } catch (e) {
      print('Data Store For Consumers Error: ${e.toString()}');
    }
  }

  Future<void> dataStoreForSellers(
      String email, String storeName, String address) async {
    try {
      await FirebaseFirestore.instance.collection(_sellerPath).add({
        'email': email,
        'store_name': storeName,
        'address': address,
      });
    } catch (e) {
      print('Data Store for Sellers Error: ${e.toString()}');
    }
  }

  Future<bool> alreadySellerAccountPresent(String email) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(this._sellerPath)
          .where('email', isEqualTo: email)
          .get();

      final Map<String, dynamic> take =
          querySnapshot.docs[0].data() as Map<String, dynamic>;

      if (take['email'] != null && take['email'] != '') return true;
      return false;
    } catch (e) {
      print('Seller Account Present Error: ${e.toString()}');
      return false;
    }
  }

  Future<Map<String, dynamic>> allCategoryFetch() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .doc('${this._categoryPath}/ebucket')
              .get();

      final Map<String, dynamic> _categoryList =
          documentSnapshot.data() as Map<String, dynamic>;
      return _categoryList;
    } catch (e) {
      print('Error is: ${e.toString()}');
      return {};
    }
  }

  Future<bool> newProductDataStoreInFireStore({
    required String productName,
    required String categoryName,
    required String subCategoryName,
    required String actualPrice,
    required String discountPrice,
    required List<String> productImagesLinks,
    required String productQuantity,
    required String productDescription,
    required String productKeyPoints,
    required String priceCurrency,
    required String storeName,
    required String storeAddress,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .doc('$categoryName/$subCategoryName')
              .get();
      print('DocumentSnapShot is: ${documentSnapshot.data()}');

      if (documentSnapshot.data() == null) {
        /// Specific Category Not Present
        await FirebaseFirestore.instance
            .doc('$categoryName/$subCategoryName')
            .set({
          storeName: [
            {
              this._productName: productName,
              this._productMainCategory: categoryName,
              this._productSubCategory: subCategoryName,
              this._productImagesLink: productImagesLinks,
              this._productDescription: productDescription,
              this._productKeyPoints: productKeyPoints,
              this._productQuantity: productQuantity,
              this._priceCurrency: priceCurrency,
              this._productActualPrice: actualPrice,
              this._productDiscountPrice: discountPrice,
              this._storeName: storeName,
              this._storeAddress: storeAddress,
            }
          ]
        });
      } else {
        /// Specific Category Present
        print('take');
        final DocumentSnapshot<Map<String, dynamic>> allProducts =
            await FirebaseFirestore.instance
                .doc('$categoryName/$subCategoryName')
                .get();
        List<dynamic>? storeAll = allProducts.data()![storeName];

        if (storeAll == null) {
          /// Store Not Present
          final Map<String, dynamic>? tempMap = documentSnapshot.data();

          tempMap!.addAll({
            storeName: [
              {
                this._productName: productName,
                this._productMainCategory: categoryName,
                this._productSubCategory: subCategoryName,
                this._productImagesLink: productImagesLinks,
                this._productDescription: productDescription,
                this._productKeyPoints: productKeyPoints,
                this._productQuantity: productQuantity,
                this._priceCurrency: priceCurrency,
                this._productActualPrice: actualPrice,
                this._productDiscountPrice: discountPrice,
                this._storeName: storeName,
                this._storeAddress: storeAddress,
              }
            ]
          });

          print('tempMAp: $tempMap');

          await FirebaseFirestore.instance
              .doc('$categoryName/$subCategoryName')
              .update(tempMap);
        } else {
          /// Store Name Present
          print('Store All : $storeAll');
          bool _productNameSame = false;
          int fieldMatchingIndex = -1;

          storeAll.forEach((field) {
            if (field[this._productName].toString() == productName) {
              _productNameSame = true;
              fieldMatchingIndex = storeAll.indexOf(field);
            }
          });
          final Map<String, dynamic>? allStoreCollection = allProducts.data();

          if (_productNameSame) {
            /// Same Product Name PResent
            print('Product Name Same');

            allStoreCollection![storeName].removeAt(fieldMatchingIndex);
          }

          print(allStoreCollection![storeName]);

          allStoreCollection[storeName].add({
            this._productName: productName,
            this._productMainCategory: categoryName,
            this._productSubCategory: subCategoryName,
            this._productImagesLink: productImagesLinks,
            this._productDescription: productDescription,
            this._productKeyPoints: productKeyPoints,
            this._productQuantity: productQuantity,
            this._priceCurrency: priceCurrency,
            this._productActualPrice: actualPrice,
            this._productDiscountPrice: discountPrice,
            this._storeName: storeName,
            this._storeAddress: storeAddress,
          });

          print('All Store Collection: $allStoreCollection');

          await FirebaseFirestore.instance
              .doc('$categoryName/$subCategoryName')
              .set(allStoreCollection)
              .whenComplete(() => print('Completed'));
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> uploadMediaToStorage(File filePath,
      {required String reference}) async {
    try {
      late String? downLoadUrl;

      final String fileName =
          '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}';

      final Reference firebaseStorageRef =
          FirebaseStorage.instance.ref(reference).child(fileName);

      print('Firebase Storage Reference: $firebaseStorageRef');

      final UploadTask uploadTask = firebaseStorageRef.putFile(filePath);

      await uploadTask.whenComplete(() async {
        print("Media Uploaded");
        downLoadUrl = await firebaseStorageRef.getDownloadURL();
        print("Download Url: $downLoadUrl}");
      });

      return downLoadUrl;
    } catch (e) {
      print('Error : Firebase Storage Error: ${e.toString()}');
      return '';
    }
  }

  Future<List<dynamic>>? getStoreNameAndAddress({required String email}) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(this._sellerPath)
          .where('email', isEqualTo: email)
          .get();

      final Map<String, dynamic> take =
          querySnapshot.docs[0].data() as Map<String, dynamic>;

      return [take['store_name'], take['address']];
    } catch (e) {
      print('Error in Get Store Name and Address: ${e.toString()}');
      return [];
    }
  }
}
