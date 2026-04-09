# 🌿 Ilmnihol — Botanika O'quv Ilovasi

**STEAM asosida 12–16 yoshli o'quvchilar uchun botanika ta'lim platformasi**

---

## 📁 Loyiha tuzilmasi

```
lib/
├── main.dart                    # Asosiy kirish nuqtasi
├── theme/
│   └── app_theme.dart           # Ranglar, shriftlar, tema
├── models/
│   ├── models.dart              # UserModel, LessonModel, QuizQuestion, NewsModel
│   └── app_provider.dart        # State management (Provider)
├── data/
│   └── app_data.dart            # 10 ta dars, yangiliklar, reyting ma'lumotlari
└── screens/
    ├── auth_screens.dart        # SplashScreen, LoginScreen, RegisterScreen
    ├── main_screen.dart         # Bottom navigation
    ├── home_screen.dart         # Bosh sahifa (yangiliklar)
    ├── lessons_screen.dart      # Darslar ro'yhati va dars detail
    ├── quiz_screen.dart         # Interaktiv test (taymer, animatsiyalar)
    ├── leaderboard_screen.dart  # Reyting jadval
    └── profile_screen.dart      # Profil, tahrirlash, yutuqlar
```

---

## ⚡ O'rnatish

### 1. Kerakli paketlar
```bash
flutter pub get
```

### 2. Ishga tushirish
```bash
flutter run
```

---

## 📦 Ishlatilgan paketlar

| Paket | Maqsad |
|---|---|
| `provider` | State management |
| `google_fonts` | Playfair Display, DM Sans, Space Mono |
| `shared_preferences` | Lokal ma'lumot saqlash |
| `percent_indicator` | Doiraviy va chiziqli progress |
| `youtube_player_flutter` | YouTube video ijrochi |
| `cached_network_image` | Rasmlarni keshlashtirish |
| `fl_chart` | Statistika grafiklari |

---

## 🖥️ Sahifalar va funksiyalar

### 🔐 Auth
- **Login** — Email + parol, validatsiya
- **Register** — Ism, familiya, maktab, sinf, email, parol (8+ belgi, katta harf, raqam)

### 🏠 Bosh sahifa
- Salomlashuv banner (ism, daraja)
- Tezkor statistika (yulduz, ball, darslar, sertifikat)
- STEAM yo'nalishlari
- Botanika yangiliklari lenti

### 📚 Darslar (10 ta mavzu)
1. O'simlik hujayrasi
2. Fotosintez
3. O'simlik ildizi
4. Barg tuzilishi
5. Tasniflash tizimi
6. Ko'payish
7. Ekotizim
8. Fibonacci va o'simliklar (MATH)
9. Dorivor o'simliklar
10. Aqlli qishloq xo'jaligi (TECH)

**Har bir darsda:**
- 📖 Matn bo'limi (formatlangan)
- 🎬 Video (YouTube link)
- 📝 Interaktiv test (taymer, animatsiya)
- 🔬 Virtual laboratoriya (simulatsiya)

### 📝 Test tizimi
- ⏱️ 30 soniya taymer
- Ko'p tanlovli (A/B/C/D)
- To'g'ri/Noto'g'ri
- Rasmli savollar
- Javob animatsiyasi (yashil/qizil)
- Izoh ko'rsatish
- Ball hisoblash: 80%+ → 3 yulduz + sertifikat

### 🏆 Reyting
- Top-3 podium (oltin, kumush, bronza)
- Barcha foydalanuvchilar jadval
- "Men" ko'rsatgich
- Ball, yulduz, maktab info

### 👤 Profil
- Avatar (ism boshi)
- 4 ta statistika chip
- Doiraviy progress (o'zlashtirish %)
- Sertifikatlar va yulduzlar
- Tugallangan darslar ro'yhati
- Shaxsiy ma'lumotlar
- Tahrirlash modal

---

## 🎨 Dizayn tizimi

**Asosiy ranglar:**
- `#2D6A4F` — Primary (to'q yashil)
- `#52B788` — Primary Light
- `#1A3A2A` — Primary Dark
- `#D4E157` — Accent (sariq-yashil)
- `#F0EBE3` — Background (kremli)

**Shriftlar:**
- `Playfair Display` — Sarlavhalar
- `DM Sans` — Asosiy matn
- `Space Mono` — Raqamlar, badge'lar

---

## 🔗 Backend ulash (keyingi qadam)

Hozirda `SharedPreferences` orqali lokal saqlash ishlatilmoqda.  
Real backend uchun `app_provider.dart` dagi metodlarni almashtirishingiz mumkin:

```dart
// Firebase uchun:
await FirebaseAuth.instance.createUserWithEmailAndPassword(...)
await FirebaseFirestore.instance.collection('users').doc(uid).set(...)

// REST API uchun:
final response = await http.post('https://api.ilmnihol.uz/auth/register', ...)
```

---

## 📱 Minimun talablar

- Flutter 3.0+
- Dart 3.0+
- iOS 12+ / Android 6.0+

---

*Ilmnihol — O'simliklar dunyosini kashf eting 🌱*
