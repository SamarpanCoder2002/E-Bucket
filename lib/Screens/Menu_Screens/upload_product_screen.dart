import 'dart:io';

import 'package:e_bucket/Screens/Common%20Screens/common_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UploadProducts extends StatefulWidget {
  final Map<int, String> uploadPictureContainer;

  UploadProducts(
      {Key? key,
      required this.uploadPictureContainer})
      : super(key: key);

  @override
  _UploadProductsState createState() => _UploadProductsState();
}

class _UploadProductsState extends State<UploadProducts> {

  @override
  Widget build(BuildContext context) {
    return CommonProductScreen(
      elevation: 10.0,
      pageTitle: 'Upload Product Images',
      actionsAndMenu: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.1,
              margin: EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _uploadPictureBox(0),
                  _uploadPictureBox(2),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: ElevatedButton(
                child: Text('Upload Pictures'),
                onPressed: () {
                  String? msg = '';
                  if (widget.uploadPictureContainer.length < 4)
                    msg = '4 Pictures Needed';

                  msg != ''
                      ? ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(msg)))
                      : Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadPictureBox(int imagePosition) {
    return Row(
      children: [
        _imagePuttingRow(imagePosition),
        SizedBox(
          width: 10,
        ),
        _imagePuttingRow(imagePosition + 1),
      ],
    );
  }

  _imagePuttingRow(int imagePosition) {
    return Expanded(
      child: Container(
        width: (MediaQuery.of(context).size.width - 40) / 2,
        height: (MediaQuery.of(context).size.width - 40) / 2,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: widget.uploadPictureContainer.containsKey(imagePosition)
            ? Stack(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - 40) / 2,
                    height: (MediaQuery.of(context).size.width - 40) / 2,
                    child: Image.file(
                        File(widget.uploadPictureContainer[imagePosition]
                            .toString()),
                        fit: BoxFit.cover),
                  ),
                  Container(
                    color: Colors.black12,
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.red,
                        size: 30.0,
                      ),
                      onPressed: () {
                        if(mounted){
                          setState(() {
                            widget.uploadPictureContainer.remove(imagePosition);
                          });
                        }
                      },
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () async {
                            await _imageCapture(
                                ImageSource.camera, imagePosition);
                          },
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            size: 30.0,
                            color: Colors.black45,
                          )),
                      Text('Camera'),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () async {
                            await _imageCapture(
                                ImageSource.gallery, imagePosition);
                          },
                          icon: Icon(
                            Icons.image_outlined,
                            size: 30.0,
                            color: Colors.black45,
                          )),
                      Text('Gallery'),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _imageCapture(ImageSource imageSource, int imagePosition) async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: imageSource, imageQuality: 50);
    print('PickedImage: $pickedImage');
    if (pickedImage != null) {
      if (mounted) {
        setState(() {
          widget.uploadPictureContainer[imagePosition] =
              File(pickedImage.path).path;
        });
      }
    }
  }
}
