import 'package:get/get.dart';
import 'package:school_management_system/student/models/task/task_model.dart';
import 'package:school_management_system/student/resources/task/task_api.dart';

class TasksController extends GetxController {

  var taskServ   = taskServices();
  var tasks      = <TaskModel>[].obs;
  var isLoading  = true.obs;
  var file_name  = 'Add file'.obs;
  var task_name  = ''.obs;
  var task_id    = ''.obs;
  var taskresult;

  @override
  void onInit() {
    super.onInit();
    getTask();
  }

  Future<void> getTask() async {
    try {
      isLoading.value = true;
      tasks.value     = await taskServ.getTasks();
    } catch (e) {
      print('getTask error: $e');
      tasks.value = [];
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void updateFile(file) {
    if (file == null) return;
    taskresult        = file;
    file_name.value   = file.path.split('/').last;
    update();
  }

  Future<void> uploadTaskResult() async {
    if (taskresult == null) return;
    // TODO: file upload API se karna hai
    print('Upload: ${task_id.value}');
  }
}