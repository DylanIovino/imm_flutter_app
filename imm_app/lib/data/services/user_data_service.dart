import 'package:flutter/foundation.dart';
import 'package:imm_app/data/models/data_with_id.dart';
import 'package:imm_app/data/repositories/firestore_repository.dart';
import 'package:imm_app/data/models/user.dart';

class UserDataService extends ChangeNotifier {

  final FirestoreRepository _firestoreRepository;

  UserDataService(this._firestoreRepository);

  /// creates a user and returns the user. Note: users should be created with an ID already
  Future<User?> createUser(User user) async {
    final newId = await _firestoreRepository.createWithId(User.collectionName, user.id,  user.toMap());

    if (newId == null) {
      debugPrint('UserDataService: Failed to create user');
      return null;
    }

    notifyListeners();
    return user;
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

  /// updates a user and returns the user on success
  /// Should take in a modified version of the current user with the ID desired to update
  Future<bool> updateUser(String id, {String? email, String? name, double? weightLbs, double? heightInches}) async {
    final updateMap = User.createUpdateMap(email: email, name: name, weightLbs: weightLbs, heightInches: heightInches);
    final success = await _firestoreRepository.update(User.collectionName, id, updateMap);

    if (!success) {
      debugPrint('UserDataService: Failed to update user');
      return false;
    }

    notifyListeners();
    return true;
  }

  Future<bool> deleteUser(String id) async {
    final success = await _firestoreRepository.delete(User.collectionName, id);

    if (!success) {
      debugPrint('UserDataService: Failed to delete user');
      return false;
    }

    notifyListeners();
    return success;
  }

}