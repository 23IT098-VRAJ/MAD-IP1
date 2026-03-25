import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import 'app_data_provider.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get errorMessage => _errorMessage;

  Future<bool> login({
    required String username,
    required String password,
    required AppDataProvider dataProvider,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final AppUser? user = dataProvider.findUserByUsername(username);
      final bool isValid =
          user != null && user.password == password.trim() && user.isActive;

      if (!isValid) {
        _errorMessage = 'Invalid credentials. Please try again.';
        _currentUser = null;
        return false;
      }

      _currentUser = user;
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
}
