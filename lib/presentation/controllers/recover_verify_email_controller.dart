import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class RecoverVerifyEmailController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getRecoverVerifyEmail(String userEmail)async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    String email = userEmail;
    NetworkResponse response = await NetworkCaller.getRequest(url: Urls.verifyEmail(email));
    if(response.isSuccess){
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}