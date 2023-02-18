import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simpleui/modules/screens/splash_screen/splash_screen.dart';
import 'package:simpleui/modules/screens/sign_screens/cubit/signCubit.dart';
import 'package:simpleui/shared/constants.dart';
import 'package:simpleui/shared/network/local_network.dart';
import 'package:simpleui/shared/style/colors.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'layout/cubit/bloc_observer.dart';
import 'layout/cubit/layout_cubit.dart';

Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint(
      "Message while App is closed, message's data is : ${message.data}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.cacheInit();

  // Todo: Firebase Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Todo: get token t use it on Firebase messaging FCM Rest API
  if (firebase_messaging_token == null) {
    await CacheHelper.saveCacheData(
        key: 'firebase_messaging_token',
        val: await FirebaseMessaging.instance.getToken());
  }
  firebase_messaging_token =
      CacheHelper.getCacheData(key: 'firebase_messaging_token');
  debugPrint("FirebaseMessagingToken is : $firebase_messaging_token");

  // Todo: receive messages from Firebase Messaging ( while app is open and user is in it )
  FirebaseMessaging.onMessage.listen((message) {
    debugPrint(
        "Message while App is open, message's data is : ${message.data}");
  });

  // Todo: Get message while app is open but user outside The Application
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    debugPrint(
        "Message while App is open but user is outside, message's data is : ${message.data}");
  });

  // Todo: Receive message on Background as app is closed
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);

  userID = CacheHelper.getCacheData(key: 'uid') ?? "";
  debugPrint("User ID is $userID");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => SignCubit()),
              BlocProvider(
                  create: (context) => LayoutCubit()..getMyData()..getMyAllCommunitiesData()),
            ],
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  appBarTheme: const AppBarTheme(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      foregroundColor: mainColor),
                  // Todo: add u font here fontFamily: "Cairo",
                  textTheme: Typography.englishLike2018.apply(
                      fontSizeFactor: 1.sp,
                      displayColor: Colors.black,
                      bodyColor: Colors.black),
                ),
                home: child,
                routes: appRoutes),
          );
        },
        child: const SplashScreen());
  }
}
