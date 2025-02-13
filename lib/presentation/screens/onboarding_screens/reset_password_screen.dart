import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/recover_reset_password_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/snackbar.dart';
import '../../widgets/center_circular_progress_indicator.dart';
import '../../widgets/screen_background.dart';
import 'sign_in_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const name = "/resetPasswordScreen";
  const ResetPasswordScreen({
    super.key,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController _passwordTEController = TextEditingController();
  TextEditingController _resetPTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RecoverResetPasswordController rRPController = Get.find<RecoverResetPasswordController>();

  String? email;
  String? oTP;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    email = args["email"]??"";
    oTP = args["OTP"]??"";
  }
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Set password",
                        style: textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold),),
                      Text('Password must be at least 8 characters long, containing both letters and numbers.',
                        style: textTheme.bodyLarge?.copyWith(color: Colors.grey),
                      ),
                      _resetPasswordFormMethod(),
                      _signInSection(),
                    ],
                  ),
          )),
    );
  }

  Widget _resetPasswordFormMethod() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20,),
          TextFormField(
            decoration: const InputDecoration(
                hintText: "New Password",
                hintStyle: TextStyle(
                    color: Colors.grey
                )
            ),
            controller: _passwordTEController,
            validator: (value)=>value!.length<8?"Password must be 8 characters long": null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: true,
          ),
          const SizedBox(height: 20,),
          TextFormField(
            validator: (value)=>value!=_passwordTEController.text?"Enter same password":null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: true,
            controller: _resetPTEController,
            decoration: const InputDecoration(
                hintText: "Confirm password",
                hintStyle: TextStyle(
                    color: Colors.grey
                )
            ),
          ),
          const SizedBox(height: 20,),
          SizedBox(
            width: double.infinity,
            child: GetBuilder<RecoverResetPasswordController>(
              builder: (controller) {
                return Visibility(
                  visible: !controller.inProgress,
                  replacement: const CenterCircularProgressIndicator(),
                  child: ElevatedButton(
                      onPressed: _onTapNavigateToNextScreen,
                      child: const Icon(Icons.arrow_circle_right_outlined,
                          color: Colors.white,
                          size: 26,
                      )
                  ),
                );
              }
            ),
          ),
          const SizedBox(height: 60,),
        ],
      ),
    );
  }

  void _onTapNavigateToNextScreen(){
    if(!_formKey.currentState!.validate()){
      return;
    }
    _getRecoverResetPassword();
  }

  Future<void> _getRecoverResetPassword()async {
    final bool result = await rRPController.getRecoverResetPassword(email!, oTP!, _passwordTEController.text);

    if(result){
      showSnackBarMessage(context, rRPController.successMessage!, false);
      _onTapLoginScreen();
    }else{
      showSnackBarMessage(context, rRPController.errorMessage!, true);
    }
  }
  void _onTapLoginScreen(){
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.name, (predicate)=>false);
  }

  Widget _signInSection() {
    return Center(
      child: RichText(text: TextSpan(
          text: "Have an account? ", style: const TextStyle(
          color: Color(0xff2E374F),
          fontSize: 16
      ),
          children: [
            TextSpan(
                text: "Sign in",
                style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
                recognizer: TapGestureRecognizer()..onTap = _onTapNavigateToSignInScreen
            )
          ]
      )),
    );
  }
  void _onTapNavigateToSignInScreen(){
    Navigator.pushNamed(context, LoginScreen.name);
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _resetPTEController.dispose();
    super.dispose();
  }
}
