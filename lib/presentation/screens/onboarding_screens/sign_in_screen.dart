import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controllers/sign_in_controller.dart';
import 'package:task_manager/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/presentation/utils/app_colors.dart';
import 'package:task_manager/presentation/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/presentation/widgets/screen_background.dart';

import '../../utils/snackbar.dart';
import 'email_verification_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  static const name = "/loginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final SignInController signInController = Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: const Color(0xffFAF8F6),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Get Started with',
                style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold),),
              _signInFormMethod(),
              _buildSignUpSection()
            ],
          ),
        ),),
    );
  }

  Widget _signInFormMethod() {
    return Form(
      key: _formKey,
      child: Column(children: [
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return "Enter a valid email";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                            color: Colors.grey
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return "Enter your password";
                      }
                      if(value!.length <8){
                        return "Enter a password more than 8 characters";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                            color: Colors.grey
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    child: GetBuilder<SignInController>(
                      builder: (controller) {
                        return Visibility(
                          visible: !controller.inProgress,
                          replacement: const CenterCircularProgressIndicator(),
                          child: ElevatedButton(
                              onPressed: _onTabNextButton,
                              child: const Icon(Icons.arrow_circle_right_outlined,
                                  color: Colors.white,
                                  size: 26,
                              )
                          ),
                        );
                      }
                    ),
                  ),
                ],),
    );
  }
  void _onTabNextButton(){
    if(!_formKey.currentState!.validate()){
      return;
    }
    _signIn();
  }

  Future<void> _signIn()async {
    final bool result = await signInController.signIn(
        _emailTEController.text.trim(),
        _passwordTEController.text,
    );
    if(result){
      Navigator.pushNamedAndRemoveUntil(context, MainBottomNavScreen.name, (predicate)=>false);
    }else{
      showSnackBarMessage(context, signInController.errorMessage!, true);
    }
  }

  Widget _buildSignUpSection() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40,),
          TextButton(
              onPressed: _onTabForgetPassword,
              child: const Text("Forget password?", style: TextStyle(
                  color: Color(0xff5F5F5F),
                  fontSize: 16
              ),)),
          RichText(text: TextSpan(
              text: "Don't have an account? ", style: const TextStyle(
              color: Color(0xff2E374F),
              fontSize: 16
          ),
              children: [
                TextSpan(
                    text: "Sign up",
                    style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
                  recognizer: TapGestureRecognizer()..onTap = _onTabSignUpScreen
                )
              ]
          ))
        ],),
    );
  }
  void _onTabForgetPassword(){
    Navigator.pushNamed(context, EmailVerificationScreen.name);
  }
  void _onTabSignUpScreen(){
    Navigator.pushNamed(context, SignUpScreen.name);
  }
}
