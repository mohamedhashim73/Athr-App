import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simpleui/layout/cubit/layout_cubit.dart';
import 'package:simpleui/layout/cubit/layout_states.dart';
import 'package:simpleui/modules/screens/sign_screens/signScreens/login.dart';
import 'package:simpleui/modules/widgets/snackBar_widget.dart';
import 'package:simpleui/shared/network/local_network.dart';
import 'package:simpleui/shared/style/colors.dart';
import '../../widgets/buttons_widget.dart';

class ProfileScreen extends StatelessWidget{
  final bool isDark = false;

  const ProfileScreen({super.key});
  @override
  Widget build(context){
    final LayoutCubit cubit = LayoutCubit.getInstance(context);
    return Builder(
        builder: (context) {
          if( cubit.userData == null ) cubit.getMyData();   // Todo: as if I log out will get the new info
          return Scaffold(
              appBar: AppBar(title: const Text("Profile"),leadingWidth: 0.w,leading: Container(),),
              body: BlocConsumer<LayoutCubit,LayoutStates>(
                  listener:(context,state){},
                  builder: (context,state){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                      [
                        Expanded(
                            flex: 3,
                            child: cubit.userData != null ?
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 70.w,
                                  backgroundColor: Colors.grey.withOpacity(0.5),
                                  backgroundImage: NetworkImage(cubit.userData!.image.toString()),
                                ),
                                SizedBox(height: 20.h,),
                                Text(cubit.userData!.userName.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                SizedBox(height: 5.h,),
                                Text(cubit.userData!.email.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.grey),),
                              ],
                            ) :
                            const CupertinoActivityIndicator(color: mainColor,)
                        ),
                        SizedBox(height: 20.h,),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              children:
                              [
                                _buttonItem(iconData: Icons.person,title: "Update Data", onTap: (){Navigator.pushNamed(context, 'update_profile_screen');}),
                                SizedBox(height: 15.h,),
                                _buttonItem(iconData: Icons.favorite,title: "Create a Community", onTap: (){
                                  Navigator.pushNamed(context, "create_community_screen");
                                }),
                                SizedBox(height: 15.h,),
                                _buttonItem(iconData: Icons.favorite,title: "Communities", onTap: (){ cubit.changeBottomNavIndex(0);}),
                                SizedBox(height: 15.h,),
                                _buttonItem(
                                    iconData: Icons.logout,
                                    title: "Log out",
                                    onTap: ()
                                    {
                                      cubit.userData = null;
                                      CacheHelper.clearCache();
                                      Navigator.pushReplacementNamed(context, "login_screen");
                                    }
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
              )
          );
        }
    );
  }

  Widget _buttonItem({required dynamic onTap,required String title,required IconData iconData}){
    return defaultButton(
        height: 45.h,
        roundedRectangleBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.w)
        ),
        minWidth:double.infinity,
        onTap: onTap,
        backgroundColor: mainColor,
        contentWidget: Center(child: Text(title,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 17,color: Colors.white),))
    );
  }
}