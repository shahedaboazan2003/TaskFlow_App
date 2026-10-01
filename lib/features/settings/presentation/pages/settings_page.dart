import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../theme/presentation/bloc/theme_cubit.dart';

/// Settings screen — theme selection and app preferences.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance section
            Text(
              'Appearance',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Theme selector
            _ThemeSelector(colorScheme: colorScheme, textTheme: textTheme),

            const SizedBox(height: 24),

            // Notifications section
            Text(
              'Notifications',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            _SettingTile(
              icon: Icons.notifications_outlined,
              title: 'Push Notifications',
              subtitle: 'Receive reminders for upcoming tasks',
              colorScheme: colorScheme,
              textTheme: textTheme,
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Toggle notifications
                },
              ),
            ),

            const SizedBox(height: 24),

            // About section
            Text(
              'About',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            _SettingTile(
              icon: Icons.info_outline_rounded,
              title: 'App Version',
              subtitle: 'TaskFlow v1.0.0',
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),

            _SettingTile(
              icon: Icons.policy_outlined,
              title: 'Privacy Policy',
              subtitle: 'View our privacy policy',
              colorScheme: colorScheme,
              textTheme: textTheme,
              onTap: () {
                // Open privacy policy
              },
            ),

            _SettingTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'View terms of service',
              colorScheme: colorScheme,
              textTheme: textTheme,
              onTap: () {
                // Open terms of service
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Theme selector with three options: Light, Dark, System.
class _ThemeSelector extends StatelessWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ThemeSelector({
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, currentMode) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              _ThemeOption(
                icon: Icons.light_mode_outlined,
                label: 'Light',
                description: 'Always use light theme',
                isSelected: currentMode == ThemeMode.light,
                onTap: () => context.read<ThemeCubit>().setTheme(ThemeMode.light),
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const Divider(height: 24),
              _ThemeOption(
                icon: Icons.dark_mode_outlined,
                label: 'Dark',
                description: 'Always use dark theme',
                isSelected: currentMode == ThemeMode.dark,
                onTap: () => context.read<ThemeCubit>().setTheme(ThemeMode.dark),
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const Divider(height: 24),
              _ThemeOption(
                icon: Icons.brightness_auto_outlined,
                label: 'System',
                description: 'Follow system theme',
                isSelected: currentMode == ThemeMode.system,
                onTap: () => context.read<ThemeCubit>().setTheme(ThemeMode.system),
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSelected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_circle_rounded,
              color: colorScheme.primary,
              size: 24,
            ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorScheme,
    required this.textTheme,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withAlpha(76),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
