import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'auth_service.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime updatedAt;

  Task({required this.id, required this.title, required this.description, required this.updatedAt});
}

class TaskService extends ChangeNotifier {
  final StreamController<List<Task>> _controller = StreamController.broadcast();
  Stream<List<Task>> get tasksStream => _controller.stream;

  Timer? _pollTimer;

  TaskService() {
    // default: poll every 3 seconds
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => refreshTasks());
  }

  Future<List<Task>> fetchTasksForOwner(String ownerId) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('ownerId', ownerId)
      ..orderByDescending('updatedAt');

    final response = await query.query();
    final List<Task> tasks = [];
    if (response.success && response.results != null) {
      for (var r in response.results as List<ParseObject>) {
        tasks.add(Task(
          id: r.objectId!,
          title: (r.get<String>('title') ?? ''),
          description: (r.get<String>('description') ?? ''),
          updatedAt: r.updatedAt ?? DateTime.now(),
        ));
      }
    }
    return tasks;
  }

  Future<void> refreshTasks() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      _controller.add([]);
      return;
    }
    final tasks = await fetchTasksForOwner(currentUser.objectId!);
    _controller.add(tasks);
  }

  Future<ParseResponse> createTask(String ownerId, String title, String description) async {
    final parseObj = ParseObject('Task')
      ..set('title', title)
      ..set('description', description)
      ..set('ownerId', ownerId);
    final response = await parseObj.save();
    // refresh after change
    await refreshTasks();
    return response;
  }

  Future<ParseResponse> updateTask(String objectId, String title, String description) async {
    final parseObj = ParseObject('Task')..objectId = objectId;
    parseObj.set('title', title);
    parseObj.set('description', description);
    final response = await parseObj.save();
    await refreshTasks();
    return response;
  }

  Future<ParseResponse> deleteTask(String objectId) async {
    final parseObj = ParseObject('Task')..objectId = objectId;
    final response = await parseObj.delete();
    await refreshTasks();
    return response;
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _controller.close();
    super.dispose();
  }
}
