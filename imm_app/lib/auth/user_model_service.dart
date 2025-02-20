import 'package:flutter/material.dart';

import 'package:imm_app/auth/authentication_service.dart';

import 'package:imm_app/util/pair.dart';
import 'package:imm_app/util/user_type.dart';

import 'package:imm_app/data/models/user.dart';

import 'package:imm_app/data/services/user_data_service.dart';
import 'package:imm_app/data/services/general_user_service.dart';


class UserModelService extends ChangeNotifier {
  /// The type of user that is currently authenticated. !!!This should only be set if the corresponding object is not null!!!
  UserType _userType = UserType.unauthenticated;

  final UserDataService _userDataService;

  final GeneralUserService _generalUserService;

  final AuthenticationService _authenticationService;
  
  User? _user;

  bool _userChanged = false;

  UserModelService(
      {required UserDataService userDataService,
      required GeneralUserService generalUserService,
      required AuthenticationService authenticationService})
      : _userDataService = userDataService,
        _generalUserService = generalUserService,
        _authenticationService = authenticationService {
    _userDataService.addListener(() {
      _userChanged = true;
      notifyListeners();
    });
    _authenticationService.addListener(_synchronizeUser);
  }

  Future<void> _synchronizeUser() async {
    debugPrint("UserModelService: Synchronizing user");

    if (!_authenticationService.isAuthenticated) {
      _unathenticateUser();
      debugPrint("UserModelService: User unauthenticated");
      return;
    } else if (_userType == UserType.unauthenticated ||
              _getCurrentUserModelUid() != _authenticationService.uid ||
              _getCurrentModelEmail() != _authenticationService.userEmail ||
              _getCurrentUserModelName() != _authenticationService.userName)
    {
      // debugPrint all of these and their comparison: _getCurrentModelEmail() != _authenticationService.userEmail || _getCurrentUserModelName() != _authenticationService.userName
      debugPrint("UserModelService: ${_userType.name} user authenticated, but not synchronized");

      // fetchUserModel also sets the userType variable, so if that is set, we know the corresponding data isn't null
      await _fetchUserModel(_authenticationService.uid!);

      if (_userType == UserType.unauthenticated) {
        // debugPrint("UserModelService: Creating new user -> email: ${_authenticationService.userEmail} | uaserName: ${_authenticationService.userName}");

        Pair<dynamic, UserType> user = await _generalUserService.createUser(
          User(id: _authenticationService.uid!, email: _authenticationService.userEmail, name: _authenticationService.userName),
          UserType.user
        );

        debugPrint("UserModelService: user created -> ${user.first} | ${user.second}");

        if (user.second == UserType.user) {
          setUserUser(user.first);
          debugPrint("UserModelService: new User created");
        } else {
          debugPrint("Error: UserModelService: Failed to create user");
        }
      }

      else {
        switch (_userType) {
          case UserType.user: // becuase _userType is set to user, we know _user is not null
            if (_user!.id != _authenticationService.uid ||
                _user!.email != _authenticationService.userEmail ||
                _user!.name != _authenticationService.userName) {
  
              final success = await _userDataService.updateUser(
                    _authenticationService.uid!,
                    email: _authenticationService.userEmail,
                    name: _authenticationService.userName);

              if (success) {
                setUserUser(_user!.copyWith(email: _authenticationService.userEmail, name: _authenticationService.userName));
              } else {
                debugPrint("Error: Failed to update user in UserModelService");
                //TODO: handle this error
              }
            }
            break;
          default:
            break;
        }
      }
    }
  }

  void setUserUser(User user) {
    if (_user != user) {
      _user = user;
      _userType = UserType.user;
      notifyListeners();
    }
  }

  Future<void> _fetchUserModel(String uid, {bool notify = false}) async {
    Pair<dynamic, UserType> user =
        await _generalUserService.getUser(uid, expectedType: _userType);

    if (user.second == UserType.user) {
      setUserUser(user.first);
    } else {
      _unathenticateUser();
    }

    if (notify) {
      notifyListeners();
    }
  }

  dynamic _getCurrentUserModel() {
    switch (_userType) {
      case UserType.user:
        return _user;
      default:
        return null;
    }
  }

  String? _getCurrentModelEmail() {
    return _getCurrentUserModel()?.email;
  }

  String? _getCurrentUserModelName() {
    return _getCurrentUserModel()?.name;
  }

  String? _getCurrentUserModelUid() {
    return _getCurrentUserModel()?.id;
  }

  void _unathenticateUser() {
    _userType = UserType.unauthenticated;
    _user = null;
    notifyListeners();
  }

  // this should only be called when the userType is user and _user is set with a uid
  Future<void> _refreshUser() async {
    if (_userChanged) {
      final newUser = await _userDataService.getUser(_user!.id);
      if (newUser != null) { // TODO: this is one of the places where the specific error is needed. We need to know if there is no user or if there was a network failure or some other bug
        _user = newUser;
      } else {
        debugPrint("Error: Failed to refresh user in UserModelService");
      }
      _userChanged = false;
    }
  }

  UserType get userType => _userType;

  Future<User?> get user async {
    await _refreshUser();
    return _user;
  }
}
