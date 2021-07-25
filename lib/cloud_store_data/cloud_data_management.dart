import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:e_bucket/global_uses/product_details_helper.dart';

class CloudDataStore {
  final String _consumerPath = 'consumers';
  final String _sellerPath = 'sellers';
  final String _categoryPath = 'category';

  Future<void> dataStoreForConsumers(String email) async {
    try {
      await FirebaseFirestore.instance.doc('$_consumerPath/$email').set({
        'email': '$email',
        'cart': [],
        'orders': [],
        'name': '',
        'address': '',
        'profilePicUrl': '',
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
    required String productNameLocal,
    required String categoryNameLocal,
    required String subCategoryNameLocal,
    required String actualPriceLocal,
    required String discountPriceLocal,
    required List<String> productImagesLinksLocal,
    required String productQuantityLocal,
    required String productDescriptionLocal,
    required String productKeyPointsLocal,
    required String priceCurrencyLocal,
    required String storeNameLocal,
    required String storeAddressLocal,
    required String mainProductImageUrlLocal,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .doc('$categoryNameLocal/$subCategoryNameLocal')
              .get();
      print('DocumentSnapShot is: ${documentSnapshot.data()}');

      if (documentSnapshot.data() == null) {
        /// Specific Category Not Present
        await FirebaseFirestore.instance
            .doc('$categoryNameLocal/$subCategoryNameLocal')
            .set({
          storeNameLocal: [
            {
              productName: productNameLocal,
              productMainCategory: categoryNameLocal,
              productSubCategory: subCategoryNameLocal,
              productImagesLink: productImagesLinksLocal,
              productDescription: productDescriptionLocal,
              productKeyPoints: productKeyPointsLocal,
              productQuantity: productQuantityLocal,
              priceCurrency: priceCurrencyLocal,
              productActualPrice: actualPriceLocal,
              productDiscountPrice: discountPriceLocal,
              productMainImageUrl: mainProductImageUrlLocal,
              storeName: storeNameLocal,
              storeAddress: storeAddressLocal,
            }
          ]
        }).whenComplete(() => print('Completed Firestore Uplaod'));
      } else {
        /// Specific Category Present
        print('take');
        final DocumentSnapshot<Map<String, dynamic>> allProducts =
            await FirebaseFirestore.instance
                .doc('$categoryNameLocal/$subCategoryNameLocal')
                .get();
        List<dynamic>? storeAll = allProducts.data()![storeNameLocal];

        if (storeAll == null) {
          /// Store Not Present
          final Map<String, dynamic>? tempMap = documentSnapshot.data();

          tempMap!.addAll({
            storeNameLocal: [
              {
                productName: productNameLocal,
                productMainCategory: categoryNameLocal,
                productSubCategory: subCategoryNameLocal,
                productImagesLink: productImagesLinksLocal,
                productDescription: productDescriptionLocal,
                productKeyPoints: productKeyPointsLocal,
                productQuantity: productQuantityLocal,
                priceCurrency: priceCurrencyLocal,
                productActualPrice: actualPriceLocal,
                productDiscountPrice: discountPriceLocal,
                storeName: storeNameLocal,
                storeAddress: storeAddressLocal,
                productMainImageUrl: mainProductImageUrlLocal,
              }
            ]
          });

          print('tempMAp: $tempMap');

          await FirebaseFirestore.instance
              .doc('$categoryNameLocal/$subCategoryNameLocal')
              .update(tempMap)
              .whenComplete(() => print('Completed'));
        } else {
          /// Store Name Present
          print('Store All : $storeAll');
          bool _productNameSame = false;
          int fieldMatchingIndex = -1;

          storeAll.forEach((field) {
            if (field[productName].toString() == productName) {
              _productNameSame = true;
              fieldMatchingIndex = storeAll.indexOf(field);
            }
          });
          final Map<String, dynamic>? allStoreCollection = allProducts.data();

          if (_productNameSame) {
            /// Same Product Name PResent
            print('Product Name Same');

            allStoreCollection![storeNameLocal].removeAt(fieldMatchingIndex);
          }

          print(allStoreCollection![storeNameLocal]);

          allStoreCollection[storeNameLocal].add({
            productName: productNameLocal,
            productMainCategory: categoryNameLocal,
            productSubCategory: subCategoryNameLocal,
            productImagesLink: productImagesLinksLocal,
            productDescription: productDescriptionLocal,
            productKeyPoints: productKeyPointsLocal,
            productQuantity: productQuantityLocal,
            priceCurrency: priceCurrencyLocal,
            productActualPrice: actualPriceLocal,
            productDiscountPrice: discountPriceLocal,
            storeName: storeNameLocal,
            storeAddress: storeAddressLocal,
            productMainImageUrl: mainProductImageUrlLocal,
          });

          print('All Store Collection: $allStoreCollection');

          await FirebaseFirestore.instance
              .doc('$categoryNameLocal/$subCategoryNameLocal')
              .set(allStoreCollection)
              .whenComplete(() => print('Completed'));
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> uploadMediaToStorage(File filePath,
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

      return downLoadUrl.toString();
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

  Future<Map<String, dynamic>?> getAllThings(
      {required String? mainCategory, required String subCategory}) async {
    print('Main Category: $mainCategory');
    print('Sub Category: $subCategory');
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .doc('$mainCategory/$subCategory')
            .get();

    /// print(documentSnapshot.data());
    return documentSnapshot.data();
  }

  Future<bool> addNewItemToCart(
      {required String email, required Map<String, dynamic> productMap}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .doc('${this._consumerPath}/$email')
              .get();
      print(documentSnapshot.data());

      final List<dynamic> _cartCollection = documentSnapshot.data()!['cart'];
      _cartCollection.add(productMap);

      await FirebaseFirestore.instance
          .doc('${this._consumerPath}/$email')
          .update({
        'cart': _cartCollection,
      });

      return true;
    } catch (e) {
      print('Error In Add New Item Cart: ${e.toString()}');
      return false;
    }
  }

  // Future<bool> profileSectionAddThings(
  //     {required String email,
  //     required String userName,
  //     required String userAddress,
  //     required String profilePicLocalPath}) async {
  //   try {
  //     final String downloadUrl = await uploadMediaToStorage(
  //         File(profilePicLocalPath),
  //         reference: 'UserProfileImages/');
  //
  //     await FirebaseFirestore.instance
  //         .doc('${this._consumerPath}/$email')
  //         .update({
  //       'name': userName,
  //       'address': userAddress,
  //       'profilePicUrl': downloadUrl,
  //     });
  //
  //     return true;
  //   } catch (e) {
  //     print('Error in Profile Section And Things: ${e.toString()}');
  //     return false;
  //   }
  // }

  Future<List<dynamic>> getCartSavedProducts({required String email}) async{
    try{
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await FirebaseFirestore.instance
          .doc('${this._consumerPath}/$email')
          .get();
      print(documentSnapshot.data());

      final List<dynamic> _cartCollection = documentSnapshot.data()!['cart'];
      return _cartCollection;
    }catch(e){
      print('Error in getCartSavedProducts: ${e.toString()}');
        return [];
    }
  }
}
