import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/change_task_status.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/get_tasks_by_date.dart';
import '../../domain/usecases/get_tasks_for_month.dart';
import '../../domain/usecases/toggle_task_completion.dart';
import '../../domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks _getTasks;
  final GetTasksByDate _getTasksByDate;
  final GetTasksForMonth _getTasksForMonth;
  final CreateTask _createTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;
  final ToggleTaskCompletion _toggleTaskCompletion;
  final ChangeTaskStatus _changeTaskStatus;

  StreamSubscription? _tasksSubscription;

  TaskBloc({
    required GetTasks getTasks,
    required GetTasksByDate getTasksByDate,
    required GetTasksForMonth getTasksForMonth,
    required CreateTask createTask,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
    required ToggleTaskCompletion toggleTaskCompletion,
    required ChangeTaskStatus changeTaskStatus,
  })  : _getTasks = getTasks,
        _getTasksByDate = getTasksByDate,
        _getTasksForMonth = getTasksForMonth,
        _createTask = createTask,
        _updateTask = updateTask,
        _deleteTask = deleteTask,
        _toggleTaskCompletion = toggleTaskCompletion,
        _changeTaskStatus = changeTaskStatus,
        super(TaskInitial()) {
    on<GetTasksEvent>(_onGetTasks);
    on<GetTasksByDateEvent>(_onGetTasksByDate);
    on<GetTasksForMonthEvent>(_onGetTasksForMonth);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<ChangeTaskStatusEvent>(_onChangeTaskStatus);
  }

  void _onGetTasks(GetTasksEvent event, Emitter<TaskState> emit) {
    _tasksSubscription?.cancel();
    _tasksSubscription = _getTasks(event.userId).listen(
      (result) {
        result.fold(
          (failure) => emit(TaskError(failure.message)),
          (tasks) => emit(TasksLoaded(tasks)),
        );
      },
      onError: (error) {
        emit(const TaskError('Failed to load tasks. Please try again.'));
      },
    );
  }

  void _onGetTasksByDate(GetTasksByDateEvent event, Emitter<TaskState> emit) {
    _tasksSubscription?.cancel();
    _tasksSubscription = _getTasksByDate(event.userId, event.date).listen(
      (result) {
        result.fold(
          (failure) => emit(TaskError(failure.message)),
          (tasks) => emit(TasksLoaded(tasks)),
        );
      },
      onError: (error) {
        emit(const TaskError('Failed to load tasks. Please try again.'));
      },
    );
  }

  void _onGetTasksForMonth(GetTasksForMonthEvent event, Emitter<TaskState> emit) {
    _tasksSubscription?.cancel();
    _tasksSubscription = _getTasksForMonth(event.userId, event.month).listen(
      (result) {
        result.fold(
          (failure) => emit(TaskError(failure.message)),
          (tasks) => emit(TasksLoaded(tasks)),
        );
      },
      onError: (error) {
        emit(const TaskError('Failed to load tasks. Please try again.'));
      },
    );
  }

  Future<void> _onCreateTask(CreateTaskEvent event, Emitter<TaskState> emit) async {
    final result = await _createTask(event.task);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (task) => emit(TaskOperationSuccess(
        'Task created successfully',
        operationId: DateTime.now().microsecondsSinceEpoch,
      )),
    );
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    final result = await _updateTask(event.task);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (task) => emit(TaskOperationSuccess(
        'Task updated successfully',
        operationId: DateTime.now().microsecondsSinceEpoch,
      )),
    );
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    final result = await _deleteTask(event.taskId);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => emit(TaskOperationSuccess(
        'Task deleted successfully',
        operationId: DateTime.now().microsecondsSinceEpoch,
      )),
    );
  }

  Future<void> _onToggleTaskCompletion(
      ToggleTaskCompletionEvent event, Emitter<TaskState> emit) async {
    final result = await _toggleTaskCompletion(event.taskId);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => emit(TaskOperationSuccess(
        'Task status updated',
        operationId: DateTime.now().microsecondsSinceEpoch,
      )),
    );
  }

  Future<void> _onChangeTaskStatus(
      ChangeTaskStatusEvent event, Emitter<TaskState> emit) async {
    final result = await _changeTaskStatus(event.taskId, event.status);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => emit(TaskOperationSuccess(
        'Task status updated',
        operationId: DateTime.now().microsecondsSinceEpoch,
      )),
    );
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
