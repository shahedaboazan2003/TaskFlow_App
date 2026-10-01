import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class TaskDetailPage extends StatelessWidget {
  final TaskEntity task;

  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => context.push('/edit-task', extra: task),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pop();
          } else if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status row
              Row(
                children: [
                  _StatusChip(
                    completed: task.completed,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(width: 8),
                  _PriorityChip(
                    priority: task.priority,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.sync_rounded,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Synced',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                task.title,
                style: textTheme.headlineSmall?.copyWith(
                  color: task.completed
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              if (task.description != null && task.description!.isNotEmpty) ...[
                Text(
                  'Description',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.description!,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Due date
              if (task.dueDate != null) ...[
                _DetailRow(
                  icon: Icons.event_rounded,
                  label: 'Due Date & Time',
                  value: _formatDateTime(task.dueDate!),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 16),
              ],

              // Priority
              _DetailRow(
                icon: Icons.flag_rounded,
                label: 'Priority',
                value: task.priority[0].toUpperCase() + task.priority.substring(1),
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: 16),

              // Created
              _DetailRow(
                icon: Icons.person_outline_rounded,
                label: 'Created',
                value: _formatDate(task.createdAt),
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: 32),

              // Complete/Uncomplete button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    context.read<TaskBloc>().add(
                          ToggleTaskCompletionEvent(taskId: task.id),
                        );
                  },
                  icon: Icon(
                    task.completed
                        ? Icons.undo_rounded
                        : Icons.check_rounded,
                  ),
                  label: Text(
                    task.completed ? 'Mark as Incomplete' : 'Mark as Completed',
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Edit button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/edit-task', extra: task),
                  icon: const Icon(Icons.edit_note_rounded),
                  label: const Text('Edit Task'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, ${date.year} at $hour:$minute $period';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"? This action cannot be undone.'),
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

class _StatusChip extends StatelessWidget {
  final bool completed;
  final ColorScheme colorScheme;

  const _StatusChip({
    required this.completed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: completed
            ? colorScheme.secondaryContainer
            : colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            completed ? Icons.check_circle_rounded : Icons.schedule_rounded,
            size: 16,
            color: completed
                ? colorScheme.onSecondaryContainer
                : colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 6),
          Text(
            completed ? 'Completed' : 'Pending',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: completed
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String priority;
  final ColorScheme colorScheme;

  const _PriorityChip({
    required this.priority,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    switch (priority.toLowerCase()) {
      case 'high':
        chipColor = colorScheme.error;
        break;
      case 'low':
        chipColor = colorScheme.secondary;
        break;
      default:
        chipColor = colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withAlpha(26),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priority.toLowerCase() == 'high'
                ? Icons.priority_high_rounded
                : Icons.flag_rounded,
            size: 16,
            color: chipColor,
          ),
          const SizedBox(width: 6),
          Text(
            '${priority[0].toUpperCase()}${priority.substring(1)} Priority',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: chipColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
