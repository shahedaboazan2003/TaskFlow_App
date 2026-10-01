import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../tasks/presentation/bloc/task_bloc.dart';
import '../../../tasks/presentation/bloc/task_event.dart';
import '../../../tasks/presentation/bloc/task_state.dart';

/// Task Flow page — shows task analytics and productivity insights.
class TaskFlowPage extends StatefulWidget {
  const TaskFlowPage({super.key});

  @override
  State<TaskFlowPage> createState() => _TaskFlowPageState();
}

class _TaskFlowPageState extends State<TaskFlowPage> {
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Flow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today_rounded),
            onPressed: () => _loadTasks(),
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
                final tasks = state.tasks;
                final completed = tasks.where((t) => t.completed).length;
                final pending = tasks.length - completed;
                final overdue = tasks.where((t) {
                  if (t.dueDate == null || t.completed) return false;
                  return t.dueDate!.isBefore(DateTime.now());
                }).length;
                final completionRate = tasks.isEmpty
                    ? 0.0
                    : completed / tasks.length;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Your Productivity',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Track your task flow and progress',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Stats cards row
                      Row(
                        children: [
                          _StatCard(
                            icon: Icons.check_circle_outline_rounded,
                            label: 'Completed',
                            value: '$completed',
                            color: colorScheme.secondary,
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                          ),
                          const SizedBox(width: 12),
                          _StatCard(
                            icon: Icons.pending_outlined,
                            label: 'Pending',
                            value: '$pending',
                            color: colorScheme.primary,
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _StatCard(
                            icon: Icons.warning_amber_outlined,
                            label: 'Overdue',
                            value: '$overdue',
                            color: colorScheme.error,
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                          ),
                          const SizedBox(width: 12),
                          _StatCard(
                            icon: Icons.format_list_numbered_rounded,
                            label: 'Total',
                            value: '${tasks.length}',
                            color: colorScheme.onSurfaceVariant,
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Completion rate
                      _CompletionRateCard(
                        rate: completionRate,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                      const SizedBox(height: 24),

                      // Recent tasks
                      Text(
                        'Recent Tasks',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (tasks.isEmpty)
                        _EmptyState(colorScheme: colorScheme)
                      else
                        ...tasks.take(5).map((task) {
                          return _RecentTaskTile(
                            title: task.title,
                            priority: task.priority,
                            completed: task.completed,
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            onTap: () =>
                                context.push('/task-detail', extra: task),
                          );
                        }),
                    ],
                  ),
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
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionRateCard extends StatelessWidget {
  final double rate;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _CompletionRateCard({
    required this.rate,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withAlpha(76),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Completion Rate',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(rate * 100).toInt()}%',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: rate,
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentTaskTile extends StatelessWidget {
  final String title;
  final String priority;
  final bool completed;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  const _RecentTaskTile({
    required this.title,
    required this.priority,
    required this.completed,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color priorityColor;
    switch (priority.toLowerCase()) {
      case 'high':
        priorityColor = colorScheme.error;
        break;
      case 'low':
        priorityColor = colorScheme.secondary;
        break;
      default:
        priorityColor = colorScheme.primary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(
                  completed
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: completed ? colorScheme.secondary : colorScheme.outline,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      decoration:
                          completed ? TextDecoration.lineThrough : null,
                      color: completed
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    priority[0].toUpperCase() + priority.substring(1),
                    style: textTheme.labelSmall?.copyWith(
                      color: priorityColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ColorScheme colorScheme;

  const _EmptyState({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insights_rounded,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No data yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create tasks to see your productivity insights',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
