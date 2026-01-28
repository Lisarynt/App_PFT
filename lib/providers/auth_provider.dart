import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  UserModel? _userModel;

  bool _initialized = false;
  bool _isLoading = false;
  String? _errorMessage;

  StreamSubscription<User?>? _authSub;

  // ================== GETTERS ==================
  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get initialized => _initialized;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // ================== CONSTRUCTOR ==================
  AuthProvider() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      _user = user;
      print('Auth state changed. user uid: ${user?.uid}');

      if (user != null) {
        try {
          _userModel = await _authService.getUserData(user.uid);
          print('Loaded userModel on auth change: ${_userModel?.toMap()}');
        } catch (e) {
          _userModel = null;
          print('getUserData error: $e');
        }
      } else {
        _userModel = null;
      }

      _initialized = true;
      notifyListeners();
    });
  }

  // ================== SIGN IN ==================
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signIn(email, password);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================== REGISTER ==================
  Future<bool> register(String email, String password, String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(email, password, name);
      
      // Sign out setelah registrasi berhasil
      await FirebaseAuth.instance.signOut();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('Register Error: $_errorMessage'); // Untuk debugging
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // ================== UPDATE PROFILE (INI YANG KURANG) ==================
// ...existing code...
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    // fallback ke currentUser jika _user belum ter-set
    final uid = _user?.uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.updateUserProfile(uid, data);

      // reload user data
      try {
        _userModel = await _authService.getUserData(uid);
        print('Reloaded userModel: ${_userModel?.toMap()}'); // debug
      } catch (e) {
        print('Failed reload user data: $e');
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('UpdateProfile Error: $_errorMessage');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
// ...existing code...

  // ================== SIGN OUT ==================
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _userModel = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
