import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

//this class is for database service

class TaskRepository {
  late Database db;

  TaskRepository() {
    initDB();
  }

// Create database and table 'task' with title,desc,latlang and status coulumn
  Future<void> initDB() async {
    try {
      db = await openDatabase(
        join(await getDatabasesPath(), 'task_database.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, latitude REAL, longitude REAL, status TEXT)",
          );
        },
        version: 1,
      );
    } catch (e) {
      print('Error initializing database: $e');
      throw Exception('Failed to initialize database');
    }
  }

// for add task request from controller
  Future<bool> createTask(Task task) async {
    try {
      await db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return true; 
    } catch (e) {
      print('Error adding task: $e');
      return false; 
    }
  }

// for load task list request from controller
  Future<List<Task>> getTasks() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query('tasks');
      return List.generate(maps.length, (i) {
        return Task.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error retrieving tasks: $e');
      return []; 
    }
  }

// for update task status request from controller
  Future<bool> updateTask(Task task) async {
    try {
      await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
      return true; 
    } catch (e) {
      print('Error updating task: $e');
      return false; 
    }
  }
}
