import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class AddNewTaskController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> addNewTask(String title, String description)async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    Map<String, dynamic> reqBody = {
      "title": title,
      "description": description,
      "status": "New"
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.createTaskUrl,
      body: reqBody,
    );
    if(response.isSuccess){
      isSuccess =true;
    }else{
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}