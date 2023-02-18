import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simpleui/modules/screens/sign_screens/signScreens/register.dart';
import 'package:simpleui/modules/widgets/snackBar_widget.dart';
import 'package:simpleui/shared/style/colors.dart';
import '../../../../layout/layout_screen.dart';
import '../../../widgets/alert_dialog_widget.dart';
import '../../../widgets/buttons_widget.dart';
import '../cubit/signCubit.dart';
import '../cubit/signStates.dart';


class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignCubit,SignStates>(
        listener: (context,state)
        {
          if(state is UserLoginSuccessState)
          {
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeLayoutScreen()));
          }
          if(state is UserLoginErrorState)
          {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message: state.error.toString(), context: context, color: Colors.red));
          }
          if( state is UserLoginLoadingState )
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
                        const Text("Sign In",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: mainColor),),
                        SizedBox(height: 20.h,),
                        textFieldItem(emailController,"Email",Icons.email,false),
                        SizedBox(height: 10.h,),
                        textFieldItem(passwordController,"Password",Icons.password,true),
                        SizedBox(height: 25.h,),
                        defaultButton(
                            contentWidget: state is UserLoginLoadingState ?
                                Text("Loading...",style: TextStyle(color: whiteColor,fontSize: 16.sp),) :
                                Text("Sign In",style: TextStyle(color: whiteColor,fontSize: 16.sp),),
                            minWidth: double.infinity,
                            onTap: ()
                            async
                            {
                              await cubit.userLogin(email: emailController.text, password: passwordController.text);
                            },
                            padding: const EdgeInsets.all(12.5),
                            roundedRectangleBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))
                        ),
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            defaultTextButton(
                                title: const Text("Sign Up",style: TextStyle(fontWeight:FontWeight.bold,fontSize:15,color: mainColor),),
                                onTap: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen()));
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget textFieldItem(TextEditingController controller,String title,IconData iconData,bool isSecure){
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
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
