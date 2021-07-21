import 'package:e_bucket/Screens/Common%20Screens/common_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SellOnEBucket extends StatefulWidget {
  const SellOnEBucket({Key? key}) : super(key: key);

  @override
  _SellOnEBucketState createState() => _SellOnEBucketState();
}

class _SellOnEBucketState extends State<SellOnEBucket> {
  final TextEditingController _storeName = TextEditingController();
  final TextEditingController _storeLocation = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: this._isLoading,
      child: CommonProductScreen(
        elevation: 5.0,
        actionsAndMenu: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Create Seller Profile',
                  style: TextStyle(
                      fontSize: 20.0, color: Theme.of(context).accentColor),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              _textFormField(storeLocation: false),
              SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  Expanded(child: _textFormField(storeLocation: true)),
                  IconButton(
                    color: Colors.green,
                      icon: Icon(Icons.location_on_outlined, size: 30.0,),
                    onPressed: ()async{
                        await _currentLocationDetector();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFormField({required bool storeLocation}) {
    return TextField(
      controller: _getTextEditingController(storeLocation: storeLocation),
      decoration: InputDecoration(
        labelText: _getLabelText(storeLocation: storeLocation),
        labelStyle: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.w400),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
              color: const Color.fromRGBO(4, 123, 213, 1), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
              color: const Color.fromRGBO(4, 123, 213, 1), width: 1.5),
        ),
      ),
    );
  }

  TextEditingController _getTextEditingController({required bool storeLocation}){
    if(storeLocation)
      return this._storeLocation;
    return this._storeName;
  }

  String _getLabelText({required bool storeLocation}){
    return storeLocation?'Location':'Company/Store Name';
  }

  Future<void> _currentLocationDetector() async{
    final LocationPermission _locationPermission = await Geolocator.requestPermission();

    print(_locationPermission);

    if(_locationPermission == LocationPermission.always || _locationPermission == LocationPermission.whileInUse){

      if(mounted){
        setState(() {
            this._isLoading = true;
        });
      }

      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      /// Get address from the coordinates
      final coordinates = new Coordinates(position.latitude, position.longitude);
      final List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

      addresses.forEach((element) {
        print(element.addressLine.toString());
      });

      if(mounted){
        setState(() {
          this._storeLocation.text = addresses.first.addressLine.toString();
          this._isLoading = false;
        });
      }
    }
  }
}
