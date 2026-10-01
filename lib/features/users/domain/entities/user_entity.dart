import 'package:equatable/equatable.dart';

/// User profile entity representing a document in the `users` collection.
class UserProfileEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final DateTime createdAt;

  const UserProfileEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  UserProfileEntity copyWith({
    String? uid,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return UserProfileEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [uid, name, email, createdAt];
}
