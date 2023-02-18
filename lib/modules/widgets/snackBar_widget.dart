import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SnackBar snackBarWidget({required String message,required BuildContext context,required Color color,double elevation = 0 }){
  return SnackBar(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    elevation: elevation,
    content: FittedBox(fit: BoxFit.scaleDown,child: Center(child: Text(message,style:TextStyle(fontSize: 15.sp),textAlign: TextAlign.center))),
    clipBehavior: Clip.hardEdge,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(horizontal: 50.w),
    padding: EdgeInsets.all(8.w),
    backgroundColor: color,
    duration: const Duration(seconds: 1),
  );
}