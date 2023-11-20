// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'package:flutter/foundation.dart';
import 'package:instagram/firebase_services/auth.dart';
import 'package:instagram/models/userData.dart';

class UserProvider with ChangeNotifier {
  UserData? _userData;
  UserData? get getUser => _userData;
  final context;
  UserProvider({required this.context});
  refreshUser() async {
    UserData userData = await AuthClass(context: context).getUserDetails();
    _userData = userData;
    notifyListeners();
  }
}
