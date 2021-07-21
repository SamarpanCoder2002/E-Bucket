import 'package:cloud_firestore/cloud_firestore.dart';

class CloudDataStore{
  final String _consumerPath = 'consumers';
  final String _sellerPath = 'sellers';

  Future<void> dataStoreForConsumers(String email) async{
    try{
      await FirebaseFirestore.instance.doc('$_consumerPath/$email').set({
        'email':'$email',
      });
    }catch(e){
      print('Data Store For Consumers Error: ${e.toString()}');
    }
  }
}