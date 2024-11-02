import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/views/add_task.dart';
import 'package:task_management_app/app/views/work_task.dart';
import 'package:task_management_app/app/widgets/task_card.dart';

class HomePage extends StatelessWidget {
  final TaskController taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      appBar: AppBar(
        title: const Text('Task Management', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        elevation: 2,
        backgroundColor: const Color.fromARGB(255, 139, 123, 150), 
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        // call filter function by keyword as parameter
                        taskController.filterTasksByKeyword(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Tasks',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.blueAccent.shade700),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    // observe change from value of seleceted status variable
                    child: Obx(() => DropdownButton<String>(
                          value: taskController.selectedStatus.value,
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text('All')),
                            DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                            DropdownMenuItem(value: 'On Progress', child: Text('On Progress')),
                            DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                          ],
                          onChanged: (value) {
                            taskController.filterTasksByStatus(value ?? 'All');
                          },
                          icon: Icon(Icons.filter_list, color: Colors.blueAccent.shade700),
                          style: const TextStyle(color: Colors.black),
                        )),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // show list based on filter result
            child: Obx(() {
              final filteredTasks = taskController.filteredTaskList;
              if (filteredTasks.isEmpty) {
                return Center(
                  child: Text(
                    'No tasks found',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TaskCard(
                      task: task,
                      onTap: () {
                        Get.to(() => WorkOnTaskPage(
                              taskLocation: LatLng(task.latitude, task.longitude),
                              task: task,
                            ));
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddTaskPage());
        },
        backgroundColor: const Color.fromARGB(255, 99, 89, 130),
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
