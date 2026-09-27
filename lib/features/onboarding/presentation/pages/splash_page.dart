import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _opacityAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    // Start entry animation then check onboarding status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
      context.read<OnboardingBloc>().add(CheckOnboardingStatusEvent());
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.go('/login');
        } else if (state is OnboardingIncomplete) {
          context.go('/onboarding');
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Stack(
            children: [
              // Ambient soft blobs
              _AmbientBlob(
                color: colorScheme.primaryContainer.withAlpha(90),
                top: -96,
                left: -96,
                size: 320,
              ),
              _AmbientBlob(
                color: colorScheme.secondaryContainer.withAlpha(100),
                top: null,
                left: null,
                right: -112,
                bottom: null,
                topFraction: 0.5,
                size: 288,
              ),
              _AmbientBlob(
                color: colorScheme.primaryContainer.withAlpha(76),
                top: null,
                left: null,
                bottom: -80,
                leftFraction: 0.25,
                size: 320,
              ),
              // Main content
              Column(
                children: [
                  const Spacer(),
                  // Brand cluster with entry animation
                  FadeTransition(
                    opacity: _opacityAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: _BrandCluster(colorScheme: colorScheme),
                    ),
                  ),
                  const Spacer(),
                  // Bottom: spinner + powered-by
                  FadeTransition(
                    opacity: _opacityAnim,
                    child: _BottomLoader(colorScheme: colorScheme),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _AmbientBlob extends StatelessWidget {
  final Color color;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? topFraction;
  final double? leftFraction;
  final double size;

  const _AmbientBlob({
    required this.color,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.topFraction,
    this.leftFraction,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final resolvedTop =
              topFraction != null ? constraints.maxHeight * topFraction! : top;
          final resolvedLeft = leftFraction != null
              ? constraints.maxWidth * leftFraction!
              : left;
          return Stack(
            children: [
              Positioned(
                top: resolvedTop,
                left: resolvedLeft,
                right: right,
                bottom: bottom,
                child: IgnorePointer(
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    // Blur approximation via nested containers with opacity
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BrandCluster extends StatelessWidget {
  final ColorScheme colorScheme;
  const _BrandCluster({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo container with glow
        _LogoContainer(colorScheme: colorScheme),
        const SizedBox(height: 24),
        // App title
        Text(
          'TaskFlow',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: 12),
        // Tagline pill
        _TaglinePill(colorScheme: colorScheme),
      ],
    );
  }
}

class _LogoContainer extends StatelessWidget {
  final ColorScheme colorScheme;
  const _LogoContainer({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow ring
        Container(
          width: 128 + 16,
          height: 128 + 16,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary.withAlpha(76),
                colorScheme.secondaryContainer.withAlpha(102),
              ],
            ),
            borderRadius: BorderRadius.circular(36),
          ),
        ),
        // Logo box
        Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withAlpha(40),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.task_alt_rounded,
              size: 56,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _TaglinePill extends StatelessWidget {
  final ColorScheme colorScheme;
  const _TaglinePill({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh.withAlpha(178),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
          Text(
            'Mindful productivity, simplified.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _BottomLoader extends StatelessWidget {
  final ColorScheme colorScheme;
  const _BottomLoader({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // M3-style circular indeterminate progress
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: colorScheme.primary,
            backgroundColor: colorScheme.surfaceContainerHighest,
            strokeCap: StrokeCap.round,
          ),
        ),
        const SizedBox(height: 16),
        // "Powered by" label
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bolt_rounded,
              size: 15,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'Powered by Firebase & Flutter',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withAlpha(204),
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
