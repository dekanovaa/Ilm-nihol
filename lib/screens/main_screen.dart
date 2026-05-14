import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'lessons_screen.dart';
import 'leaderboard_screen.dart';
import 'labs_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _idx = 0;
  late List<AnimationController> _ctrls;

  final _screens = [HomeScreen(), LessonsScreen(), LabsScreen(), LeaderboardScreen(), ProfileScreen()];

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(5, (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 280)));
    _ctrls[0].forward();
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    super.dispose();
  }

  void _onTap(int i) {
    if (i == _idx) return;
    HapticFeedback.selectionClick();
    _ctrls[_idx].reverse();
    setState(() => _idx = i);
    _ctrls[i].forward();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: IndexedStack(index: _idx, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: c.surface,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4)),
          ],
          border: Border(top: BorderSide(color: c.cardBorder.withValues(alpha: 0.5), width: 0.5)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                _NavItem(activeIcon: Icons.home_rounded, outlineIcon: Icons.home_outlined, label: 'Asosiy', index: 0, current: _idx, ctrl: _ctrls[0], onTap: _onTap),
                _NavItem(activeIcon: Icons.menu_book_rounded, outlineIcon: Icons.menu_book_outlined, label: 'Darslar', index: 1, current: _idx, ctrl: _ctrls[1], onTap: _onTap),
                _NavItem(activeIcon: Icons.science_rounded, outlineIcon: Icons.science_outlined, label: 'Lab', index: 2, current: _idx, ctrl: _ctrls[2], onTap: _onTap),
                _NavItem(activeIcon: Icons.leaderboard_rounded, outlineIcon: Icons.leaderboard_outlined, label: 'Reyting', index: 3, current: _idx, ctrl: _ctrls[3], onTap: _onTap),
                _NavItem(activeIcon: Icons.person_rounded, outlineIcon: Icons.person_outline_rounded, label: 'Profil', index: 4, current: _idx, ctrl: _ctrls[4], onTap: _onTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData activeIcon, outlineIcon;
  final String label;
  final int index, current;
  final AnimationController ctrl;
  final void Function(int) onTap;
  const _NavItem({required this.activeIcon, required this.outlineIcon, required this.label, required this.index, required this.current, required this.ctrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    final c = context.colors;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: ctrl,
          builder: (_, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: EdgeInsets.symmetric(horizontal: isActive ? 18 : 10, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive ? c.primary.withValues(alpha: 0.13) : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Transform.scale(
                  scale: 1.0 + ctrl.value * 0.08,
                  child: Icon(
                    isActive ? activeIcon : outlineIcon,
                    color: isActive ? c.primary : c.textLight,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: GoogleFonts.sora(
                  fontSize: 9.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? c.primary : c.textLight,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Nav icons removed — now using IconData directly in _NavItem
