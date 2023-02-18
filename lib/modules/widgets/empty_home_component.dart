import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
// Todo: This widget will be shown when there is no data on Archived screen
Widget emptyDataItemView({required BuildContext context,required String title}){
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15.0.h),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
      [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              SvgPicture.asset('assets/empty_box.svg',color: Colors.grey,height: 100.h,width: 100.w,),
              SizedBox(height: 20.h,),
              Center(
                child: Text(title,style: Theme.of(context).textTheme.headlineSmall!.copyWith(color:Colors.black.withOpacity(0.4),fontSize: 15.5.sp,fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}