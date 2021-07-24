import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Widget textFormFieldForProduct(
    {required BuildContext context,
    required TextEditingController textEditingController,
    String? labelText,
    Widget? suffix,
    Widget? prefix,
    int? maxLines,
    String? hintText,
    bool enabled = true,
    String? Function(String?)? validator,
    bool outLineBorder = true,
    double labelFontSize = 16.0,
    TextInputType textInputType = TextInputType.text}) {
  return TextFormField(
    controller: textEditingController,
    maxLines: maxLines,
    keyboardType: textInputType,
    validator: validator,
    decoration: InputDecoration(
      alignLabelWithHint: true,
      suffix: suffix,
      prefix: prefix,
      hintText: hintText,
      enabled: enabled,
      hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
      labelText: labelText,
      labelStyle: TextStyle(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.w400,
          fontSize: labelFontSize),
      focusedBorder: inputBorder(fieldState: true, outLineBorder: outLineBorder),
      enabledBorder: inputBorder(fieldState: true, outLineBorder: outLineBorder),
      errorBorder: inputBorder(fieldState: false, outLineBorder: outLineBorder),
      focusedErrorBorder: inputBorder(fieldState: false, outLineBorder: outLineBorder),
    ),
  );
}

InputBorder? inputBorder({required bool fieldState, required bool outLineBorder}){
  return outLineBorder
      ? OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
        color: fieldState?const Color.fromRGBO(4, 123, 213, 1):Colors.red, width: 1.5),
  )
      : UnderlineInputBorder(
    borderSide: BorderSide(
        color: fieldState?const Color.fromRGBO(4, 123, 213, 1):Colors.red, width: 1.5),
  );
}
