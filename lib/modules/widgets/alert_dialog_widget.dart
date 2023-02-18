import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/style/colors.dart';

void showAlertDialog({required BuildContext context,required Widget content}){
  showDialog(context: context, builder: (context) => AlertDialog(
    backgroundColor: Colors.grey.shade200,
    contentPadding: EdgeInsets.symmetric(vertical: 25.h),
    contentTextStyle: TextStyle(color: mainColor,fontWeight: FontWeight.w600,fontSize: 18.sp),
    content : content
  )
  );
}