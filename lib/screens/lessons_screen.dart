import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/app_provider.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import 'quiz_screen.dart';

// ════════════════════════════════════════════════════════════
// LESSONS LIST SCREEN
// ════════════════════════════════════════════════════════════
class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});
  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  String _filter = 'Barchasi';
  final _filters = ['Barchasi', 'Oson', "O'rta", 'Qiyin'];
  bool _showSearch = false;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().currentUser;
    final allLessons = AppData.lessons;
    final c = context.colors;

    // 1. Qiyinchilik filtri
    var lessons = _filter == 'Barchasi' ? allLessons : allLessons.where((l) => l.difficulty == _filter).toList();
    // 2. Qidiruv filtri
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      lessons = lessons.where((l) => l.title.toLowerCase().contains(q) || l.subtitle.toLowerCase().contains(q) || l.steamTag.toLowerCase().contains(q)).toList();
    }

    final completed = user?.completedLessons.length ?? 0;
    final progress = allLessons.isEmpty ? 0.0 : completed / allLessons.length;

    return Scaffold(
      backgroundColor: c.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true, backgroundColor: c.background,
            surfaceTintColor: Colors.transparent, elevation: 0,
            title: _showSearch
                ? TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: GoogleFonts.sora(fontSize: 14, color: c.textPrimary),
                    decoration: InputDecoration(
                      hintText: "Dars qidirish...",
                      hintStyle: GoogleFonts.nunito(color: c.textMuted, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Darslar', style: Theme.of(context).textTheme.displaySmall),
                    Text('${allLessons.length} ta mavzu', style: GoogleFonts.nunito(fontSize: 12, color: c.textMuted)),
                  ]),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(color: _showSearch ? c.primary.withValues(alpha: 0.12) : c.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _showSearch ? c.primary : c.cardBorder)),
                child: IconButton(
                  icon: Icon(_showSearch ? Icons.close_rounded : Icons.search_rounded, color: _showSearch ? c.primary : c.textSecondary, size: 20),
                  onPressed: () => setState(() {
                    _showSearch = !_showSearch;
                    if (!_showSearch) {
                      _searchQuery = '';
                      _searchCtrl.clear();
                    }
                  }),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Progress strip
                _ProgressStrip(progress: progress, completed: completed, total: allLessons.length),
                const SizedBox(height: 14),
                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((f) {
                      final on = _filter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _filter = f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: on ? c.primary : c.cardBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: on ? c.primary : c.cardBorder, width: 1.5),
                              boxShadow: on ? [BoxShadow(color: c.primary.withValues(alpha: 0.26), blurRadius: 10, offset: const Offset(0, 3))] : [],
                            ),
                            child: Text(f, style: GoogleFonts.sora(color: on ? Colors.white : c.textMuted, fontWeight: FontWeight.w700, fontSize: 12)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                if (i == lessons.length) {
                  // No results message
                  return _searchQuery.isNotEmpty && lessons.isEmpty
                      ? null
                      : null;
                }
                final lesson = lessons[i];
                final isCompleted = user?.completedLessons.contains(lesson.id) ?? false;
                final score = user?.lessonScores[lesson.id] ?? 0;
                final hasCert = user?.certificates.contains(lesson.id) ?? false;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                  child: _LessonCard(lesson: lesson, isCompleted: isCompleted, score: score, hasCertificate: hasCert,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonDetailScreen(lesson: lesson)))),
                );
              },
              childCount: lessons.length,
            ),
          ),
          if (_searchQuery.isNotEmpty && lessons.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('🔍', style: TextStyle(fontSize: 52)),
                  const SizedBox(height: 16),
                  Text("'$_searchQuery' bo'yicha dars topilmadi", style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w700, color: c.textPrimary), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text("Boshqa kalit so'z bilan qidiring", style: GoogleFonts.nunito(fontSize: 13, color: c.textMuted)),
                ]),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _ProgressStrip extends StatelessWidget {
  final double progress;
  final int completed, total;
  const _ProgressStrip({required this.progress, required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final pct = (progress * 100).round();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: c.cardBorder)),
      child: Row(children: [
        SizedBox(width: 66, height: 66, child: Stack(alignment: Alignment.center, children: [
          Transform.rotate(angle: -1.5708, child: CustomPaint(
            size: const Size(66, 66),
            painter: _CirclePainter(progress: progress.clamp(0.0, 1.0), bgColor: c.cardBorder, fgColor: c.primary, strokeWidth: 5),
          )),
          Text('$pct%', style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.w800, color: c.primary)),
        ])),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Umumiy jarayon', style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w700, color: c.textPrimary)),
          const SizedBox(height: 3),
          Text('$completed/$total dars tugatildi', style: GoogleFonts.nunito(fontSize: 11, color: c.textMuted)),
          const SizedBox(height: 9),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0), minHeight: 6,
            backgroundColor: c.cardBorder,
            valueColor: AlwaysStoppedAnimation<Color>(c.primary),
          )),
        ])),
      ]),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress, strokeWidth;
  final Color bgColor, fgColor;
  const _CirclePainter({required this.progress, required this.bgColor, required this.fgColor, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = (size.width - strokeWidth) / 2;
    final paint = Paint()..strokeWidth = strokeWidth..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    paint.color = bgColor;
    canvas.drawCircle(c, r, paint);
    paint.color = fgColor;
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), 0, 2 * 3.14159 * progress, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final bool isCompleted, hasCertificate;
  final int score;
  final VoidCallback onTap;
  const _LessonCard({required this.lesson, required this.isCompleted, required this.score, required this.hasCertificate, required this.onTap});

  Color _diffColor(BuildContext context) {
    switch (lesson.difficulty) {
      case 'Oson': return context.colors.successGreen;
      case 'Qiyin': return context.colors.errorRed;
      default: return context.colors.warningYellow;
    }
  }

  int get _stars => score >= 80 ? 3 : score >= 60 ? 2 : score >= 40 ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final steamColor = lesson.getSteamColor(context);
    return Container(
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isCompleted ? c.primary.withValues(alpha: 0.25) : c.cardBorder),
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [BoxShadow(color: c.primary.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))]
            : [],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20), onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(children: [
            Row(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: steamColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: steamColor.withValues(alpha: 0.22)),
                ),
                child: Center(child: Text(lesson.emoji, style: const TextStyle(fontSize: 26))),
              ),
              const SizedBox(width: 13),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  _Tag(lesson.steamTag, steamColor),
                  const SizedBox(width: 5),
                  _Tag(lesson.difficulty, _diffColor(context)),
                  if (hasCertificate) ...[const SizedBox(width: 4), const Icon(Icons.workspace_premium_rounded, size: 14, color: Color(0xFFD97706))],
                ]),
                const SizedBox(height: 5),
                Text(lesson.title, style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w800, color: c.textPrimary, letterSpacing: -0.1)),
                const SizedBox(height: 2),
                Text(lesson.subtitle, style: GoogleFonts.nunito(fontSize: 11, color: c.textMuted)),
                if (isCompleted) ...[
                  const SizedBox(height: 6),
                  Row(children: [
                    ...List.generate(3, (i) => Icon(i < _stars ? Icons.star_rounded : Icons.star_outline_rounded, color: c.starColor, size: 14)),
                    const SizedBox(width: 6),
                    Text('$score/100', style: GoogleFonts.sora(fontSize: 10, color: c.textMuted, fontWeight: FontWeight.w600)),
                  ]),
                ],
              ])),
              const SizedBox(width: 8),
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: isCompleted ? c.successGreen.withValues(alpha: 0.12) : c.cardBorder.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(isCompleted ? Icons.check_rounded : Icons.arrow_forward_ios_rounded, color: isCompleted ? c.successGreen : c.textLight, size: isCompleted ? 17 : 12),
              ),
            ]),
            if (isCompleted) ...[
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(
                  value: score / 100, minHeight: 4,
                  backgroundColor: c.cardBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(c.primary),
                ))),
                const SizedBox(width: 9),
                Text('$score%', style: GoogleFonts.sora(fontSize: 10.5, fontWeight: FontWeight.w700, color: c.primary)),
              ]),
            ],
          ]),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag(this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
    child: Text(text, style: GoogleFonts.sora(fontSize: 8.5, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.2)),
  );
}

// ════════════════════════════════════════════════════════════
// LESSON DETAIL SCREEN
// ════════════════════════════════════════════════════════════
class LessonDetailScreen extends StatefulWidget {
  final LessonModel lesson;
  const LessonDetailScreen({super.key, required this.lesson});
  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() { super.initState(); _tab = TabController(length: 4, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final user = context.watch<AppProvider>().currentUser;
    final isCompleted = user?.completedLessons.contains(lesson.id) ?? false;
    final score = user?.lessonScores[lesson.id] ?? 0;
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            expandedHeight: 200, pinned: true,
            backgroundColor: c.surface, surfaceTintColor: Colors.transparent,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 17), onPressed: () => Navigator.pop(context), padding: EdgeInsets.zero),
            ),
            actions: [
              if (isCompleted) Container(
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF15803D), lesson.getSteamColor(context).withValues(alpha: 0.8)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 52, 18, 18),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                    Row(children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white.withValues(alpha: 0.3))),
                        child: Center(child: Text(lesson.emoji, style: const TextStyle(fontSize: 28))),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${lesson.steamTag} · ${lesson.difficulty}', style: GoogleFonts.sora(fontSize: 9.5, color: Colors.white.withValues(alpha: 0.78), fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        Text(lesson.title, style: GoogleFonts.sora(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.2)),
                        Text(lesson.subtitle, style: GoogleFonts.nunito(fontSize: 12, color: Colors.white.withValues(alpha: 0.72))),
                      ])),
                    ]),
                    if (isCompleted) ...[
                      const SizedBox(height: 10),
                      Row(children: [
                        ...List.generate(3, (i) { final s = score >= 80 ? 3 : score >= 60 ? 2 : score >= 40 ? 1 : 0; return Icon(i < s ? Icons.star_rounded : Icons.star_outline_rounded, color: const Color(0xFFFBBF24), size: 18); }),
                        const SizedBox(width: 8),
                        Text('$score/100', style: GoogleFonts.sora(fontSize: 11, color: Colors.white.withValues(alpha: 0.88), fontWeight: FontWeight.w600)),
                      ]),
                    ],
                  ]),
                )),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Container(
                color: c.surface,
                child: TabBar(
                  controller: _tab,
                  labelColor: c.primary,
                  unselectedLabelColor: c.textMuted,
                  indicatorColor: c.primary,
                  indicatorWeight: 2.5,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: c.cardBorder,
                  labelStyle: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(icon: Icon(Icons.menu_book_rounded, size: 18), text: 'Matn', height: 52),
                    Tab(icon: Icon(Icons.play_circle_rounded, size: 18), text: 'Video', height: 52),
                    Tab(icon: Icon(Icons.quiz_rounded, size: 18), text: 'Test', height: 52),
                    Tab(icon: Icon(Icons.functions_rounded, size: 18), text: 'Formula', height: 52),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: [
            _TextTab(lesson: lesson),
            _VideoTab(lesson: lesson),
            _QuizTab(lesson: lesson),
            _LessonFormulasTab(lesson: lesson),
          ],
        ),
      ),
    );
  }
}

// ── TEXT TAB ──────────────────────────────────────────────
class _TextTab extends StatelessWidget {
  final LessonModel lesson;
  const _TextTab({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: c.cardBorder)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.menu_book_outlined, color: c.primary, size: 16),
              const SizedBox(width: 8),
              Text("O'QUV MATERIALI", style: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.w700, color: c.primary, letterSpacing: 0.5)),
            ]),
            const SizedBox(height: 14),
            _RichText(text: lesson.description),
          ]),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.primary.withValues(alpha: 0.18))),
          child: Row(children: [
            Icon(Icons.lightbulb_outline_rounded, color: c.primary, size: 20),
            const SizedBox(width: 11),
            Expanded(child: Text("Bilimingizni sinash uchun Test bo'limiga o'ting!", style: GoogleFonts.nunito(fontSize: 13, color: c.textPrimary, fontWeight: FontWeight.w600))),
            Icon(Icons.arrow_forward_rounded, color: c.primary, size: 16),
          ]),
        ),
      ]),
    );
  }
}

class _RichText extends StatelessWidget {
  final String text;
  const _RichText({required this.text});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: text.split('\n').map((line) {
        if (line.startsWith('**') && line.endsWith('**')) {
          return Padding(padding: const EdgeInsets.only(top: 12, bottom: 4), child: Text(line.replaceAll('**', ''), style: GoogleFonts.sora(fontSize: 13.5, fontWeight: FontWeight.w800, color: c.primary)));
        }
        if (line.startsWith('•') || line.startsWith('✦') || line.startsWith('✅') || line.startsWith('⚠️')) {
          return Padding(padding: const EdgeInsets.only(top: 5), child: Text(line, style: GoogleFonts.nunito(fontSize: 13, color: c.textPrimary, height: 1.55)));
        }
        return Padding(padding: const EdgeInsets.only(top: 4), child: Text(line, style: GoogleFonts.nunito(fontSize: 13, color: c.textSecondary, height: 1.65)));
      }).toList(),
    );
  }
}

// ── VIDEO TAB ─────────────────────────────────────────────
class _VideoTab extends StatelessWidget {
  final LessonModel lesson;
  const _VideoTab({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 192, width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF15803D), Color(0xFF22C55E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(alignment: Alignment.center, children: [
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text(lesson.emoji, style: const TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              Text(lesson.title, style: GoogleFonts.sora(color: Colors.white.withValues(alpha: 0.88), fontSize: 13, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
            ]),
            GestureDetector(
              onTap: () => _launch(context),
              child: Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.5), blurRadius: 22)]),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: c.cardBorder)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 34, height: 34, decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.play_circle_rounded, color: Colors.red, size: 18)),
              const SizedBox(width: 10),
              Text('YouTube dars', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 14, color: c.textPrimary)),
            ]),
            const SizedBox(height: 8),
            Text(lesson.title, style: GoogleFonts.sora(fontSize: 13.5, fontWeight: FontWeight.w700, color: c.textPrimary)),
            const SizedBox(height: 4),
            Text(lesson.youtubeUrl, style: GoogleFonts.nunito(fontSize: 10, color: c.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launch(context),
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text("YouTube'da ko'rish"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  void _launch(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('YouTube: ${lesson.youtubeUrl}'), action: SnackBarAction(label: 'OK', onPressed: () {})));
  }
}

// ── QUIZ TAB ──────────────────────────────────────────────
class _QuizTab extends StatelessWidget {
  final LessonModel lesson;
  const _QuizTab({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().currentUser;
    final score = user?.lessonScores[lesson.id] ?? 0;
    final isCompleted = user?.completedLessons.contains(lesson.id) ?? false;
    final hasCert = user?.certificates.contains(lesson.id) ?? false;
    final c = context.colors;
    final stars = score >= 80 ? 3 : score >= 60 ? 2 : score >= 40 ? 1 : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(children: [
        if (isCompleted) ...[
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: (score >= 80 ? c.successGreen : score >= 60 ? c.warningYellow : c.errorRed).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: (score >= 80 ? c.successGreen : score >= 60 ? c.warningYellow : c.errorRed).withValues(alpha: 0.28)),
            ),
            child: Row(children: [
              Text(score >= 80 ? '🎉' : score >= 60 ? '👍' : '💪', style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(score >= 80 ? 'Ajoyib natija!' : score >= 60 ? 'Yaxshi ishlash!' : 'Davom eting!', style: GoogleFonts.sora(fontWeight: FontWeight.w700, color: c.textPrimary, fontSize: 14)),
                const SizedBox(height: 4),
                Row(children: [
                  ...List.generate(3, (i) => Icon(i < stars ? Icons.star_rounded : Icons.star_outline_rounded, color: c.starColor, size: 16)),
                  const SizedBox(width: 7),
                  Text('$score/100', style: GoogleFonts.sora(fontSize: 11, color: c.textMuted, fontWeight: FontWeight.w600)),
                ]),
                if (hasCert) Row(children: [Icon(Icons.workspace_premium_rounded, color: c.gold, size: 15), const SizedBox(width: 4), Text('Sertifikat olindi!', style: GoogleFonts.sora(fontSize: 11, color: c.primary, fontWeight: FontWeight.w700))]),
              ])),
            ]),
          ),
          const SizedBox(height: 14),
        ],
        Container(
          width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [c.cardBg, c.primary.withValues(alpha: 0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.primary.withValues(alpha: 0.2)),
          ),
          child: Column(children: [
            const Text('📝', style: TextStyle(fontSize: 46)),
            const SizedBox(height: 10),
            Text('Test', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 5),
            Text('${lesson.questions.length} ta savol', style: GoogleFonts.nunito(color: c.textMuted, fontSize: 13)),
            const SizedBox(height: 14),
            Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
              _InfoBadge(Icons.timer_outlined, '${lesson.questions.length * 30} soniya', c.primary),
              _InfoBadge(Icons.bolt_rounded, '${lesson.maxScore} ball', c.accentOrange),
              _InfoBadge(Icons.star_outline_rounded, '80% → 3 yulduz', c.starColor),
            ]),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen(lesson: lesson))),
                child: Text(isCompleted ? 'Qayta ishlash' : 'Testni boshlash', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: c.cardBorder)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Savol turlari', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 14, color: c.textPrimary)),
            const SizedBox(height: 11),
            ..._types(lesson.questions).map((t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
              Icon(t['icon'] as IconData, color: c.primary, size: 17),
              const SizedBox(width: 10),
              Text(t['label'] as String, style: GoogleFonts.nunito(fontSize: 13, color: c.textPrimary)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(7)), child: Text('${t['count']} ta', style: GoogleFonts.sora(fontSize: 10, color: c.primary, fontWeight: FontWeight.w700))),
            ]))),
          ]),
        ),
      ]),
    );
  }

  List<Map<String, dynamic>> _types(List<QuizQuestion> qs) {
    int mc = qs.where((q) => q.type == QuestionType.multipleChoice).length;
    int tf = qs.where((q) => q.type == QuestionType.trueFalse).length;
    int img = qs.where((q) => q.type == QuestionType.imageChoice).length;
    return [
      if (mc > 0) {'icon': Icons.radio_button_checked_rounded, 'label': "Ko'p tanlovli", 'count': mc},
      if (tf > 0) {'icon': Icons.check_circle_outline_rounded, 'label': "To'g'ri/Noto'g'ri", 'count': tf},
      if (img > 0) {'icon': Icons.image_outlined, 'label': 'Rasmli savol', 'count': img},
    ];
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoBadge(this.icon, this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.18))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: 13),
      const SizedBox(width: 5),
      Text(text, style: GoogleFonts.sora(fontSize: 11, color: context.colors.textPrimary, fontWeight: FontWeight.w600)),
    ]),
  );
}


// ════════════════════════════════════════════════════════════
// LESSON FORMULAS TAB — mavzuga mos formulalar + kalkulyator
// ════════════════════════════════════════════════════════════
class _LessonFormulasTab extends StatefulWidget {
  final LessonModel lesson;
  const _LessonFormulasTab({required this.lesson});
  @override
  State<_LessonFormulasTab> createState() => _LessonFormulasTabState();
}

class _LessonFormulasTabState extends State<_LessonFormulasTab>
    with SingleTickerProviderStateMixin {
  late TabController _innerTab;

  @override
  void initState() {
    super.initState();
    _innerTab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _innerTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final formulas = _getFormulasForLesson(widget.lesson);

    return Column(children: [
      Container(
        color: c.surface,
        child: TabBar(
          controller: _innerTab,
          labelColor: c.primary,
          unselectedLabelColor: c.textMuted,
          indicatorColor: c.primary,
          indicatorWeight: 2.5,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: c.cardBorder,
          labelStyle: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: '📐 Formulalar'),
            Tab(text: '🔢 Kalkulyator'),
          ],
        ),
      ),
      Expanded(
        child: TabBarView(
          controller: _innerTab,
          children: [
            _FormulasList(formulas: formulas, lesson: widget.lesson),
            _LessonCalcPanel(lesson: widget.lesson),
          ],
        ),
      ),
    ]);
  }

  List<_LessonFormula> _getFormulasForLesson(LessonModel lesson) {
    final tag = lesson.steamTag.toUpperCase();
    final title = lesson.title.toLowerCase();
    final List<_LessonFormula> result = [];

    // Fotosintez formulalari
    if (tag == 'SCIENCE' && (title.contains('fotosintez') || title.contains('hujayra') || title.contains('barg'))) {
      result.addAll([
        _LessonFormula(
          name: 'Asosiy fotosintez reaksiyasi',
          formula: '6CO₂ + 6H₂O + nur → C₆H₁₂O₆ + 6O₂',
          description: "O'simlik karbonat angidrid va suvdan glyukoza va kislorod hosil qiladi.",
          color: const Color(0xFF16A34A), emoji: '🌿',
        ),
        _LessonFormula(
          name: 'Fotosintez samaradorligi',
          formula: 'η = (ΔG / E_nur) × 100%',
          description: "Fotosintez samaradorligini foizda hisoblaydi.",
          color: const Color(0xFF16A34A), emoji: '⚡',
        ),
      ]);
    }

    // O'sish formulalari
    if (title.contains("o'sish") || title.contains('rivojlanish') || title.contains('ildiz')) {
      result.addAll([
        _LessonFormula(
          name: "Nisbiy o'sish tezligi (RGR)",
          formula: 'RGR = (ln W₂ − ln W₁) / (t₂ − t₁)',
          description: "O'simlikning biomassa to'plash tezligi.",
          color: const Color(0xFF0284C7), emoji: '🌱',
        ),
        _LessonFormula(
          name: 'Barglar maydoni indeksi (LAI)',
          formula: 'LAI = ΣA_barg / A_tuproq',
          description: "Tuproq maydoniga nisbatan barglar umumiy maydoni.",
          color: const Color(0xFF0284C7), emoji: '🍃',
        ),
      ]);
    }

    // Ekologiya formulalari
    if (tag == 'ECOLOGY' || title.contains('ekotizim') || title.contains('populyatsiya')) {
      result.addAll([
        _LessonFormula(
          name: 'Populyatsiya zichligi',
          formula: 'D = N / A',
          description: "Birlik maydondagi individlar soni.",
          color: const Color(0xFF7C3AED), emoji: '🌳',
        ),
        _LessonFormula(
          name: "Shanon xilma-xillik indeksi",
          formula: "H' = −Σ (pᵢ × ln pᵢ)",
          description: "Ekosistemdagi o'simlik turlarining xilma-xillik darajasi.",
          color: const Color(0xFF7C3AED), emoji: '🌍',
        ),
      ]);
    }

    // Suv va transpiratsiya
    if (title.contains('barg') || title.contains('transpiratsiya') || title.contains('suv')) {
      result.addAll([
        _LessonFormula(
          name: 'Transpiratsiya samaradorligi (TE)',
          formula: 'TE = ΔBiomassa / ΔSuv',
          description: "Sarflangan suv hisobiga hosil bo'lgan biomassa.",
          color: const Color(0xFF0891B2), emoji: '💧',
        ),
        _LessonFormula(
          name: "Suv potentsiali",
          formula: 'Ψ = Ψs + Ψp',
          description: "Hujayradagi umumiy suv potentsiali.",
          color: const Color(0xFF0891B2), emoji: '🔬',
        ),
      ]);
    }

    // Math — Fibonacci
    if (tag == 'MATH' || title.contains('fibonacci') || title.contains('raqam')) {
      result.addAll([
        _LessonFormula(
          name: 'Fibonacci qatori',
          formula: 'Fₙ = Fₙ₋₁ + Fₙ₋₂',
          description: "Har son avvalgi ikki sonning yig'indisi: 1,1,2,3,5,8,13...",
          color: const Color(0xFFF59E0B), emoji: '🐚',
        ),
        _LessonFormula(
          name: 'Oltin nisbat',
          formula: 'Φ = (1 + √5) / 2 ≈ 1.618',
          description: "Fibonacci qatorida qo'shni sonlar nisbatining limiti.",
          color: const Color(0xFFF59E0B), emoji: '✨',
        ),
      ]);
    }

    // Ko'payish formulalari
    if (title.contains("ko'payish") || title.contains('gul') || title.contains("urug'")) {
      result.addAll([
        _LessonFormula(
          name: "Logistik o'sish modeli",
          formula: 'dN/dt = rN × (K − N) / K',
          description: "Populyatsiya ekologik sig'im chegarasiga yaqinlashganda o'sishi.",
          color: const Color(0xFFDB2777), emoji: '🌸',
        ),
      ]);
    }

    // Agar hech narsa topilmasa — umumiy formulalar
    if (result.isEmpty) {
      result.addAll([
        _LessonFormula(
          name: 'Populyatsiya zichligi',
          formula: 'D = N / A',
          description: "Birlik maydondagi individlar soni.",
          color: const Color(0xFF7C3AED), emoji: '🌳',
        ),
        _LessonFormula(
          name: 'Transpiratsiya samaradorligi',
          formula: 'TE = ΔBiomassa / ΔSuv',
          description: "Sarflangan suv hisobiga hosil bo'lgan biomassa.",
          color: const Color(0xFF0891B2), emoji: '💧',
        ),
        _LessonFormula(
          name: "Nisbiy o'sish tezligi (RGR)",
          formula: 'RGR = (ln W₂ − ln W₁) / (t₂ − t₁)',
          description: "O'simlikning biomassa to'plash tezligi.",
          color: const Color(0xFF0284C7), emoji: '🌱',
        ),
      ]);
    }

    return result;
  }
}

class _LessonFormula {
  final String name, formula, description, emoji;
  final Color color;
  const _LessonFormula({
    required this.name, required this.formula,
    required this.description, required this.emoji, required this.color,
  });
}

// ── Formulalar ro'yxati ──────────────────────────────────
class _FormulasList extends StatelessWidget {
  final List<_LessonFormula> formulas;
  final LessonModel lesson;
  const _FormulasList({required this.formulas, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [c.primary, c.primaryDark],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('"${lesson.title}"',
                  style: GoogleFonts.sora(fontSize: 11, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Text('Mavzuga mos formulalar',
                  style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
                child: Text('${formulas.length} ta formula',
                    style: GoogleFonts.sora(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ])),
            const Text('📐', style: TextStyle(fontSize: 42)),
          ]),
        ),
        const SizedBox(height: 16),
        ...formulas.map((f) => _LessonFormulaCard(formula: f)),
        const SizedBox(height: 80),
      ]),
    );
  }
}

class _LessonFormulaCard extends StatefulWidget {
  final _LessonFormula formula;
  const _LessonFormulaCard({required this.formula});
  @override
  State<_LessonFormulaCard> createState() => _LessonFormulaCardState();
}

class _LessonFormulaCardState extends State<_LessonFormulaCard> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final f = widget.formula;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: f.color.withValues(alpha: 0.2)),
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [BoxShadow(color: f.color.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3))]
            : [],
      ),
      child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: f.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(f.emoji, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(f.name,
              style: GoogleFonts.sora(fontSize: 12.5, fontWeight: FontWeight.w800, color: c.textPrimary))),
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: f.formula));
              setState(() => _copied = true);
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) setState(() => _copied = false);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: _copied ? f.color.withValues(alpha: 0.2) : f.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(_copied ? Icons.check_rounded : Icons.copy_rounded, color: f.color, size: 13),
                const SizedBox(width: 4),
                Text(_copied ? 'Nusxalandi' : 'Nusxa',
                    style: GoogleFonts.sora(fontSize: 10, color: f.color, fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: f.color.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: f.color.withValues(alpha: 0.18)),
          ),
          child: Text(f.formula,
              style: GoogleFonts.robotoMono(
                  fontSize: 13.5, fontWeight: FontWeight.w700, color: f.color, height: 1.5),
              textAlign: TextAlign.center),
        ),
        const SizedBox(height: 10),
        Text(f.description, style: GoogleFonts.nunito(fontSize: 12, color: c.textMuted, height: 1.5)),
      ])),
    );
  }
}

// ── Mini Lesson Calculator ─────────────────────────────────
class _LessonCalcPanel extends StatefulWidget {
  final LessonModel lesson;
  const _LessonCalcPanel({required this.lesson});
  @override
  State<_LessonCalcPanel> createState() => _LessonCalcPanelState();
}

class _LessonCalcPanelState extends State<_LessonCalcPanel> {
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();
  String _result = '';
  int _selectedCalc = 0;

  final List<Map<String, dynamic>> _calcTypes = [
    {'label': "O'sish tezligi", 'emoji': '🌱', 'id': 'rgr'},
    {'label': 'Zichlik', 'emoji': '🌳', 'id': 'density'},
    {'label': 'Transpiratsiya', 'emoji': '💧', 'id': 'te'},
  ];

  @override
  void dispose() {
    _c1.dispose(); _c2.dispose(); _c3.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() {
      try {
        switch (_selectedCalc) {
          case 0: // RGR
            final w1 = double.parse(_c1.text);
            final w2 = double.parse(_c2.text);
            final days = double.parse(_c3.text);
            if (w1 <= 0 || w2 <= 0 || days <= 0) throw Exception();
            final rgr = (log(w2) - log(w1)) / days;
            _result = 'RGR = ${rgr.toStringAsFixed(4)} g/g/kun';
          case 1: // Populyatsiya zichligi
            final n = double.parse(_c1.text);
            final area = double.parse(_c2.text);
            if (area <= 0) throw Exception();
            final d = n / area;
            _result = 'D = ${d.toStringAsFixed(3)} dona/m²';
          case 2: // Transpiratsiya
            final biomass = double.parse(_c1.text);
            final water = double.parse(_c2.text);
            if (water <= 0) throw Exception();
            final te = biomass / water;
            _result = 'TE = ${te.toStringAsFixed(3)} g/L';
        }
      } catch (_) {
        _result = "❌ To'g'ri qiymat kiriting!";
      }
    });
  }

  Widget _field(String label, String hint, TextEditingController ctrl, Color color) {
    final c = context.colors;
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.sora(fontSize: 11.5, fontWeight: FontWeight.w700, color: c.textSecondary)),
      const SizedBox(height: 5),
      TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: GoogleFonts.sora(fontSize: 14, color: c.textPrimary, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.nunito(color: c.textMuted, fontSize: 13),
          prefixIcon: Icon(Icons.edit_rounded, size: 16, color: color),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          filled: true, fillColor: c.cardBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.cardBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.cardBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: color, width: 2)),
        ),
      ),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final id = _calcTypes[_selectedCalc]['id'] as String;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: List.generate(_calcTypes.length, (i) {
            final on = _selectedCalc == i;
            return GestureDetector(
              onTap: () => setState(() { _selectedCalc = i; _result = ''; _c1.clear(); _c2.clear(); _c3.clear(); }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: on ? c.primary : c.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: on ? c.primary : c.cardBorder, width: on ? 2 : 1),
                  boxShadow: on ? [BoxShadow(color: c.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))] : [],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(_calcTypes[i]['emoji'], style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(_calcTypes[i]['label'],
                      style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.w700,
                          color: on ? Colors.white : c.textMuted)),
                ]),
              ),
            );
          })),
        ),
        const SizedBox(height: 18),
        // Formula display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: c.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.primary.withValues(alpha: 0.2)),
          ),
          child: Text(
            id == 'rgr'
                ? 'RGR = (ln W₂ − ln W₁) / (t₂ − t₁)'
                : id == 'density'
                    ? 'D = N / A'
                    : 'TE = ΔBiomassa / ΔSuv',
            style: GoogleFonts.robotoMono(
                fontSize: 13, fontWeight: FontWeight.w700, color: c.primary, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 18),
        if (id == 'rgr') ...[
          _field("W₁ — Boshlang'ich massa (g)", 'masalan: 5.2', _c1, c.primary),
          _field('W₂ — Yakuniy massa (g)', 'masalan: 12.8', _c2, c.primary),
          _field('Davr (kunlar)', 'masalan: 14', _c3, c.primary),
        ] else if (id == 'density') ...[
          _field('N — Individlar soni', 'masalan: 120', _c1, const Color(0xFF7C3AED)),
          _field('A — Maydon (m²)', 'masalan: 25', _c2, const Color(0xFF7C3AED)),
        ] else ...[
          _field('Biomassa (g)', 'masalan: 8.5', _c1, const Color(0xFF0891B2)),
          _field('Sarflangan suv (L)', 'masalan: 3.2', _c2, const Color(0xFF0891B2)),
        ],
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () { HapticFeedback.selectionClick(); _calculate(); },
            icon: const Icon(Icons.calculate_rounded, size: 18),
            label: Text('Hisoblash', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 14)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        if (_result.isNotEmpty) ...[
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _result.startsWith('❌')
                  ? c.errorRed.withValues(alpha: 0.08)
                  : c.successGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _result.startsWith('❌')
                    ? c.errorRed.withValues(alpha: 0.25)
                    : c.successGreen.withValues(alpha: 0.25),
              ),
            ),
            child: Column(children: [
              Icon(
                _result.startsWith('❌') ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
                color: _result.startsWith('❌') ? c.errorRed : c.successGreen,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(_result,
                  style: GoogleFonts.sora(
                      fontSize: 16, fontWeight: FontWeight.w800,
                      color: _result.startsWith('❌') ? c.errorRed : c.successGreen),
                  textAlign: TextAlign.center),
            ]),
          ),
        ],
      ]),
    );
  }
}
