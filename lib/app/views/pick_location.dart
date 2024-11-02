import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:task_management_app/app/helpers/map_helpers.dart';

class PickLocationPage extends StatefulWidget {
  final LatLng initialLocation;

  const PickLocationPage({
    super.key,
    required this.initialLocation,
  });

  @override
  _PickLocationPageState createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  // Observe variable
  var userLocation = LatLng(0, 0).obs;
  var selectedLocation = LatLng(0, 0).obs;
  var isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    userLocation.value = (await getCurrentLocation()) ?? widget.initialLocation;
    // set task location = device location
    selectedLocation.value = userLocation.value;
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: userLocation.value,
                  initialZoom: 13.0,
                  onTap: (tapPosition, point) {
                    // Update task location = latlag selected point value 
                    selectedLocation.value = point;
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: tileLayerUrl,
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      createMarker(userLocation.value, Colors.blue, 40, Icons.person_pin_circle),
                      createMarker(selectedLocation.value, Colors.red, 40, Icons.location_on),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                 Get.back(result: selectedLocation.value);
              },
              child: const Text('Select Location'),
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }
}
