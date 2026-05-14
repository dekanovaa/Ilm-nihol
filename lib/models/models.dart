// ============================================================
// MODELS
// ============================================================
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UserModel {
  String id;
  String firstName;
  String lastName;
  String school;
  String grade;
  String email;
  int totalScore;
  int totalStars;
  List<String> certificates;
  List<String> completedLessons;
  Map<String, int> lessonScores;
  String? avatarPath;
  DateTime registeredAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.school,
    required this.grade,
    required this.email,
    this.totalScore = 0,
    this.totalStars = 0,
    List<String>? certificates,
    List<String>? completedLessons,
    Map<String, int>? lessonScores,
    this.avatarPath,
    DateTime? registeredAt,
  })  : certificates = certificates ?? [],
        completedLessons = completedLessons ?? [],
        lessonScores = lessonScores ?? {},
        registeredAt = registeredAt ?? DateTime.now();

  String get fullName => '$firstName $lastName';

  double get averageScore {
    if (lessonScores.isEmpty) return 0;
    final sum = lessonScores.values.fold(0, (a, b) => a + b);
    return sum / lessonScores.length;
  }

  String get rankTitle {
    if (totalScore >= 900) return 'Master Botanik 🏆';
    if (totalScore >= 600) return 'Ilg\'or O\'quvchi 🌟';
    if (totalScore >= 300) return 'Botanik Talaba 🌿';
    return 'Yangi Botanik 🌱';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'school': school,
        'grade': grade,
        'email': email,
        'totalScore': totalScore,
        'totalStars': totalStars,
        'certificates': certificates,
        'completedLessons': completedLessons,
        'lessonScores': lessonScores,
        'avatarPath': avatarPath,
        'registeredAt': registeredAt.toIso8601String(),
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        school: map['school'],
        grade: map['grade'],
        email: map['email'],
        totalScore: map['totalScore'] ?? 0,
        totalStars: map['totalStars'] ?? 0,
        certificates: List<String>.from(map['certificates'] ?? []),
        completedLessons: List<String>.from(map['completedLessons'] ?? []),
        lessonScores: Map<String, int>.from(map['lessonScores'] ?? {}),
        avatarPath: map['avatarPath'],
        registeredAt: DateTime.parse(
            map['registeredAt'] ?? DateTime.now().toIso8601String()),
      );
}

// ---- Lesson Model ----
class LessonModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String youtubeUrl;
  final String emoji;
  final String steamTag;
  final Color steamColor;
  final List<QuizQuestion> questions;
  final int maxScore;
  final String difficulty; // 'Oson', 'O\'rta', 'Qiyin'

  const LessonModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.youtubeUrl,
    required this.emoji,
    required this.steamTag,
    required this.steamColor,
    required this.questions,
    required this.maxScore,
    required this.difficulty,
  });
}

extension LessonModelExt on LessonModel {
  Color getSteamColor(BuildContext context) {
    switch (steamTag.toUpperCase()) {
      case 'SCIENCE':
        return context.colors.scienceBadge;
      case 'TECH':
        return context.colors.techBadge;
      case 'ENGINEER':
        return context.colors.engineerBadge;
      case 'ARTS':
        return context.colors.artBadge;
      case 'MATH':
        return context.colors.mathBadge;
      default:
        return context.colors.primary;
    }
  }
}

// ---- Quiz Question ----
class QuizQuestion {
  final String id;
  final String question;
  final QuestionType type;
  final List<String> options;
  final int correctIndex;
  final String? imageUrl;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.type,
    required this.options,
    required this.correctIndex,
    this.imageUrl,
    required this.explanation,
  });
}

enum QuestionType { multipleChoice, trueFalse, imageChoice }

// ---- News Model ----
class NewsModel {
  final String id;
  final String title;
  final String summary;
  final String imageUrl;
  final String category;
  final DateTime publishedAt;
  final String readTime;

  const NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.category,
    required this.publishedAt,
    required this.readTime,
  });
}

// ---- Leaderboard Entry ----
class LeaderboardEntry {
  final String userId;
  final String fullName;
  final String school;
  final String grade;
  final int score;
  final int stars;
  final String rankTitle;
  int rank;

  LeaderboardEntry({
    required this.userId,
    required this.fullName,
    required this.school,
    required this.grade,
    required this.score,
    required this.stars,
    required this.rankTitle,
    required this.rank,
  });
}

// ---- Community Post Model ----
class CommunityPostModel {
  final String id;
  final String userId;
  final String userName;
  final String userGrade;
  final String? userAvatar;
  final String plantName;
  final String description;
  final String? imageUrl;
  final int likes;
  final int comments;
  final DateTime createdAt;

  CommunityPostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userGrade,
    this.userAvatar,
    required this.plantName,
    required this.description,
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'userName': userName,
        'userGrade': userGrade,
        'userAvatar': userAvatar,
        'plantName': plantName,
        'description': description,
        'imageUrl': imageUrl,
        'likes': likes,
        'comments': comments,
        'createdAt': createdAt.toIso8601String(),
      };

  factory CommunityPostModel.fromMap(Map<String, dynamic> map, String id) =>
      CommunityPostModel(
        id: id,
        userId: map['userId'] ?? '',
        userName: map['userName'] ?? 'Noma\'lum',
        userGrade: map['userGrade'] ?? '',
        userAvatar: map['userAvatar'],
        plantName: map['plantName'] ?? '',
        description: map['description'] ?? '',
        imageUrl: map['imageUrl'],
        likes: map['likes'] ?? 0,
        comments: map['comments'] ?? 0,
        createdAt: DateTime.parse(
            map['createdAt'] ?? DateTime.now().toIso8601String()),
      );
}
