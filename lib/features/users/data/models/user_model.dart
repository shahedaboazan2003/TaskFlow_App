import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserProfileEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromEntity(UserProfileEntity entity) {
    return UserModel(
      uid: entity.uid,
      name: entity.name,
      email: entity.email,
      createdAt: entity.createdAt,
    );
  }

  factory UserModel.fromFirebaseAuth({
    required String uid,
    required String email,
    String name = '',
  }) {
    return UserModel(
      uid: uid,
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );
  }
}
