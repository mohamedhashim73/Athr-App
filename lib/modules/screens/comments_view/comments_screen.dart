import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simpleui/main.dart';
import 'package:simpleui/models/comment_model.dart';
import 'package:simpleui/modules/widgets/alert_dialog_widget.dart';
import 'package:simpleui/shared/constants.dart';
import '../../../layout/cubit/layout_cubit.dart';
import '../../../layout/cubit/layout_states.dart';
import '../../../models/post_model.dart';
import '../../../shared/style/colors.dart';
import '../../widgets/buttons_widget.dart';
import '../../widgets/snackBar_widget.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel model;
  final String postID;
  final String communityAuthorID;
  const CommentsScreen({super.key, required this.model,required this.postID,required this.communityAuthorID});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = LayoutCubit.getInstance(context);
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context,state) {
        if ( state is AddCommentSuccessState )
          {
            commentController.text = "";
          }
        if( state is DeleteCommentSuccessState )
          {
            Navigator.pop(context);
          }
        if( state is FailedToAddCommentState )
          {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message: "Something went wrong, try again later!", context: context, color: Colors.red));
          }
      },
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: const Text("Comments"),
            leading: defaultTextButton(title: const Icon(Icons.arrow_back_ios), onTap: (){Navigator.pop(context);}),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5,horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                Expanded(
                    child: state is GetCommentsLoadingState ?
                      const Center(child: CupertinoActivityIndicator(color: mainColor,),) :
                      cubit.comments.isNotEmpty ?
                      ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context,index){ return buildCommentItem(model: cubit.comments[index],commentID: cubit.commentsID[index],cubit: cubit);},
                      separatorBuilder: (context,i){return SizedBox(height: 15.0.h);},
                      itemCount: cubit.comments.length,) :
                      const Center(child: Text("No Comments yet",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 17),))
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                    [
                      CircleAvatar(
                        radius: 20.h,
                        backgroundImage: NetworkImage(cubit.userData!.image!),
                      ),
                      SizedBox(width: 12.5.w,),
                      Expanded(
                        child: StatefulBuilder(
                          builder: (context,setState){
                            return TextFormField(
                              controller: commentController,
                              onFieldSubmitted: (val)
                              {
                                if( commentController.text.isNotEmpty )
                                  {
                                    cubit.addComment(
                                        comment: commentController.text,
                                        postModel: widget.model,
                                        postID: widget.postID,
                                    );
                                  }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(22),borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
                                contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 12.0),
                                hintText: "add a new comment...",
                                hintStyle: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildCommentItem({required CommentModel model,required String commentID,required LayoutCubit cubit}){
    return Row(
      children:
      [
        CircleAvatar(
          radius: 27,
          backgroundImage: NetworkImage(model.commentMakerImage!),
        ),
        const SizedBox(width: 10,),
        Expanded(
            child: InkWell(
              onDoubleTap: ()
              {
                // Todo: Delete it if I made it or Community Author have also the ability to do this
                if( model.commentMakerID == userID || widget.communityAuthorID == userID )
                {
                  showAlertDialog(
                      context: context,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                        [
                          GestureDetector(
                            child: const Text("Delete Comment"),
                            onTap: ()
                            {
                              cubit.deleteComment(postModel: widget.model, commentID: commentID, postID: widget.postID);
                            },
                          ),
                        ],
                      ),
                  );

                }
              },
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 16.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),border: Border.all(color: Colors.grey.withOpacity(0.5))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      FittedBox(fit: BoxFit.scaleDown,child: Text(model.commentMakerName!,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp),),),
                      const SizedBox(height: 3,),
                      Text(model.comment!,style: TextStyle(fontSize: 12.8.sp,color: Colors.black.withOpacity(0.7)),maxLines: 1,overflow: TextOverflow.ellipsis,)
                    ],
                  )
              ),
            )
        ),
      ],
    );
  }
}
