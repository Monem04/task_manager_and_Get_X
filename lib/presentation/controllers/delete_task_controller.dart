import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class DeleteTaskController extends GetxController{
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> deleteTask(String ID)async {
    bool isSuccess = false;
    String id = ID;
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.deleteUrl+id);
    if(response.isSuccess){
      isSuccess = true;
    }else{
      _errorMessage= response.errorMessage;
    }
    update();
    return isSuccess;
  }
}