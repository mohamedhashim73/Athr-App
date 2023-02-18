import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../layout/cubit/layout_cubit.dart';
import '../../models/post_model.dart';
import '../../shared/constants.dart';
import '../screens/comments_view/comments_screen.dart';
import '../screens/likes_screen/likesViewScreen.dart';
import '../screens/posts/edit_post.dart';
import 'alert_dialog_widget.dart';

// Todo: Post Widget which will be shown on HomeScreen
class PostWidget extends StatelessWidget{
  final PostModel model;
  final String postID;
  final Map<String,bool> likesStatus ;
  final LayoutCubit cubit;
  const PostWidget({super.key, required this.model,required this.postID,required this.likesStatus,required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(backgroundImage: NetworkImage(model.postMakerImage.toString()),),
          title: Text(model.communityName.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp),),
          subtitle: Text("${model.postMakerName.toString()}, ${model.postDate.toString()}",style: Theme.of(context).textTheme.caption,),
          trailing : GestureDetector(
            onTap: ()
            {
              if( model.postMakerID == userID )
              {
                showAlertDialog(
                  context: context,
                  content : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    [
                      updatePost(context),
                      SizedBox(height: 22.5.h,),
                      deletePost(),
                    ],
                  ),
                );
              }
              else if( model.communityAuthorID == userID )
              {
                showAlertDialog(
                  context: context,
                  content : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    [
                      deletePost(),
                    ],
                  ),
                );
              }
            },
            child: const Icon(Icons.more_horiz),
          ),
        ),
        if( model.postCaption != null )
          InkWell(
            onTap: () {navToCommentsScreen(context);},
            child: Text(model.postCaption.toString(),maxLines: 2,overflow: TextOverflow.ellipsis,textScaleFactor: 1.2),
          ),
        SizedBox(height: 12.h,),
        if( model.postImage != null && model.postImage != "" )
          InkWell(
              onTap: () {navToCommentsScreen(context);},
              child: Image.network(model.postImage.toString(),fit: BoxFit.fill,width: double.infinity)
          ),
        if( model.postImage != null && model.postImage != "" )
          SizedBox(height: 12.h,),
        StatefulBuilder(
            builder: (context,setState){
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:
                [
                  GestureDetector(
                    child: Icon(Icons.favorite,color: likesStatus[postID] == true ? Colors.red : Colors.grey),
                    onTap: ()
                    {
                      // Todo: will refresh This Row only
                      setState((){
                        if( likesStatus[postID] == true )
                        {
                          likesStatus[postID] = false;
                          cubit.removeLike(communityID: model.communityID!, postMakerID: model.postMakerID!, postID: postID, communityAuthorID: model.communityAuthorID!);
                        }
                        else
                        {
                          likesStatus[postID] = true;
                          cubit.addLike(communityID: model.communityID!, postMakerID: model.postMakerID!, postID: postID, communityAuthorID: model.communityAuthorID!);
                        }
                      });
                    },
                  ),
                  SizedBox(width: 7.w,),
                  GestureDetector(
                    child: const Text("Likes"),
                    onTap: ()
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context){
                            return LikesViewScreen(communityID: model.communityID!, communityAuthorID: model.communityAuthorID!, postID: postID, postMakerID: model.postMakerID!);
                          }));
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: ()
                    {
                      // Todo: call comments method first then open CommentsScreen
                      navToCommentsScreen(context);
                    },
                    child: const Text("Comments"),
                  )
                ],
              );
            }
        ),
        Divider(color: Colors.black.withOpacity(0.4),thickness: 0.2,),
      ],
    );
  }

  // Todo: This Method can be done either I made this post or I created the community which this post create in
  Widget deletePost(){
    return GestureDetector(
      child: const Text("Delete Post"),
      onTap: ()
      {
        cubit.deletePost(communityID: model.communityID!, postMakerID: model.postMakerID!, postID: postID, communityAuthorID: model.communityAuthorID!);
      },
    );
  }

  // Todo: Update Post if I created it
  Widget updatePost(BuildContext context){
    return GestureDetector(
      child: const Text("Update Post"),
      onTap: ()
      {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => EditPostScreen(model: model, postID: postID)));
      },
    );
  }

  // Todo: Go To Comments Screen
  void navToCommentsScreen(BuildContext context) {
    cubit.getAllComments(communityID: model.communityID!, communityAuthorID: model.communityAuthorID!, postID: postID);
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return CommentsScreen(model: model, postID: postID,communityAuthorID: model.communityAuthorID!);})
    );
  }
}