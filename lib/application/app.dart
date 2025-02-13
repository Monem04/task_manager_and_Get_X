import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/screens/onboarding_screens/email_verification_screen.dart';
import 'package:task_manager/presentation/screens/onboarding_screens/pin_verification_screen.dart';
import 'package:task_manager/presentation/screens/onboarding_screens/sign_in_screen.dart';
import 'package:task_manager/presentation/screens/onboarding_screens/sign_up_screen.dart';
import 'package:task_manager/presentation/screens/task_screens/add_new_task_screen.dart';
import 'package:task_manager/presentation/utils/app_colors.dart';

import '../presentation/screens/main_bottom_nav_screen.dart';
import '../presentation/screens/onboarding_screens/reset_password_screen.dart';
import '../presentation/screens/splash_screen.dart';
import 'controller_binder.dart';

class TaskManager extends StatelessWidget {
  const TaskManager({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBinder(),
      initialRoute: "/",
      routes: {
        SplashScreen.name : (context)=> const SplashScreen(),
        MainBottomNavScreen.name : (context)=> const MainBottomNavScreen(),
        LoginScreen.name : (context)=> const LoginScreen(),
        SignUpScreen.name : (context)=> const SignUpScreen(),
        PinVerificationScreen.name : (context)=> const PinVerificationScreen(),
        ResetPasswordScreen.name : (context)=> const ResetPasswordScreen(),
        AddNewTaskScreen.name : (context)=> const AddNewTaskScreen(),
        EmailVerificationScreen.name : (context)=> const EmailVerificationScreen(),
      },

      theme: ThemeData(
        colorSchemeSeed: AppColors.primaryColor,
        textTheme: const TextTheme(),
        inputDecorationTheme: buildInputDecorationTheme(),
        elevatedButtonTheme: buildElevatedButtonThemeData()
      )
    );
  }

  ElevatedButtonThemeData buildElevatedButtonThemeData() {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          fixedSize: const Size.fromWidth(double.maxFinite),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 45)
        )
      );
  }

  InputDecorationTheme buildInputDecorationTheme() {
    return InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none
        ),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none
        ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none
        ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none
        ),
      );
  }
}
