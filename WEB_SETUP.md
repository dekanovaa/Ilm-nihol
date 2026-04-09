# 🌿 Ilmnihol — Web da Ishga Tushirish

## 1-qadam: Loyiha papkasiga kiring
```
cd C:\Users\user\Desktop\ilmnihol
```

## 2-qadam: Web platformasini qo'shing
```
flutter create --platforms=web .
```
> Bu buyruq `web/` papkasini yaratadi (index.html, manifest.json va boshqalar)

## 3-qadam: Paketlarni yuklab oling
```
flutter pub get
```

## 4-qadam: Chrome da ishga tushiring
```
flutter run -d chrome
```

yoki Edge uchun:
```
flutter run -d edge
```

## 5-qadam (ixtiyoriy): Build qiling
```
flutter build web
```
Tayyor fayl: `build/web/` papkasida

---

## ⚠️ Agar xato chiqsa

### "pubspec.yaml" xatosi:
```
flutter pub get
```

### Port band bo'lsa:
```
flutter run -d chrome --web-port=8080
```

### youtube_player_flutter xatosi chiqsa:
Bu paket web da ishlamaydi — bizning pubspec.yaml da olib tashlangan,
lekin flutter create dan keyin pub get albatta bajaring.

---

## 📦 Loyihadagi paketlar (web-compatible)
- provider — state management  
- google_fonts — Playfair Display, DM Sans
- shared_preferences — lokal saqlash (web: localStorage)
- percent_indicator — progress ko'rsatgich
