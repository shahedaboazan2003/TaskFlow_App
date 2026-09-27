import 'package:flutter/material.dart';

/// Illustration for Onboarding 2 — "Stay on Track"
/// Matches the Stitch design: calendar card with mini grid, floating reminder
/// card and smart snooze pill.
class OnboardingIllustrationTwo extends StatelessWidget {
  const OnboardingIllustrationTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxWidth * (3.8 / 4),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Ambient aura behind
              Positioned(
                top: null,
                left: null,
                right: null,
                bottom: null,
                child: Container(
                  width: 256,
                  height: 256,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withAlpha(153),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Main calendar card
              Positioned(
                left: constraints.maxWidth * 0.04,
                right: constraints.maxWidth * 0.04,
                top: constraints.maxWidth * 0.04,
                bottom: constraints.maxWidth * 0.04,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha(25),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Calendar header
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    color: colorScheme.onPrimary,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'October',
                                      style: textTheme.labelLarge?.copyWith(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Focus Sprint',
                                      style: textTheme.labelSmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Mini calendar grid
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                        child: _MiniCalendarGrid(colorScheme: colorScheme),
                      ),
                      // Milestone pill
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: colorScheme.secondary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Client Strategy Sync',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Oct 14',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Floating reminder card (bottom-right)
              Positioned(
                bottom: 0,
                right: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh.withAlpha(242),
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
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.notifications_active_rounded,
                              color: colorScheme.onSecondaryContainer,
                              size: 20,
                            ),
                          ),
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: colorScheme.error,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.surfaceContainerHigh,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '10:00 AM Reminder',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            'Quarterly Roadmap',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Smart snooze pill (top-left)
              Positioned(
                top: 0,
                left: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha(25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Smart Snooze',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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

class _MiniCalendarGrid extends StatelessWidget {
  final ColorScheme colorScheme;
  const _MiniCalendarGrid({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final prevDays = ['28', '29', '30'];
    final days = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18'];
    const activeDay = '14';

    return Column(
      children: [
        // Day labels row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dayLabels
              .map((d) => SizedBox(
                    width: 24,
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 4),
        // Day grid
        Wrap(
          spacing: 2,
          runSpacing: 4,
          children: [
            ...prevDays.map((d) => _CalDay(
                  label: d,
                  colorScheme: colorScheme,
                  dimmed: true,
                )),
            ...days.map((d) => d == activeDay
                ? _CalDay(
                    label: d,
                    colorScheme: colorScheme,
                    isActive: true,
                  )
                : _CalDay(
                    label: d,
                    colorScheme: colorScheme,
                  )),
          ],
        ),
      ],
    );
  }
}

class _CalDay extends StatelessWidget {
  final String label;
  final ColorScheme colorScheme;
  final bool dimmed;
  final bool isActive;

  const _CalDay({
    required this.label,
    required this.colorScheme,
    this.dimmed = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Center(
        child: isActive
            ? Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: dimmed
                          ? colorScheme.onSurfaceVariant.withAlpha(102)
                          : colorScheme.onSurface,
                    ),
              ),
      ),
    );
  }
}
