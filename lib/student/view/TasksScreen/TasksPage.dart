import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import '../../controllers/TasksController.dart';
import 'TasksCard.dart';

class TasksPage extends StatelessWidget {
  TasksPage({Key? key}) : super(key: key);

  final TasksController c = Get.put(TasksController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() {

          // Loading
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Empty
          if (c.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt,
                      size: 64, color: Colors.grey.shade300),
                  SizedBox(height: 16.h),
                  Text(
                    'No tasks right now!',
                    style: sfRegularStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Grid
          return RefreshIndicator(
            onRefresh: c.getTask,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: GridView.builder(
                itemCount: c.tasks.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.w,
                ),
                itemBuilder: (context, index) {
                  final task = c.tasks[index];
                  return Container(
                    decoration: BoxDecoration(
                      gradient: gradientColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TasksCard(
                      name:        task.name,
                      subjectName: task.subjectName,
                      uploadDate:  task.uploadDate,
                      deadline:    task.deadline,
                      task_id:     task.id,
                      url:         task.url,
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}