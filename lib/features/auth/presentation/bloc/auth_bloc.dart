import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_auth_state_stream.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;
  final ResetPassword _resetPassword;
  final GetAuthStateStream _getAuthStateStream;
  
  StreamSubscription<UserEntity?>? _authSubscription;

  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required SignOut signOut,
    required ResetPassword resetPassword,
    required GetAuthStateStream getAuthStateStream,
  })  : _signIn = signIn,
        _signUp = signUp,
        _signOut = signOut,
        _resetPassword = resetPassword,
        _getAuthStateStream = getAuthStateStream,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
    on<_AuthUserChanged>((event, emit) => emit(AuthAuthenticated(event.user)));
    on<_AuthUserUnauthenticated>((event, emit) => emit(AuthUnauthenticated()));
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) {
    _authSubscription?.cancel();
    _authSubscription = _getAuthStateStream().listen((user) {
      if (user != null) {
        add(_AuthUserChanged(user));
      } else {
        add(_AuthUserUnauthenticated());
      }
    });
    // Let the stream decide the state.
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signIn(event.email, event.password);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signUp(event.email, event.password);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signOut();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _resetPassword(event.email);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(const AuthSuccessMessage('Password reset email sent!')),
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}

// Internal events for stream listening
class _AuthUserChanged extends AuthEvent {
  final UserEntity user;
  const _AuthUserChanged(this.user);
  @override
  List<Object> get props => [user];
}

class _AuthUserUnauthenticated extends AuthEvent {}
