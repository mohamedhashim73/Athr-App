import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:simpleui/shared/style/colors.dart';
import 'cubit/layout_cubit.dart';
import 'cubit/layout_states.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener:(context,state){},
      builder:(context,state){
        final cubit = LayoutCubit.getInstance(context);
        return Scaffold(
          bottomNavigationBar: GNav(
              gap: 6,
              padding: EdgeInsets.symmetric(vertical: 12.5.h,horizontal: 12.5.w),
              tabMargin: EdgeInsets.symmetric(vertical: 12.h,horizontal: 12.w),
              iconSize: 30.w,
              color: Colors.blueGrey,
              textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.sp,color: const Color.fromARGB(255, 109, 173, 202)),
              activeColor: const Color.fromARGB(255, 109, 173, 202),
              backgroundColor: Colors.white,
              tabBackgroundColor: (const Color.fromARGB(255, 221, 228, 228)),
              tabs:
              const
              [
                GButton(icon: Icons.group, text: 'Community'),
                GButton(icon: Icons.person, text: 'Profile'),
                GButton(icon: Icons.noise_aware_outlined, text: 'Certificates'),
              ],
              selectedIndex: cubit.bottomNavIndex,
              onTabChange :(index)
              {
                cubit.changeBottomNavIndex(index);
              }
          ),
          body: cubit.layoutScreens[cubit.bottomNavIndex],
        );
      },
    );
  }
}
