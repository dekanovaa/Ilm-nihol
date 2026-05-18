import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../theme/app_theme.dart';

class BotanyGameScreen extends StatefulWidget {
  const BotanyGameScreen({super.key});

  @override
  State<BotanyGameScreen> createState() => _BotanyGameScreenState();
}

class _BotanyGameScreenState extends State<BotanyGameScreen> with TickerProviderStateMixin {
  int _idx = 0;
  int _score = 0;
  int _correctAnswers = 0;
  bool _finished = false;
  late PageController _pageController;
  
  // Timer related
  double _timerProgress = 1.0;
  Timer? _timer;
  final int _secondsPerQuestion = 15;

  final List<Map<String, dynamic>> _questions = [
    {
      'q': 'Fotosintez jarayoni uchun nima eng zarur?',
      'a': 'Quyosh nuri',
      'o': ['Quyosh nuri', 'Tuz', 'Yog\'och', 'Shakar'],
      'icon': '☀️',
      'color': const Color(0xFFF59E0B),
    },
    {
      'q': 'O\'simlikning qaysi qismi suvni tuproqdan shimadi?',
      'a': 'Ildiz',
      'o': ['Barg', 'Ildiz', 'Gultoj', 'Poya'],
      'icon': '🌱',
      'color': const Color(0xFF10B981),
    },
    {
      'q': 'Daraxtlarning yoshini qayerdan aniqlash mumkin?',
      'a': 'Yillik halqalardan',
      'o': ['Balandligidan', 'Yillik halqalardan', 'Barglaridan', 'Ildizidan'],
      'icon': '🌳',
      'color': const Color(0xFF78350F),
    },
    {
      'q': 'Dunyoga eng ko\'p kislorod beradigan nima?',
      'a': 'Okean o\'simliklari',
      'o': ['Amazonka o\'rmonlari', 'Okean o\'simliklari', 'Parklar', 'Bog\'lar'],
      'icon': '🌊',
      'color': const Color(0xFF3B82F6),
    },
    {
      'q': 'Eng tez o\'sadigan o\'simlik qaysi?',
      'a': 'Bambuk',
      'o': ['Eman', 'Bambuk', 'Atirgul', 'Bug\'doy'],
      'icon': '🎍',
      'color': const Color(0xFF059669),
    },
    {
      'q': 'O\'simlik hujayrasi devori nimadan iborat?',
      'a': 'Sellyuloza',
      'o': ['Oqsil', 'Sellyuloza', 'Yog\'', 'Shakar'],
      'icon': '🔬',
      'color': const Color(0xFF6366F1),
    },
    {
      'q': 'Qaysi gul Quyoshga qarab buriladi?',
      'a': 'Kungaboqar',
      'o': ['Lola', 'Atirgul', 'Kungaboqar', 'Moychechak'],
      'icon': '🌻',
      'color': const Color(0xFFFBBF24),
    },
    {
      'q': 'O\'simliklar nafas olganda qaysi gazni yutadi?',
      'a': 'Karbonat angidrid',
      'o': ['Kislorod', 'Vodorod', 'Karbonat angidrid', 'Azot'],
      'icon': '🌬️',
      'color': const Color(0xFF6B7280),
    },
    {
      'q': 'Eng katta urug\'li o\'simlik qaysi?',
      'a': 'Lodoitseya palmasi',
      'o': ['Yong\'oq', 'Lodoitseya palmasi', 'Qovoq', 'Tarvuz'],
      'icon': '🥥',
      'color': const Color(0xFF92400E),
    },
    {
      'q': 'O\'simlikning ko\'payish organi nima?',
      'a': 'Gul',
      'o': ['Barg', 'Gul', 'Ildiz', 'Tikan'],
      'icon': '🌸',
      'color': const Color(0xFFEC4899),
    },
    {
      'q': 'Cho\'l sharoitiga eng moslashgan o\'simlik?',
      'a': 'Kaktus',
      'o': ['Lola', 'Kaktus', 'Makkajo\'xori', 'Sholi'],
      'icon': '🌵',
      'color': const Color(0xFF065F46),
    },
    {
      'q': 'O\'simlik shirasining harakati nima deyiladi?',
      'a': 'Transpiratsiya',
      'o': ['Fotosintez', 'Transpiratsiya', 'Difuziya', 'Osmos'],
      'icon': '💧',
      'color': const Color(0xFF60A5FA),
    },
    {
      'q': 'Yirtqich o\'simlikni toping:',
      'a': 'Venera pashshaxo\'ri',
      'o': ['Moychechak', 'Venera pashshaxo\'ri', 'Kashnich', 'Rayhon'],
      'icon': '🦷',
      'color': const Color(0xFFDC2626),
    },
    {
      'q': 'Bargning yashil rangini nima ta\'minlaydi?',
      'a': 'Xlorofill',
      'o': ['Gemoglobin', 'Xlorofill', 'Melanin', 'Karotin'],
      'icon': '🍃',
      'color': const Color(0xFF22C55E),
    },
    {
      'q': 'Eng uzoq umr ko\'ruvchi daraxtlardan biri?',
      'a': 'Sekvoya',
      'o': ['Olma', 'Sekvoya', 'Tol', 'Terak'],
      'icon': '🏛️',
      'color': const Color(0xFF451A03),
    },
  ];

  @override
  void initState() {
    super.initState();
    _questions.shuffle();
    _pageController = PageController();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _timerProgress = 1.0);
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _timerProgress -= 0.1 / _secondsPerQuestion;
        if (_timerProgress <= 0) {
          _nextQuestion(false);
        }
      });
    });
  }

  void _nextQuestion(bool wasCorrect) {
    if (wasCorrect) {
      _score += (_timerProgress * 100).toInt() + 10;
      _correctAnswers++;
    }

    if (_idx < _questions.length - 1) {
      setState(() {
        _idx++;
        _timerProgress = 1.0;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      _startTimer();
    } else {
      _timer?.cancel();
      setState(() => _finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: c.textMuted),
                    style: IconButton.styleFrom(
                      backgroundColor: c.cardBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: c.cardBorder),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Botanika O'yini",
                          style: GoogleFonts.sora(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: c.textPrimary,
                          ),
                        ),
                        Text(
                          "Ball: $_score",
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: c.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: c.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${_idx + 1}/${_questions.length}",
                      style: GoogleFonts.sora(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: c.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LinearPercentIndicator(
                lineHeight: 6.0,
                percent: _timerProgress.clamp(0.0, 1.0),
                barRadius: const Radius.circular(3),
                progressColor: _timerProgress > 0.3 ? c.primary : c.errorRed,
                backgroundColor: c.cardBorder,
                padding: EdgeInsets.zero,
                animateFromLastPercent: true,
              ),
            ),

            const SizedBox(height: 20),

            // Question View
            Expanded(
              child: _finished 
                ? _buildResult() 
                : PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      final q = _questions[index];
                      return _buildQuestionCard(q);
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> q) {
    final c = context.colors;
    final options = q['o'] as List<String>;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: c.cardBg,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: c.cardBorder, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: q['color'].withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative background icon
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Text(
                      q['icon'],
                      style: TextStyle(fontSize: 180, color: q['color'].withOpacity(0.05)),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: q['color'].withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              q['icon'],
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          q['q'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sora(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: c.textPrimary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          ...options.map((opt) => _buildOptionButton(opt, q['a'], q['color'])),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option, String correctAnswer, Color accentColor) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () => _nextQuestion(option == correctAnswer),
          style: ElevatedButton.styleFrom(
            backgroundColor: c.cardBg,
            foregroundColor: c.textPrimary,
            elevation: 0,
            side: BorderSide(color: c.cardBorder, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: c.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + (_questions[_idx]['o'] as List).indexOf(option)),
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: c.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  option,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: c.textLight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    final c = context.colors;
    final percentage = (_correctAnswers / _questions.length * 100).toInt();
    
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: c.cardBg,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: c.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: c.primary.withOpacity(0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.emoji_events_rounded, color: Colors.orange, size: 100),
                const SizedBox(height: 20),
                Text(
                  "Tabriklaymiz!",
                  style: GoogleFonts.sora(fontSize: 28, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Text(
                  "Siz botanika bilimdoni ekansiz!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(fontSize: 16, color: c.textMuted),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildResultStat("To'g'ri", "$_correctAnswers", c.primary),
                    _buildResultStat("Ball", "$_score", Colors.orange),
                    _buildResultStat("Natija", "$percentage%", Colors.blue),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                "Yopish",
                style: GoogleFonts.sora(fontWeight: FontWeight.w800, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () {
              setState(() {
                _idx = 0;
                _score = 0;
                _correctAnswers = 0;
                _finished = false;
                _timerProgress = 1.0;
              });
              _pageController.jumpToPage(0);
              _startTimer();
            },
            child: Text(
              "Qaytadan boshlash",
              style: GoogleFonts.sora(
                color: c.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.sora(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: context.colors.textMuted,
          ),
        ),
      ],
    );
  }
}
