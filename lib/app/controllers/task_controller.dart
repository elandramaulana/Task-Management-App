import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/app/repositories/task_repo.dart';
import 'package:task_management_app/app/views/home_page.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  // Access database
  final TaskRepository taskRepository;

  // Observable variable
  var taskList = <Task>[].obs;
  var filteredTaskList = <Task>[].obs;
  var selectedStatus = 'All'.obs;

  TaskController({required this.taskRepository});

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
  }
  // prepare the database and load task from database
  Future<void> _initializeRepository() async {
    await taskRepository.initDB();
    loadTasks();
  }

  // funtion to load task list
  Future<void> loadTasks() async {
    taskList.value = await taskRepository.getTasks();
    applyFilters(); 
  }

  void filterTasksByKeyword(String keyword) {
    keyword = keyword.toLowerCase();
    applyFilters(keyword: keyword);
  }

  void filterTasksByStatus(String status) {
    selectedStatus.value = status;
    applyFilters();
  }

   // update task list based on search or filter
   void applyFilters({String keyword = ''}) {
    filteredTaskList.value = taskList.where((task) {
      final matchesKeyword = task.title.toLowerCase().contains(keyword);
      final matchesStatus = selectedStatus.value == 'All' || task.status == selectedStatus.value;
      return matchesKeyword && matchesStatus;
    }).toList();
  }


  //function to validate input in add task 
  bool validateTaskFields(String title, String description) {
    if (title.isEmpty) {
      Get.snackbar('Error', 'Title cannot be empty', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (description.isEmpty) {
      Get.snackbar('Error', 'Description cannot be empty', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }

  Future<void> addTask(String title, String description, double latitude, double longitude, {String status = 'Pending'}) async {
    // Check validation input
    if (!validateTaskFields(title, description)) return;

    Task newTask = Task(
      title: title,
      description: description,
      latitude: latitude,
      longitude: longitude,
      status: status,
    );
    
    await taskRepository.createTask(newTask);
    loadTasks();

    Get.snackbar('Success', 'Task added successfully', backgroundColor: Colors.green, colorText: Colors.white);
    Get.offAll(() => HomePage());
  }

  //function to update task status 
  Future<void> updateTask(Task task) async {
  await taskRepository.updateTask(task);
  loadTasks();

  // Show success snackbar
  Get.snackbar(
    'Success','Task updated successfully', backgroundColor: Colors.green, colorText: Colors.white,
  );
   Get.offAll(() => HomePage());
}


}
