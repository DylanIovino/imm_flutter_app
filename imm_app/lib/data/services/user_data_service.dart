import 'package:flutter/foundation.dart';
import 'package:imm_app/data/repositories/firestore_repository.dart';
import 'package:imm_app/data/models/user.dart';

class UserDataService {

  final FirestoreRepository _firestoreRepository;

  UserDataService(this._firestoreRepository);

  Future<User?> createUser(User user) async {
    final id = await _firestoreRepository.create(User.collectionName, user.toMap());

    if (id == null) {
      debugPrint('UserDataService: Failed to create user');
      return null;
    }

    return user.copyWith(id: id);
  }

  Future<User?> getUser(String id) async {
    final userMap = await _firestoreRepository.read(User.collectionName, id);

    if (userMap == null) {
      debugPrint('UserDataService: Failed to get user');
      return null;
    }

    return User.fromDataWithId(userMap);
  }

  Future<List<User>?> getUserByEmail(String email) async {
    final userList = await _firestoreRepository.queryByField(User.collectionName, 'email', email, limit: 1);

    if (userList == null) {
      debugPrint('UserDataService: Failed to get user');
      return null;
    }

    return userList.map((dataWithId) => User.fromDataWithId(dataWithId)).toList();
  }

  Future<User?> updateUserById(User currentUser, {double? height_inches, double? weight_lbs}) async {
    if (currentUser.id == null) {
      debugPrint('UserDataService: Failed to update user');
      return null;
    }

    final user = currentUser.copyWith(
      heightInches: height_inches,
      weightLbs: weight_lbs,
    );

    final success = await _firestoreRepository.update(User.collectionName, user.id!, user.toMap());

    if (!success) {
      debugPrint('UserDataService: Failed to update user');
      return null;
    }

    return user;
  }

  Future<User?> updateUserByEmail(User user) async {
    if (user.id == null) {
      debugPrint('UserDataService: Failed to update user');
      return null;
    }

    final success = await _firestoreRepository.update(User.collectionName, user.id!, user.toMap());

    if (!success) {
      debugPrint('UserDataService: Failed to update user');
      return null;
    }

    return user;
  }

  Future<bool> deleteUser(String id) async {
    return _firestoreRepository.delete(User.collectionName, id);
  }

}