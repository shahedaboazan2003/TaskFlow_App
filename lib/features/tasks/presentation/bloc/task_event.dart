import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class GetTasksEvent extends TaskEvent {
  final String userId;

  const GetTasksEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class CreateTaskEvent extends TaskEvent {
  final TaskEntity task;

  const CreateTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;

  const UpdateTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  const DeleteTaskEvent({required this.taskId});

  @override
  List<Object> get props => [taskId];
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final String taskId;

  const ToggleTaskCompletionEvent({required this.taskId});

  @override
  List<Object> get props => [taskId];
}

class ChangeTaskStatusEvent extends TaskEvent {
  final String taskId;
  final String status;

  const ChangeTaskStatusEvent({required this.taskId, required this.status});

  @override
  List<Object> get props => [taskId, status];
}

class GetTasksByDateEvent extends TaskEvent {
  final String userId;
  final DateTime date;

  const GetTasksByDateEvent({required this.userId, required this.date});

  @override
  List<Object> get props => [userId, date];
}

class GetTasksForMonthEvent extends TaskEvent {
  final String userId;
  final DateTime month;

  const GetTasksForMonthEvent({required this.userId, required this.month});

  @override
  List<Object> get props => [userId, month];
}
