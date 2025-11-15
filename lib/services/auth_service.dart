// import 'package:flutter/material.dart';
// import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// class AuthService extends ChangeNotifier {
//   ParseUser? _user;
//   bool get isLoggedIn => _user != null;

//   String? get userId => _user?.objectId;
//   String? get username => _user?.username;

//   Future<bool> tryRestoreSession() async {
//     final current = await ParseUser.currentUser() as ParseUser?;
//     if (current != null && current.sessionToken != null) {
//       _user = current;
//       notifyListeners();
//       return true;
//     }
//     return false;
//   }

//   Future<ParseResponse> register(String username, String email, String password) async {
//     final user = ParseUser(username, password, email);
//     final response = await user.signUp();
//     if (response.success && response.result != null) {
//       _user = response.result as ParseUser;
//       notifyListeners();
//     }
//     return response;
//   }

//   Future<ParseResponse> login(String usernameOrEmail, String password) async {
//     final user = ParseUser(usernameOrEmail, password, null);
//     final response = await user.login();
//     if (response.success && response.result != null) {
//       _user = response.result as ParseUser;
//       notifyListeners();
//     }
//     return response;
//   }

//   Future<void> logout() async {
//     if (_user != null) {
//       await _user!.logout();
//     } else {
//       final current = await ParseUser.currentUser();
//       if (current != null) {
//         await current.logout(deleteLocalUserData: true);
//       }
//     }
//     _user = null;
//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthService extends ChangeNotifier {
  ParseUser? _user;

  bool get isLoggedIn => _user != null;
  String? get userId => _user?.objectId;
  String? get username => _user?.username;

  /// Restore user session using Back4App's local persistence
  Future<bool> tryRestoreSession() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user?.sessionToken != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// User Registration (Sign-up)
  Future<ParseResponse> register(String username, String email, String password) async {
    final user = ParseUser(username, password, email);
    final response = await user.signUp();

    if (response.success && response.results != null) {
      _user = response.results!.first as ParseUser;
      notifyListeners();
    }

    return response;
  }

  /// Login using email or username
  Future<ParseResponse> login(String usernameOrEmail, String password) async {
    final user = ParseUser(usernameOrEmail, password, null);
    final response = await user.login();

    if (response.success && response.result != null) {
      _user = response.result as ParseUser;
      notifyListeners();
    }

    return response;
  }

  /// Logout user and clear session
  Future<void> logout() async {
    final current = await ParseUser.currentUser();

    if (current != null) {
      await current.logout(deleteLocalUserData: true);
    }

    _user = null;
    notifyListeners();
  }
}