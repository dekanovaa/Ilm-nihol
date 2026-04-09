import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/app_provider.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import 'lessons_screen.dart';
import 'engineering_lab_screen.dart';
import 'arts_herbarium_screen.dart';
import 'math_botany_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().currentUser;
    final news = AppData.news;
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true, expandedHeight: 0,
            backgroundColor: c.background,
            surfaceTintColor: Colors.transparent, elevation: 0,
            title: Row(children: [
              _LogoBadge(),
              const SizedBox(width: 10),
              Text('Ilmnihol', style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w800, color: c.textPrimary, letterSpacing: -0.4)),
            ]),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: c.cardBorder)),
                child: IconButton(
                  icon: Icon(Icons.notifications_outlined, color: c.textSecondary, size: 20),
                  onPressed: () {},
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _GreetingCard(user: user),
                const SizedBox(height: 14),
                if (user != null) ...[_QuickStats(user: user), const SizedBox(height: 22)],
                const _SteamRow(),
                const SizedBox(height: 26),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Yangiliklar', style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(foregroundColor: c.primary, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                    child: Row(children: [
                      Text('Barchasi', style: GoogleFonts.sora(color: c.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                      const SizedBox(width: 3),
                      Icon(Icons.arrow_forward_ios_rounded, size: 11, color: c.primary),
                    ]),
                  ),
                ]),
                const SizedBox(height: 8),
              ]),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                child: _NewsCard(news: news[i]),
              ),
              childCount: news.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [c.primaryLight, c.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: c.primary.withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: const Center(child: Text('🌿', style: TextStyle(fontSize: 18))),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final dynamic user;
  const _GreetingCard({required this.user});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Xayrli tong ☀️';
    if (h < 17) return 'Xayrli kun 🌤';
    return 'Xayrli kech 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.cardBg,
        gradient: isDark
            ? LinearGradient(colors: [c.cardBg, c.primary.withValues(alpha: 0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight)
            : LinearGradient(colors: [Colors.white, c.primary.withValues(alpha: 0.06)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.primary.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: c.primary.withValues(alpha: isDark ? 0.07 : 0.09), blurRadius: 20, offset: const Offset(0, 5))],
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_greeting(), style: GoogleFonts.nunito(color: c.textMuted, fontSize: 12.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text(user != null ? user.firstName : "O'quvchi",
              style: GoogleFonts.sora(color: c.textPrimary, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: c.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: c.primary.withValues(alpha: 0.22)),
            ),
            child: Text(
              user != null ? user.rankTitle : 'Yangi Botanik 🌱',
              style: GoogleFonts.sora(color: c.primary, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        ])),
        const SizedBox(width: 14),
        Container(
          width: 68, height: 68,
          decoration: BoxDecoration(
            gradient: RadialGradient(colors: [c.primary.withValues(alpha: 0.16), c.primary.withValues(alpha: 0.03)]),
            shape: BoxShape.circle,
            border: Border.all(color: c.primary.withValues(alpha: 0.18), width: 1.5),
          ),
          child: const Center(child: Text('🌳', style: TextStyle(fontSize: 38))),
        ),
      ]),
    );
  }
}

class _QuickStats extends StatelessWidget {
  final dynamic user;
  const _QuickStats({required this.user});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(children: [
      Expanded(child: _StatChip(icon: Icons.star_rounded, value: '${user.totalStars}', label: 'Yulduz', color: c.starColor)),
      const SizedBox(width: 9),
      Expanded(child: _StatChip(icon: Icons.bolt_rounded, value: '${user.totalScore}', label: 'Ball', color: c.primary)),
      const SizedBox(width: 9),
      Expanded(child: _StatChip(icon: Icons.menu_book_rounded, value: '${user.completedLessons.length}', label: 'Dars', color: c.accentOrange)),
      const SizedBox(width: 9),
      Expanded(child: _StatChip(icon: Icons.workspace_premium_rounded, value: '${user.certificates.length}', label: 'Cert', color: c.accentPink)),
    ]);
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final Color color;
  const _StatChip({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 5),
        Text(value, style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.nunito(fontSize: 9.5, color: c.textMuted, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
      ]),
    );
  }
}

class _SteamRow extends StatelessWidget {
  const _SteamRow();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      {
        'label': 'Science',
        'color': c.successGreen,
        'icon': Icons.biotech_outlined,
        'emoji': '🔬',
        'desc': "Ilmiy tadqiqotlar",
        'screen': null, // Science – hozircha yo'q
      },
      {
        'label': 'Tech',
        'color': c.techBadge,
        'icon': Icons.computer_outlined,
        'emoji': '💻',
        'desc': "Barcha darslar",
        'screen': 'lessons',
      },
      {
        'label': 'Engineer',
        'color': c.accentOrange,
        'icon': Icons.settings_outlined,
        'emoji': '⚗️',
        'desc': "Virtual laboratoriya",
        'screen': 'engineering',
      },
      {
        'label': 'Arts',
        'color': c.accentPink,
        'icon': Icons.palette_outlined,
        'emoji': '🎨',
        'desc': "Gerbariy yasash",
        'screen': 'arts',
      },
      {
        'label': 'Math',
        'color': c.starColor,
        'icon': Icons.calculate_outlined,
        'emoji': '📐',
        'desc': "Formulalar & kalkulyator",
        'screen': 'math',
      },
    ];

    void navigate(String? screen) {
      if (screen == null) return;
      switch (screen) {
        case 'lessons':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const LessonsScreen()));
        case 'engineering':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const EngineeringLabScreen()));
        case 'arts':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ArtsHerbariumScreen()));
        case 'math':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MathBotanyScreen()));
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("STEAM yo'nalishlari", style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items.map((item) {
            final textColor = item['color'] as Color;
            final screen = item['screen'] as String?;
            final hasNav = screen != null;
            return GestureDetector(
              onTap: () => navigate(screen),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? textColor.withValues(alpha: 0.12)
                      : textColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: textColor.withValues(alpha: isDark ? 0.28 : 0.22),
                    width: hasNav ? 1.5 : 1,
                  ),
                  boxShadow: hasNav
                      ? [BoxShadow(color: textColor.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 3))]
                      : [],
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(item['emoji'] as String, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 7),
                    Text(
                      item['label'] as String,
                      style: GoogleFonts.sora(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    if (hasNav) ...[
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward_ios_rounded, size: 10, color: textColor),
                    ],
                  ]),
                  const SizedBox(height: 4),
                  Text(
                    item['desc'] as String,
                    style: GoogleFonts.nunito(
                      fontSize: 9.5,
                      color: textColor.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
              ),
            );
          }).toList(),
        ),
      ),
    ]);
  }
}


class _NewsCard extends StatelessWidget {
  final NewsModel news;
  const _NewsCard({required this.news});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays} kun oldin';
    if (diff.inHours > 0) return '${diff.inHours} soat oldin';
    return '${diff.inMinutes} daqiqa oldin';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.cardBg, borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.cardBorder),
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [BoxShadow(color: c.primary.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))]
            : [],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18), onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(news.imageUrl, width: 76, height: 76, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 76, height: 76,
                    decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Icon(Icons.eco_outlined, color: c.primary, size: 30)),
                  )),
            ),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(news.category, style: GoogleFonts.sora(fontSize: 8.5, fontWeight: FontWeight.w700, color: c.primary, letterSpacing: 0.3)),
                ),
                const Spacer(),
                Text(_timeAgo(news.publishedAt), style: GoogleFonts.nunito(fontSize: 9.5, color: c.textLight)),
              ]),
              const SizedBox(height: 6),
              Text(news.title, style: GoogleFonts.sora(fontSize: 12.5, fontWeight: FontWeight.w700, color: c.textPrimary, height: 1.35), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(news.summary, style: GoogleFonts.nunito(fontSize: 11, color: c.textMuted, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),
          ]),
        ),
      ),
    );
  }
}
