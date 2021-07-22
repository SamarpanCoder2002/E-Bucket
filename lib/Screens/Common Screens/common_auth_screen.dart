import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CommonAuthScreen extends StatelessWidget {
  final Widget child;
  final Widget? bottomWidget;

  CommonAuthScreen({required this.child, required this.bottomWidget});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(4, 123, 213, 1),
      bottomSheet: this.bottomWidget,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              margin: EdgeInsets.only(top: 30.0),
              alignment: Alignment.center,
              child: Text(
                'E-Bucket',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lato',
                    fontSize: 25.0,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 85.0,
              margin: EdgeInsets.only(top: 85.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              child: this.child,
            ),
          ],
        ),
      ),
    );
  }
}
