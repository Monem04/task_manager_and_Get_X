import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/presentation/controllers/auth_controller.dart';
import 'package:task_manager/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/presentation/screens/onboarding_screens/sign_in_screen.dart';
import 'package:task_manager/presentation/utils/assets.dart';

import '../widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  static const String name = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void>_navigateToNextScreen()async {
   await Future.delayed(const Duration(seconds: 2));
   await AuthController.getAccessToken();
   if(AuthController.isLoggedIn()){
     await AuthController.getUserData();
     Navigator.pushReplacementNamed(context, MainBottomNavScreen.name);
   }else{
     Navigator.pushReplacementNamed(context, LoginScreen.name);
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
        child: SvgPicture.asset(AssetsPath.logoImagePath, alignment: Alignment.center,),
      ),),
    );
  }
}


