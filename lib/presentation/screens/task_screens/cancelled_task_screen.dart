import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controllers/cancelled_task_list_controller.dart';
import 'package:task_manager/presentation/widgets/center_circular_progress_indicator.dart';

import '../../utils/snackbar.dart';
import '../../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  CancelledTaskListController cTLController = Get.find<CancelledTaskListController>();
  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return  Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
        child: GetBuilder<CancelledTaskListController>(
          builder: (controller) {
            return Visibility(
              visible: !controller.inProgress,
              replacement: const CenterCircularProgressIndicator(),
              child: ListView.separated(
                itemBuilder: (BuildContext context, index)=>TaskCard(
                  textTheme: textTheme,
                  taskList: controller.cancelledTaskList[index],
                  onRefreshList: () {
                    _getCancelledTaskList();
                  },),
                separatorBuilder: (BuildContext context, index)=>const SizedBox(height: 12,),
                itemCount: controller.cancelledTaskList.length
                    ),
            );
          }
        ),
    ),
    );
  }
  Future<void>_getCancelledTaskList()async {
   final bool result = await cTLController.getCancelledTaskList();
    if(result==false){
      showSnackBarMessage(context, cTLController.errorMessage!, true);
    }
  }
}
