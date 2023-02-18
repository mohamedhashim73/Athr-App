import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simpleui/models/like_model.dart';
import '../../../layout/cubit/layout_cubit.dart';
import '../../../layout/cubit/layout_states.dart';

class LikesViewScreen extends StatelessWidget {
  final String communityID,communityAuthorID,postID,postMakerID;  // to enable to get the comments for this post
  const LikesViewScreen({super.key,required this.communityID,required this.communityAuthorID,required this.postID,required this.postMakerID});
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          LayoutCubit.getInstance(context).getLikesForSpecificPost(communityID: communityID,communityAuthorID: communityAuthorID,postID: postID,postMakerID: postMakerID);
          return BlocConsumer<LayoutCubit,LayoutStates>(
            listener: (context,state){},
            builder: (context,state){
              final cubit = LayoutCubit.getInstance(context);
              return Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  backgroundColor: Colors.grey.withOpacity(0.05),
                  title: const Text("Likes",style: TextStyle(fontSize: 20),),
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.5.h,horizontal: 14.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      state is GetLikesLoadingState ?
                      const Center(child: CupertinoActivityIndicator(),) :
                      cubit.likesData.isNotEmpty ?
                      ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context,i){ return buildCommentItem(model: cubit.likesData[i]);},
                        separatorBuilder: (context,i){return SizedBox(height: 15.0.h);},
                        itemCount: cubit.likesData.length,) :
                      const Expanded(
                          child: Center(child: Text("No Likes yet",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),))
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Widget buildCommentItem({required LikeModel model}){
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: CircleAvatar(
        radius: 25.h,
        backgroundImage: NetworkImage(model.likeMakerImage!),
      ),
      title: Text(model.likeMakerName!,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.sp),),
    );
  }
}
