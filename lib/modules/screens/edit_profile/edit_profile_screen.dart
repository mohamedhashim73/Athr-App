import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleui/modules/widgets/snackBar_widget.dart';
import '../../../layout/cubit/layout_cubit.dart';
import '../../../layout/cubit/layout_states.dart';
import '../../../shared/style/colors.dart';
import '../../widgets/buttons_widget.dart';


class EditProfileScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final userNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = LayoutCubit.getInstance(context);
    emailController.text = cubit.userData!.email!;
    userNameController.text = cubit.userData!.userName!;
    phoneNumberController.text = cubit.userData!.phoneNumber!;
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: ()
            {
              cubit.canceledUpdateUserData();    // for this reason i made this function canceledUpdateUserData()
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
          title: const Text("Edit",style: TextStyle(fontSize: 18),),
          titleSpacing: 7.5,
          actions:
          [
            BlocConsumer<LayoutCubit,LayoutStates>(
                listener: (context,state)
                {
                  if( state is UpdateUserDataWithoutImageSuccessState )
                  {
                    ScaffoldMessenger.of(context).showSnackBar( snackBarWidget(message: "User Data Updated successfully!", context: context, color: Colors.green));
                    Navigator.pop(context);
                  }
                },
                builder: (context,state){
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: state is UpdateUserDataWithImageLoadingState || state is UpdateUserDataWithoutImageLoadingState?
                    const CupertinoActivityIndicator(color: mainColor,) :
                    InkWell(
                      onTap: ()
                      {
                        if( cubit.userImageFile != null )
                        {
                          cubit.updateUserDataWithImage(userName: userNameController.text,email: emailController.text,phoneNumber: phoneNumberController.text);
                        }
                        else
                        {
                          cubit.updateUserDataWithoutImage(userName: userNameController.text,email: emailController.text,phoneNumber: phoneNumberController.text);
                        }
                      },
                      child: const Icon(Icons.done,color: Colors.black,),),
                  );
                }),
          ],
        ),
        body: cubit.userData == null ?
        const CircularProgressIndicator(color: mainColor) :
        Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                  [
                    BlocConsumer<LayoutCubit,LayoutStates>(
                        listener: (context,state) {},
                        builder: (context,state){
                          return Center(
                            child: Container(
                              height: 120,
                              width: 120,
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              // made this function as if i change profile photo but canceled update imageProfileUrl will show on EditProfileScreen as i canceled update and i use profileImageUrl to be shown not userData!.image
                              child: cubit.userImageFile != null && state is! CanceledUpdateUserDataState?
                              Image(image: FileImage(cubit.userImageFile!)) :
                              Image(image: NetworkImage(cubit.userData!.image!),),
                            ),
                          );
                        }),
                    const SizedBox(height: 20,),
                    defaultTextButton(
                        title: Text("Update Photo",style: Theme.of(context).textTheme.headline6!.copyWith(color: mainColor)),
                        onTap: ()
                        {
                          cubit.getUserImage();
                        },
                        width: double.infinity,alignment: Alignment.center
                    ),
                    const SizedBox(height: 30,),
                    specificTextFormField(
                        label: "UserName",
                        inputType: TextInputType.name,
                        controller: userNameController,
                        validator: (val)
                        {
                          return userNameController.text.isEmpty ? "UserName must not be empty" : null ;
                        }
                    ),
                    const SizedBox(height: 20,),
                    specificTextFormField(
                        label: "Email",
                        inputType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (val)
                        {
                          return emailController.text.isEmpty ? "Email must not be empty" : null ;
                        }
                    ),
                    const SizedBox(height: 20,),
                    specificTextFormField(
                        label: "Phone Number",
                        inputType: TextInputType.number,
                        controller: phoneNumberController,
                        validator: (val)
                        {
                          return phoneNumberController.text.isEmpty ? "Phone Number must not be empty" : null ;
                        }
                    ),
                  ]
              ),
            ),
          ),
        )
    );
  }

  Widget specificTextFormField({required String label,required TextEditingController controller,required TextInputType inputType,required dynamic validator,String? hint}){
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border: const UnderlineInputBorder(),
      ),
    );
  }
}
