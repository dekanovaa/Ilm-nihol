import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';

class AppProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  List<LeaderboardEntry> _leaderboard = [];
  StreamSubscription<List<LeaderboardEntry>>? _leaderboardSub;
  String? _localPin;
  bool _pinVerified = false;

  ThemeMode _themeMode = ThemeMode.system;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  List<LeaderboardEntry> get leaderboard => _leaderboard;
  ThemeMode get themeMode => _themeMode;
  bool get hasPin => _localPin != null && _localPin!.isNotEmpty;
  bool get isPinVerified => _pinVerified;

  AppProvider() {
    _init();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> _init() async {
    // Firebase Auth state o'zgarishini kuzatamiz
    FirebaseAuth.instance.authStateChanges().listen((fbUser) async {
      if (fbUser != null) {
        // Foydalanuvchi login qilgan — ma'lumotlarni yuklaymiz
        try {
          final user = await FirebaseService.loadUser(fbUser.uid);
          if (user != null) {
            _currentUser = user;
            _isLoggedIn = true;
            await _loadLocalPin();
            _subscribeLeaderboard(); // Faqat login qilgandan keyin
            notifyListeners();
          }
        } catch (e) {
          debugPrint('User load error: $e');
        }
      } else {
        // Foydalanuvchi logout qilgan
        _currentUser = null;
        _isLoggedIn = false;
        _localPin = null;
        _pinVerified = false;
        _leaderboard = [];
        _leaderboardSub?.cancel();
        _leaderboardSub = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadLocalPin() async {
    if (_currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    _localPin = prefs.getString('${_currentUser!.email}_pin');
  }

  Future<void> setPin(String pin) async {
    if (_currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_currentUser!.email}_pin', pin);
    _localPin = pin;
    _pinVerified = true;
    notifyListeners();
  }

  bool verifyPin(String pin) {
    if (_localPin == pin) {
      _pinVerified = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void resetPinVerification() {
    _pinVerified = false;
    notifyListeners();
  }

  void _subscribeLeaderboard() {
    _leaderboardSub?.cancel();
    _leaderboardSub = FirebaseService.leaderboardStream().listen((entries) {
      _leaderboard = entries;
      notifyListeners();
    }, onError: (e) {
      debugPrint('Leaderboard error: $e');
    });
  }

  @override
  void dispose() {
    _leaderboardSub?.cancel();
    super.dispose();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String school,
    required String grade,
    required String email,
    required String password,
  }) async {
    UserCredential cred;
    try {
      cred = await FirebaseService.register(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Oldingi tugallanmagan ro'yxatdan o'tish bo'lishi mumkin
        // Shu email va parol bilan kirishga urinib ko'ramiz
        try {
          cred = await FirebaseService.login(email, password);
        } catch (_) {
          // Parol mos kelmasa, foydalanuvchiga xabar beramiz
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message:
                'Bu email allaqachon ro\'yxatdan o\'tgan. Iltimos, "Kirish" sahifasidan foydalaning.',
          );
        }
      } else {
        rethrow;
      }
    }
    final user = UserModel(
      id: cred.user!.uid,
      firstName: firstName,
      lastName: lastName,
      school: school,
      grade: grade,
      email: email,
    );
    _currentUser = user;
    _isLoggedIn = true;
    await FirebaseService.saveUser(user);
    _subscribeLeaderboard();
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final cred = await FirebaseService.login(email, password);
    final user = await FirebaseService.loadUser(cred.user!.uid);
    if (user == null) throw Exception("Foydalanuvchi ma'lumotlari topilmadi");
    _currentUser = user;
    _isLoggedIn = true;
    _subscribeLeaderboard();
    notifyListeners();
  }

  Future<void> logout() async {
    await FirebaseService.logout();
    _currentUser = null;
    _isLoggedIn = false;
    _leaderboard = [];
    _leaderboardSub?.cancel();
    _leaderboardSub = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? school,
    String? grade,
  }) async {
    if (_currentUser == null) return;
    _currentUser = UserModel(
      id: _currentUser!.id,
      firstName: firstName ?? _currentUser!.firstName,
      lastName: lastName ?? _currentUser!.lastName,
      school: school ?? _currentUser!.school,
      grade: grade ?? _currentUser!.grade,
      email: _currentUser!.email,
      totalScore: _currentUser!.totalScore,
      totalStars: _currentUser!.totalStars,
      certificates: _currentUser!.certificates,
      completedLessons: _currentUser!.completedLessons,
      lessonScores: _currentUser!.lessonScores,
      avatarPath: _currentUser!.avatarPath,
      registeredAt: _currentUser!.registeredAt,
    );
    await FirebaseService.saveUser(_currentUser!);
    notifyListeners();
  }

  Future<void> completeLessonWithScore(String lessonId, int score) async {
    if (_currentUser == null) return;

    final isNew = !_currentUser!.completedLessons.contains(lessonId);
    if (isNew) _currentUser!.completedLessons.add(lessonId);

    final previousScore = _currentUser!.lessonScores[lessonId] ?? 0;
    if (score > previousScore) {
      final scoreDiff = score - previousScore;
      _currentUser!.lessonScores[lessonId] = score;
      _currentUser!.totalScore += scoreDiff;

      int newStars = score >= 80
          ? 3
          : score >= 60
              ? 2
              : score >= 40
                  ? 1
                  : 0;
      int prevStars = previousScore >= 80
          ? 3
          : previousScore >= 60
              ? 2
              : previousScore >= 40
                  ? 1
                  : 0;
      if (newStars > prevStars) {
        _currentUser!.totalStars += (newStars - prevStars);
      }

      if (score >= 80 && !_currentUser!.certificates.contains(lessonId)) {
        _currentUser!.certificates.add(lessonId);
      }
    }

    await FirebaseService.saveUser(_currentUser!);
    notifyListeners();
  }

  int get currentUserRank {
    if (_currentUser == null) return -1;
    final idx = _leaderboard.indexWhere((e) => e.userId == _currentUser!.id);
    return idx == -1 ? -1 : idx + 1;
  }
}
