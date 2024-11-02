import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:task_management_app/app/bindings/task_binding.dart';
import 'package:task_management_app/app/views/home_page.dart';

void main() async {
  // check permission for location access and etc
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.checkPermission();
  runApp( const MyApp());
  TaskBinding().dependencies();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: TaskBinding(), 
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

