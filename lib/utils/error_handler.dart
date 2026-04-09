import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorHandler {
  static String getErrorMessage(dynamic e) {
    String? code;

    if (e is FirebaseAuthException) {
      code = e.code;
    } else if (e is FirebaseException) {
      code = e.code;
    } else {
      // Agar exception turi boshqacha bo'lsa, toString() dan kodni ajratib olish
      final str = e.toString();
      final match = RegExp(r'\[firebase_auth/([\w-]+)\]').firstMatch(str);
      if (match != null) {
        code = match.group(1);
      }
    }

    if (code != null) {
      return _mapCodeToMessage(code);
    }

    return 'Xatolik yuz berdi: ${e.toString()}';
  }

  static String _mapCodeToMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Bu email manzil allaqachon ro\'yxatdan o\'tgan. Iltimos, boshqa email kiriting yoki "Kirish" sahifasidan foydalaning.';
      case 'invalid-email':
        return 'Email manzil shakli noto\'g\'ri.';
      case 'operation-not-allowed':
        return 'Bu amalga ruxsat berilmagan.';
      case 'weak-password':
        return 'Parol juda kuchsiz. Iltimos, murakkabroq parol tanlang.';
      case 'user-disabled':
        return 'Ushbu hisob bloklangan.';
      case 'user-not-found':
        return 'Bunday email bilan foydalanuvchi topilmadi.';
      case 'wrong-password':
        return 'Parol noto\'g\'ri. Iltimos, qaytadan urinib ko\'ring.';
      case 'too-many-requests':
        return 'Juda ko\'p urinish bo\'ldi. Biroz kutib, qaytadan urinib ko\'ring.';
      case 'network-request-failed':
        return 'Internet bilan aloqa yo\'q. Iltimos, tarmoqni tekshiring.';
      case 'invalid-credential':
        return 'Email yoki parol noto\'g\'ri.';
      default:
        return 'Kutilmagan xato yuz berdi (kod: $code).';
    }
  }
}
