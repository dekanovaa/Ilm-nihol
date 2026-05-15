import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../models/app_provider.dart';

class QuizScreen extends StatefulWidget {
  final LessonModel lesson;
  const QuizScreen({super.key, required this.lesson});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _score = 0;
  bool _quizFinished = false;
  final List<int?> _userAnswers = [];

  late Timer _timer;
  int _timeLeft = 30;

  late AnimationController _slideCtrl;
  late AnimationController _shakeCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _userAnswers.addAll(List.filled(widget.lesson.questions.length, null));

    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _slideAnim = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _shakeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn));

    _slideCtrl.forward();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        if (!_answered) _selectAnswer(-1);
      }
    });
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    _timer.cancel();
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      _userAnswers[_currentIndex] = index;
    });

    final correct = widget.lesson.questions[_currentIndex].correctIndex;
    if (index == correct) {
      _score += (20 + (_timeLeft * 0.5)).round().clamp(10, 20);
    } else {
      _shakeCtrl.forward(from: 0);
    }
  }

  void _nextQuestion() async {
    if (_currentIndex < widget.lesson.questions.length - 1) {
      await _slideCtrl.reverse();
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
      _slideCtrl.forward();
      _startTimer();
    } else {
      _timer.cancel();
      setState(() => _quizFinished = true);
      final finalScore = (_score / (widget.lesson.questions.length * 20) * 100)
          .round()
          .clamp(0, 100);
      await context
          .read<AppProvider>()
          .completeLessonWithScore(widget.lesson.id, finalScore);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _slideCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_quizFinished)
      return _ResultScreen(
        lesson: widget.lesson,
        score: (_score / (widget.lesson.questions.length * 20) * 100)
            .round()
            .clamp(0, 100),
        userAnswers: _userAnswers,
        onRetry: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => QuizScreen(lesson: widget.lesson))),
        onBack: () => Navigator.pop(context),
      );

    final question = widget.lesson.questions[_currentIndex];
    final progress = (_currentIndex + 1) / widget.lesson.questions.length;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close_rounded,
                        color: context.colors.textSecondary),
                    onPressed: () => _confirmExit(context),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${_currentIndex + 1}',
                                style: GoogleFonts.sora(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: context.colors.textPrimary)),
                            Text(' / ${widget.lesson.questions.length}',
                                style: GoogleFonts.sora(
                                    fontSize: 16, color: context.colors.textMuted)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: context.colors.cardBorder,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                context.colors.primary),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _TimerWidget(timeLeft: _timeLeft),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: context.colors.cardBg,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: context.colors.cardBorder),
                ),
                child: SlideTransition(
                  position: _slideAnim,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _QuestionTypeBadge(type: question.type),
                        const SizedBox(height: 16),
                        if (question.imageUrl != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              question.imageUrl!,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color:
                                      context.colors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                    child: Icon(Icons.image_not_supported_rounded,
                                        size: 48, color: Colors.grey)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        Text(question.question,
                            style: GoogleFonts.nunito(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPrimary,
                                height: 1.4)),
                        const SizedBox(height: 24),
                        AnimatedBuilder(
                          animation: _shakeAnim,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(
                                _answered &&
                                        _selectedAnswer != question.correctIndex
                                    ? 8 * (0.5 - _shakeAnim.value).abs()
                                    : 0,
                                0),
                            child: child,
                          ),
                          child: Column(
                            children: List.generate(
                              question.options.length,
                              (i) => _AnswerOption(
                                text: question.options[i],
                                index: i,
                                selected: _selectedAnswer,
                                correct:
                                    _answered ? question.correctIndex : null,
                                onTap: () => _selectAnswer(i),
                              ),
                            ),
                          ),
                        ),
                        if (_answered) ...[
                          const SizedBox(height: 16),
                          _ExplanationCard(
                            isCorrect: _selectedAnswer == question.correctIndex,
                            text: question.explanation,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _nextQuestion,
                              child: Text(
                                  _currentIndex <
                                          widget.lesson.questions.length - 1
                                      ? 'Keyingi savol'
                                      : 'Natijani ko\'rish',
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmExit(BuildContext ctx) {
    _timer.cancel();
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: context.colors.cardBg,
        title: Text('Testdan chiqish?',
            style: GoogleFonts.sora(
                fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
        content: Text('Progress saqlanmaydi.',
            style: GoogleFonts.nunito(color: context.colors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _startTimer();
              },
              child: Text('Davom etish',
                  style: GoogleFonts.nunito(color: context.colors.primary))),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(ctx);
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: context.colors.errorRed),
              child:
                  const Text('Chiqish', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}

class _TimerWidget extends StatelessWidget {
  final int timeLeft;
  const _TimerWidget({required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    final color = timeLeft > 15
        ? context.colors.successGreen
        : timeLeft > 7
            ? context.colors.warningYellow
            : context.colors.errorRed;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text('$timeLeft',
            style: GoogleFonts.sora(
                fontSize: 14, fontWeight: FontWeight.w700, color: color)),
      ),
    );
  }
}

class _QuestionTypeBadge extends StatelessWidget {
  final QuestionType type;
  const _QuestionTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String label;
    Color color;
    switch (type) {
      case QuestionType.multipleChoice:
        icon = Icons.radio_button_checked_rounded;
        label = 'Ko\'p tanlovli';
        color = context.colors.primary;
      case QuestionType.trueFalse:
        icon = Icons.check_circle_outline_rounded;
        label = 'To\'g\'ri/Noto\'g\'ri';
        color = context.colors.accentOrange;
      case QuestionType.imageChoice:
        icon = Icons.image_rounded;
        label = 'Rasmli savol';
        color = context.colors.accentPink;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon as IconData, color: color, size: 14),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
      ]),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String text;
  final int index;
  final int? selected;
  final int? correct;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.text,
    required this.index,
    required this.selected,
    required this.correct,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == index;
    final isCorrect = correct == index;
    final isWrong = isSelected && correct != null && correct != index;

    Color bg = context.colors.surface;
    Color border = context.colors.cardBorder;
    Color textColor = context.colors.textPrimary;
    IconData? icon;

    if (isCorrect && correct != null) {
      bg = context.colors.successGreen.withValues(alpha: 0.1);
      border = context.colors.successGreen;
      textColor = context.colors.successGreen;
      icon = Icons.check_circle_rounded;
    } else if (isWrong) {
      bg = context.colors.errorRed.withValues(alpha: 0.1);
      border = context.colors.errorRed;
      textColor = context.colors.errorRed;
      icon = Icons.cancel_rounded;
    } else if (isSelected) {
      bg = context.colors.primary.withValues(alpha: 0.08);
      border = context.colors.primary;
      textColor = context.colors.primary;
    }

    final labels = ['A', 'B', 'C', 'D'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: border,
                width: isSelected || (isCorrect && correct != null) ? 2 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: border.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: icon != null
                      ? Icon(icon, color: border, size: 18)
                      : Text(
                          index < labels.length
                              ? labels[index]
                              : '${index + 1}',
                          style: GoogleFonts.sora(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: border)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(text,
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  final bool isCorrect;
  final String text;
  const _ExplanationCard({required this.isCorrect, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? context.colors.successGreen : context.colors.errorRed;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isCorrect ? Icons.check_circle_rounded : Icons.info_outline_rounded,
              color: color, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isCorrect ? 'To\'g\'ri javob!' : 'Izoh:',
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        color: color,
                        fontSize: 13)),
                const SizedBox(height: 4),
                Text(text,
                    style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: context.colors.textSecondary,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Result Screen
class _ResultScreen extends StatelessWidget {
  final LessonModel lesson;
  final int score;
  final List<int?> userAnswers;
  final VoidCallback onRetry, onBack;

  const _ResultScreen({
    required this.lesson,
    required this.score,
    required this.userAnswers,
    required this.onRetry,
    required this.onBack,
  });

  int get _stars => score >= 80
      ? 3
      : score >= 60
          ? 2
          : score >= 40
              ? 1
              : 0;
  int get _correct => List.generate(lesson.questions.length,
          (i) => userAnswers[i] == lesson.questions[i].correctIndex ? 1 : 0)
      .fold(0, (a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    final isGood = score >= 80;
    final hasCert = score >= 80;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
                  Icon(
                    isGood
                        ? Icons.emoji_events
                        : score >= 60
                            ? Icons.thumb_up
                            : Icons.fitness_center,
                    size: 80, color: isGood ? context.colors.gold : context.colors.primary,
                  ),
              const SizedBox(height: 16),
              Text(
                  isGood
                      ? 'Ajoyib!'
                      : score >= 60
                          ? 'Yaxshi!'
                          : 'Davom eting!',
                  style: GoogleFonts.sora(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: context.colors.textPrimary)),
              const SizedBox(height: 8),
              Text(lesson.title,
                  style: GoogleFonts.nunito(
                      fontSize: 14, color: context.colors.textMuted)),
              const SizedBox(height: 24),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.primary.withValues(alpha: 0.08),
                  border: Border.all(
                      color: context.colors.primary.withValues(alpha: 0.3),
                      width: 2),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$score',
                          style: GoogleFonts.sora(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: context.colors.primary)),
                      Text('/ 100',
                          style: GoogleFonts.sora(
                              fontSize: 14, color: context.colors.textMuted)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    3,
                    (i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                              i < _stars
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: context.colors.starColor,
                              size: 36),
                        )),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.colors.cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: context.colors.cardBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                        icon: Icons.check_circle_rounded, color: context.colors.successGreen, value: '$_correct', label: 'To\'g\'ri'),
                    _StatItem(
                        icon: Icons.cancel_rounded, color: context.colors.errorRed,
                        value: '${lesson.questions.length - _correct}',
                        label: 'Noto\'g\'ri'),
                    _StatItem(
                        icon: Icons.bar_chart_rounded, color: context.colors.primary,
                        value: '${lesson.questions.length}',
                        label: 'Jami'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (hasCert)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.workspace_premium, color: Colors.white, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sertifikat olindi!',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: Colors.white)),
                            Text('Profilingizda ko\'rishingiz mumkin',
                                style: GoogleFonts.nunito(
                                    fontSize: 11, color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onBack,
                  child: Text('Darsga qaytish',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onRetry,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.colors.textPrimary,
                    side: BorderSide(color: context.colors.cardBorder),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Qayta ishlash',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value, label;
  const _StatItem(
      {required this.icon, required this.color, required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.sora(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary)),
          Text(label,
              style:
                  GoogleFonts.nunito(fontSize: 11, color: context.colors.textMuted)),
        ],
      );
}