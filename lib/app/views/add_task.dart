import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:task_management_app/app/views/pick_location.dart';
import '../controllers/task_controller.dart';

class AddTaskPage extends StatelessWidget {
  final TaskController taskController = Get.find<TaskController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final Rx<LatLng> selectedLocation = const LatLng(-7.250445, 112.768845).obs; //iniital location value

  AddTaskPage({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Text(
              'Fill in the details below to create a new task.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Task Title',
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.title, color: Colors.black),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.description, color: Colors.black),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                 Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        // observe LatLang for change value and rebuild the widget with new data
                        child: Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.black),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Location: ${selectedLocation.value.latitude.toStringAsFixed(5)}, ${selectedLocation.value.longitude.toStringAsFixed(5)}',
                                    style: TextStyle(color: Colors.grey[700]),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8), 
                      IconButton(
                       onPressed: () async {
                            // Pick New Location
                            final LatLng? result = await Get.to<LatLng?>(
                              () => PickLocationPage(initialLocation: selectedLocation.value),
                            );

                            // Update selected location if a new location was chosen
                            if (result != null) {
                              selectedLocation.value = result;
                            }
                          },

                        icon: const Icon(Icons.map, color: Colors.blueAccent),
                        tooltip: 'Pick Location', 
                      ),
                    ],
                  ),

                ],
              ),
            ),
            const SizedBox(height: 24),
          Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              elevation: 5,
            ),
            onPressed: () {
              // save task to database
              taskController.addTask(
                titleController.text,
                descriptionController.text,
                selectedLocation.value.latitude,
                selectedLocation.value.longitude,
              );
            },
            child: const Text(
              'Add Task',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        )
          ],
        ),
      ),
    );
  }
}
