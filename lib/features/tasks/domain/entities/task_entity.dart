import 'package:equatable/equatable.dart';

/// Task entity representing a document in the top-level `tasks` collection.
///
/// Each task contains the [userId] of its owner for user isolation.
/// The [status] field tracks the task lifecycle: 'pending', 'in_progress', 'completed'.
class TaskEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskEntity({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.status = 'pending',
    this.priority = 'medium',
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Whether the task is completed (derived from status).
  bool get completed => status == 'completed';

  TaskEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        status,
        priority,
        dueDate,
        createdAt,
        updatedAt,
      ];
}
