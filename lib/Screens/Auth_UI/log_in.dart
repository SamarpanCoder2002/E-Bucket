import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:e_bucket/Screens/Common%20Screens/common_auth_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _pwdEyeLined = true;

  @override
  Widget build(BuildContext context) {
    return CommonAuthScreen(
      bottomWidget: null,
      child: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30.0),
            child: Text(
              'Log In',
              style: TextStyle(
                  fontSize: 25.0, color: Theme.of(context).accentColor),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
            child: Form(
              child: Column(
                children: [
                  _logInFields(
                      labelText: 'Email-Id',
                      iconData: Icons.person_outline_outlined),
                  SizedBox(
                    height: 20.0,
                  ),
                  _logInFields(
                      labelText: 'Password',
                      iconData: this._pwdEyeLined
                          ? Entypo.eye_with_line
                          : Entypo.eye),
                  SizedBox(
                    height: 30.0,
                  ),
                  _doneBtn(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Text(
                        'Forgot Password?',
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 40.0,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(width: 6.0),
                          Text('Sign Up')
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  _connectWithOtherOptions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logInFields({required String labelText, required IconData iconData}) {
    return TextFormField(
      obscureText: labelText == 'Password' ? this._pwdEyeLined : false,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(iconData),
          onPressed: () {
            if (labelText == 'Password') {
              if (mounted) {
                setState(() {
                  this._pwdEyeLined = !this._pwdEyeLined;
                });
              }
            }
          },
          color: Theme.of(context).accentColor,
        ),
        labelText: labelText,
        labelStyle: TextStyle(
            color: Theme.of(context).accentColor, fontWeight: FontWeight.w400),
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

  Widget _doneBtn() {
    return Container(
      width: double.maxFinite,
      height: 50.0,
      child: ElevatedButton(
        child: Text(
          'Done',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(4, 123, 213, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            )),
        onPressed: () {},
      ),
    );
  }

  Widget _connectWithOtherOptions() {
    return Container(
        height: 90.0,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Or Connect With',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/google.png',
                  width: 50.0,
                ),
                Image.asset(
                  'assets/images/fbook.png',
                  width: 50.0,
                ),
              ],
            ),
          ],
        ));
  }
}
