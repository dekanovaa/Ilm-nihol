import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/models.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static FirebaseAuth get auth => _auth;
  static FirebaseFirestore get db => _db;

  // ── AUTH ──────────────────────────────────────────────────

  static Future<UserCredential> register(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<UserCredential> login(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static User? get currentFirebaseUser => _auth.currentUser;

  // ── USER DOC ──────────────────────────────────────────────

  static Future<void> saveUser(UserModel user) async {
    await _db
        .collection('users')
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true));
  }

  static Future<UserModel?> loadUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  // ── LEADERBOARD ───────────────────────────────────────────

  /// Barcha foydalanuvchilarni score bo'yicha kamayish tartibida oladi
  static Stream<List<LeaderboardEntry>> leaderboardStream() {
    return _db
        .collection('users')
        .orderBy('totalScore', descending: true)
        .snapshots()
        .map((snap) {
      final entries = <LeaderboardEntry>[];
      for (int i = 0; i < snap.docs.length; i++) {
        final data = snap.docs[i].data();
        entries.add(LeaderboardEntry(
          userId: snap.docs[i].id,
          fullName: '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
          school: data['school'] ?? '',
          grade: data['grade'] ?? '',
          score: data['totalScore'] ?? 0,
          stars: data['totalStars'] ?? 0,
          rankTitle: _rankTitle(data['totalScore'] ?? 0),
          rank: i + 1,
        ));
      }
      return entries;
    });
  }

  static String _rankTitle(int score) {
    if (score >= 900) return 'Master Botanik 🏆';
    if (score >= 600) return "Ilg'or O'quvchi 🌟";
    if (score >= 300) return "Botanik Talaba 🌿";
    return 'Yangi Botanik 🌱';
  }
}
