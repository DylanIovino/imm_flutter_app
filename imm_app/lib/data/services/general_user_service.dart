import 'package:flutter/foundation.dart';

import 'package:imm_app/data/services/user_data_service.dart';

import 'package:imm_app/util/user_type.dart';
import 'package:imm_app/util/pair.dart';

import 'package:imm_app/data/models/user.dart';



class GeneralUserService {

  final UserDataService _userDataService;

  GeneralUserService({
    required UserDataService userDataService
  }) : _userDataService = userDataService;

  /// creates a user based on user type and returns the user and user type as a pair object
  Future<Pair<dynamic, UserType>> createUser(User user, UserType userType) async {
    if (userType == UserType.user) {
      final newUser = await _userDataService.createUser(user);
      if (newUser != null) {
        return Pair(newUser, UserType.user);
      }
    }

    return Pair(null, UserType.unauthenticated);
  }

  /// queries the user based on the user type and returns the user and user type as a pair object
  Future<Pair<dynamic, UserType>> _queryUserByType(UserType type, String uid) async {
    switch (type) {
      case UserType.user:
        final user = await _userDataService.getUser(uid);
        if (user != null) {
          return Pair(user, UserType.user);
        }
        break;
      default:
        return Pair(null, UserType.unauthenticated);
    }
    return Pair(null, UserType.unauthenticated);
  }

  // TODO: remove logging here, I am just being safe since this is still kind of new
  /// gets the user based on the uid and prioritizes the expected type when searching
  Future<Pair<dynamic, UserType>> getUser(String uid, {UserType? expectedType}) async {
    debugPrint("GeneralUserService: getUser() uid: $uid, expectedType: $expectedType");

    // if there is no expected type, run simultaneous queries
    if (expectedType == null || expectedType == UserType.unauthenticated) {
      debugPrint("GeneralUserService: getUser() running simultaneous queries");
      final results = await Future.wait([
        _userDataService.getUser(uid)
      ]);

      debugPrint("GeneralUserService: getUser() simultaneous queries results: $results");

      if (results[0] != null) {
        return Pair(results[0], UserType.user);
      }
    } 
    else { // else run the query for the expected type then any other types

      debugPrint("GeneralUserService: getUser() running query for expected type: $expectedType");
      final expectedResult = await _queryUserByType(expectedType, uid);
      if (expectedResult.first != null) {
        return expectedResult;
      }

      debugPrint("GeneralUserService: getUser() expected type not found, running query for other types");
      if (expectedType != UserType.user) {
        final parent = await _userDataService.getUser(uid);
        debugPrint("GeneralUserService: getUser() parent: $parent");
        if (parent != null) {
          return Pair(parent, UserType.user);
        }
      }
    }

    debugPrint("GeneralUserService: getUser() no user found");
    return Pair(null, UserType.unauthenticated); // if no user found return unauthenticated
  }

  
}