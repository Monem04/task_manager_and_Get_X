import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../controllers/recovery_verify_otp_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/snackbar.dart';
import '../../widgets/center_circular_progress_indicator.dart';
import '../../widgets/screen_background.dart';
import 'reset_password_screen.dart';
import 'sign_in_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  static const String name = "/pinVerificationScreen";
  const PinVerificationScreen({
    super.key,
  });

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  TextEditingController _pinTEController = TextEditingController();
  RecoveryVerifyOtpController rVOtpController = Get.find<RecoveryVerifyOtpController>();
  GlobalKey<FormState>_formKey = GlobalKey<FormState>();

  String? email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    email = args?["email"] ?? "";
  }

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
              Text("Pin verification",
                style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold),),
              Text('A 6 digit verification pi will send to your email address',
                style: textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 20,),
              Form(
                key: _formKey,
                child: PinCodeTextField(
                  controller: _pinTEController,
                  validator: (value)=> value!.length<5 ? "Enter your pin" : null,
                  length: 6,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    inactiveColor: Colors.transparent,

                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  appContext: context,
                ),
              ),
              _buildOnTapSubmissionMethod(),
              _signInSectionMethod()
            ],
          ),
        ),),
    );
  }

  Widget _buildOnTapSubmissionMethod() {
    return Column(children: [
              const SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                child: GetBuilder<RecoveryVerifyOtpController>(
                  builder: (controller) {
                    return Visibility(
                      visible: !controller.inProgress,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: _onTapNavigateToBNS,
                          child: const Text("Verify", style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600
                          ),
                          )
                      ),
                    );
                  }
                ),
              ),
              const SizedBox(height: 60,),
            ],);
  }

  void _onTapNavigateToBNS(){
    if(!_formKey.currentState!.validate()){
      return;
    }
      _getRecoverVerifyOTP();
  }

  Future<void> _getRecoverVerifyOTP()async {
    final bool result = await rVOtpController.getRecoverVerifyOTP(_pinTEController.text, email!);

    if(result){
      showSnackBarMessage(context, rVOtpController.successMessage!, false);
      Navigator.pushNamedAndRemoveUntil(context, ResetPasswordScreen.name, (predicate)=>false,
        arguments: {"email":email!, "OTP":_pinTEController.text,},
      );
    }else{
      showSnackBarMessage(context, rVOtpController.errorMessage ?? "Something went wrong, please try again.", true);
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
}
