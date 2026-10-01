import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../tasks/domain/entities/task_entity.dart';
import '../../../tasks/presentation/bloc/task_bloc.dart';
import '../../../tasks/presentation/bloc/task_event.dart';
import '../../../tasks/presentation/bloc/task_state.dart';
import '../../../tasks/presentation/widgets/task_card.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDate;
  late DateTime _focusedDate;
  List<TaskEntity> _monthTasks = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _focusedDate = DateTime(now.year, now.month);
    _loadTasksForMonth(_focusedDate);
  }

  void _loadTasksForMonth(DateTime date) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<TaskBloc>().add(GetTasksForMonthEvent(
            userId: authState.user.id,
            month: date,
          ));
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
      _focusedDate = DateTime(date.year, date.month);
    });
  }

  void _onTodaySelected() {
    final now = DateTime.now();
    _onDateSelected(now);
    _loadTasksForMonth(DateTime(now.year, now.month));
  }

  List<TaskEntity> _getTasksForSelectedDate() {
    return _monthTasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.year == _selectedDate.year &&
          task.dueDate!.month == _selectedDate.month &&
          task.dueDate!.day == _selectedDate.day;
    }).toList();
  }

  int _getTaskCountForDay(DateTime day) {
    return _monthTasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.year == day.year &&
          task.dueDate!.month == day.month &&
          task.dueDate!.day == day.day;
    }).length;
  }

  DateTime _getMondayOfWeek(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Stitch-style header
              _CalendarHeader(
                userEmail: authState.user.email,
              ),
              // Month navigation + weekly strip
              Expanded(
                child: BlocConsumer<TaskBloc, TaskState>(
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
                      _monthTasks = state.tasks;
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Month navigation
                          _CalendarMonthNav(
                            focusedDate: _focusedDate,
                            onTodaySelected: _onTodaySelected,
                          ),
                          // Weekly strip
                          _WeeklyStrip(
                            selectedDate: _selectedDate,
                            onDateSelected: _onDateSelected,
                            getTaskCountForDay: _getTaskCountForDay,
                            getMondayOfWeek: _getMondayOfWeek,
                          ),
                          // Selected date banner
                          _SelectedDateBanner(
                            selectedDate: _selectedDate,
                            taskCount: _getTasksForSelectedDate().length,
                          ),
                          // Task list
                          _TaskList(
                            tasks: _getTasksForSelectedDate(),
                            onToggleComplete: (task) {
                              context.read<TaskBloc>().add(
                                    ToggleTaskCompletionEvent(
                                      taskId: task.id,
                                    ),
                                  );
                            },
                            onDelete: (task) {
                              _showDeleteDialog(context, task);
                            },
                            onTap: (task) {
                              context.push('/task-detail', extra: task);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _AddTaskFab(
        onPressed: () => context.push('/add-task'),
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

class _CalendarHeader extends StatelessWidget {
  final String userEmail;

  const _CalendarHeader({
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      child: Row(
        children: [
          // Logo + Title
          Expanded(
            child: Row(
              children: [
                // Logo placeholder
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TaskFlow',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Calendar',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Search button
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              icon: Icon(
                Icons.search_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
            ),
          ),
          // Profile avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary.withAlpha(51),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                userEmail.isNotEmpty ? userEmail[0].toUpperCase() : 'U',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarMonthNav extends StatelessWidget {
  final DateTime focusedDate;
  final VoidCallback onTodaySelected;

  const _CalendarMonthNav({
    required this.focusedDate,
    required this.onTodaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Month pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatMonthYear(focusedDate),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.expand_more_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
          // Today + View mode buttons
          Row(
            children: [
              // Today button
              GestureDetector(
                onTap: onTodaySelected,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Today',
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // View mode button
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  icon: Icon(
                    Icons.calendar_view_month_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainer,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _WeeklyStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final int Function(DateTime) getTaskCountForDay;
  final DateTime Function(DateTime) getMondayOfWeek;

  const _WeeklyStrip({
    required this.selectedDate,
    required this.onDateSelected,
    required this.getTaskCountForDay,
    required this.getMondayOfWeek,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final monday = getMondayOfWeek(selectedDate);
    final weekDays = List.generate(7, (i) => monday.add(Duration(days: i)));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: weekDays.map((day) {
          final isSelected = day.year == selectedDate.year &&
              day.month == selectedDate.month &&
              day.day == selectedDate.day;
          final isToday = day.year == DateTime.now().year &&
              day.month == DateTime.now().month &&
              day.day == DateTime.now().day;
          final taskCount = getTaskCountForDay(day);

          return GestureDetector(
            onTap: () => onDateSelected(day),
            child: Container(
              constraints: BoxConstraints(
                minWidth: isSelected ? 48 : 42,
              ),
              padding: EdgeInsets.symmetric(
                vertical: isSelected ? 10 : 8,
                horizontal: 4,
              ),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getDayName(day),
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: (isSelected ? textTheme.titleMedium : textTheme.titleSmall)?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : isToday
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Task dots
                  SizedBox(
                    height: 4,
                    child: taskCount > 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              taskCount > 3 ? 3 : taskCount,
                              (i) => Container(
                                width: isSelected ? 6 : 4,
                                height: isSelected ? 6 : 4,
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? colorScheme.onSecondaryContainer
                                      : colorScheme.secondary,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}

class _SelectedDateBanner extends StatelessWidget {
  final DateTime selectedDate;
  final int taskCount;

  const _SelectedDateBanner({
    required this.selectedDate,
    required this.taskCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatSelectedDate(selectedDate),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$taskCount tasks scheduled',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatSelectedDate(DateTime date) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}

class _TaskList extends StatelessWidget {
  final List<TaskEntity> tasks;
  final ValueChanged<TaskEntity> onToggleComplete;
  final ValueChanged<TaskEntity> onDelete;
  final ValueChanged<TaskEntity> onTap;

  const _TaskList({
    required this.tasks,
    required this.onToggleComplete,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const _EmptyTasksForDate();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TaskCard(
            task: task,
            onTap: () => onTap(task),
            onToggleComplete: () => onToggleComplete(task),
            onDelete: () => onDelete(task),
          ),
        );
      },
    );
  }
}

class _EmptyTasksForDate extends StatelessWidget {
  const _EmptyTasksForDate();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 48,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks for this date',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add a task',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddTaskFab extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddTaskFab({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withAlpha(77),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              color: colorScheme.onPrimary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Add Task',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
