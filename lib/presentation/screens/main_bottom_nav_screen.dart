import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controllers/main_bottom_nav_contoller.dart';
import 'package:task_manager/presentation/screens/task_screens/cancelled_task_screen.dart';
import 'package:task_manager/presentation/screens/task_screens/completed_task_screen.dart';
import 'package:task_manager/presentation/screens/task_screens/progress_task_screen.dart';
import 'package:task_manager/presentation/utils/app_colors.dart';

import '../widgets/tm_app_bar_widget.dart';
import 'task_screens/new_task_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  static const String name = "/mainBottomNavScreen";
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {

  final MainBottomNavController mBNController = Get.find<MainBottomNavController>();

  final List<Widget> _screens = [
    const NewTaskScreen(),
    const CompletedTaskScreen(),
    const CancelledTaskScreen(),
    const ProgressTaskScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: Obx(()=>_screens[mBNController.selectedIndex.value]),
      bottomNavigationBar: Obx(()=> NavigationBar(
        indicatorColor: AppColors.primaryColor.withOpacity(0.7),
        selectedIndex: mBNController.selectedIndex.value,
        onDestinationSelected: (int index){
          mBNController.selectedIndex.value = index;
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.file_copy_outlined),
            label: "New Task",
            selectedIcon: Icon(Icons.file_copy_rounded, color: Colors.white,),
          ),
          NavigationDestination(icon: Icon(Icons.file_copy_outlined),
            label: "Completed",
            selectedIcon: Icon(Icons.file_copy_rounded, color: Colors.white,),
          ),
          NavigationDestination(icon: Icon(Icons.file_copy_outlined),
            label: "Cancelled",
            selectedIcon: Icon(Icons.file_copy_rounded, color: Colors.white,),),
          NavigationDestination(icon: Icon(Icons.file_copy_outlined),
            label: "Progress", selectedIcon:
            Icon(Icons.file_copy_rounded, color: Colors.white,),
          ),
        ],
      )),
    );
  }
}


