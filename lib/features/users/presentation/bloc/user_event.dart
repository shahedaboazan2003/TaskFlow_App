import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserProfileEvent extends UserEvent {
  final String uid;

  const GetUserProfileEvent({required this.uid});

  @override
  List<Object> get props => [uid];
}

class CreateUserProfileEvent extends UserEvent {
  final UserProfileEntity user;

  const CreateUserProfileEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateUserProfileEvent extends UserEvent {
  final UserProfileEntity user;

  const UpdateUserProfileEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteUserProfileEvent extends UserEvent {
  final String uid;

  const DeleteUserProfileEvent({required this.uid});

  @override
  List<Object> get props => [uid];
}
