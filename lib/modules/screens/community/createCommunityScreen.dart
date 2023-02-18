import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simpleui/modules/widgets/snackBar_widget.dart';
import 'package:simpleui/shared/constants.dart';
import '../../../layout/cubit/layout_cubit.dart';
import '../../../layout/cubit/layout_states.dart';
import '../../../shared/style/colors.dart';
import '../../widgets/buttons_widget.dart';


class CreateCommunityScreen extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CreateCommunityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final LayoutCubit cubit = LayoutCubit.getInstance(context);
    return BlocConsumer<LayoutCubit,LayoutStates>(
        listener: (context,state)
        {
          if( state is CreateMyCommunitySuccessfullyState )
          {
            cubit.communityImageFile = null ;
            titleController.text = "";
            descriptionController.text = "";
            Navigator.pushReplacementNamed(context, 'home_layout_screen');
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message: "Community Created successfully!", context: context, color: Colors.green));
          }
        },
        builder: (context,state){
          return Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
              title: const Text("Add Community"),titleSpacing: 0,leading: const SizedBox(width: 0,),leadingWidth: 14.w,
              actions:
              [
                state is CreateMyCommunityLoadingState ?
                  Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: const CupertinoActivityIndicator(color: mainColor),
                  ) :
                  Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: InkWell(
                      child: const Icon(Icons.done,color: mainColor,size: 25,),
                      onTap: ()
                      {
                        if( cubit.communityImageFile != null && descriptionController.text.isNotEmpty && titleController.text.isNotEmpty)
                        {
                          cubit.createMyCommunity(communityName:titleController.text,communityDescription: descriptionController.text );
                        }
                        else if( descriptionController.text.isEmpty || titleController.text.isEmpty )
                        {
                          ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message: "TextFormField mustn't be empty!", context: context, color: Colors.red));
                        }
                        else
                        {
                          ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message: "Community's Image mustn't be empty!", context: context, color: Colors.red));
                        }
                      },
                    ),
                  )
              ],
            ),
            body: cubit.userData == null ?
              const Center(child: CircularProgressIndicator(color: mainColor,),) :
              buildCommunityItem(context: context, cubit: cubit),
          );
        }
    );
  }

  Widget buildCommunityItem({required BuildContext context,dynamic model,required LayoutCubit cubit}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          clipBehavior: Clip.hardEdge,
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.withOpacity(0.5))
                          ),
                          child : cubit.userData?.image != null? Image.network(cubit.userData!.image!,fit: BoxFit.cover,) : const Text("")
                      ),
                      const SizedBox(width: 15,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          Text(cubit.userData!.userName!,style: const TextStyle(fontSize: 16),),
                          const SizedBox(height: 2,),
                          Text(timeNow,style: Theme.of(context).textTheme.caption,),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: titleController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(0),
                        hintText: "type Community's title here...",
                        hintStyle: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14)
                    ),
                  ),
                  if( cubit.communityImageFile != null )
                    Text("Community's Image",style: TextStyle(color: mainColor,fontWeight: FontWeight.bold,fontSize: 17.sp),),
                  SizedBox(height: 15.h,),
                  if( cubit.communityImageFile != null )
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        SizedBox(
                            width: double.infinity,
                            child: Image(image: FileImage(cubit.communityImageFile!))
                        ),
                        GestureDetector(
                          onTap: ()
                          {
                            cubit.canceledCommunityImage();
                          },
                          child: Container(margin:const EdgeInsets.all(7.5),child: const CircleAvatar(radius: 15,child:Icon(Icons.close,size: 20,),)),
                        ),
                      ],
                    ),
                  if( cubit.communityImageFile != null )
                    SizedBox(height: 15.h,),
                  if( cubit.communityImageFile != null )
                    Text("Community's Description",style: TextStyle(color: mainColor,fontWeight: FontWeight.bold,fontSize: 17.sp),),
                  if( cubit.communityImageFile != null )
                    SizedBox(height: 12.5.h,),
                  TextFormField(
                    maxLines: 10,
                    controller: descriptionController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 5.h),
                        hintText: "type Community's description here...",
                        hintStyle: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if( cubit.communityImageFile == null )
        Padding(
          padding: EdgeInsets.only(bottom: 15.0.h),
          child: Center(
            child: defaultButton(
                onTap: ()
                {
                  cubit.getCommunityImage();
                },
                backgroundColor: whiteColor,
                padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
                roundedRectangleBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.w)),
                contentWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children:
                  [
                    Icon(Icons.image,color: whiteColor,size: 20.w,),
                    SizedBox(width: 8.w,),
                    const FittedBox(fit:BoxFit.scaleDown,child: Text("add a photo",style: TextStyle(color: whiteColor,fontWeight: FontWeight.bold),))
                  ],
                )
            ),
          )
        ),
      ],
    );
  }
}
