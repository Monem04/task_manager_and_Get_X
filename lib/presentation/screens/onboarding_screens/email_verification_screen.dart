import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/recover_verify_email_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/snackbar.dart';
import '../../widgets/center_circular_progress_indicator.dart';
import '../../widgets/screen_background.dart';
import 'pin_verification_screen.dart';
import 'sign_in_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const String name = "/emailVerificationScreen";
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  TextEditingController _emailTEController = TextEditingController();
  RecoverVerifyEmailController rVEController = Get.find<RecoverVerifyEmailController>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ScreenBackground(
        child:
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Your email address",
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold),),
              Text('A 6 digit verification pi will send to your email address',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
              _emailVerificationForm(),
              _signInSectionMethod()
          ],
        ),
      ),),
    );
  }


  Column _emailVerificationForm() {
    return Column(
      children: [
        const SizedBox(height: 20,),
        Form(
          key: _formKey,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: "Email",
              hintStyle: TextStyle(
                  color: Colors.grey
              ),
            ),
            controller: _emailTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              if(value?.isEmpty?? true){
                return "Enter your email address";
              }return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(height: 20,),
        SizedBox(
                width: double.infinity,
                child: GetBuilder<RecoverVerifyEmailController>(
                  builder: (controller) {
                    return Visibility(
                      visible: !controller.inProgress,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: _getRecoverVerifyEmail,
                          child: const Icon(Icons.arrow_circle_right_outlined,
                              color: Colors.white,
                              size: 26)
                      ),
                    );
                  }
                ),
              ),
        const SizedBox(height: 60,),
      ],
    );
  }

  void _onTabNextButton(){
    String email = _emailTEController.text.trim();
    Navigator.pushNamedAndRemoveUntil(context, PinVerificationScreen.name, (predicate)=> false, arguments: {"email": email});
  }

  Future<void> _getRecoverVerifyEmail()async {
    final bool result = await rVEController.getRecoverVerifyEmail(_emailTEController.text.trim());
    if(result){
      showSnackBarMessage(context, "A pin has been sent");
      _onTabNextButton();
    }else{
      showSnackBarMessage(context, rVEController.errorMessage!);
    }
  }

  Widget _signInSectionMethod() {
    return Center(
      child: RichText(text:  TextSpan(
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
                recognizer: TapGestureRecognizer()..onTap = _onTapNextScreen
            )
          ]
      )),
    );
  }
  void _onTapNextScreen(){
    Navigator.pushNamed(context, LoginScreen.name);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
