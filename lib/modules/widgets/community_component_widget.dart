import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simpleui/layout/cubit/layout_cubit.dart';
import 'package:simpleui/models/community_model.dart';
import 'package:simpleui/models/post_model.dart';
import 'package:simpleui/modules/screens/comments_view/comments_screen.dart';
import 'package:simpleui/modules/screens/community/community_details_screen.dart';
import 'package:simpleui/modules/screens/likes_screen/likesViewScreen.dart';
import 'package:simpleui/modules/screens/posts/edit_post.dart';
import 'package:simpleui/modules/widgets/alert_dialog_widget.dart';
import 'package:simpleui/shared/constants.dart';

class CommunityWidget extends StatelessWidget{
  final CommunityModel model;
  final String communityID;
  final LayoutCubit cubit;
  const CommunityWidget({super.key, required this.model,required this.communityID,required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
        ListTile(
          onTap: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> CommunityDetails(communityModel: model, communityID: communityID)));
          },
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(backgroundImage: NetworkImage(model.authorImage!),),
          title: Text(model.communityName!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp),),
          subtitle: Text(model.communityDate!),
          trailing: GestureDetector(
            onTap: ()
            {
              showAlertDialog(
                  context: context,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Text(model.authorID == userID ? "Delete Community" : "Leave Community"),
                        onTap: ()
                        async
                        {
                          model.authorID == userID ?
                          await cubit.deleteCommunity(communityID: communityID) :
                          await cubit.leaveCommunity(communityID: communityID,communityName: model.communityName!);
                        },
                      ),
                    ],
                  ),
              );
            },
            child: const Icon(Icons.more_horiz),
          )
        ),
        Text(model.communityDescription!,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp),),
        SizedBox(height: 12.h,),
        GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CommunityDetails(communityModel: model, communityID: communityID)));
            },
            child: Image.network(model.communityImage!,fit: BoxFit.fill,width: double.infinity,height: 200.h,)),
        SizedBox(height: 10.h,),
        Divider(color: Colors.black.withOpacity(0.4),thickness: 0.2,),
      ],
    );
  }

}


