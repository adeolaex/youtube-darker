import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserAuthModel extends ChangeNotifier {
  String _plug;
  String _email;
  String _password;

  String get plug => _plug;
  String get email => _email;
  String get password => _password;

  set plug(String newPlug) {
    _plug = newPlug;
    notifyListeners();
  }

  set email(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  set password(String newpassword) {
    _password = newpassword;
    notifyListeners();
  }
}

class UserModel extends ChangeNotifier {
  User _user;

  // This is called to initialize the models
  UserModel() {
    FirebaseAuth.instance.authStateChanges().listen(
      (currentUser) {
        if (currentUser != null && currentUser.phoneNumber != null) {
          user = currentUser;
        }
      },
    );
  }

  User get user => _user;

  set user(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}
