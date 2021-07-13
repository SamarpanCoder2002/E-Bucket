import 'package:e_bucket/AuthManagement/email_auth.dart';
import 'package:e_bucket/AuthManagement/facebook_auth.dart';
import 'package:e_bucket/AuthManagement/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final EmailAuthentication _emailAuthentication = EmailAuthentication();
  final GoogleAuthentication _googleAuth = GoogleAuthentication();
  final FacebookAuthentication _facebookAuthentication = FacebookAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ElevatedButton(
          child: Text('LogOut'),
          onPressed: ()async{
            final bool googleLogOutResponse = await _googleAuth.logOut();
            if(!googleLogOutResponse){
              final bool fbLogOutResponse = await _facebookAuthentication.logOut();
              if(!fbLogOutResponse)
                await _googleAuth.logOut();
            }

            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

          },
        ),
      ),
    );
  }
}
