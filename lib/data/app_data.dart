import 'package:flutter/material.dart';
import '../models/models.dart';

class AppData {
  // Lessons Data
  static List<LessonModel> get lessons => [
    LessonModel(
      id: 'lesson_01',
      title: 'O\'simlik hujayrasining tuzilishi',
      subtitle: 'Hayotning asosiy birligi',
      emoji: '🔬',
      steamTag: 'SCIENCE',
      steamColor: const Color(0xFF2D6A4F),
      difficulty: 'Oson',
      maxScore: 100,
      youtubeUrl: 'https://youtu.be/4-hwMov6INs',
      description: '''O'simlik hujayra — barcha tirik organizmlarning asosiy qurilish birligidir. 
      
Hujayraning asosiy qismlari:
• **Hujayra devori** — sellyulozadan tuzilgan mustahkam tashqi qatlam
• **Plazmatik membrana** — moddalar o'tishini boshqaradi
• **Sitoplazma** — barcha organoidlar joylashgan gel-like muhit
• **Yadro** — irsiy ma'lumotlar (DNK) saqlanadi
• **Xloroplastlar** — fotosintez jarayoni yuz beradi (yashil rang)
• **Vakuola** — suv va oziq moddalarni saqlaydi
• **Mitoxondriya** — energiya ishlab chiqaradi

O'simlik hujayrasining hayvon hujayrasidan farqi:
✦ Hujayra devori mavjud
✦ Xloroplastlar bor (fotosintez uchun)
✦ Katta markaziy vakuola mavjud

Hujayra o'lchami odatda 10-100 mikrometr bo'ladi.''',
      questions: [
        QuizQuestion(
          id: 'q1_1',
          question: 'Qaysi organoid fotosintez jarayonini amalga oshiradi?',
          type: QuestionType.multipleChoice,
          options: ['Mitoxondriya', 'Xloroplast', 'Vakuola', 'Yadro'],
          correctIndex: 1,
          explanation: 'Xloroplastlar xlorofill pigmentini o\'z ichiga oladi va quyosh energiyasini ishlatib fotosintez qiladi.',
        ),
        QuizQuestion(
          id: 'q1_2',
          question: 'O\'simlik hujayra devori qaysi moddadan tashkil topgan?',
          type: QuestionType.multipleChoice,
          options: ['Kraxmal', 'Oqsil', 'Sellyuloza', 'Lipid'],
          correctIndex: 2,
          explanation: 'Sellyuloza — glyukoza birliklaridan tuzilgan murakkab uglerod bo\'lib, hujayra devorining asosiy komponenti hisoblanadi.',
        ),
        QuizQuestion(
          id: 'q1_3',
          question: 'O\'simlik hujayrasida hayvon hujayrasidan farqli ravishda vakuola mavjud.',
          type: QuestionType.trueFalse,
          options: ['To\'g\'ri', 'Noto\'g\'ri'],
          correctIndex: 0,
          explanation: 'Ha, o\'simlik hujayrasida katta markaziy vakuola bo\'lib, u suv, tuzlar va boshqa moddalarni saqlaydi.',
        ),
        QuizQuestion(
          id: 'q1_4',
          question: 'Rasmda ko\'rsatilgan organoidni aniqlang:',
          type: QuestionType.imageChoice,
          options: ['Mitoxondriya', 'Xloroplast', 'Yadro', 'Ribosoma'],
          correctIndex: 1,
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Simple_diagram_of_plant_cell_%28en%29.svg/600px-Simple_diagram_of_plant_cell_%28en%29.svg.png',
          explanation: 'Rasmda ko\'rsatilgan yashil rangli organoidlar — xloroplastlar.',
        ),
        QuizQuestion(
          id: 'q1_5',
          question: 'Hujayrada irsiy ma\'lumot qayerda saqlanadi?',
          type: QuestionType.multipleChoice,
          options: ['Sitoplazma', 'Vakuola', 'Yadro', 'Hujayra devori'],
          correctIndex: 2,
          explanation: 'Yadro — DNK (deoksiribonuklein kislota) ko\'rinishidagi irsiy ma\'lumotlarning saqlanish joyi.',
        ),
      ],
    ),

    LessonModel(
      id: 'lesson_02',
      title: 'Fotosintez jarayoni',
      subtitle: 'Quyosh energiyasini qayta ishlash',
      emoji: '☀️',
      steamTag: 'SCIENCE',
      steamColor: const Color(0xFF2D6A4F),
      difficulty: 'O\'rta',
      maxScore: 100,
      youtubeUrl: 'https://youtu.be/CU3-U03A1CI',
      description: '''Fotosintez — o\'simliklarning quyosh energiyasidan foydalanib, karbonat angidrid va suvdan organik moddalar va kislorod hosil qilish jarayoni.

**Kimyoviy tenglama:**
6CO₂ + 6H₂O + Quyosh energiyasi → C₆H₁₂O₆ + 6O₂

**Fotosintez ikki bosqichda kechadi:**

1. **Yorug\'lik bosqichi** (Tilakoid membranada)
   • Quyosh energiyasi yutiladi
   • Suv molekulalari parchalanadi (fotoliz)
   • ATP va NADPH hosil bo\'ladi
   • Kislorod ajralib chiqadi

2. **Qorong\'ilik bosqichi** (Calvin sikli, Stroma)
   • CO₂ bog\'lanadi
   • Glyukoza sintezlanadi
   • ATP va NADPH sarflanadi

**Fotosintezga ta\'sir etuvchi omillar:**
✦ Yorug\'lik intensivligi
✦ CO₂ konsentratsiyasi
✦ Harorat (15-30°C optimal)
✦ Suv miqdori''',
      questions: [
        QuizQuestion(
          id: 'q2_1',
          question: 'Fotosintez jarayonida qaysi gaz ajralib chiqadi?',
          type: QuestionType.multipleChoice,
          options: ['CO₂', 'N₂', 'O₂', 'H₂'],
          correctIndex: 2,
          explanation: 'Fotosintez natijasida kislorod (O₂) ajralib chiqadi — bu suv molekulalarining fotolizi natijasida hosil bo\'ladi.',
        ),
        QuizQuestion(
          id: 'q2_2',
          question: 'Fotosintez xloroplastning tillakoid membranasida to\'liq kechadi.',
          type: QuestionType.trueFalse,
          options: ['To\'g\'ri', 'Noto\'g\'ri'],
          correctIndex: 1,
          explanation: 'Fotosintez ikki qismda: yorug\'lik bosqichi tillakoidda, qorong\'ilik bosqichi (Calvin sikli) esa stromalarda kechadi.',
        ),
        QuizQuestion(
          id: 'q2_3',
          question: 'Fotosintez uchun zarur bo\'lgan asosiy moddalar:',
          type: QuestionType.multipleChoice,
          options: ['O₂ va Glyukoza', 'CO₂ va H₂O', 'N₂ va Mineraltuzlar', 'ATP va NADPH'],
          correctIndex: 1,
          explanation: 'Fotosintez uchun karbonat angidrid (CO₂) va suv (H₂O) hamda quyosh energiyasi zarur.',
        ),
        QuizQuestion(
          id: 'q2_4',
          question: 'Fotosintez uchun optimal harorat qancha?',
          type: QuestionType.multipleChoice,
          options: ['0-5°C', '35-50°C', '15-30°C', '50-70°C'],
          correctIndex: 2,
          explanation: 'Ko\'pgina o\'simliklar uchun fotosintez 15-30°C haroratda eng samarali kechadi.',
        ),
        QuizQuestion(
          id: 'q2_5',
          question: 'Rasmda fotosintez jarayonini ko\'rsating:',
          type: QuestionType.imageChoice,
          options: ['Nafas olish', 'Fotosintez', 'Transpiratsiya', 'Fermentatsiya'],
          correctIndex: 1,
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Photosynthesis_en.svg/500px-Photosynthesis_en.svg.png',
          explanation: 'Rasmda quyosh energiyasidan glyukoza hosil qilish jarayoni — fotosintez ko\'rsatilgan.',
        ),
      ],
    ),

    LessonModel(
      id: 'lesson_03',
      title: 'O\'simlik ildizi',
      subtitle: 'Yer ostidagi hayot',
      emoji: '🌱',
      steamTag: 'SCIENCE',
      steamColor: const Color(0xFF2D6A4F),
      difficulty: 'Oson',
      maxScore: 100,
      youtubeUrl: 'https://youtu.be/RtF1gd3IDLY',
      description: '''Ildiz — o\'simliklarning yer ostidagi asosiy organi bo\'lib, bir nechta muhim vazifalarni bajaradi.

**Ildizning vazifalari:**
• Tuproqdan suv va mineral tuzlarni so\'rish
• O\'simlikni tuproqda mahkamlash
• Oziq moddalarni to\'plash (lavlagi, sabzi)
• Vegetativ ko\'payish (ba\'zi o\'simliklarda)

**Ildiz tizimi turlari:**

1. **O\'q ildiz tizimi**
   - Asosiy kuchli ildiz mavjud
   - Yon ildizlar undan shoxlanadi
   - Misol: Karam, lavlagi, o\'rik

2. **Mochkali ildiz tizimi**
   - Ko\'plab bir xil ingichka ildizlar
   - Asosiy ildiz yo\'q
   - Misol: Bug\'doy, makkajo\'xori

**Ildiz tuzilishi (kesma)**:
Ildiz uchi → O\'sish zonasi → So\'rish zonasi (ildiz tuklari) → O\'tkazish zonasi → Ildiz bo\'yni''',
      questions: [
        QuizQuestion(
          id: 'q3_1',
          question: 'Ildizning asosiy vazifasi qaysi?',
          type: QuestionType.multipleChoice,
          options: ['Fotosintez', 'Tuproqdan suv va mineral so\'rish', 'Urug\' hosil qilish', 'Nafas olish'],
          correctIndex: 1,
          explanation: 'Ildizning bosh vazifasi tuproqdan suv va mineral tuzlarni so\'rib olish hamda o\'simlikni ushlab turishdir.',
        ),
        QuizQuestion(
          id: 'q3_2',
          question: 'Bug\'doy o\'simligi qaysi turdagi ildiz tizimiga ega?',
          type: QuestionType.multipleChoice,
          options: ['O\'q ildiz tizimi', 'Mochkali ildiz tizimi', 'Havo ildizlari', 'Tayanch ildizlari'],
          correctIndex: 1,
          explanation: 'Bug\'doy va boshqa don ekinlari mochkali ildiz tizimiga ega — ko\'p ingichka ildizlardan iborat.',
        ),
        QuizQuestion(
          id: 'q3_3',
          question: 'Sabzi va lavlagining ildizi oziq moddalarni to\'plash uchun xizmat qiladi.',
          type: QuestionType.trueFalse,
          options: ['To\'g\'ri', 'Noto\'g\'ri'],
          correctIndex: 0,
          explanation: 'Ha, sabzi, lavlagi va shunga o\'xshash o\'simliklarning ildizi to\'qiq — oziq moddalar to\'planadi.',
        ),
        QuizQuestion(
          id: 'q3_4',
          question: 'Ildiz so\'rish zonasidagi mayda tukchalar nima uchun kerak?',
          type: QuestionType.multipleChoice,
          options: ['Yorug\'lik yutish', 'So\'rish yuzasini kengaytirish', 'Suv chiqarish', 'Nafas olish'],
          correctIndex: 1,
          explanation: 'Ildiz tukchalari so\'rish yuzasini 10-20 marta kengaytirib, suv va mineral tuzlarni samaraliroq so\'rish imkonini beradi.',
        ),
        QuizQuestion(
          id: 'q3_5',
          question: 'Rasmda qaysi ildiz tizimi ko\'rsatilgan?',
          type: QuestionType.imageChoice,
          options: ['O\'q ildiz', 'Mochkali ildiz', 'Havo ildizi', 'Tuganakli ildiz'],
          correctIndex: 0,
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Dandelion_root.jpg/320px-Dandelion_root.jpg',
          explanation: 'Rasmda o\'q ildiz tizimi ko\'rsatilgan — bitta kuchli asosiy ildiz va undan shoxlangan yon ildizlar.',
        ),
      ],
    ),

    LessonModel(
      id: 'lesson_04',
      title: 'Bargning tuzilishi va vazifalari',
      subtitle: 'Fotosintez fabrikasi',
      emoji: '🍃',
      steamTag: 'SCIENCE',
      steamColor: const Color(0xFF2D6A4F),
      difficulty: 'Oson',
      maxScore: 100,
      youtubeUrl: 'https://www.youtube.com/watch?v=kDxgFDmQeaM',
      description: '''Barg — o\'simlikning asosiy oziqlanish organi bo\'lib, fotosintez, transpiratsiya va gaz almashinuvi amalga oshadi.

**Bargning tashqi tuzilishi:**
• Barg plasti (plastinka) — asosiy keng qism
• Barg bandi (chetiol) — poyaga ulaydi
• Barg asosi — poyaga birikish joyi
• Tomirlar — suv va oziqlarni tashiydi

**Bargning ichki tuzilishi:**
1. **Epidermis** — himoya qatlami, stomalar bor
2. **Palisad to\'qimasi** — xloroplastlarga boy, fotosintez
3. **Gubka to\'qimasi** — gaz almashinuvi
4. **O\'tkazuvchi to\'qima** — ksilema va floema

**Stomalar** — bargning osti-ustida joylashgan teshikchalar:
• Gaz almashinuvini ta\'minlaydi
• Transpiratsiyani boshqaradi
• 2 ta qo\'riqchi hujayra bilan o\'ralgan

**Bargning vazifalari:**
✦ Fotosintez (organik moddalar hosil qilish)
✦ Transpiratsiya (suv bug\'latish)
✦ Gaz almashinuvi (CO₂ kirish, O₂ chiqish)''',
      questions: [
        QuizQuestion(
          id: 'q4_1',
          question: 'Bargdagi stomalarning asosiy vazifasi nima?',
          type: QuestionType.multipleChoice,
          options: ['Suv so\'rish', 'Gaz almashinuvi', 'Fotosintez', 'Oziq saqlash'],
          correctIndex: 1,
          explanation: 'Stomalar orqali CO₂ kiradi, O₂ va suv bug\'i chiqadi — bu gaz almashinuvi jarayoni.',
        ),
        QuizQuestion(
          id: 'q4_2',
          question: 'Palisad to\'qimasi bargning qaysi qismida joylashgan?',
          type: QuestionType.multipleChoice,
          options: ['Pastki qismida', 'Yuqori qismida epidermis tagida', 'O\'rtada', 'Tomirlar yonida'],
          correctIndex: 1,
          explanation: 'Palisad to\'qimasi yuqori epidermis tagida joylashib, ko\'p xloroplastlarga ega va fotosintezning asosiy joyi.',
        ),
        QuizQuestion(
          id: 'q4_3',
          question: 'Transpiratsiya — bu suv bug\'latish jarayoni.',
          type: QuestionType.trueFalse,
          options: ['To\'g\'ri', 'Noto\'g\'ri'],
          correctIndex: 0,
          explanation: 'Ha, transpiratsiya — o\'simliklarning stomalar orqali suv bug\'latish jarayoni bo\'lib, ildizdan suv harakatini ta\'minlaydi.',
        ),
        QuizQuestion(
          id: 'q4_4',
          question: 'Rasmda barg kesmasining qaysi qismi ko\'rsatilgan?',
          type: QuestionType.imageChoice,
          options: ['Epidermis', 'Palisad to\'qimasi', 'Stoma', 'Ksilema'],
          correctIndex: 2,
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Leaf_anatomy_%28en%29.svg/500px-Leaf_anatomy_%28en%29.svg.png',
          explanation: 'Rasmda stomalar ko\'rsatilgan — ular 2 ta qo\'riqchi hujayra bilan o\'ralgan.',
        ),
        QuizQuestion(
          id: 'q4_5',
          question: 'Bargning ichidagi qaysi to\'qima suvni ildizdan barggacha olib chiqadi?',
          type: QuestionType.multipleChoice,
          options: ['Floema', 'Ksilema', 'Palisad', 'Epidermis'],
          correctIndex: 1,
          explanation: 'Ksilema — suvni va mineral tuzlarni ildizdan yuqoriga (barg va poyaga) olib chiquvchi o\'tkazuvchi to\'qima.',
        ),
      ],
    ),

    LessonModel(
      id: 'lesson_05',
      title: 'O\'simliklar tasniflash tizimi',
      subtitle: 'Linney sistemasi va guruhlar',
      emoji: '🗂️',
      steamTag: 'SCIENCE',
      steamColor: const Color(0xFF2D6A4F),
      difficulty: 'O\'rta',
      maxScore: 100,
      youtubeUrl: 'https://www.youtube.com/watch?v=SA02un37GFQ',
      description: '''Botanik tasniflash (sistematika) — o\'simliklarni o\'xshashlik belgilari asosida guruhlash fani.

**Tasniflash birliklari (yuqoridan pastga):**
1. Turkum (Regnum) — O\'simliklar
2. Bo\'lim (Divisio) — Guldorlar, Ochiq urug\'lilar
3. Sinf (Classis) — Bir pallalilar, Ikki pallalilar
4. Tartib (Ordo)
5. Oila (Familia)
6. Urug\' (Genus)
7. Tur (Species)

**Linney ikkilik nomenklaturasi:**
Har bir tur ikkita lotin so\'zidan iborat nom oladi:
• Birinchi so\'z — urug\' nomi (Bosh harf)
• Ikkinchi so\'z — tur epitetи (kichik harf)

Misol: *Rosa canina* (it nashvati)

**O\'simliklar asosiy guruhlari:**
🌿 Suvo\'tlar — oddiy tuzilish, xlorofill bor
🌾 Moslar — ildiz yo\'q, namliq yerlarda
🌲 Qarag\'aysimonlar — ochiq urug\'lilar
🌸 Guldorlar — yopiq urug\'lilar (eng ko\'p)''',
      questions: [
        QuizQuestion(
          id: 'q5_1',
          question: 'Linney tasniflash sistemasida eng kichik birlik qaysi?',
          type: QuestionType.multipleChoice,
          options: ['Urug\'', 'Oila', 'Tur', 'Sinf'],
          correctIndex: 2,
          explanation: 'Tur (Species) — tasniflashning eng kichik asosiy birligi. O\'zaro erkin chatishuvchi va unumdor avlod beradigan organizmlar bir turga kiradi.',
        ),
        QuizQuestion(
          id: 'q5_2',
          question: 'Linney ikkilik nomenklaturasida birinchi so\'z nimani bildiradi?',
          type: QuestionType.multipleChoice,
          options: ['Tur nomini', 'Urug\' nomini', 'Oila nomini', 'Sinf nomini'],
          correctIndex: 1,
          explanation: 'Birinchi so\'z urug\' (Genus) nomini bildiradi va bosh harf bilan yoziladi. Masalan: *Rosa*, *Quercus*.',
        ),
        QuizQuestion(
          id: 'q5_3',
          question: 'Guldorlar o\'simliklari ochiq urug\'lilar guruhiga kiradi.',
          type: QuestionType.trueFalse,
          options: ['To\'g\'ri', 'Noto\'g\'ri'],
          correctIndex: 1,
          explanation: 'Guldorlar — yopiq urug\'lilar (Angiospermae). Ochiq urug\'lilarga esa qarag\'ay, archa kabi o\'simliklar kiradi.',
        ),
        QuizQuestion(
          id: 'q5_4',
          question: 'Rasmda qaysi o\'simlik guruhi ko\'rsatilgan?',
          type: QuestionType.imageChoice,
          options: ['Suvo\'tlar', 'Moslar', 'Qarag\'aysimonlar', 'Guldorlar'],
          correctIndex: 2,
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Picea_abies_wood.jpg/320px-Picea_abies_wood.jpg',
          explanation: 'Rasmda ignabargli o\'simlik — qarag\'aysimonlar (ochiq urug\'lilar) guruhiga mansub.',
        ),
        QuizQuestion(
          id: 'q5_5',
          question: '*Solanum lycopersicum* — tomat o\'simligining ilmiy nomi. Bu nom qaysi tildan olingan?',
          type: QuestionType.multipleChoice,
          options: ['Grek', 'Arab', 'Lotin', 'Fransuz'],
          correctIndex: 2,
          explanation: 'Ilmiy nomlar lotin tilida yoziladi — bu barcha mamlakatlarda bir xil tushunilishi uchun xalqaro standart.',
        ),
      ],
    ),

    LessonModel(
      id: 'lesson_06',
      title: 'O\'simliklarning ko\'payishi',
      subtitle: 'Jinsiy va jinssiz ko\'payish',
      emoji: '🌸',
      steamTag: 'BIOLOGY',
      steamColor: const Color(0xFF1565C0),
      difficulty: 'O\'rta',
      maxScore: 100,
      youtubeUrl: 'https://www.youtube.com/watch?v=R_TrXbVGvR4',
      description: '''O\'simliklar ikkita asosiy usulda ko\'payadi: jinsiy va jinssiz ko\'payish.

**Jinssiz ko\'payish:**
Ota-ona organizmdan yangi organizm paydo bo\'ladi, irsiy o\'zgarishlar minimal.

1. *Vegetativ ko\'payish:*
   • Ildiz yordamida (malina, to\'ng\'izqo\'noq)
   • Poya yordamida (qovun, qovoq — uzun poyalar)
   • Barg yordamida (begoniya, tosh gullar)
   • Tuganak (kartoshka, dahliya)
   • Piyoz (piyoz, sarimsoq)

2. *Sporalar yordamida:* Qirqquloq, moslar

**Jinsiy ko\'payish:**
Erkak va urg\'ochi ko\'payish hujayralari (gametalar) qo\'shilishi.

*Gul — jinsiy ko\'payish organi:*
• Changchi — erkak gametofitlar hosil qiladi
• Urug\'chi — urg\'ochi gametofitlar
• Changlanish (pollinatsiya): shamo l, hasharotlar, suv
• Urug\' hosil bo\'lishi: chang + tuxum hujayra
• Meva va urug\' rivojlanishi''',
      questions: [
        QuizQuestion(
          id: 'q6_1',
          question: 'Kartoshkaning vegetativ ko\'payishi qaysi organi orqali amalga oshadi?',
          type: QuestionType.multipleChoice,
          options: ['Barg', 'Gul', 'Tuganak', 'Ildiz'],
          correctIndex: 2,
          explanation: 'Kartoshka tuganaklar (yer ostidagi poya qismi) orqali vegetativ ko\'payadi. Har bir "ko\'z" yangi o\'simlik berishi mumkin.',
        ),
        QuizQuestion(
          id: 'q6_2',
          question: 'Gul o\'simliklarning jinsiy ko\'payish organi hisoblanadi.',
          type: QuestionType.trueFalse,
          options: ['To\'g\'ri', 'Noto\'g\'ri'],
          correctIndex: 0,
          explanation: 'Ha, gul — jinsiy ko\'payish organi. Unda changchi (erkak) va urug\'chi (urg\'ochi) qismlar joylashgan.',
        ),
        QuizQuestion(
          id: 'q6_3',
          question: 'Qirqquloq qanday ko\'payadi?',
          type: QuestionType.multipleChoice,
          options: ['Gul orqali', 'Sporalar orqali', 'Urug\' orqali', 'Tuganak orqali'],
          correctIndex: 1,
          explanation: 'Qirqquloq va moslar sporalar yordamida ko\'payadi — ular gulsiz o\'simliklar.',
        ),
        QuizQuestion(
          id: 'q6_4',
          question: 'Rasmda qaysi changlanish turi ko\'rsatilgan?',
          type: QuestionType.imageChoice,
          options: ['Shamol bilan changlanish', 'Hasharot bilan changlanish', 'Suv bilan changlanish', 'O\'z-o\'zidan changlanish'],
          correctIndex: 1,
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Bumblebee_October_2007-1.jpg/320px-Bumblebee_October_2007-1.jpg',
          explanation: 'Rasmda ari guldan chang olib uchmoqda — bu hasharot yordamida (entomofil) changlanish.',
        ),
        QuizQuestion(
          id: 'q6_5',
          question: 'Jinsiy ko\'payishda irsiy xilma-xillik jinssizga qaraganda:',
          type: QuestionType.multipleChoice,
          options: ['Kamroq', 'Bir xil', 'Ko\'proq', 'Umuman yo\'q'],
          correctIndex: 2,
          explanation: 'Jinsiy ko\'payishda ikkita ota-onaning genlari aralashadi, bu irsiy xilma-xillikni oshiradi va evolyutsiya uchun muhim.',
        ),
      ],
    ),

    LessonModel(
      id: 'lesson_07',
      title: 'O\'simlik ekotizimi',
      subtitle: 'Tabiat va o\'simliklar munosabati',
      emoji: '🌍',
      steamTag: 'ECOLOGY',
      steamColor: const Color(0xFF2E7D32),
      difficulty: 'O\'rta',
      maxScore: 100,
      youtubeUrl: 'https://www.youtube.com/watch?v=Zy3ZNhQ_Gxo',
      description: '''Ekotizim — tirik organizmlar va ularning abiotic (jonsiz) muhiti o\'rtasidagi murakkab munosabatlar tizimi.

**O\'simliklar ekotizimdagi roli:**
• Produtsentlar — organik moddalar hosil qiladi
• Kislorod manbai — atmosfera O₂ ni to\'ldiradi
• Oziq zanjirining asosi
• Iqlimni tartibga solish

**Oziq zanjiri misoli:**
🌿 O\'t → 🐛 Hasharot → 🐸 Qurbaqa → 🦅 Lochin

**O\'zbekiston o\'simliklari:**
🌲 Archa — tog\' o\'rmanlari (1500-3000m)
🌾 Saksovul — cho\'l o\'simligi (Qizilqum)
🌺 Boychechak — birinchi bahor guli
🌹 Nasrin — O\'zbekiston milliy guli
🌰 Yong\'oq — Farg\'ona vodiysi

**Ekologik muammolar:**
⚠️ O\'rmon kesish — biodiversite yo\'qolishi
⚠️ Iqlim o\'zgarishi — o\'simlik areallari siljiydi
⚠️ Tuproq eroziyasi — ildiz o\'simliklarini yo\'qotadi
⚠️ Suv tanqisligi — cho\'llanish muammosi

**Muhofaza choralari:**
✅ Milliy bog\'lar va qo\'riqxonalar
✅ Ekologik qishloq xo\'jaligi
✅ O\'rmon tiklanishi''',
      questions: [
        QuizQuestion(
          id: 'q7_1',
          question: 'Ekotizimdagi produtsentlar kim hisoblanadi?',
          type: QuestionType.multipleChoice,
          options: ['Hayvonlar', 'O\'simliklar', 'Zamburug\'lar', 'Bakteriyalar'],
          correctIndex: 1,
          explanation: 'O\'simliklar — produtsentlar. Ular fotosintez orqali organik moddalar hosil qilib, barcha boshqa organizmlar uchun oziq manbai bo\'ladi.',
        ),
        QuizQuestion(
          id: 'q7_2',
          question: 'Saksovul O\'zbekistonning cho\'l hududlarida tarqalgan.',
          type: QuestionType.trueFalse,
          options: ['To\'g\'ri', 'Noto\'g\'ri'],
          correctIndex: 0,
          explanation: 'Ha, saksovul — Qizilqum va Qoraqum cho\'llarida o\'sadigan asosiy daraxt. Kuchli ildiz tizimi bilan cho\'l sharoitiga moslashgan.',
        ),
        QuizQuestion(
          id: 'q7_3',
          question: 'O\'simliklar atmosferadagi qaysi gaz miqdorini oshiradi?',
          type: QuestionType.multipleChoice,
          options: ['CO₂', 'N₂', 'O₂', 'CH₄'],
          correctIndex: 2,
          explanation: 'O\'simliklar fotosintez orqali kislorod (O₂) ajratib, atmosferani boyitadi. Yer atmosferasidagi O₂ ning aksariyati o\'simliklar mahsuli.',
        ),
        QuizQuestion(
          id: 'q7_4',
          question: 'Rasmda qaysi O\'zbekiston tabiiy landshafti ko\'rsatilgan?',
          type: QuestionType.imageChoice,
          options: ['Tog\' o\'rmoni', 'Cho\'l', 'Daryo vodiysi', 'Dasht'],
          correctIndex: 1,
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Kyzyl-Kum_Desert.JPG/320px-Kyzyl-Kum_Desert.JPG',
          explanation: 'Rasmda Qizilqum cho\'li ko\'rsatilgan — O\'zbekistonning katta qismini egallagan.',
        ),
        QuizQuestion(
          id: 'q7_5',
          question: 'Oziq zanjirida o\'simliklarning o\'rni:',
          type: QuestionType.multipleChoice,
          options: ['Konsument (iste\'molchi)', 'Produsent (ishlab chiqaruvchi)', 'Destruent (parchalovchi)', 'Parazit'],
          correctIndex: 1,
          explanation: 'O\'simliklar produtsentlar — ular organik moddalar ishlab chiqaradi va oziq zanjirining boshida turadi.',
        ),
      ],
    ),

    LessonModel(
      id: 'lesson_08',
      title: 'Fibonacci raqamlar va o\'simliklar',
      subtitle: 'Matematika va tabiat',
      emoji: '🐚',
      steamTag: 'MATH',
      steamColor: const Color(0xFF1565C0),
      difficulty: 'Qiyin',
      maxScore: 100,
      youtubeUrl: 'https://www.youtube.com/watch?v=ahXIMUkSXX0',
      description: '''O\'simliklar tabiatdagi eng chiroyli matematik naqshlarni namoyish etadi.

**Fibonacci qatori:**
1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89 ...
Qoida: Har sonni avvalgi ikki sonning yig\'indisi.

**O\'simliklardagi Fibonacci:**
🌻 Kungaboqar — spiral sonlari 34 va 55 (Fibonacci!)
🍍 Ananas — 8 va 13 spiral
🌹 Atirgul — 5 ta toj barg
🍂 Ko\'pgina o\'simliklar — 3, 5, 8, 13 ta barg

**Oltin nisbat (Φ = 1.618...):**
Fibonacci qatorida qo\'shni sonlar nisbati oltin nisbatga yaqinlashadi:
55/34 = 1.617... ≈ Φ

O\'simliklar bu naqshni quyosh nuridan maksimal foydalanish uchun ishlatadi!

**Barg tartiblanishi (fiyllotaksis):**
Barglar poyada spiral tartibda joylashadi:
• 1/2 spiral — javdar
• 1/3 spiral — qamish
• 2/5 spiral — olma
• 3/8 spiral — bug\'doy

Bu raqamlar ham Fibonacci qatoridan!

**Fraktallar:**
Qirqquloq, brokkoli Romanesco — o\'z-o\'ziga o\'xshash fraktal tuzilish.''',
      questions: [
        QuizQuestion(
          id: 'q8_1',
          question: 'Fibonacci qatoridagi 8 dan keyingi son qaysi?',
          type: QuestionType.multipleChoice,
          options: ['10', '12', '13', '16'],
          correctIndex: 2,
          explanation: '5+8=13. Fibonacci qatorida har bir son avvalgi ikkitasining yig\'indisi: 1,1,2,3,5,8,**13**,21...',
        ),
        QuizQuestion(
          id: 'q8_2',
          question: 'Kungaboqar guldagi spirallar soni Fibonacci qatoridagi sonlarga to\'g\'ri keladi.',
          type: QuestionType.trueFalse,
          options: ['To\'g\'ri', 'Noto\'g\'ri'],
          correctIndex: 0,
          explanation: 'Ha! Kungaboqardagi spirallar odatda 34 va 55 ta — ikkalasi ham Fibonacci qatoridagi son.',
        ),
        QuizQuestion(
          id: 'q8_3',
          question: 'Oltin nisbat (Φ) qiymati taxminan:',
          type: QuestionType.multipleChoice,
          options: ['1.414', '1.618', '2.718', '3.141'],
          correctIndex: 1,
          explanation: 'Oltin nisbat Φ ≈ 1.618... Bu Fibonacci qatorida qo\'shni sonlar nisbatining limiti.',
        ),
        QuizQuestion(
          id: 'q8_4',
          question: 'Rasmda qaysi matematik naqsh ko\'rsatilgan?',
          type: QuestionType.imageChoice,
          options: ['Pi (π)', 'Fibonacci spirali', 'Evklid geometriyasi', 'Fraktal'],
          correctIndex: 1,
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Fibonacci_spiral_34.svg/320px-Fibonacci_spiral_34.svg.png',
          explanation: 'Rasmda Fibonacci spirali ko\'rsatilgan — tabiatda dengiz chig\'anoqlari, o\'simlik spirallarida uchraydigan naqsh.',
        ),
        QuizQuestion(
          id: 'q8_5',
          question: 'Fiyllotaksis nima?',
          type: QuestionType.multipleChoice,
          options: ['Fotosintez turi', 'Barglarning poyada joylashish tartibı', 'Ildiz o\'sishi', 'Gul tuzilishi'],
          correctIndex: 1,
          explanation: 'Fiyllotaksis — barglarning poyada spiral tartibda joylashishi. Bu quyosh nuridan maksimal foydalanish imkonini beradi.',
        ),
      ],
    ),

    LessonModel(
      id: 'lesson_09',
      title: 'Dorivor o\'simliklar',
      subtitle: 'Tabiat dorixonasi',
      emoji: '🌿',
      steamTag: 'HEALTH',
      steamColor: const Color(0xFF558B2F),
      difficulty: 'Oson',
      maxScore: 100,
      youtubeUrl: 'https://www.youtube.com/watch?v=fHr8WtmX3G8',
      description: '''O\'zbekistonda 4500 dan ortiq o\'simlik turi o\'sadi, ularning 1000 dan ko\'prog\'i dorivor xususiyatlarga ega.

**Asosiy dorivor o\'simliklar:**

🌼 **Isiriq (Peganum harmala)**
   • Dezinfeksiya, havoni tozalash
   • Surunkali kasalliklar uchun

🍃 **Limon o\'ti (Melissa officinalis)**
   • Asab tinchituvchi, uyqu yaxshilash
   • Choy sifatida ichiladi

🌹 **Itburun (Rosa canina)**
   • C vitamini manbai
   • Immunitetni mustahkamlash

🟡 **Arslonquyruq (Leonurus cardiaca)**
   • Yurak-tomir kasalliklari
   • Qon bosimini pasaytirish

🌺 **Zafaron (Crocus sativus)**
   • Kayfiyat yaxshilash
   • Qon aylanishini yaxshilash
   • Dunyodagi eng qimmat ziravorlardan biri

**Ehtiyot choralar:**
⚠️ Dorivor o\'simliklarni shifokor maslahatsiz ishlatmang
⚠️ To\'g\'ri miqdor muhim
⚠️ Allergiya tekshiruvi zarur''',
      questions: [
        QuizQuestion(
          id: 'q9_1',
          question: 'Qaysi o\'simlik C vitaminiga eng boy?',
          type: QuestionType.multipleChoice,
          options: ['Isiriq', 'Limon o\'ti', 'Itburun', 'Zafaron'],
          correctIndex: 2,
          explanation: 'Itburun (Rosa canina) — C vitaminiga juda boy. Limondan 10-100 marta ko\'p vitamin C o\'z ichiga oladi.',
        ),
        QuizQuestion(
          id: 'q9_2',
          question: 'Zafaron dunyodagi eng qimmat ziravorlardan biri hisoblanadi.',
          type: QuestionType.trueFalse,
          options: ['To\'g\'ri', 'Noto\'g\'ri'],
          correctIndex: 0,
          explanation: 'Ha! 1 kg zafaron uchun ~150,000 dan ortiq gul qo\'lda yig\'iladi. Narxi kg uchun 1000-10000 dollar.',
        ),
        QuizQuestion(
          id: 'q9_3',
          question: 'Limon o\'ti (Melissa) asosan qanday ta\'sirga ega?',
          type: QuestionType.multipleChoice,
          options: ['Og\'riq qoldiruvchi', 'Asab tinchituvchi', 'Isitma tushiruvchi', 'Qon to\'xtatuvchi'],
          correctIndex: 1,
          explanation: 'Limon o\'ti (Melissa officinalis) — sedativ (asab tinchituvchi) ta\'sirga ega. Stress va uyqu muammolarida qo\'llaniladi.',
        ),
        QuizQuestion(
          id: 'q9_4',
          question: 'Rasmda qaysi dorivor o\'simlik ko\'rsatilgan?',
          type: QuestionType.imageChoice,
          options: ['Isiriq', 'Zafaron', 'Itburun', 'Lavanda'],
          correctIndex: 1,
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Crocus_vernus_crop.jpg/320px-Crocus_vernus_crop.jpg',
          explanation: 'Rasmda zafaron (Crocus) ko\'rsatilgan — binafsha rangli guli bilan tanilgan qimmatbaho o\'simlik.',
        ),
        QuizQuestion(
          id: 'q9_5',
          question: 'O\'zbekistonda necha tur o\'simlik o\'sadi?',
          type: QuestionType.multipleChoice,
          options: ['500 dan ortiq', '1000 dan ortiq', '4500 dan ortiq', '10000 dan ortiq'],
          correctIndex: 2,
          explanation: 'O\'zbekistonda 4500 dan ortiq o\'simlik turi mavjud, ularning 1000 dan ko\'prog\'i dorivor xususiyatlarga ega.',
        ),
      ],
    ),

    LessonModel(
      id: 'lesson_10',
      title: 'O\'simliklarni parvarish qilish texnologiyasi',
      subtitle: 'Aqlli bog\'dorchilik',
      emoji: '🤖',
      steamTag: 'TECH',
      steamColor: const Color(0xFF0277BD),
      difficulty: 'Qiyin',
      maxScore: 100,
      youtubeUrl: 'https://www.youtube.com/watch?v=oDFm9EFiGvc',
      description: '''Zamonaviy texnologiyalar qishloq xo\'jaligini inqilobiy o\'zgartirishda.

**Aqlli qishloq xo\'jaligi (Smart Agriculture):**

🌡️ **Sensor texnologiyalari:**
   • Tuproq namligi sensori
   • Harorat va namlik o\'lchagich
   • pH metr (tuproq kislotaligi)
   • Yorug\'lik intensivligi sensori

💧 **Avtomatik sug\'orish:**
   • Drip irrigation (tomchilatib sug\'orish)
   • Sensor ma\'lumotlariga asoslanib
   • Suv tejash: 50-90%

🤖 **Sun\'iy intellekt qo\'llanilishi:**
   • O\'simlik kasalliklarini aniqlash
   • Hosil prognozi
   • Optimal ekish vaqti

🛸 **Dron texnologiyasi:**
   • Katta maydonlarni monitoring qilish
   • Pestitsid sepish
   • Holat tahlili

**Arduino/Raspberry Pi loyihalari:**
Siz ham quyidagi loyihani qilishingiz mumkin:
1. Tuproq namligi sensori ulang
2. Arduino kodni yozing
3. Nasosni avtomatik boshqaring
4. Ko\'rsatgichni telefonga ulang

**AI o\'simlik tanish:**
Ilmihol ilovasi kabi AI kamera orqali o\'simlik turini 95% aniqlik bilan taniydi!''',
      questions: [
        QuizQuestion(
          id: 'q10_1',
          question: 'Drip irrigation (tomchilatib sug\'orish) qancha suv tejaydi?',
          type: QuestionType.multipleChoice,
          options: ['10-20%', '20-30%', '50-90%', '95-99%'],
          correctIndex: 2,
          explanation: 'Tomchilatib sug\'orish an\'anaviy usulga nisbatan 50-90% suv tejaydi — suvni to\'g\'ridan-to\'g\'ri ildiz zonasiga yetkazadi.',
        ),
        QuizQuestion(
          id: 'q10_2',
          question: 'Dronilar qishloq xo\'jaligida faqat pestitsid sepish uchun ishlatiladi.',
          type: QuestionType.trueFalse,
          options: ['To\'g\'ri', 'Noto\'g\'ri'],
          correctIndex: 1,
          explanation: 'Dronlar ko\'p maqsadlarda: monitoring, kasallik aniqlash, hosil hisobi, xaritalashtirish uchun ham ishlatiladi.',
        ),
        QuizQuestion(
          id: 'q10_3',
          question: 'Tuproq pH sensori nima o\'lchaydi?',
          type: QuestionType.multipleChoice,
          options: ['Namlik', 'Harorat', 'Kislotalik darajasi', 'Yorug\'lik'],
          correctIndex: 2,
          explanation: 'pH sensori tuproq kislotalik darajasini o\'lchaydi. Ko\'pgina o\'simliklar uchun optimal pH 6.0-7.0 oralig\'ida.',
        ),
        QuizQuestion(
          id: 'q10_4',
          question: 'Rasmda qaysi aqlli texnologiya ko\'rsatilgan?',
          type: QuestionType.imageChoice,
          options: ['Oddiy sug\'orish', 'Tomchilatib sug\'orish', 'Yomg\'ir sug\'orish', 'Yer osti sug\'orish'],
          correctIndex: 1,
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/Drip_irrigation_Afghanistan.jpg/320px-Drip_irrigation_Afghanistan.jpg',
          explanation: 'Rasmda tomchilatib sug\'orish (drip irrigation) ko\'rsatilgan — suv tejovchi zamonaviy texnologiya.',
        ),
        QuizQuestion(
          id: 'q10_5',
          question: 'Sun\'iy intellekt (AI) o\'simlik kasalliklarini qanday aniqlaydi?',
          type: QuestionType.multipleChoice,
          options: ['Hid orqali', 'Rasm tahlili orqali', 'Tuproq tahlili orqali', 'Ovoz orqali'],
          correctIndex: 1,
          explanation: 'AI konvolyutsion neyron tarmoq (CNN) yordamida o\'simlik rasmini tahlil qilib kasallik belgilarini aniqlaydi.',
        ),
      ],
    ),
  ];

  // ============================================================
  // NEWS DATA
  // ============================================================
  static List<NewsModel> get news => [
    NewsModel(
      id: 'news_01',
      title: 'O\'zbekistonda 3 ta yangi o\'simlik turi kashf etildi',
      summary: 'Botanika instituti olimlari Nurota tog\'larida ilmiy-tadqiqot ekspeditsiyasi davomida fan uchun yangi 3 ta o\'simlik turini kashf etishdi.',
      imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400',
      category: 'Kashfiyot',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      readTime: '3 daqiqa',
    ),
    NewsModel(
      id: 'news_02',
      title: 'Mars sayyorasida o\'simlik o\'stirish muvaffaqiyatli sinov',
      summary: 'NASA olimlari simulatsiya qilingan Mars tuproqida o\'simlik o\'stirishga muvaffaq bo\'lishdi. Bu kelajakdagi Mars missiyalari uchun muhim qadam.',
      imageUrl: 'https://images.unsplash.com/photo-1614728423169-3f65fd722b7e?w=400',
      category: 'Fan',
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      readTime: '5 daqiqa',
    ),
    NewsModel(
      id: 'news_03',
      title: 'Yashil shahar: Toshkentda 1 million daraxt ekish dasturi',
      summary: '2025-2026 yillarda Toshkent shahrida 1 million daraxt ekish rejalashtirilmoqda. Dastur shahardagi haroratni 2-3 gradusgа pasaytirishi kutilmoqda.',
      imageUrl: 'https://images.unsplash.com/photo-1476231682828-37e571bc172f?w=400',
      category: 'Ekologiya',
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      readTime: '4 daqiqa',
    ),
    NewsModel(
      id: 'news_04',
      title: 'Qizilqumda saksovul o\'rmoni tiklanish loyihasi',
      summary: 'O\'zbekiston hukumati hamkorligida 50,000 gektar cho\'l hududida saksovul o\'rmoni tiklash ishlari boshlandi. Cho\'llanishga qarshi kurashning yangi bosqichi.',
      imageUrl: 'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=400',
      category: 'Ekologiya',
      publishedAt: DateTime.now().subtract(const Duration(days: 4)),
      readTime: '4 daqiqa',
    ),
    NewsModel(
      id: 'news_05',
      title: 'Maktab laboratoriyalarida virtual botanika sinflari',
      summary: 'Xalq ta\'limi vazirligi maktablarda virtual reallik orqali botanika darslarini joriy etish rejasini e\'lon qildi. 500 ta maktabda sinov boshlanadi.',
      imageUrl: 'https://images.unsplash.com/photo-1532094349884-543559059f3c?w=400',
      category: 'Ta\'lim',
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      readTime: '3 daqiqa',
    ),
  ];

  // ============================================================
  // MOCK LEADERBOARD
  // ============================================================
  static List<LeaderboardEntry> get leaderboard => [
    LeaderboardEntry(userId: '1', fullName: 'Aziza Karimova', school: '1-maktab, Toshkent', grade: '9-sinf', score: 980, stars: 48, rankTitle: 'Master Botanik 🏆', rank: 1),
    LeaderboardEntry(userId: '2', fullName: 'Bobur Toshmatov', school: '15-maktab, Samarqand', grade: '10-sinf', score: 920, stars: 45, rankTitle: 'Master Botanik 🏆', rank: 2),
    LeaderboardEntry(userId: '3', fullName: 'Dilnoza Yusupova', school: '7-maktab, Andijon', grade: '9-sinf', score: 875, stars: 42, rankTitle: 'Ilg\'or O\'quvchi 🌟', rank: 3),
    LeaderboardEntry(userId: '4', fullName: 'Eldor Nazarov', school: '3-maktab, Namangan', grade: '8-sinf', score: 820, stars: 40, rankTitle: 'Ilg\'or O\'quvchi 🌟', rank: 4),
    LeaderboardEntry(userId: '5', fullName: 'Feruza Mirova', school: '22-maktab, Buxoro', grade: '10-sinf', score: 780, stars: 38, rankTitle: 'Ilg\'or O\'quvchi 🌟', rank: 5),
    LeaderboardEntry(userId: '6', fullName: 'G\'ayrat Sultonov', school: '5-maktab, Qo\'qon', grade: '9-sinf', score: 740, stars: 36, rankTitle: 'Ilg\'or O\'quvchi 🌟', rank: 6),
    LeaderboardEntry(userId: '7', fullName: 'Hulkar Abdullayeva', school: '12-maktab, Toshkent', grade: '8-sinf', score: 690, stars: 33, rankTitle: 'Ilg\'or O\'quvchi 🌟', rank: 7),
    LeaderboardEntry(userId: '8', fullName: 'Islom Hasanov', school: '8-maktab, Farg\'ona', grade: '10-sinf', score: 650, stars: 31, rankTitle: 'Ilg\'or O\'quvchi 🌟', rank: 8),
    LeaderboardEntry(userId: '9', fullName: 'Jasmin Rahimova', school: '19-maktab, Nukus', grade: '9-sinf', score: 580, stars: 28, rankTitle: 'Botanik Talaba 🌿', rank: 9),
    LeaderboardEntry(userId: '10', fullName: 'Kamol Ortiqov', school: '4-maktab, Termiz', grade: '8-sinf', score: 520, stars: 25, rankTitle: 'Botanik Talaba 🌿', rank: 10),
  ];
}
