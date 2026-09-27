import 'package:flutter/material.dart';

/// Animated M3-style page indicator dots.
/// The active dot expands to a pill shape; inactive dots are small circles.
class OnboardingPageIndicator extends StatelessWidget {
  final int count;
  final int current;

  const OnboardingPageIndicator({
    super.key,
    required this.count,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}
