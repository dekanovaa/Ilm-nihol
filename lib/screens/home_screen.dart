import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../models/app_provider.dart';
import 'botany_game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().currentUser;
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
                const SizedBox(height: 24),
                _GameSection(),
                const SizedBox(height: 24),
                if (user != null) ...[_QuickStats(user: user), const SizedBox(height: 24)],
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Gerbariylar', style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(foregroundColor: c.primary),
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
                child: _HerbariumCard(video: _herbariumVideos[i]),
              ),
              childCount: _herbariumVideos.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// Home Screen Data
final _herbariumVideos = [
  {
    'title': 'Gerbariy tayyorlash',
    'desc': 'O\'simliklarni qog\'ozda presslab quritish bo\'yicha qisqa dars.',
    'url': 'https://youtube.com/shorts/96UAaf0NsSE',
    'thumb': 'https://img.youtube.com/vi/96UAaf0NsSE/hqdefault.jpg',
    'duration': '0:58',
  },
  {
    'title': 'Gerbariy tayyorlash',
    'desc': 'O\'simliklarni to\'g\'ri yig\'ish va tayyorlash bo\'yicha qisqa dars.',
    'url': 'https://youtube.com/shorts/vqD5OBIXJAo',
    'thumb': 'https://img.youtube.com/vi/vqD5OBIXJAo/hqdefault.jpg',
    'duration': '0:56',
  },
  {
    'title': 'Gerbariy tayyorlash',
    'desc': 'Botanika olamida gerbariyning o\'rni va uni saqlash usullari.',
    'url': 'https://youtube.com/shorts/BlBvibGYvuE',
    'thumb': 'https://img.youtube.com/vi/BlBvibGYvuE/hqdefault.jpg',
    'duration': '0:45',
  },
  {
    'title': 'Gerbariy tayyorlash',
    'desc': 'Gerbariy yaratishning ilmiy asoslari va amaliy qo\'llanmasi.',
    'url': 'https://youtu.be/FXsIaYxGU3M',
    'thumb': 'https://img.youtube.com/vi/FXsIaYxGU3M/hqdefault.jpg',
    'duration': '12:15',
  },
];

// Home Screen Widgets
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
      child: const Center(child: Icon(Icons.eco_rounded, color: Colors.white, size: 20)),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final dynamic user;
  const _GreetingCard({required this.user});
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.primary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(28),
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?q=80&w=500&auto=format&fit=crop'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(c.primary.withValues(alpha: 0.7), BlendMode.srcOver),
        ),
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Xush kelibsiz!", style: GoogleFonts.nunito(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text(user != null ? user.firstName : "O'quvchi", style: GoogleFonts.sora(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
            child: Text(user != null ? user.rankTitle : 'Botanika ishqibozi', style: GoogleFonts.sora(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ])),
      ]),
    );
  }
}

class _GameSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showGame(context),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              const Icon(Icons.sports_esports, color: Colors.white, size: 40),
              const SizedBox(width: 18),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Botanika O'yini", style: GoogleFonts.sora(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text("Kartochkalar orqali bilimingizni topshiring", style: GoogleFonts.nunito(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
              ])),
              const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 36),
            ]),
          ),
        ),
      ),
    );
  }

  void _showGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BotanyGameScreen()),
    );
  }
}


class _QuickStats extends StatelessWidget {
  final dynamic user;
  const _QuickStats({required this.user});
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return LayoutBuilder(builder: (context, constraints) {
      final chipWidth = (constraints.maxWidth - 20) / 3;
      return Row(children: [
        SizedBox(width: chipWidth, child: _StatChip(Icons.star_rounded, '${user.totalStars}', 'Yulduz', c.starColor)),
        const SizedBox(width: 10),
        SizedBox(width: chipWidth, child: _StatChip(Icons.bolt_rounded, '${user.totalScore}', 'Ball', c.primary)),
        const SizedBox(width: 10),
        SizedBox(width: chipWidth, child: _StatChip(Icons.workspace_premium_rounded, '${user.certificates.length}', 'Cert', const Color(0xFFF472B6))),
      ]);
    });
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon; final String val, lbl; final Color color;
  const _StatChip(this.icon, this.val, this.lbl, this.color);
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.15))),
      child: Column(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(val, style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
        Text(lbl, style: GoogleFonts.nunito(fontSize: 10, color: c.textMuted, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _HerbariumCard extends StatelessWidget {
  final Map<String, String> video;
  const _HerbariumCard({required this.video});
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: c.cardBorder)),
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(video['url']!);
          if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Stack(alignment: Alignment.center, children: [
              ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(video['thumb']!, width: 90, height: 90, fit: BoxFit.cover)),
              const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 32),
            ]),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(video['title']!, style: GoogleFonts.sora(fontSize: 13.5, fontWeight: FontWeight.w800, color: c.textPrimary, height: 1.3), maxLines: 2),
              const SizedBox(height: 4),
              Text(video['desc']!, style: GoogleFonts.nunito(fontSize: 11, color: c.textMuted), maxLines: 2),
              const SizedBox(height: 6),
              Text('YouTube dars', style: GoogleFonts.nunito(fontSize: 10, color: c.primary, fontWeight: FontWeight.w800)),
            ])),
          ]),
        ),
      ),
    );
  }
}
