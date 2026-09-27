import 'package:flutter/material.dart';

/// Illustration for Onboarding 1 — "Organize Your Day"
/// Matches the Stitch design: task card with completed/in-progress items,
/// floating achievement badge, and tilted accent card backdrop.
class OnboardingIllustrationOne extends StatelessWidget {
  const OnboardingIllustrationOne({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxWidth * (4.2 / 4),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Ambient blur backdrop
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                bottom: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withAlpha(153),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              // Tilted accent backdrop card
              Positioned(
                left: constraints.maxWidth * 0.07,
                right: constraints.maxWidth * 0.07,
                top: constraints.maxWidth * 0.14,
                bottom: constraints.maxWidth * 0.14,
                child: Transform.rotate(
                  angle: -0.10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withAlpha(178),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 64,
                              height: 12,
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withAlpha(76),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today_rounded,
                              color: colorScheme.secondary,
                              size: 20,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity * 0.75,
                              height: 10,
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withAlpha(51),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 10,
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withAlpha(51),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Main focal card
              Positioned(
                left: constraints.maxWidth * 0.04,
                right: constraints.maxWidth * 0.04,
                top: constraints.maxWidth * 0.04,
                bottom: constraints.maxWidth * 0.04,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha(20),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.today_rounded,
                                  color: colorScheme.onPrimaryContainer,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Today's Focus",
                                    style: textTheme.labelLarge?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '3 of 5 completed',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          _ActiveBadge(colorScheme: colorScheme),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Completed task 1
                      _TaskRow(
                        label: 'Team sprint sync & review',
                        time: '9:30 AM',
                        isDone: true,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                      const SizedBox(height: 6),
                      // Completed task 2
                      _TaskRow(
                        label: 'Finalize Q3 design roadmap',
                        time: 'Design',
                        isDone: true,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                      const SizedBox(height: 6),
                      // In-progress task
                      _TaskRow(
                        label: 'Refactor user flows',
                        time: 'Due in 45m',
                        isDone: false,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                    ],
                  ),
                ),
              ),
              // Floating achievement pill (bottom-right)
              Positioned(
                bottom: 0,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha(30),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          color: colorScheme.onPrimary,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Flow State On',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Zero clutter day',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Floating done_all bubble (top-left)
              Positioned(
                top: 0,
                left: 0,
                child: Transform.rotate(
                  angle: -0.21,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withAlpha(40),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.done_all_rounded,
                      color: colorScheme.onSecondary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  final ColorScheme colorScheme;
  const _ActiveBadge({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt_rounded, size: 12, color: colorScheme.onSecondaryContainer),
          const SizedBox(width: 2),
          Text(
            'Active',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final String label;
  final String time;
  final bool isDone;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _TaskRow({
    required this.label,
    required this.time,
    required this.isDone,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDone
            ? colorScheme.surfaceContainerLow
            : colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isDone ? colorScheme.primary : colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: isDone
                ? Icon(Icons.check_rounded, color: colorScheme.onPrimary, size: 16)
                : Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: isDone
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurface,
                decoration: isDone ? TextDecoration.lineThrough : null,
                fontWeight: isDone ? FontWeight.w400 : FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isDone
                  ? colorScheme.secondaryContainer.withAlpha(128)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              time,
              style: textTheme.labelSmall?.copyWith(
                color: isDone ? colorScheme.secondary : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
