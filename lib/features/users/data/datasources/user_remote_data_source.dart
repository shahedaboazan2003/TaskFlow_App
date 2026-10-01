import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserProfile(String uid);
  Future<UserModel> createUserProfile(UserProfileEntity user);
  Future<UserModel> updateUserProfile(UserProfileEntity user);
  Future<void> deleteUserProfile(String uid);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl(this.firestore);

  CollectionReference get _usersCollection => firestore.collection('users');

  @override
  Future<UserModel> getUserProfile(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) {
      throw Exception('User not found');
    }
    return UserModel.fromFirestore(doc);
  }

  @override
  Future<UserModel> createUserProfile(UserProfileEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _usersCollection.doc(user.uid).set(userModel.toFirestore());
    return userModel;
  }

  @override
  Future<UserModel> updateUserProfile(UserProfileEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _usersCollection.doc(user.uid).update(userModel.toFirestore());
    return userModel;
  }

  @override
  Future<void> deleteUserProfile(String uid) async {
    await _usersCollection.doc(uid).delete();
  }
}
