import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/widgets/center_circular_progress_indicator.dart';

import '../../controllers/progress_task_list_controller.dart';
import '../../utils/snackbar.dart';
import '../../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  ProgressTaskListController pTLController= Get.find<ProgressTaskListController>();
  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return  Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
        child: GetBuilder<ProgressTaskListController>(
            builder: (controller) {
              return Visibility(
                visible: !controller.inProgress,
                replacement: const CenterCircularProgressIndicator(),
                child: ListView.separated(
                    itemBuilder: (BuildContext context, index)=>TaskCard(
                      textTheme: textTheme,
                      taskList: controller.progressTaskList[index],
                      onRefreshList: () {
                        _getProgressTaskList();
                        },
                    ),
                    separatorBuilder: (BuildContext context, index)=>const SizedBox(height: 12,),
                    itemCount: controller.progressTaskList.length
                          ),
              );
        }
      ),
    ),
    );
  }
  Future<void>_getProgressTaskList()async {
    final bool result = await pTLController.getProgressTaskList();
    if(result==false){
      showSnackBarMessage(context, pTLController.errorMessage!, true);
    }
  }
}
