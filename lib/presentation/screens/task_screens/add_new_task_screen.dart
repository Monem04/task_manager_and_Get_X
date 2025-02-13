import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controllers/add_new_task_controller.dart';
import 'package:task_manager/presentation/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/presentation/widgets/tm_app_bar_widget.dart';

import '../../utils/snackbar.dart';
import '../../widgets/screen_background.dart';

class AddNewTaskScreen extends StatefulWidget {
  static const name = "/addNewTaskScreen";
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  TextEditingController _subjectTEController = TextEditingController();
  TextEditingController _descriptionTEController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AddNewTaskController addNTController = Get.find<AddNewTaskController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result)async{
        if(didPop){
          return;
        }
        else{
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        appBar: const TMAppBar(),
        body: ScreenBackground(
          child:
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 56,),
                  Text("Add new task",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold),),
                  const SizedBox(height: 32,),
                 Form(
                   key: _formKey,
                     child: Column(
                       children: [
                         TextFormField(
                           decoration: const InputDecoration(
                             hintText: "Subject",
                   ),
                           controller: _subjectTEController,
                           validator: (String? value){
                             if(value?.isEmpty ?? true){
                               return "Enter a subject";
                             }return null;
                           },
                 ),
                         const SizedBox(height: 16,),
                         TextFormField(
                           controller: _descriptionTEController,
                           validator: (String? value){
                             if(value?.isEmpty ?? true){
                               return "Enter your description";
                             }return null;
                           },
                           maxLines: 5,
                           decoration: const InputDecoration(
                             hintText: "Description",
                     ),
                   ),
                         const SizedBox(height: 32,),
                       ],
                     ),
                 ),
                  GetBuilder<AddNewTaskController>(
                    builder: (controller) {
                      return Visibility(
                        visible: !controller.inProgress,
                        replacement: const CenterCircularProgressIndicator(),
                        child: ElevatedButton(
                            onPressed: (){
                              _onTabNextButton();
                            },
                            child: const Icon(Icons.arrow_circle_right_outlined, color: Colors.white,)),
                      );
                    }
                  )
                ],
              ),
            ),
          ),),
      ),
    );
  }

  void _onTabNextButton(){
    if(!_formKey.currentState!.validate()){
      return;
    }
    _addNewTask();
  }

  Future<void> _addNewTask()async {
    final bool result = await addNTController.addNewTask(_subjectTEController.text.trim(), _descriptionTEController.text.trim());
    if(result){
      clearForm();
      showSnackBarMessage(context, "New task added successfully");
    }else{
      showSnackBarMessage(context, addNTController.errorMessage!, true);
    }
  }

  void clearForm(){
    _descriptionTEController.clear();
    _subjectTEController.clear();
  }

  @override
  void dispose() {
    _subjectTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
