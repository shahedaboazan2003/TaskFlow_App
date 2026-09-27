import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_onboarding_status.dart';
import '../../domain/usecases/mark_onboarding_complete.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CheckOnboardingStatus checkOnboardingStatus;
  final MarkOnboardingComplete markOnboardingComplete;

  OnboardingBloc({
    required this.checkOnboardingStatus,
    required this.markOnboardingComplete,
  }) : super(OnboardingInitial()) {
    on<CheckOnboardingStatusEvent>(_onCheckStatus);
    on<CompleteOnboardingEvent>(_onComplete);
  }

  Future<void> _onCheckStatus(
    CheckOnboardingStatusEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    final result = await checkOnboardingStatus();
    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (isCompleted) {
        if (isCompleted) {
          emit(OnboardingCompleted());
        } else {
          emit(OnboardingIncomplete());
        }
      },
    );
  }

  Future<void> _onComplete(
    CompleteOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    final result = await markOnboardingComplete();
    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (_) => emit(OnboardingCompleted()),
    );
  }
}
