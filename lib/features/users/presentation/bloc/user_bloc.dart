import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_user_profile.dart';
import '../../domain/usecases/delete_user_profile.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfile _getUserProfile;
  final CreateUserProfile _createUserProfile;
  final UpdateUserProfile _updateUserProfile;
  final DeleteUserProfile _deleteUserProfile;

  UserBloc({
    required GetUserProfile getUserProfile,
    required CreateUserProfile createUserProfile,
    required UpdateUserProfile updateUserProfile,
    required DeleteUserProfile deleteUserProfile,
  })  : _getUserProfile = getUserProfile,
        _createUserProfile = createUserProfile,
        _updateUserProfile = updateUserProfile,
        _deleteUserProfile = deleteUserProfile,
        super(UserInitial()) {
    on<GetUserProfileEvent>(_onGetUserProfile);
    on<CreateUserProfileEvent>(_onCreateUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<DeleteUserProfileEvent>(_onDeleteUserProfile);
  }

  Future<void> _onGetUserProfile(
    GetUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await _getUserProfile(event.uid);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onCreateUserProfile(
    CreateUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await _createUserProfile(event.user);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await _updateUserProfile(event.user);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onDeleteUserProfile(
    DeleteUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await _deleteUserProfile(event.uid);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (_) => emit(UserProfileDeleted()),
    );
  }
}
