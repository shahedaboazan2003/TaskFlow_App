import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<TaskEntity> tasks;

  const TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskOperationSuccess extends TaskState {
  final String message;
  final int operationId;

  const TaskOperationSuccess(
    this.message, {
    required this.operationId,
  });

  @override
  List<Object?> get props => [message, operationId];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
