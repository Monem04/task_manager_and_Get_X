import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/presentation/controllers/change_status_controller.dart';
import 'package:task_manager/presentation/controllers/delete_task_controller.dart';


import '../../data/models/task_model.dart';
import '../utils/snackbar.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.textTheme,
    required this.taskList,
    required this.onRefreshList,
  });

  final TextTheme textTheme;
  final TaskModel taskList;
  final VoidCallback onRefreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String _selectedStatus = '';

  DeleteTaskController deleteTController = Get.find<DeleteTaskController>();
  ChangeStatusController changeSController = Get.find<ChangeStatusController>();

  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.taskList.status!;
    formatingDateTime();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskList.title ?? "",
              style: widget.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),),
            const SizedBox(height: 8,),
            Text(widget.taskList.description ?? "",
              style: widget.textTheme.bodyLarge,),
            const SizedBox(height: 8,),
            Text("Date: $formattedDate"),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTaskStatusChip(),
                OverflowBar(children: [
                  IconButton(
                      onPressed: _onTapEditButton,
                      icon: const Icon(Icons.edit_note_outlined),
                  ),
                  IconButton(
                    onPressed: _onTapDeleteButton,
                      icon: const Icon(Icons.delete_rounded),
                  ),
                ],)
              ],
            )
          ],
        ),
      ),
    );
  }

  void formatingDateTime(){
    if(widget.taskList.createdDate!=null){
      DateTime? date = DateTime.tryParse(widget.taskList.createdDate!);
      if(date!=null){
        formattedDate = DateFormat("MM/dd/yyyy").format(date);
      }else{
        formattedDate = "Invalid Date";
      }
    }else{
      formattedDate = "No data provided";
    }
  }

  void _onTapEditButton(){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: const Text("Edit Status"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ["New", "Completed", "Canceled", "Progress"].map((e)=>ListTile(
          title: Text(e),
          onTap: (){
            _changeStatus(e);
            Navigator.pop(context);
          },
          selected: _selectedStatus ==e,
          trailing: _selectedStatus == e ? const Icon(Icons.check): null,
        )).toList(),
      ),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
      ],
    ));
  }

  Future<void> _changeStatus(String newStatus)async {
    final bool result = await changeSController.changeStatus(newStatus, widget.taskList.sId!);
    if(result){
      widget.onRefreshList();
      showSnackBarMessage(context, "Task status has updated", false);
    }else{
      showSnackBarMessage(context, changeSController.errorMessage!, true);
    }
  }

  void _onTapDeleteButton(){
    showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
      title: const Text("Do you want to delete?"),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text("No")),
        TextButton(
            onPressed: (){
              _deleteTask();
              Navigator.pop(context);
            },
            child: const Text("Yes")),
      ],
    ));
  }

  Future<void>_deleteTask()async {
    final bool result = await deleteTController.deleteTask(widget.taskList.sId ?? "");

    if(result){
      widget.onRefreshList();
      showSnackBarMessage(context, "Successfully deleted", false);
    }else{
      showSnackBarMessage(context, deleteTController.errorMessage!, true);
    }
  }

  Widget _buildTaskStatusChip() => Chip(label: Text(widget.taskList.status ?? ""),);
}