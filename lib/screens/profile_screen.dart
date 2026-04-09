import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';
import '../models/app_provider.dart';
import '../models/models.dart';
import '../data/app_data.dart';
import 'auth_screens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().currentUser;
    final rank = context.watch<AppProvider>().currentUserRank;
    final c = context.colors;

    if (user == null) return Scaffold(backgroundColor: c.background, body: Center(child: CircularProgressIndicator(color: c.primary)));

    final totalLessons = AppData.lessons.length;
    final completedCount = user.completedLessons.length;
    final progress = totalLessons == 0 ? 0.0 : completedCount / totalLessons;

    return Scaffold(
      backgroundColor: c.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 278, pinned: true,
            backgroundColor: c.surface, surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(
                icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: Colors.white, size: 22),
                onPressed: () { final p = context.read<AppProvider>(); p.setThemeMode(Theme.of(context).brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark); },
              ),
              IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20), onPressed: () => _showEdit(context, user)),
              IconButton(icon: const Icon(Icons.logout_rounded, color: Colors.white70, size: 20), onPressed: () => _confirmLogout(context)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF15803D), Color(0xFF22C55E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: Stack(children: [
                  Positioned(top: -30, right: -30, child: Container(width: 140, height: 140, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), shape: BoxShape.circle))),
                  SafeArea(child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 50, 22, 20),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        width: 74, height: 74,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2.5), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 18)]),
                        child: Center(child: Text(user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?', style: GoogleFonts.sora(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white))),
                      ),
                      const SizedBox(height: 10),
                      Text(user.fullName, style: GoogleFonts.sora(fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.3)),
                      const SizedBox(height: 4),
                      Text('${user.grade} · ${user.school}', style: GoogleFonts.nunito(color: Colors.white.withValues(alpha: 0.75), fontSize: 12.5), textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white.withValues(alpha: 0.3))),
                        child: Text(user.rankTitle, style: GoogleFonts.sora(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ]),
                  )),
                ]),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _StatsGrid(user: user, rank: rank),
                const SizedBox(height: 15),
                _ProgressCard(progress: progress, completed: completedCount, total: totalLessons),
                const SizedBox(height: 20),
                Text('Yulduzlar va Sertifikatlar', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                _Achievements(user: user),
                const SizedBox(height: 20),
                if (user.completedLessons.isNotEmpty) ...[
                  Text('Tugallangan darslar', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _CompletedList(user: user),
                  const SizedBox(height: 20),
                ],
                Text("Shaxsiy ma'lumotlar", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                _InfoCard(user: user),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showEdit(BuildContext context, UserModel user) {
    final fc = TextEditingController(text: user.firstName);
    final lc = TextEditingController(text: user.lastName);
    final sc = TextEditingController(text: user.school);
    String grade = user.grade;
    final grades = ['5-sinf','6-sinf','7-sinf','8-sinf','9-sinf','10-sinf','11-sinf'];
    final c = context.colors;

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (ctx, set) => Container(
        height: MediaQuery.of(context).viewInsets.bottom + 520,
        decoration: BoxDecoration(color: c.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
        child: Column(children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: c.textLight, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 18),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 22), child: Text('Profilni tahrirlash', style: Theme.of(context).textTheme.titleLarge)),
          const SizedBox(height: 18),
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_Label2('Ism'), const SizedBox(height: 7), TextField(controller: fc, style: GoogleFonts.nunito(color: c.textPrimary, fontWeight: FontWeight.w600), decoration: const InputDecoration(hintText: 'Ism'))])),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_Label2('Familiya'), const SizedBox(height: 7), TextField(controller: lc, style: GoogleFonts.nunito(color: c.textPrimary, fontWeight: FontWeight.w600), decoration: const InputDecoration(hintText: 'Familiya'))])),
              ]),
              const SizedBox(height: 12),
              _Label2('Maktab'), const SizedBox(height: 7),
              TextField(controller: sc, style: GoogleFonts.nunito(color: c.textPrimary, fontWeight: FontWeight.w600), decoration: const InputDecoration(hintText: 'Maktab')),
              const SizedBox(height: 12),
              _Label2('Sinf'), const SizedBox(height: 7),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.cardBorder, width: 1.5)),
                child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                  value: grade, isExpanded: true, dropdownColor: c.cardBg,
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.textMuted),
                  style: GoogleFonts.nunito(color: c.textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
                  items: grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (v) => set(() => grade = v!),
                )),
              ),
              const SizedBox(height: 18),
              SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: () async {
                  await context.read<AppProvider>().updateProfile(firstName: fc.text.trim(), lastName: lc.text.trim(), school: sc.text.trim(), grade: grade);
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Saqlash'),
              )),
            ]),
          )),
        ]),
      )),
    );
  }

  void _confirmLogout(BuildContext context) {
    final c = context.colors;
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: c.cardBg,
      title: Text('Chiqish?', style: GoogleFonts.sora(fontWeight: FontWeight.w800, color: c.textPrimary)),
      content: Text("Hisobdan chiqmoqchimisiz?", style: GoogleFonts.nunito(color: c.textSecondary)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Bekor qilish', style: GoogleFonts.sora(color: c.textMuted, fontWeight: FontWeight.w600))),
        ElevatedButton(
          onPressed: () async { await context.read<AppProvider>().logout(); if (context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false); },
          style: ElevatedButton.styleFrom(backgroundColor: c.errorRed),
          child: const Text('Chiqish', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }
}

class _Label2 extends StatelessWidget {
  final String t;
  const _Label2(this.t);
  @override
  Widget build(BuildContext context) => Text(t, style: GoogleFonts.sora(fontSize: 12.5, fontWeight: FontWeight.w700, color: context.colors.textSecondary));
}

class _StatsGrid extends StatelessWidget {
  final UserModel user;
  final int rank;
  const _StatsGrid({required this.user, required this.rank});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(children: [
      Expanded(child: _SBox(icon: Icons.bolt_rounded, val: '${user.totalScore}', lbl: 'Umumiy ball', color: c.primary)),
      const SizedBox(width: 9),
      Expanded(child: _SBox(icon: Icons.star_rounded, val: '${user.totalStars}', lbl: 'Yulduzlar', color: c.starColor)),
      const SizedBox(width: 9),
      Expanded(child: _SBox(icon: Icons.bar_chart_rounded, val: rank > 0 ? '#$rank' : '-', lbl: 'Reyting', color: c.accentOrange)),
      const SizedBox(width: 9),
      Expanded(child: _SBox(icon: Icons.workspace_premium_rounded, val: '${user.certificates.length}', lbl: 'Sertifikat', color: c.accentPink)),
    ]);
  }
}

class _SBox extends StatelessWidget {
  final IconData icon;
  final String val, lbl;
  final Color color;
  const _SBox({required this.icon, required this.val, required this.lbl, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.2))),
    child: Column(children: [
      Icon(icon, color: color, size: 19),
      const SizedBox(height: 5),
      Text(val, style: GoogleFonts.sora(fontSize: 13.5, fontWeight: FontWeight.w800, color: color)),
      Text(lbl, style: GoogleFonts.nunito(fontSize: 9, color: context.colors.textMuted, fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
    ]),
  );
}

class _ProgressCard extends StatelessWidget {
  final double progress;
  final int completed, total;
  const _ProgressCard({required this.progress, required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: c.primary.withValues(alpha: 0.2))),
      child: Row(children: [
        CircularPercentIndicator(
          radius: 40, lineWidth: 6,
          percent: progress.clamp(0.0, 1.0),
          center: Text('${(progress * 100).round()}%', style: GoogleFonts.sora(color: c.primary, fontSize: 12, fontWeight: FontWeight.w800)),
          progressColor: c.primary, backgroundColor: c.cardBorder,
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("O'zlashtirish darajasi", style: GoogleFonts.sora(color: c.textPrimary, fontWeight: FontWeight.w700, fontSize: 13.5)),
          const SizedBox(height: 4),
          Text('$completed ta / $total ta dars tugallandi', style: GoogleFonts.nunito(color: c.textMuted, fontSize: 12)),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(5), child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: c.cardBorder,
            valueColor: AlwaysStoppedAnimation<Color>(c.primary), minHeight: 7,
          )),
        ])),
      ]),
    );
  }
}

class _Achievements extends StatelessWidget {
  final UserModel user;
  const _Achievements({required this.user});

  @override
  Widget build(BuildContext context) {
    final lessons = AppData.lessons;
    final c = context.colors;

    if (user.certificates.isEmpty && user.totalStars == 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: c.cardBorder)),
        child: Center(child: Column(children: [
          Icon(Icons.eco_outlined, size: 34, color: c.textMuted),
          const SizedBox(height: 8),
          Text("Hali mukofot yo'q", style: GoogleFonts.sora(color: c.textMuted, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Testlarni yaxshi ishlab sertifikat oling!', style: GoogleFonts.nunito(color: c.textLight, fontSize: 11), textAlign: TextAlign.center),
        ])),
      );
    }

    return Column(children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: c.starColor.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.starColor.withValues(alpha: 0.2))),
        child: Row(children: [
          Icon(Icons.star_rounded, color: c.starColor, size: 26),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("${user.totalStars} ta yulduz to'plandi", style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 14, color: c.textPrimary)),
            Text('Har testda 80%+ ball → 3 yulduz', style: GoogleFonts.nunito(fontSize: 11, color: c.textMuted)),
          ])),
        ]),
      ),
      const SizedBox(height: 8),
      ...user.certificates.map((certId) {
        final lesson = lessons.firstWhere((l) => l.id == certId, orElse: () => lessons.first);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: c.gold.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.gold.withValues(alpha: 0.2))),
          child: Row(children: [
            Icon(Icons.workspace_premium_rounded, color: c.gold, size: 26),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('SERTIFIKAT', style: GoogleFonts.sora(fontSize: 9, fontWeight: FontWeight.w700, color: c.gold, letterSpacing: 0.5)),
              Text(lesson.title, style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 13, color: c.textPrimary)),
              Text('Ball: ${user.lessonScores[certId] ?? 0}/100', style: GoogleFonts.nunito(fontSize: 11, color: c.textMuted)),
            ])),
            Icon(Icons.verified_rounded, color: c.gold, size: 22),
          ]),
        );
      }),
    ]);
  }
}

class _CompletedList extends StatelessWidget {
  final UserModel user;
  const _CompletedList({required this.user});

  @override
  Widget build(BuildContext context) {
    final lessons = AppData.lessons;
    final c = context.colors;
    return Column(children: user.completedLessons.map((id) {
      final lesson = lessons.firstWhere((l) => l.id == id, orElse: () => lessons.first);
      final score = user.lessonScores[id] ?? 0;
      final stars = score >= 80 ? 3 : score >= 60 ? 2 : score >= 40 ? 1 : 0;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(14), border: Border.all(color: c.cardBorder)),
        child: Row(children: [
          Text(lesson.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(child: Text(lesson.title, style: GoogleFonts.sora(fontSize: 12.5, fontWeight: FontWeight.w700, color: c.textPrimary))),
          Row(children: List.generate(3, (i) => Icon(i < stars ? Icons.star_rounded : Icons.star_outline_rounded, color: c.starColor, size: 13))),
          const SizedBox(width: 6),
          Text('$score', style: GoogleFonts.sora(fontSize: 11, color: c.textMuted, fontWeight: FontWeight.w700)),
        ]),
      );
    }).toList());
  }
}

class _InfoCard extends StatelessWidget {
  final UserModel user;
  const _InfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: c.cardBorder)),
      child: Column(children: [
        _IR(Icons.person_rounded, 'Ism Familiya', user.fullName),
        _IR(Icons.alternate_email_rounded, 'Email', user.email),
        _IR(Icons.school_rounded, 'Maktab', user.school),
        _IR(Icons.class_rounded, 'Sinf', user.grade),
        _IR(Icons.calendar_month_rounded, "Ro'yxat", '${user.registeredAt.day}.${user.registeredAt.month}.${user.registeredAt.year}', last: true),
      ]),
    );
  }
}

class _IR extends StatelessWidget {
  final IconData icon;
  final String lbl, val;
  final bool last;
  const _IR(this.icon, this.lbl, this.val, {this.last = false});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 11),
      child: Row(children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 15, color: c.primary),
        ),
        const SizedBox(width: 10),
        Text('$lbl:', style: GoogleFonts.nunito(fontSize: 12, color: c.textMuted)),
        const SizedBox(width: 6),
        Expanded(child: Text(val, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: c.textPrimary), overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}
