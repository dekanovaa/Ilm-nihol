import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/app_provider.dart';
import '../models/models.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final leaderboard = provider.leaderboard;
    final currentUser = provider.currentUser;
    final myRank = provider.currentUserRank;
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 190, pinned: false,
            backgroundColor: c.surface, surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF15803D), Color(0xFF22C55E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 70),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                    Row(children: [
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(13), border: Border.all(color: Colors.white.withValues(alpha: 0.28))),
                        child: const Center(child: Text('🏆', style: TextStyle(fontSize: 22))),
                      ),
                      const SizedBox(width: 12),
                      Text('Reyting', style: GoogleFonts.sora(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                    ]),
                    const SizedBox(height: 6),
                    Text("Barcha o'quvchilar reytingi", style: GoogleFonts.nunito(color: Colors.white.withValues(alpha: 0.75), fontSize: 13)),
                    const SizedBox(height: 14),
                    if (currentUser != null && myRank > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.26))),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.person_rounded, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text("Sizning o'rningiz: ", style: GoogleFonts.nunito(color: Colors.white.withValues(alpha: 0.88), fontSize: 12, fontWeight: FontWeight.w600)),
                          Text('#$myRank', style: GoogleFonts.sora(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
                        ]),
                      ),
                  ]),
                )),
              ),
            ),
          ),
          if (leaderboard.length >= 3)
            SliverToBoxAdapter(
              child: Padding(padding: const EdgeInsets.fromLTRB(18, 18, 18, 0), child: _Podium(top3: leaderboard.take(3).toList())),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
              child: Text('Barcha ishtirokchilar', style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 7),
                child: _LbRow(entry: leaderboard[i], isMe: currentUser?.id == leaderboard[i].userId),
              ),
              childCount: leaderboard.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  final List<LeaderboardEntry> top3;
  const _Podium({required this.top3});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
      decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(22), border: Border.all(color: c.cardBorder)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _PodItem(entry: top3[1], rank: 2, h: 72, medal: '🥈', color: c.silver),
        _PodItem(entry: top3[0], rank: 1, h: 104, medal: '🥇', color: c.gold),
        if (top3.length > 2) _PodItem(entry: top3[2], rank: 3, h: 54, medal: '🥉', color: c.bronze),
      ]),
    );
  }
}

class _PodItem extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final double h;
  final String medal;
  final Color color;
  const _PodItem({required this.entry, required this.rank, required this.h, required this.medal, required this.color});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(children: [
      Text(medal, style: const TextStyle(fontSize: 24)),
      const SizedBox(height: 5),
      Container(
        width: 44, height: 44,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
        child: Center(child: Text(entry.fullName.isNotEmpty ? entry.fullName[0].toUpperCase() : '?', style: GoogleFonts.sora(fontSize: 17, fontWeight: FontWeight.w800, color: color))),
      ),
      const SizedBox(height: 5),
      Text(entry.fullName.split(' ').first, style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w700, color: c.textPrimary), textAlign: TextAlign.center),
      Text('${entry.score} ball', style: GoogleFonts.nunito(fontSize: 9.5, color: c.textMuted)),
      const SizedBox(height: 5),
      Container(
        width: 84, height: h,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          border: Border(top: BorderSide(color: color.withValues(alpha: 0.3)), left: BorderSide(color: color.withValues(alpha: 0.3)), right: BorderSide(color: color.withValues(alpha: 0.3))),
        ),
        child: Center(child: Text('#$rank', style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w900, color: color))),
      ),
    ]);
  }
}

class _LbRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isMe;
  const _LbRow({required this.entry, required this.isMe});

  Color _rankColor(BuildContext context) {
    final c = context.colors;
    switch (entry.rank) { case 1: return c.gold; case 2: return c.silver; case 3: return c.bronze; default: return c.textLight; }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? c.primary.withValues(alpha: 0.08) : c.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isMe ? c.primary.withValues(alpha: 0.35) : c.cardBorder, width: isMe ? 1.5 : 1),
      ),
      child: Row(children: [
        SizedBox(width: 34, child: Text('#${entry.rank}', style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w800, color: _rankColor(context)), textAlign: TextAlign.center)),
        const SizedBox(width: 10),
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.1), shape: BoxShape.circle, border: Border.all(color: c.primary.withValues(alpha: 0.2))),
          child: Center(child: Text(entry.fullName.isNotEmpty ? entry.fullName[0].toUpperCase() : '?', style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w800, color: c.primary))),
        ),
        const SizedBox(width: 11),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(entry.fullName + (isMe ? ' (Men)' : ''), style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w700, color: isMe ? c.primary : c.textPrimary), overflow: TextOverflow.ellipsis),
          Text('${entry.grade} · ${entry.school}', style: GoogleFonts.nunito(fontSize: 10, color: c.textMuted), overflow: TextOverflow.ellipsis),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${entry.score}', style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w800, color: c.primary)),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.star_rounded, color: c.starColor, size: 12),
            const SizedBox(width: 2),
            Text('${entry.stars}', style: GoogleFonts.sora(fontSize: 10, color: c.textMuted, fontWeight: FontWeight.w600)),
          ]),
        ]),
      ]),
    );
  }
}
