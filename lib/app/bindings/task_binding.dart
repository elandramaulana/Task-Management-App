import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/repositories/task_repo.dart';

// This class is for binding for TaskController and TaskRepository
class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskRepository>(() => TaskRepository());
    Get.lazyPut<TaskController>(() => TaskController(taskRepository: Get.find<TaskRepository>()));
  }
}
