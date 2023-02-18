import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simpleui/layout/cubit/layout_cubit.dart';
import 'package:simpleui/modules/widgets/snackBar_widget.dart';
import '../../../../layout/layout_screen.dart';
import '../../../../shared/style/colors.dart';
import '../../../widgets/alert_dialog_widget.dart';
import '../../../widgets/buttons_widget.dart';
import '../cubit/signCubit.dart';
import '../cubit/signStates.dart';
import 'login.dart';

class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignCubit,SignStates>(
        listener: (context,state)
        {
          if(state is CreateUserErrorState )
          {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message: state.error.toString(), context: context, color: Colors.red));
          }
          if(state is SaveUserDataErrorState)
          {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message: state.error.toString(), context: context, color: Colors.red));
          }
          if( state is CreateUserLoadingState )
          {
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
          }
          if(state is SaveUserDataSuccessState)
          {
            LayoutCubit.getInstance(context).getMyData().then((value){
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeLayoutScreen()));
            });
          }
        },
        builder: (context,state){
          final cubit = SignCubit.get(context);
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Center(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                height: 125,
                                width: 125,
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(shape: BoxShape.circle,color: mainColor),
                              ),
                              Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: whiteColor,
                                    ),
                                    child: cubit.userImageFile != null ?
                                    Image(image: FileImage(cubit.userImageFile!)) :
                                    const Text(""),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      cubit.getUserImageFile();
                                    },
                                    child: const CircleAvatar(backgroundColor:mainColor,maxRadius: 15,child: Icon(Icons.photo_camera,color:whiteColor,size: 20,),),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        textFieldItem(userNameController,"User Name",Icons.person,false,TextInputType.name),
                        const SizedBox(height: 10,),
                        textFieldItem(phoneController,"Phone Number",Icons.phone,false,TextInputType.phone),
                        const SizedBox(height: 10,),
                        textFieldItem(emailController,"Email",Icons.email,false,TextInputType.emailAddress),
                        const SizedBox(height: 10,),
                        textFieldItem(passwordController,"Password",Icons.password,true,TextInputType.name),
                        const SizedBox(height: 20,),
                        defaultButton(
                            contentWidget: Text(state is CreateUserLoadingState ? "Loading..." : "Sign Up",style: TextStyle(color: whiteColor,fontSize: 16.sp),),
                            minWidth: double.infinity,
                            onTap: ()
                            {
                             if( formKey.currentState!.validate() )
                               {
                                 if( cubit.userImageFile != null && formKey.currentState!.validate() )
                                 {
                                   cubit.createUser(userName:userNameController.text,email: emailController.text, password: passwordController.text,phoneNumber: phoneController.text);
                                 }
                                 else if ( cubit.userImageFile == null)
                                 {
                                   ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message: "choose an Image and try again!", context: context, color: Colors.grey.withOpacity(1)));
                                 }
                               }
                             },
                            padding: const EdgeInsets.all(12.5),
                            roundedRectangleBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))
                        ),
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Already have an account? ",style: TextStyle(color: Colors.black),),
                            defaultTextButton(
                                title: const Text("Sign In",style: TextStyle(fontWeight:FontWeight.bold,fontSize:15,color: mainColor),),
                                onTap: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                                }
                                ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  Widget textFieldItem(TextEditingController controller,String title,IconData iconData,bool isSecure,TextInputType textInputType){
    return TextFormField(
      keyboardType: textInputType,
      controller: controller,
      obscureText: isSecure,
      validator: (val)
      {
        return controller.text.isEmpty ? "$title must not be empty" : null ;
      },
      decoration: InputDecoration(
        hintText: title,
        prefixIcon: Icon(iconData),
      ),
    );
  }
}
