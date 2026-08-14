import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/task_storage.dart';

class TaskProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];

  bool _isLoading = false;

  List<TaskModel> get tasks {
    return List.unmodifiable(_tasks);
  }

  bool get isLoading => _isLoading;


  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedTasks = TaskStorage.getTasks();

      _tasks
        ..clear()
        ..addAll(savedTasks);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  List<TaskModel> tasksForDate(
      DateTime date,
      ) {
    final result = _tasks.where((task) {
      return task.date.year == date.year &&
          task.date.month == date.month &&
          task.date.day == date.day;
    }).toList();

    result.sort(
          (a, b) => a.time.compareTo(b.time),
    );

    return result;
  }


  Future<void> addTask(
      TaskModel task,
      ) async {

    _tasks.add(task);
    notifyListeners();


    try {
      await TaskStorage.saveTask(task);
    } catch (e) {

      _tasks.removeWhere(
            (item) => item.id == task.id,
      );

      notifyListeners();

      rethrow;
    }
  }


  Future<void> updateTask(
      TaskModel task,
      ) async {
    final index = _tasks.indexWhere(
          (item) => item.id == task.id,
    );

    if (index == -1) {
      return;
    }

    final oldTask = _tasks[index];

    _tasks[index] = task;
    notifyListeners();


    try {
      await TaskStorage.updateTask(task);
    } catch (e) {

      _tasks[index] = oldTask;

      notifyListeners();

      rethrow;
    }
  }


  Future<void> deleteTask(
      String id,
      ) async {
    final index = _tasks.indexWhere(
          (task) => task.id == id,
    );

    if (index == -1) {
      return;
    }

    final deletedTask = _tasks[index];


    _tasks.removeAt(index);
    notifyListeners();

    try {
      await TaskStorage.deleteTask(id);
    } catch (e) {

      _tasks.insert(
        index,
        deletedTask,
      );

      notifyListeners();

      rethrow;
    }
  }


  Future<void> toggleTask(
      String id,
      ) async {
    final index = _tasks.indexWhere(
          (task) => task.id == id,
    );

    if (index == -1) {
      return;
    }

    final oldTask = _tasks[index];

    final updatedTask =
    oldTask.copyWith(
      isDone: !oldTask.isDone,
    );


    _tasks[index] = updatedTask;
    notifyListeners();


    try {
      await TaskStorage.updateTask(
        updatedTask,
      );
    } catch (e) {

      _tasks[index] = oldTask;

      notifyListeners();

      rethrow;
    }
  }
}