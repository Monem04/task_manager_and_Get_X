import 'package:get/get.dart';
import 'package:task_manager/data/models/task_model.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class CompletedTaskListController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage=> _errorMessage;

  List<TaskModel> _completedTaskList = [];
  List<TaskModel> get completedTaskList => _completedTaskList;

  Future<bool> getCompletedTaskList()async {
    _completedTaskList.clear();
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.completedTaskUrl);
    if(response.isSuccess){
      isSuccess = true;
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData!);
      _completedTaskList = taskListModel.taskList!;
    }else{
      _errorMessage = response.errorMessage;
    }
    _inProgress =false;
    update();
    return isSuccess;
  }
}