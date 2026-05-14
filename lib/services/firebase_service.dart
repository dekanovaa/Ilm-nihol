import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static FirebaseAuth get auth => _auth;
  static FirebaseFirestore get db => _db;
  static FirebaseStorage get storage => _storage;

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

  // ── COMMUNITY ──────────────────────────────────────────

  static Stream<List<CommunityPostModel>> communityPostsStream() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => CommunityPostModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  static Future<void> createPost(CommunityPostModel post) async {
    await _db.collection('posts').add(post.toMap());
  }

  static Future<void> likePost(String postId) async {
    await _db.collection('posts').doc(postId).update({
      'likes': FieldValue.increment(1),
    });
  }

  /// Eng faol foydalanuvchilarni oladi (masalan, eng ko'p scorega ega 10 tasi)
  static Stream<List<UserModel>> topUsersStream() {
    return _db
        .collection('users')
        .orderBy('totalScore', descending: true)
        .limit(10)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }

  static Stream<List<CommunityPostModel>> userPostsStream(String userId) {
    return _db
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => CommunityPostModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  static Future<String> uploadImage(Uint8List bytes, String folder) async {
    final ref = _storage
        .ref()
        .child(folder)
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putData(
        bytes, SettableMetadata(contentType: 'image/jpeg'));
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  static Future<void> deletePost(String postId) async {
    await _db.collection('posts').doc(postId).delete();
  }
}
