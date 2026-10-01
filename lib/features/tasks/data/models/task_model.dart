import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.userId,
    required super.title,
    super.description,
    super.status,
    super.priority,
    super.dueDate,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String?,
      status: data['status'] as String? ?? 'pending',
      priority: data['priority'] as String? ?? 'medium',
      dueDate: data['dueDate'] != null
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      description: entity.description,
      status: entity.status,
      priority: entity.priority,
      dueDate: entity.dueDate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
