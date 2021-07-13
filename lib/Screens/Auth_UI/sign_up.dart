import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:e_bucket/Screens/Common%20Screens/common_auth_screen.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
              'Sign Up',
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
                    height: 30.0,
                  ),
                  _doneBtn(),
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
        onPressed: () => _emailCodeAndPwdDialog(
          forCode: true,
          headingText: 'Enter the Code Sent to Email',
          textInputType: TextInputType.number,
          labelText: '6-digit-code',
          inputLimitation: 6,
        ),
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

  void _emailCodeAndPwdDialog({
    required String? labelText,
    required TextInputType? textInputType,
    required int? inputLimitation,
    required String headingText,
    required bool forCode,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Center(
          child: Text(
            headingText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w500),
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 150.0,
          child: Column(
            children: [
              TextField(
                keyboardType: textInputType,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(inputLimitation),
                ],
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w400),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: const Color.fromRGBO(4, 123, 213, 1),
                        width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: const Color.fromRGBO(4, 123, 213, 1),
                        width: 1.5),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  if (forCode)
                    _emailCodeAndPwdDialog(
                        labelText: 'Password',
                        textInputType: TextInputType.name,
                        inputLimitation: null,
                        headingText: 'Enter new Password',
                        forCode: false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
