import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuthInstance;
  User? _user;

  AuthenticationService(this._firebaseAuthInstance) {
    _firebaseAuthInstance.userChanges().listen((User? user) {
      debugPrint("AuthenticationService: User change detected");

      if ((_user == null && user != null) ||
          (_user != null && user == null) || 
          _user?.uid != user?.uid ||
          _user?.displayName != user?.displayName || 
          _user?.email != user?.email || 
          _user?.photoURL != user?.photoURL) {
        _user = user;
        // TODO: this is for debugging only and I think it needs to be removed before production
        debugPrint('AuthenticationService: User update -> name:${_user?.displayName ?? 'No name'} email: ${_user?.email ?? 'No email'}');
        notifyListeners(); // Only notify listeners if relevant fields have changed
      }
      else {
        _user = user;
      }
    });
  }

  User? get user => _user;

  String? get uid => _user?.uid;
  String? get userName => _user?.displayName;
  String? get userEmail => _user?.email;

  bool get isAuthenticated => _user != null;
}