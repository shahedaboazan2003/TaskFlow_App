import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class EditTaskPage extends StatefulWidget {
  final TaskEntity task;

  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime? _dueDate;
  late String _priority;
  static const int _maxTitleLength = 60;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');
    _dueDate = widget.task.dueDate;
    _priority = widget.task.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSave() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to update a task')),
      );
      return;
    }

    final updatedTask = widget.task.copyWith(
      title: title,
      description: description.isNotEmpty ? description : null,
      dueDate: _dueDate,
      priority: _priority,
      updatedAt: DateTime.now(),
    );

    context.read<TaskBloc>().add(UpdateTaskEvent(task: updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title field with character count
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title *',
                  hintText: 'What needs to be done?',
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLength: _maxTitleLength,
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                  return Text(
                    '$currentLength/$maxLength',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Description field
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Add details',
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),
              // Due date selector
              _DueDateSelector(
                dueDate: _dueDate,
                onDateSelected: (date) => setState(() => _dueDate = date),
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 24),
              // Priority selector
              _PrioritySelector(
                priority: _priority,
                onPriorityChanged: (p) => setState(() => _priority = p),
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 32),
              // Save button
              FilledButton.icon(
                onPressed: _onSave,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Save Task'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DueDateSelector extends StatelessWidget {
  final DateTime? dueDate;
  final ValueChanged<DateTime?> onDateSelected;
  final ColorScheme colorScheme;

  const _DueDateSelector({
    required this.dueDate,
    required this.onDateSelected,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due Date',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: dueDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              onDateSelected(date);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  dueDate != null
                      ? '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
                      : 'Select due date (optional)',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: dueDate != null
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                      ),
                ),
                if (dueDate != null) ...[
                  const Spacer(),
                  GestureDetector(
                    onTap: () => onDateSelected(null),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PrioritySelector extends StatelessWidget {
  final String priority;
  final ValueChanged<String> onPriorityChanged;
  final ColorScheme colorScheme;

  const _PrioritySelector({
    required this.priority,
    required this.onPriorityChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _PriorityChip(
              label: 'Low',
              value: 'low',
              groupValue: priority,
              onChanged: onPriorityChanged,
              color: colorScheme.secondary,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 8),
            _PriorityChip(
              label: 'Medium',
              value: 'medium',
              groupValue: priority,
              onChanged: onPriorityChanged,
              color: colorScheme.primary,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 8),
            _PriorityChip(
              label: 'High',
              value: 'high',
              groupValue: priority,
              onChanged: onPriorityChanged,
              color: colorScheme.error,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ],
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final Color color;
  final ColorScheme colorScheme;

  const _PriorityChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.color,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(26) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? color : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
