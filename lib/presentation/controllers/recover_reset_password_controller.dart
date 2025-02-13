import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class RecoverResetPasswordController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage=> _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  Future<bool> getRecoverResetPassword(String email, String OTP, String password)async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> reqBody = {
      "email": email,
      "OTP": OTP,
      "password": password,
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.resetPassword,
      body: reqBody,
    );
    if(response.isSuccess){
      isSuccess = true;
      _successMessage = "Login with your new password";
    }else{
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}