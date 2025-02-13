import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class RecoveryVerifyOtpController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage=>_successMessage;

  Future<bool> getRecoverVerifyOTP(String oTP, String userEmail)async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    String otp = oTP;
    String email = userEmail;
    NetworkResponse response = await NetworkCaller.getRequest(url: Urls.verifyOTP(email, otp));
    if(response.isSuccess){
      isSuccess = true;
      _successMessage = "Set your password";
    }else{
      _errorMessage= response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}