import 'package:e_bucket/AuthManagement/facebook_auth.dart';
import 'package:e_bucket/AuthManagement/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:e_bucket/Screens/Common%20Screens/common_auth_screen.dart';
import 'package:e_bucket/AuthManagement/email_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _pwdEyeLined = true;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _conformPwd = TextEditingController();

  final GlobalKey<FormState> _signUpKey = GlobalKey();

  final EmailAuthentication _emailAuthentication = EmailAuthentication();
  final GoogleAuthentication _googleAuth = GoogleAuthentication();
  final FacebookAuthentication _facebookAuthentication = FacebookAuthentication();

  /// Regular Expression
  final RegExp _emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: this._isLoading,
      child: CommonAuthScreen(
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
                key: this._signUpKey,
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
                      height: 20.0,
                    ),
                    _logInFields(
                        labelText: 'Conform Password',
                        iconData: this._pwdEyeLined
                            ? Entypo.eye_with_line
                            : Entypo.eye),
                    SizedBox(
                      height: 30.0,
                    ),
                    _doneBtn(context),
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
      ),
    );
  }

  Widget _logInFields({required String labelText, required IconData iconData}) {
    return TextFormField(
      controller: _chooseRightController(labelText: labelText),
      validator: (inputText) => _validator(inputText, labelText),
      obscureText: labelText == 'Password' || labelText == 'Conform Password'
          ? this._pwdEyeLined
          : false,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(iconData),
          onPressed: () {
            if (labelText == 'Password' || labelText == 'Conform Password') {
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

  TextEditingController? _chooseRightController({required String labelText}) {
    switch (labelText) {
      case 'Password':
        return this._pwd;
      case 'Conform Password':
        return this._conformPwd;
      default:
        return this._email;
    }
  }

  String? _validator(String? inputText, String labelText) {
    if (labelText == 'Email-Id') {
      if (!this._emailRegex.hasMatch(inputText!))
        return 'Email Format Not Matching';
      return null;
    } else if (labelText == 'Password') {
      if (inputText!.length < 6)
        return 'Password must be at least 6 characters';
      return null;
    } else {
      if (inputText!.length < 6)
        return 'Password must be at least 6 characters';
      if (inputText != this._pwd.text)
        return 'Password and Conform Password Not Matched';
      return null;
    }
  }

  Widget _doneBtn(BuildContext context) {
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
          onPressed: () async {
            await _emailSignUpProgress();
          }),
    );
  }

  Future<void> _emailSignUpProgress() async {
    if (mounted) {
      setState(() {
        this._isLoading = true;
      });
    }

    /// Close the keyboard
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    print('${this._email.text}  ${this._pwd.text}');
    if (!this._signUpKey.currentState!.validate()) {
      print('Not Validate');
    } else {
      final bool response = await _emailAuthentication.signUp(
          email: this._email.text, pwd: this._pwd.text);

      String msg;

      if (response)
        msg = 'Sign Up Completed. A verification link sent to the email';
      else
        msg = 'Email Already Present';

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
      ));
    }

    if (mounted) {
      setState(() {
        this._isLoading = false;
      });
    }
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
                GestureDetector(
                  onTap: () async {
                    if (mounted) {
                      setState(() {
                        this._isLoading = true;
                      });
                    }

                    final bool response = await _googleAuth.signInWithGoogle();

                    late String msg;

                    msg = response
                        ? 'Sign In Successful'
                        : 'Sign In Not Successful';

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(msg)));

                    if(response)
                      Navigator.of(context).pushNamedAndRemoveUntil('/blankScreen', (route) => false);

                    if (mounted) {
                      setState(() {
                        this._isLoading = false;
                      });
                    }
                  },
                  child: Image.asset(
                    'assets/images/google.png',
                    width: 50.0,
                  ),
                ),
                GestureDetector(
                  onTap: () async {

                    if(mounted){
                      setState(() {
                        this._isLoading = true;
                      });
                    }

                    final bool response = await _facebookAuthentication.facebookLogIn();
                    print('Facebook LogIn Response: $response');

                    final String msg = response?'SignIn Successful':'SignIn Not Successful';

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

                    if(response)
                      Navigator.of(context).pushNamedAndRemoveUntil('/blankScreen', (route) => false);

                    if(mounted){
                      setState(() {
                        this._isLoading = false;
                      });
                    }
                  },
                  child: Image.asset(
                    'assets/images/fbook.png',
                    width: 50.0,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
