import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedFilter = 0; // 0=All, 1=Today, 2=Upcoming, 3=Completed

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  void _loadTasks() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<TaskBloc>().add(GetTasksEvent(userId: authState.user.id));
    }
  }

  List<TaskEntity> _filterTasks(List<TaskEntity> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (_selectedFilter) {
      case 1: // Today
        return tasks.where((t) {
          if (t.dueDate == null) return false;
          final d = t.dueDate!;
          return d.year == today.year && d.month == today.month && d.day == today.day;
        }).toList();
      case 2: // Upcoming
        return tasks.where((t) {
          if (t.dueDate == null) return false;
          return t.dueDate!.isAfter(today);
        }).toList();
      case 3: // Completed
        return tasks.where((t) => t.completed).toList();
      default: // All
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'TaskFlow',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                'Tasks',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          return BlocConsumer<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is TaskLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TasksLoaded) {
                final filteredTasks = _filterTasks(state.tasks);
                final todayTasks = state.tasks.where((t) {
                  if (t.dueDate == null) return false;
                  final now = DateTime.now();
                  final d = t.dueDate!;
                  return d.year == now.year && d.month == now.month && d.day == now.day;
                }).toList();
                final completedTasks = state.tasks.where((t) => t.completed).toList();

                return Column(
                  children: [
                    // Greeting section
                    _GreetingSection(
                      taskCount: todayTasks.length,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    // Filter tabs
                    _FilterTabs(
                      selectedIndex: _selectedFilter,
                      taskCounts: [
                        state.tasks.length,
                        todayTasks.length,
                        state.tasks.where((t) {
                          if (t.dueDate == null) return false;
                          final now = DateTime.now();
                          return t.dueDate!.isAfter(DateTime(now.year, now.month, now.day));
                        }).length,
                        completedTasks.length,
                      ],
                      onTabSelected: (index) => setState(() => _selectedFilter = index),
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    // Task list
                    Expanded(
                      child: filteredTasks.isEmpty
                          ? _EmptyTasksList(colorScheme: colorScheme)
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                              itemCount: filteredTasks.length,
                              itemBuilder: (context, index) {
                                final task = filteredTasks[index];
                                return TaskCard(
                                  task: task,
                                  onTap: () => context.push('/task-detail', extra: task),
                                  onToggleComplete: () {
                                    context.read<TaskBloc>().add(
                                          ToggleTaskCompletionEvent(
                                            taskId: task.id,
                                          ),
                                        );
                                  },
                                  onDelete: () {
                                    _showDeleteDialog(context, task);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              }

              if (state is TaskError) {
                return _ErrorState(
                  message: state.message,
                  onRetry: _loadTasks,
                  colorScheme: colorScheme,
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-task'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task'),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, TaskEntity task) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<TaskBloc>().add(
                    DeleteTaskEvent(taskId: task.id),
                  );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  final int taskCount;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _GreetingSection({
    required this.taskCount,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wb_sunny_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Good morning, Alex',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'You have $taskCount tasks scheduled for today',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final int selectedIndex;
  final List<int> taskCounts;
  final ValueChanged<int> onTabSelected;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _FilterTabs({
    required this.selectedIndex,
    required this.taskCounts,
    required this.onTabSelected,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['All', 'Today', 'Upcoming', 'Completed'];

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primaryContainer
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        '${tabs[index]} (${taskCounts[index]})',
                        style: textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyTasksList extends StatelessWidget {
  final ColorScheme colorScheme;

  const _EmptyTasksList({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rtl_rounded,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks scheduled',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your task list is clear! Take a break or organize upcoming priorities for the week.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final ColorScheme colorScheme;

  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
