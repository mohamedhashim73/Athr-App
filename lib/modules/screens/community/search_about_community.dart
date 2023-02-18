import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simpleui/layout/cubit/layout_states.dart';
import 'package:simpleui/models/community_model.dart';
import '../../../layout/cubit/layout_cubit.dart';
import '../../../shared/style/colors.dart';
import '../../widgets/alert_dialog_widget.dart';
import '../../widgets/snackBar_widget.dart';

class SearchAboutCommunityScreen extends StatefulWidget {
  const SearchAboutCommunityScreen({Key? key}) : super(key: key);

  @override
  State<SearchAboutCommunityScreen> createState() => _SearchAboutCommunityScreenState();
}

class _SearchAboutCommunityScreenState extends State<SearchAboutCommunityScreen> {
  final searchController = TextEditingController();
  @override
  void dispose() {
    searchController.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final LayoutCubit cubit = LayoutCubit.getInstance(context);
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context,state)
      {
        if( state is AddToJoinedCommunitySuccessfullyState )
          {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message: "Added to your Communities successfully!", context: context, color: Colors.green));
          }
        if( state is AddToJoinedCommunityLoadingState )
        {
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
      builder: (context,state) {
        return Scaffold(
          appBar: AppBar(toolbarHeight: 30.h,leading: const SizedBox(),),
          body: Column(
            children:
            [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                child: TextFormField(
                  onChanged: (input)
                  {
                   // Todo : filtered Data depending on input
                    cubit.getOtherCommunities(input: input);
                  },
                  controller: searchController,
                  decoration: const InputDecoration(
                      hintText: "search for a community to join...",
                      border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 7.5.h,),
              Expanded(
                child: cubit.otherCommunitiesData.isNotEmpty ?
                ListView.separated(
                  itemCount: cubit.otherCommunitiesData.length,
                  itemBuilder: (context,index)
                  {
                    return communityItem(
                        model: cubit.otherCommunitiesData[index],
                        communityID: cubit.otherCommunitiesID[index],
                        cubit: cubit,
                        context: context
                    );
                  },
                  separatorBuilder: (context,index)
                  {
                    return const Divider(color: Colors.grey,thickness: 0.5);
                  },
                ) : state is GetOtherCommunitiesLoadingState && searchController.text.isEmpty ?
                const Center(child: CupertinoActivityIndicator(color: mainColor,),) :
                Center(child: Text("No Data yet!",style: TextStyle(color: mainColor,fontWeight: FontWeight.bold,fontSize: 17.sp),),),
              )
            ],
          ),
        );
      }
    );
  }

  Widget communityItem({required CommunityModel model,required String communityID,required LayoutCubit cubit,required BuildContext context}){
    return model.communityName != null ?
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.5.w),
        leading: CircleAvatar(backgroundImage: NetworkImage(model.communityImage.toString()),radius: 30.h,),
        title: Align(
            alignment: AlignmentDirectional.topStart,
            child: FittedBox(fit:BoxFit.scaleDown,child: Text(model.communityName.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp),))),
        subtitle: Text(model.communityDate.toString()),
        trailing: GestureDetector(
          onTap: ()
          {
            if( cubit.myCommunitiesID.contains(communityID) == false )
              {
                cubit.addToJoinedCommunity(communityModel: model, communityID: communityID);
              }
            else
              {
                showAlertDialog(
                    context: context,
                    content: Column(
                      mainAxisSize:MainAxisSize.min,
                      mainAxisAlignment:MainAxisAlignment.center,
                      children:
                      [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                          child: const FittedBox(fit: BoxFit.scaleDown,child: Text("You are already following this account"),),
                        )
                      ],
                    )
                );
              }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: cubit.joinedCommunitiesID.contains(communityID) ?
            FittedBox(fit:BoxFit.scaleDown,child: Text("Followed",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600,color: Colors.green),)) :
            FittedBox(child: Text("Follow",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600,color: mainColor),)),
          )
        ),
      ) :
      const Center(child: CupertinoActivityIndicator(color: Colors.red,),);
  }
}
