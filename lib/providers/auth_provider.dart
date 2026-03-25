import 'package:flutter/foundation.dart';

import '../models/app_user.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login({
    required String username,
    required String password,
    required List<AppUser> users,
  }) async {
    _isLoading = true;
    notifyListeners();

    final AppUser? user = users
        .where((AppUser entry) {
          return entry.username == username &&
              entry.password == password &&
              entry.isActive;
        })
        .cast<AppUser?>()
        .firstWhere((AppUser? element) => element != null, orElse: () => null);

    _currentUser = user;
    _isLoading = false;
    notifyListeners();

    return user != null;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
