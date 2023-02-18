import 'package:flutter/material.dart';
import 'package:simpleui/shared/style/colors.dart';

Widget defaultTextFormField({required TextInputType inputType,
  bool secureStatus = false,required TextEditingController controller,InputBorder? inputBorder,
  dynamic validateMethod,dynamic onChanged, String? label,String? hint,Widget? suffixIcon,IconData? prefixIcon}){
  return TextFormField(
    keyboardType: inputType,
    obscureText: secureStatus,
    validator: validateMethod,
    controller: controller,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.all(0),
      suffixIcon: suffixIcon,
      prefixIcon: Icon(prefixIcon),
      border: inputBorder?? const UnderlineInputBorder() ,
    ),
  );
}

Widget defaultButton({required Function() onTap,required Widget contentWidget,double? height,double? minWidth,dynamic padding,Color? backgroundColor,dynamic roundedRectangleBorder}){
  return MaterialButton(
    onPressed: onTap,
    height: height,
    minWidth: minWidth,
    padding: padding,
    elevation: 0,
    color: backgroundColor = mainColor,
    shape: roundedRectangleBorder,
    child: contentWidget,
  );
}

Widget defaultTextButton({required Widget title,required Function() onTap,double? width,dynamic alignment}){
  return Container(
    alignment: alignment,
    width: width,
    child: InkWell(
      onTap: onTap,
      child: title,
    ),
  );
}