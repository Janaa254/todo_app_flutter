import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/task_model.dart';

class TaskStorage {
  static const String boxName = 'tasks';


  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<String>(boxName);
    }
  }


  static Box<String> get _box {
    return Hive.box<String>(boxName);
  }



  static List<TaskModel> getTasks() {
    return _box.values.map((value) {
      final map =
      jsonDecode(value) as Map<String, dynamic>;

      return TaskModel.fromMap(map);
    }).toList();
  }


  static Future<void> saveTask(
      TaskModel task,
      ) async {
    await _box.put(
      task.id,
      jsonEncode(task.toMap()),
    );
  }


  static Future<void> deleteTask(
      String id,
      ) async {
    await _box.delete(id);
  }


  static Future<void> updateTask(
      TaskModel task,
      ) async {
    await _box.put(
      task.id,
      jsonEncode(task.toMap()),
    );
  }
}