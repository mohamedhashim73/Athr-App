import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simpleui/layout/cubit/layout_cubit.dart';
import 'package:simpleui/models/post_model.dart';
import 'package:simpleui/modules/widgets/alert_dialog_widget.dart';
import 'package:simpleui/modules/widgets/snackBar_widget.dart';
import 'package:simpleui/shared/style/colors.dart';
import '../../../layout/cubit/layout_states.dart';
import '../../../models/community_model.dart';
import '../../widgets/community_component_widget.dart';
import '../../widgets/empty_home_component.dart';
import '../../widgets/post_component_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController ;
  int currentTabIndex = 0 ;
  @override
  void initState()
  {
    tabController = TabController(vsync: this, length: 2, initialIndex: currentTabIndex);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final LayoutCubit cubit = LayoutCubit.getInstance(context);
    List<CommunityModel> communitiesData = cubit.myCommunitiesData;
    List<PostModel> postsData = cubit.postsData;
    Map<String,bool> likesStatus = cubit.likesStatus;
    List<String> communitiesID = cubit.myCommunitiesID;
    List<String> postsID = cubit.postsID;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Athr"),
        leading: const SizedBox(),
        leadingWidth: 0.w,
        bottom: TabBar(
          labelPadding: const EdgeInsets.only(top: 0),
          onTap: (index)
          {
            setState(()
            {
              currentTabIndex = index;
            });
          },
          controller: tabController,
          indicatorColor: const Color.fromARGB(255, 109, 173, 202),
          padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 0),
          labelColor: mainColor,
          labelStyle: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),
          tabs: const
          [
            Tab(child: Text("Communities"),),
            Tab(child: Text("Posts"),),
          ],
        ),
        actions: [
        Padding(
          padding: EdgeInsets.only(right: 12.0.w),
          child: GestureDetector(child: const Icon(Icons.search), onTap: () {Navigator.pushNamed(context, "search_about_community_screen");},),
        )],
      ),
      body: TabBarView(
        controller: tabController,
        children:
        [
          // Todo: It was BlocBuilder
          BlocConsumer<LayoutCubit,LayoutStates>(
            listener: (context,state)
            {
              // Todo: To pop up from AlertDialog
              if( state is DeleteCommunitySuccessfullyState || state is LeaveCommunitySuccessfullyState )
                {
                  Navigator.pop(context);
                }
              if( state is LeaveCommunityWithErrorState || state is FailedToDeleteCommunityState )
              {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message: "Something went wrong, try again later!", context: context, color: Colors.red));
              }
              if( state is LeaveCommunityLoadingState || state is DeleteCommunityLoadingState )
                {
                  Navigator.pop(context);
                  showAlertDialog(
                      context: context,
                      content: Column(
                        mainAxisSize:MainAxisSize.min,
                        mainAxisAlignment:MainAxisAlignment.center,
                        children:
                        [
                          CupertinoActivityIndicator(color: mainColor,radius: 15.h,)
                        ],
                      )
                  );
                }
            },
            buildWhen: (oldState,newState)
            {
              return newState is GetMyCommunitiesSuccessState;
            },
            builder: (context,state){
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                  child: communitiesData.isNotEmpty && cubit.userData != null ?
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        if( communitiesData.isNotEmpty )
                          ...List.generate(communitiesData.length, (index) => CommunityWidget(cubit:cubit,model: communitiesData[index],communityID: communitiesID[index],)),
                      ],
                    ),
                  ) : state is GetMyCommunitiesLoadingState ?
                  Center(child: CupertinoActivityIndicator(color: mainColor,radius: 15.h),) :
                  emptyDataItemView(context: context, title: "No Communities yet, try to join one!")
              );
            },
          ),
          BlocConsumer<LayoutCubit,LayoutStates>(
            listener: (context,state)
            {
              if( state is DeletePostSuccessState )
              {
                Navigator.pop(context);
              }
              if( state is DeletePostErrorState )
              {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message: "Something went wrong, try again later!", context: context, color: Colors.red));
              }
              if( state is DeletePostLoadingState )
              {
                Navigator.pop(context);
                showAlertDialog(
                    context: context,
                    content: Column(
                      mainAxisSize:MainAxisSize.min,
                      mainAxisAlignment:MainAxisAlignment.center,
                      children:
                      [
                        CupertinoActivityIndicator(color: mainColor,radius: 15.h,)
                      ],
                    )
                );
              }
            },
            buildWhen: (oldState,newState)
            {
              return newState is GetAllPostsSuccessfullyState ;
            },
            builder: (context,state){
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                  child: postsData.isNotEmpty && postsID.isNotEmpty && cubit.userData != null ?
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        if( postsData.isNotEmpty && postsID.isNotEmpty )
                          ...List.generate(postsData.length, (index) => PostWidget(model: postsData[index],postID: postsID[index],cubit: cubit,likesStatus: likesStatus,)),
                      ],
                    ),
                  ) : state is GetAllPostsLoadingState ?
                  Center(child: CupertinoActivityIndicator(color: mainColor,radius: 25.h,),) :
                  emptyDataItemView(context: context, title: "No Posts yet, try to add one!")
              );
            },
          ),
        ],
      )
    );
  }
}
