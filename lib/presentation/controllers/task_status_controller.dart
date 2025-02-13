import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/summery_count_model.dart';
import '../../data/models/task_summery_data_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class TaskStatusController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage=> _errorMessage;

  List<SummeryData> _summeryList = [];
  List<SummeryData> get summeryList => _summeryList;

  Future<bool> getTaskStatus()async {
    _summeryList.clear();
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.taskStatusUrl);
    if(response.isSuccess){
      isSuccess = true;
      final SummeryCountModel summeryCountModel = SummeryCountModel.fromJson(response.responseData!);
      _summeryList = summeryCountModel.summeryList ?? [];
    }else{
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}