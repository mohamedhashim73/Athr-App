import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../sign_screens/signScreens/login.dart';
import '../../../shared/constants.dart';
import '../../../layout/layout_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5)).then((value){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return userID != null && userID != "" ?  const HomeLayoutScreen() : LoginScreen();
      }));
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
        [
          Center(child: Image.asset('assets/logo.png',width: 180.w,height: 180.h,fit: BoxFit.cover,),)
        ],
      ),
    );
  }
}
