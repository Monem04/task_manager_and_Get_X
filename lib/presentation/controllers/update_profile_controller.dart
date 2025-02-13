import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/network_response.dart';
import '../../data/models/user_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class UpdateProfileController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;
  set pickedImage(XFile? pickedImage)=> _pickedImage=pickedImage;

  Future<bool> postUpdateProfile(String email, String firstName, String lastName, String mobile, String password)async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    Map<String, dynamic> reqBody ={
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };
    if(password.isNotEmpty){
      reqBody["password"] = password;
    }
    if(_pickedImage != null){
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      String convertedImage = base64Encode(imageBytes);
      reqBody["photo"] = convertedImage;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.updateProfile,
      body: reqBody,
    );
    if(response.isSuccess){
      isSuccess = true;
      UserModel userModel = UserModel.fromJson(response.responseData);
      AuthController.saveUserData(userModel);
    }else{
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}