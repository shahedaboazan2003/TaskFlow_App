import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
  });

  factory UserModel.fromFirebaseAuth(firebase_auth.User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
    );
  }
}
