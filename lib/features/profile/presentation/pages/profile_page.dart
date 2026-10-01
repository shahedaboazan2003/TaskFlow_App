import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../theme/presentation/bloc/theme_cubit.dart';

/// Profile page — shows user info, theme settings, and sign out.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = authState.user;
          final initials = user.email.isNotEmpty
              ? user.email[0].toUpperCase()
              : '?';

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header card
                _ProfileCard(
                  initials: initials,
                  email: user.email,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),

                // Appearance section
                _SectionLabel(
                  label: 'APPEARANCE',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 8),

                // Theme selector
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    return _ThemeSelector(
                      currentTheme: themeMode,
                      onThemeChanged: (mode) {
                        context.read<ThemeCubit>().setTheme(mode);
                      },
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Preferences & Security section
                _SectionLabel(
                  label: 'PREFERENCES & SECURITY',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 8),

                // Logout
                _LogoutTile(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onTap: () {
                    _showSignOutDialog(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String initials;
  final String email;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ProfileCard({
    required this.initials,
    required this.email,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with camera button
          Stack(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha(77),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.photo_camera_rounded,
                    size: 16,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            email,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          // Edit Profile + Pro badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Edit Profile button
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Edit Profile',
                      style: textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Pro badge
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Pro',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _SectionLabel({
    required this.label,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: textTheme.titleSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeMode currentTheme;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ThemeSelector({
    required this.currentTheme,
    required this.onThemeChanged,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row
          Row(
            children: [
              Icon(
                Icons.palette_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Theme Mode',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                _getThemeLabel(currentTheme),
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Segmented button
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              children: [
                _ThemeOption(
                  icon: Icons.devices_rounded,
                  title: 'System',
                  isSelected: currentTheme == ThemeMode.system,
                  onTap: () => onThemeChanged(ThemeMode.system),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _ThemeOption(
                  icon: Icons.light_mode_rounded,
                  title: 'Light',
                  isSelected: currentTheme == ThemeMode.light,
                  onTap: () => onThemeChanged(ThemeMode.light),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _ThemeOption(
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark',
                  isSelected: currentTheme == ThemeMode.dark,
                  onTap: () => onThemeChanged(ThemeMode.dark),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light Theme';
      case ThemeMode.dark:
        return 'Dark Theme';
      case ThemeMode.system:
        return 'System Theme';
    }
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.secondaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.shadow.withAlpha(26),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) ...[
                Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 6),
              ] else ...[
                Icon(
                  icon,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                title,
                style: textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback? onTap;

  const _LogoutTile({
    required this.colorScheme,
    required this.textTheme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 20,
                    color: colorScheme.error,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log Out',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                      Text(
                        'Sign out of this session',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onErrorContainer.withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.error,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
