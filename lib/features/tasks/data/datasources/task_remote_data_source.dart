import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskRemoteDataSource {
  Stream<List<TaskModel>> getTasks(String userId);
  Stream<List<TaskModel>> getTasksByDate(String userId, DateTime date);
  Stream<List<TaskModel>> getTasksForMonth(String userId, DateTime month);
  Future<TaskModel> getTaskById(String taskId);
  Future<TaskModel> createTask(TaskEntity task);
  Future<TaskModel> updateTask(TaskEntity task);
  Future<void> deleteTask(String taskId);
  Future<TaskModel> toggleTaskCompletion(String taskId);
  Future<TaskModel> changeTaskStatus(String taskId, String status);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSourceImpl(this.firestore);

  /// Top-level tasks collection — each document contains a `userId` field
  /// for user isolation. All queries filter by `userId`.
  CollectionReference get _tasksCollection => firestore.collection('tasks');

  @override
  Stream<List<TaskModel>> getTasks(String userId) {
    return _tasksCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Stream<List<TaskModel>> getTasksByDate(String userId, DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    return _tasksCollection
        .where('userId', isEqualTo: userId)
        .where('dueDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('dueDate', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Stream<List<TaskModel>> getTasksForMonth(String userId, DateTime month) {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);

    return _tasksCollection
        .where('userId', isEqualTo: userId)
        .where('dueDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('dueDate', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Future<TaskModel> getTaskById(String taskId) async {
    final doc = await _tasksCollection.doc(taskId).get();
    if (!doc.exists) {
      throw Exception('Task not found');
    }
    return TaskModel.fromFirestore(doc);
  }

  @override
  Future<TaskModel> createTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    final docRef = await _tasksCollection.add(taskModel.toFirestore());
    final createdDoc = await docRef.get();
    return TaskModel.fromFirestore(createdDoc);
  }

  @override
  Future<TaskModel> updateTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    await _tasksCollection.doc(taskModel.id).update(taskModel.toFirestore());
    return taskModel;
  }

  @override
  Future<TaskModel> toggleTaskCompletion(String taskId) async {
    final task = await getTaskById(taskId);
    final newStatus = task.completed ? 'pending' : 'completed';
    final updatedTask = TaskModel.fromEntity(task.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    ));
    await _tasksCollection.doc(taskId).update(updatedTask.toFirestore());
    return updatedTask;
  }

  @override
  Future<TaskModel> changeTaskStatus(String taskId, String status) async {
    final task = await getTaskById(taskId);
    final updatedTask = TaskModel.fromEntity(task.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    ));
    await _tasksCollection.doc(taskId).update(updatedTask.toFirestore());
    return updatedTask;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }
}
