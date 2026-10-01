import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: task.completed
            ? colorScheme.surfaceContainerLow
            : colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Completion checkbox
                _CompletionCheckbox(
                  completed: task.completed,
                  onToggle: onToggleComplete,
                  colorScheme: colorScheme,
                ),
                const SizedBox(width: 12),
                // Task content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: textTheme.bodyLarge?.copyWith(
                          color: task.completed
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : null,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (task.description != null && task.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _PriorityBadge(
                            priority: task.priority,
                            colorScheme: colorScheme,
                          ),
                          if (task.dueDate != null) ...[
                            const SizedBox(width: 8),
                            _DueDateBadge(
                              dueDate: task.dueDate!,
                              colorScheme: colorScheme,
                              textTheme: textTheme,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Drag handle + Delete button
                if (onDelete != null) ...[
                  Icon(
                    Icons.drag_indicator_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompletionCheckbox extends StatelessWidget {
  final bool completed;
  final VoidCallback? onToggle;
  final ColorScheme colorScheme;

  const _CompletionCheckbox({
    required this.completed,
    this.onToggle,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: completed ? colorScheme.primary : colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          border: completed
              ? null
              : Border.all(color: colorScheme.outline, width: 1.5),
        ),
        child: completed
            ? Icon(Icons.check_rounded, color: colorScheme.onPrimary, size: 16)
            : null,
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;
  final ColorScheme colorScheme;

  const _PriorityBadge({
    required this.priority,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    switch (priority.toLowerCase()) {
      case 'high':
        badgeColor = colorScheme.error;
        break;
      case 'low':
        badgeColor = colorScheme.secondary;
        break;
      default:
        badgeColor = colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(26),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        priority[0].toUpperCase() + priority.substring(1),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _DueDateBadge extends StatelessWidget {
  final DateTime dueDate;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _DueDateBadge({
    required this.dueDate,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isOverdue = dueDate.isBefore(now);
    final color = isOverdue ? colorScheme.error : colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            _formatDate(dueDate),
            style: textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    final diff = taskDate.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }
}
