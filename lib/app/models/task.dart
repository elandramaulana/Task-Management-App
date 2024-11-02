// task model
class Task {
  int? id;
  String title;
  String description;
  double latitude;
  double longitude;
  String status;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

// structure for send data
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }

// structure for fetch data
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      status: map['status'],
    );
  }
}
