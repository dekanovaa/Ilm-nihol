import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../models/app_provider.dart';

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

// ── DATA ──────────────────────────────────────────────────
final _herbariumVideos = [
  {
    'title': 'Gerbariy tayyorlash: To\'liq qo\'llanma',
    'desc': 'O\'simliklarni to\'g\'ri yig\'ish, quritish va saqlash usullarini o\'rganing.',
    'url': 'https://www.youtube.com/watch?v=S0vshG6G-L8',
    'thumb': 'https://img.youtube.com/vi/S0vshG6G-L8/hqdefault.jpg',
    'duration': '8:12',
  },
  {
    'title': 'Botanika san\'ati: Gerbariy turlar',
    'desc': 'Ilmiy va badiiy gerbariylar yaratishning nozik sirlari.',
    'url': 'https://www.youtube.com/watch?v=R0X_WshX168',
    'thumb': 'https://img.youtube.com/vi/R0X_WshX168/hqdefault.jpg',
    'duration': '12:45',
  },
  {
    'title': 'O\'rmon o\'simliklaridan gerbariy',
    'desc': 'Turli xil barg va gullarni quritish texnikasi.',
    'url': 'https://www.youtube.com/watch?v=CqY0T7_Z_eU',
    'thumb': 'https://img.youtube.com/vi/CqY0T7_Z_eU/hqdefault.jpg',
    'duration': '6:30',
  },
  {
    'title': 'Maktab laboratoriyasi: Gerbariy',
    'desc': 'O\'quvchilar uchun amaliy mashg\'ulot videodarsi.',
    'url': 'https://www.youtube.com/watch?v=3eR_Vq_8s00',
    'thumb': 'https://img.youtube.com/vi/3eR_Vq_8s00/hqdefault.jpg',
    'duration': '10:15',
  },
];

// ── WIDGETS ───────────────────────────────────────────────
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
    final c = context.colors;
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
              const Text('🎮', style: TextStyle(fontSize: 44)),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _FlashcardGameSheet(),
    );
  }
}

class _FlashcardGameSheet extends StatefulWidget {
  const _FlashcardGameSheet();
  @override
  State<_FlashcardGameSheet> createState() => _FlashcardGameSheetState();
}

class _FlashcardGameSheetState extends State<_FlashcardGameSheet> {
  int _idx = 0;
  int _score = 0;
  bool _finished = false;

  final _questions = [
    {'q': 'Fotosintez jarayoni uchun nima zarur?', 'a': 'Quyosh nuri', 'o': ['Quyosh nuri', 'Tuz', 'Yog\'och']},
    {'q': 'O\'simlikning qaysi qismi suvni shimadi?', 'a': 'Ildiz', 'o': ['Barg', 'Ildiz', 'Gultoj']},
    {'q': 'Daraxtlarning yoshini qayerdan bilsa bo\'ladi?', 'a': 'Yillik halqalardan', 'o': ['Balandligidan', 'Yillik halqalardan', 'Barglaridan']},
    {'q': 'Eng tez o\'sadigan o\'simlik?', 'a': 'Bambuk', 'o': ['Eman', 'Bambuk', 'Atirgul']},
  ];

  void _answer(String val) {
    if (val == _questions[_idx]['a']) _score += 10;
    if (_idx < _questions.length - 1) {
      setState(() => _idx++);
    } else {
      setState(() => _finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(color: c.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
      padding: const EdgeInsets.all(24),
      child: _finished ? _resultView() : _gameView(),
    );
  }

  Widget _gameView() {
    final q = _questions[_idx];
    final options = q['o'] as List<String>;
    return Column(children: [
      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
      const SizedBox(height: 30),
      Text("Savol ${_idx + 1}/${_questions.length}", style: GoogleFonts.sora(fontWeight: FontWeight.w700, color: context.colors.primary)),
      const SizedBox(height: 20),
      Expanded(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: context.colors.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(24), border: Border.all(color: context.colors.primary.withValues(alpha: 0.1))),
          padding: const EdgeInsets.all(20),
          child: Center(child: Text(q['q'] as String, style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center)),
        ),
      ),
      const SizedBox(height: 30),
      ...options.map((opt) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SizedBox(
          width: double.infinity, height: 54,
          child: ElevatedButton(
            onPressed: () => _answer(opt),
            style: ElevatedButton.styleFrom(backgroundColor: context.colors.background, foregroundColor: context.colors.textPrimary, elevation: 0, side: BorderSide(color: context.colors.cardBorder)),
            child: Text(opt, style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ),
      )),
    ]);
  }

  Widget _resultView() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('🏆', style: TextStyle(fontSize: 80)),
      const SizedBox(height: 20),
      Text("O'yin yakunlandi!", style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      Text("Siz to'plagan ball: $_score", style: GoogleFonts.sora(fontSize: 18, color: context.colors.primary, fontWeight: FontWeight.w700)),
      const SizedBox(height: 40),
      SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Yopish"))),
    ]);
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
