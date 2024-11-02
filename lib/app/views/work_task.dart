import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/helpers/map_helpers.dart';
import 'package:task_management_app/app/models/task.dart';

class WorkOnTaskPage extends StatelessWidget {
  final LatLng taskLocation;
  final Task task;

  WorkOnTaskPage({
    super.key,
    required this.taskLocation,
    required this.task,
  });

  final TaskController taskController = Get.find<TaskController>();
  final userLocation = Rx<LatLng?>(null); // observe value of variable


  Future<void> _getUserLocation() async {
    userLocation.value = await getCurrentLocation(); // get user location with geolocator
  }

  @override
  Widget build(BuildContext context) {
    // fetch user location
    _getUserLocation();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Work on Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showUpdateTaskDialog(context, task),
          ),
        ],
      ),
      body: Obx(() {
        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(
              (taskLocation.latitude + task.latitude) / 2,
              (taskLocation.longitude + task.longitude) / 2,
            ),
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: tileLayerUrl,
              subdomains: const ['a', 'b', 'c'],
            ),
            if (userLocation.value != null)
              MarkerLayer(
                markers: [
                  createMarker(userLocation.value!, Colors.green, 30, Icons.person_pin_circle),
                  createMarker(LatLng(task.latitude, task.longitude), Colors.red, 30, Icons.location_on),
                ],
              ),
            PolylineLayer(
              polylines: [
                createPolyline(
                  [
                    if (userLocation.value != null) userLocation.value!,
                    taskLocation,
                    LatLng(task.latitude, task.longitude),
                  ],
                  Colors.blueAccent,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }


  void _showUpdateTaskDialog(BuildContext context, Task task) {
    final TextEditingController titleController = TextEditingController(text: task.title);
    final TextEditingController descriptionController = TextEditingController(text: task.description);

    
    String selectedStatus = task.status;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Task Description'),
              ),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: const [
                  DropdownMenuItem(
                    value: 'Pending',
                    child: Text('Pending'),
                  ),
                  DropdownMenuItem(
                    value: 'On Progress',
                    child: Text('On Progress'),
                  ),
                  DropdownMenuItem(
                    value: 'Completed',
                    child: Text('Completed'),
                  ),
                ],
                onChanged: (value) {
                  selectedStatus = value ?? 'Pending';
                },
                decoration: const InputDecoration(labelText: 'Task Status'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // Menggunakan GetX untuk navigasi kembali
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedTask = Task(
                  id: task.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  latitude: task.latitude,
                  longitude: task.longitude,
                  status: selectedStatus,
                );

                // Call function update task from task controller
                taskController.updateTask(updatedTask);
                Get.back(); //redirect to homepage
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
