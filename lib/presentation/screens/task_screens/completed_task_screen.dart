import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controllers/completed_task_list_controller.dart';
import 'package:task_manager/presentation/widgets/center_circular_progress_indicator.dart';

import '../../utils/snackbar.dart';
import '../../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  CompletedTaskListController cTLController = Get.find<CompletedTaskListController>();
  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return  Expanded(
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
      child: GetBuilder<CompletedTaskListController>(
        builder: (controller) {
          return Visibility(
            visible: !controller.inProgress,
            replacement: const CenterCircularProgressIndicator(),
            child: ListView.separated(
                itemBuilder: (BuildContext context, index)=>TaskCard(
                  textTheme: textTheme,
                  taskList: controller.completedTaskList[index],
                  onRefreshList: () {
                    _getCompletedTaskList();
                  },),
                separatorBuilder: (BuildContext context, index)=>const SizedBox(height: 12,),
                itemCount: controller.completedTaskList.length
            ),
          );
        }
      ),
    ),
    );
  }
  Future<void>_getCompletedTaskList()async {
    final bool result = await cTLController.getCompletedTaskList();
    if(result==false){
      showSnackBarMessage(context, cTLController.errorMessage!, true);
    }
  }

}
