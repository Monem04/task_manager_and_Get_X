import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controllers/new_task_list_controller.dart';
import 'package:task_manager/presentation/controllers/task_status_controller.dart';
import 'package:task_manager/presentation/widgets/center_circular_progress_indicator.dart';

import '../../utils/snackbar.dart';
import '../../widgets/task_card.dart';
import '../../widgets/task_summery_widget.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  final NewTaskListController newTLController = Get.find<NewTaskListController>();
  final TaskStatusController tSController = Get.find<TaskStatusController>();

  @override
  void initState() {
    super.initState();
    _getNewTaskList();
    _getTaskStatus();
  }
  
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async {
          _getNewTaskList();
          _getTaskStatus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
          child: Column(
            children: [
              _buildTaskSummeryMethod(),
              const SizedBox(height: 24,),
              Expanded(
                child: GetBuilder<NewTaskListController>(
                builder: (controller) {
                  return Visibility(
                    visible: !controller.inProgress,
                    replacement: const CenterCircularProgressIndicator(),
                    child: ListView.separated(
                        itemBuilder: (BuildContext context, index)=>TaskCard(
                          textTheme: textTheme,
                          taskList: controller.taskList[index],
                          onRefreshList: () {
                            _getNewTaskList();
                            _getTaskStatus();
                        },
                        ),
                        separatorBuilder: (BuildContext context, index)=>const SizedBox(height: 12,),
                        itemCount: controller.taskList.length
                    ),
                  );
                }
              ),)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewTaskScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<void> _navigateToNewTaskScreen() async {
    final bool? shouldRefresh = await
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddNewTaskScreen()));

    if(shouldRefresh==true){
      _getNewTaskList();
    }
  }

  Future<void>_getNewTaskList()async {
    final bool result = await newTLController.getNewTaskList();
    if(result==false){
      showSnackBarMessage(context, newTLController.errorMessage!, true);
    }
  }

  Widget _buildTaskSummeryMethod() {
    return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: GetBuilder<NewTaskListController>(
              builder: (controller) {
                return Visibility(
                    visible: !controller.inProgress,
                    replacement: const CenterCircularProgressIndicator(),
                    child: Row(
                      children: _getTaskSummeryWidget(),
                    )
                );
              }
            ),
          );
  }

  List<TaskSummeryContainer>_getTaskSummeryWidget(){
    return tSController.summeryList.map((t)=>TaskSummeryContainer(title: t.sId!, count: t.sum ?? 0)).toList();
  }

  Future<void>_getTaskStatus()async {
    final bool result = await tSController.getTaskStatus();
    if(result==false){
      showSnackBarMessage(context, tSController.errorMessage!, true);
    }
  }

}




