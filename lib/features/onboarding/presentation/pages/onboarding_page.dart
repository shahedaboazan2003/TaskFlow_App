import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_illustration_one.dart';
import '../widgets/onboarding_illustration_two.dart';
import '../widgets/onboarding_illustration_three.dart';
import '../widgets/onboarding_page_indicator.dart';

// ---------------------------------------------------------------------------
// Data model for each onboarding page
// ---------------------------------------------------------------------------

class _OnboardingPageData {
  final String stepLabel;
  final String title;
  final String description;
  final Widget illustration;

  const _OnboardingPageData({
    required this.stepLabel,
    required this.title,
    required this.description,
    required this.illustration,
  });
}

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      stepLabel: 'Step 1 • Getting Started',
      title: 'Organize Your Day',
      description:
          'Keep all your tasks in one place and stay organized throughout your day.',
      illustration: OnboardingIllustrationOne(),
    ),
    _OnboardingPageData(
      stepLabel: 'Step 2 of 3',
      title: 'Stay on Track',
      description:
          'Set due dates and reminders so you never miss an important task.',
      illustration: OnboardingIllustrationTwo(),
    ),
    _OnboardingPageData(
      stepLabel: 'Step 3 of 3',
      title: 'Get Things Done',
      description:
          'Manage your tasks, track your progress, and get more done every day.',
      illustration: OnboardingIllustrationThree(),
    ),
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;
  bool get _isFirstPage => _currentPage == 0;

  void _goToNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPrevious() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _skip() {
    context.read<OnboardingBloc>().add(CompleteOnboardingEvent());
  }

  void _finish() {
    context.read<OnboardingBloc>().add(CompleteOnboardingEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Header bar
              _OnboardingHeader(
                stepLabel: _pages[_currentPage].stepLabel,
                onSkip: _skip,
              ),
              // Swipeable page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _OnboardingPageContent(
                      data: _pages[index],
                    );
                  },
                ),
              ),
              // Bottom controls: indicator + buttons
              _OnboardingBottomControls(
                currentPage: _currentPage,
                pageCount: _pages.length,
                isFirstPage: _isFirstPage,
                isLastPage: _isLastPage,
                onBack: _goToPrevious,
                onNext: _goToNext,
                onFinish: _finish,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _OnboardingHeader extends StatelessWidget {
  final String stepLabel;
  final VoidCallback onSkip;

  const _OnboardingHeader({
    required this.stepLabel,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand + step label
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.task_alt_rounded,
                  color: colorScheme.onPrimary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'TaskFlow',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Skip button
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: const StadiumBorder(),
            ),
            child: Text(
              'Skip',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page content (illustration + text)
// ---------------------------------------------------------------------------

class _OnboardingPageContent extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPageContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          // Illustration
          data.illustration,
          const SizedBox(height: 24),
          // Step pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  data.stepLabel,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            data.title,
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.25,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            data.description,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom controls
// ---------------------------------------------------------------------------

class _OnboardingBottomControls extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final bool isFirstPage;
  final bool isLastPage;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const _OnboardingBottomControls({
    required this.currentPage,
    required this.pageCount,
    required this.isFirstPage,
    required this.isLastPage,
    required this.onBack,
    required this.onNext,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicator
          OnboardingPageIndicator(count: pageCount, current: currentPage),
          const SizedBox(height: 24),
          // Button row
          Row(
            children: [
              // Back button (hidden on first page)
              if (!isFirstPage) ...[
                _BackButton(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onPressed: onBack,
                ),
                const SizedBox(width: 12),
              ],
              // Next / Get Started button
              Expanded(
                child: isLastPage
                    ? _GetStartedButton(
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                        onPressed: onFinish,
                      )
                    : _NextButton(
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                        onPressed: onNext,
                        isFirst: isFirstPage,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onPressed;

  const _BackButton({
    required this.colorScheme,
    required this.textTheme,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.arrow_back_rounded,
            size: 18, color: colorScheme.onSurface),
        label: Text(
          'Back',
          style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide.none,
          backgroundColor: colorScheme.surfaceContainer,
          foregroundColor: colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onPressed;
  final bool isFirst;

  const _NextButton({
    required this.colorScheme,
    required this.textTheme,
    required this.onPressed,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const SizedBox.shrink(),
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Next',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_rounded,
                size: 18, color: colorScheme.onPrimary),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isFirst
              ? colorScheme.primaryContainer
              : colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          shadowColor: colorScheme.primary.withAlpha(51),
          shape: const StadiumBorder(),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onPressed;

  const _GetStartedButton({
    required this.colorScheme,
    required this.textTheme,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const SizedBox.shrink(),
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Get Started',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_rounded,
                size: 18, color: colorScheme.onPrimary),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 3,
          shadowColor: colorScheme.primary.withAlpha(76),
          shape: const StadiumBorder(),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
