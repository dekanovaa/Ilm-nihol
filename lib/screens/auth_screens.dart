import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icons.dart';
import '../models/app_provider.dart';
import '../utils/error_handler.dart';
import 'main_screen.dart';

// ── SPLASH ────────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  late final Animation<double> _scale = Tween(begin: 0.65, end: 1.0)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
  late final Animation<double> _fade = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.4)));

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 2300), () {
      if (!mounted) return;
      final p = context.read<AppProvider>();
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => p.isLoggedIn ? const MainScreen() : const LoginScreen()));
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => Opacity(
            opacity: _fade.value,
            child: Transform.scale(
              scale: _scale.value,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 108, height: 108,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [c.primaryLight, c.primaryDark],
                        begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [BoxShadow(color: c.primary.withValues(alpha: 0.4), blurRadius: 40, offset: const Offset(0, 14))],
                  ),
                  child: Center(child: AppIcon(AppIconData.leaf, size: 54, color: Colors.white)),
                ),
                const SizedBox(height: 22),
                Text('Ilmnihol', style: GoogleFonts.sora(fontSize: 44, fontWeight: FontWeight.w900,
                    color: c.textPrimary, letterSpacing: -1.2)),
                const SizedBox(height: 8),
                Text("O'simliklar dunyosini kashf eting",
                    style: GoogleFonts.nunito(fontSize: 15, color: c.primary, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ── LOGIN ─────────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _fk = GlobalKey<FormState>();
  final _ec = TextEditingController();
  final _pc = TextEditingController();
  bool _hide = true, _loading = false;

  @override
  void dispose() { _ec.dispose(); _pc.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_fk.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AppProvider>().login(_ec.text.trim(), _pc.text);
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AuthErrorHandler.getErrorMessage(e)), backgroundColor: context.colors.errorRed));
    } finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _fk,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              // Logo
              Center(
                child: Column(children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [c.primaryLight, c.primaryDark],
                          begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [BoxShadow(color: c.primary.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8))],
                    ),
                    child: Center(child: AppIcon(AppIconData.leaf, size: 38, color: Colors.white)),
                  ),
                  const SizedBox(height: 12),
                  Text('Ilmnihol', style: GoogleFonts.sora(fontSize: 26, fontWeight: FontWeight.w900, color: c.textPrimary, letterSpacing: -0.5)),
                  const SizedBox(height: 3),
                  Text("Botanika o'quv platformasi", style: GoogleFonts.nunito(fontSize: 13, color: c.textMuted, fontWeight: FontWeight.w500)),
                ]),
              ),
              const SizedBox(height: 34),
              Text('Kirish', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 5),
              Text('Hisobingizga kiring', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 26),
              _Lbl('Email manzil'),
              const SizedBox(height: 7),
              TextFormField(
                controller: _ec, keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.nunito(color: c.textPrimary, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'example@email.com',
                  prefixIcon: Padding(padding: const EdgeInsets.all(12), child: AppIcon(AppIconData.email, size: 18, color: c.textMuted)),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email kiriting';
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return "Format noto'g'ri";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _Lbl('Parol'),
              const SizedBox(height: 7),
              TextFormField(
                controller: _pc, obscureText: _hide,
                style: GoogleFonts.nunito(color: c.textPrimary, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Kamida 6 ta belgi',
                  prefixIcon: Padding(padding: const EdgeInsets.all(12), child: AppIcon(AppIconData.lock, size: 18, color: c.textMuted)),
                  suffixIcon: IconButton(
                    icon: AppIcon(_hide ? AppIconData.info : AppIconData.check, size: 18, color: c.textMuted),
                    onPressed: () => setState(() => _hide = !_hide),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Parol kiriting';
                  if (v.length < 6) return 'Kamida 6 ta belgi';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Kirish'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: RichText(
                    text: TextSpan(
                      text: "Hisob yo'qmi? ",
                      style: GoogleFonts.nunito(color: c.textMuted, fontSize: 14, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(text: "Ro'yxatdan o'tish",
                            style: GoogleFonts.nunito(color: c.primary, fontWeight: FontWeight.w800, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ── REGISTER ──────────────────────────────────────────────────────────────
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegState();
}

class _RegState extends State<RegisterScreen> {
  final _fk = GlobalKey<FormState>();
  final _fn = TextEditingController(), _ln = TextEditingController(),
        _sc = TextEditingController(), _ec = TextEditingController(),
        _pw = TextEditingController(), _c2 = TextEditingController();
  String _grade = '7-sinf';
  bool _hp = true, _hc = true, _loading = false, _agree = false;
  final _grades = ['5-sinf','6-sinf','7-sinf','8-sinf','9-sinf','10-sinf','11-sinf'];

  @override
  void dispose() { for (final c in [_fn,_ln,_sc,_ec,_pw,_c2]) c.dispose(); super.dispose(); }

  Future<void> _reg() async {
    if (!_fk.currentState!.validate()) return;
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Shartlarga rozilik bildiring"), backgroundColor: context.colors.errorRed));
      return;
    }
    setState(() => _loading = true);
    try {
      await context.read<AppProvider>().register(
          email: _ec.text.trim(), password: _pw.text,
          firstName: _fn.text.trim(), lastName: _ln.text.trim(),
          school: _sc.text.trim(), grade: _grade);
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AuthErrorHandler.getErrorMessage(e)), backgroundColor: context.colors.errorRed));
    } finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: const Text("Ro'yxatdan o'tish"),
        leading: IconButton(
          icon: AppIcon(AppIconData.back, size: 20, color: c.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _fk,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Yangi hisob yarating", style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 5),
              Text("Ma'lumotlaringizni kiriting", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(child: _FieldW('Ism', _fn, AppIconData.profile, (v) => v!.isEmpty ? 'Kiriting' : null)),
                const SizedBox(width: 12),
                Expanded(child: _FieldW('Familiya', _ln, AppIconData.profile, (v) => v!.isEmpty ? 'Kiriting' : null)),
              ]),
              const SizedBox(height: 4),
              _FieldW('Maktab', _sc, AppIconData.school, (v) => v!.isEmpty ? 'Kiriting' : null),
              const SizedBox(height: 4),
              _Lbl('Sinf'), const SizedBox(height: 7),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: c.primary.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: c.cardBorder, width: 1.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _grade, isExpanded: true, dropdownColor: c.cardBg,
                    icon: AppIcon(AppIconData.forward, size: 14, color: c.textMuted),
                    style: GoogleFonts.nunito(color: c.textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
                    onChanged: (v) => setState(() => _grade = v!),
                    items: _grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              _FieldW('Email', _ec, AppIconData.email, (v) {
                if (v == null || v.isEmpty) return 'Email kiriting';
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return "Format noto'g'ri";
                return null;
              }, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 4),
              _Lbl('Parol'), const SizedBox(height: 7),
              TextFormField(
                controller: _pw, obscureText: _hp,
                style: GoogleFonts.nunito(color: c.textPrimary, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Kamida 6 ta belgi',
                  prefixIcon: Padding(padding: const EdgeInsets.all(12), child: AppIcon(AppIconData.lock, size: 18, color: c.textMuted)),
                  suffixIcon: IconButton(icon: AppIcon(AppIconData.info, size: 18, color: c.textMuted), onPressed: () => setState(() => _hp = !_hp)),
                ),
                validator: (v) => (v == null || v.length < 6) ? 'Kamida 6 ta belgi' : null,
              ),
              const SizedBox(height: 14),
              _Lbl('Parolni tasdiqlang'), const SizedBox(height: 7),
              TextFormField(
                controller: _c2, obscureText: _hc,
                style: GoogleFonts.nunito(color: c.textPrimary, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Parolni qaytaring',
                  prefixIcon: Padding(padding: const EdgeInsets.all(12), child: AppIcon(AppIconData.lock, size: 18, color: c.textMuted)),
                  suffixIcon: IconButton(icon: AppIcon(AppIconData.info, size: 18, color: c.textMuted), onPressed: () => setState(() => _hc = !_hc)),
                ),
                validator: (v) => v != _pw.text ? "Parollar mos kelmaydi" : null,
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () => setState(() => _agree = !_agree),
                child: Row(children: [
                  Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      color: _agree ? c.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _agree ? c.primary : c.textLight, width: 1.5),
                    ),
                    child: _agree ? Center(child: AppIcon(AppIconData.check, size: 14, color: Colors.white)) : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Foydalanish ',
                        style: GoogleFonts.nunito(color: c.textMuted, fontSize: 13, fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(text: 'shartlari', style: GoogleFonts.nunito(color: c.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                          const TextSpan(text: 'ga roziman'),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _reg,
                  child: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Ro'yxatdan o'tish"),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      text: 'Hisob bormi? ',
                      style: GoogleFonts.nunito(color: c.textMuted, fontSize: 14, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(text: 'Kirish',
                            style: GoogleFonts.nunito(color: c.primary, fontWeight: FontWeight.w800, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _FieldW(String label, TextEditingController ctrl, AppIconData icon,
      String? Function(String?) validator, {TextInputType? keyboardType}) {
    final c = context.colors;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Lbl(label), const SizedBox(height: 7),
      TextFormField(
        controller: ctrl, keyboardType: keyboardType,
        style: GoogleFonts.nunito(color: c.textPrimary, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Padding(padding: const EdgeInsets.all(12), child: AppIcon(icon, size: 18, color: c.textMuted)),
        ),
        validator: validator,
      ),
      const SizedBox(height: 14),
    ]);
  }
}

class _Lbl extends StatelessWidget {
  final String text;
  const _Lbl(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: GoogleFonts.sora(fontSize: 12.5, fontWeight: FontWeight.w700, color: context.colors.textSecondary));
}
