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
  @override
  void initState() {
    super.initState();
    _ctrl.forward();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Kamida 1.5 soniya splashni ko'rsatamiz
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;
    final p = context.read<AppProvider>();
    
    // Agar hali init bo'lmagan bo'lsa, kutib turamiz
    while (!p.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (!mounted) return;
    
    if (p.isLoggedIn) {
      if (p.hasPin) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PinLockScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PinSetupScreen()));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 100, height: 100, decoration: BoxDecoration(gradient: LinearGradient(colors: [c.primaryLight, c.primaryDark]), borderRadius: BorderRadius.circular(28)), child: Center(child: AppIcon(AppIconData.leaf, size: 50, color: Colors.white))),
        const SizedBox(height: 20),
        Text('Ilmnihol', style: GoogleFonts.sora(fontSize: 40, fontWeight: FontWeight.w900, color: c.textPrimary)),
      ])),
    );
  }
}

// ── PIN SETUP ─────────────────────────────────────────────────────────────
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});
  @override
  State<PinSetupScreen> createState() => _PinSetupState();
}

class _PinSetupState extends State<PinSetupScreen> {
  final _pc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🛡️', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 20),
          Text("Kirish paroli yaratish", style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text("Ilovaga tezroq kirish uchun 4 raqamli parol o'rnating", style: GoogleFonts.nunito(color: c.textMuted), textAlign: TextAlign.center),
          const SizedBox(height: 40),
          TextField(
            controller: _pc,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            textAlign: TextAlign.center,
            style: GoogleFonts.sora(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 20),
            decoration: InputDecoration(counterText: "", border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
          ),
          const SizedBox(height: 30),
          SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: () {
            if (_pc.text.length == 4) {
              context.read<AppProvider>().setPin(_pc.text);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
            }
          }, child: const Text("Saqlash"))),
        ]),
      ),
    );
  }
}

// ── PIN LOCK ──────────────────────────────────────────────────────────────
class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});
  @override
  State<PinLockScreen> createState() => _PinLockState();
}

class _PinLockState extends State<PinLockScreen> {
  final _pc = TextEditingController();
  String? _err;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final user = context.watch<AppProvider>().currentUser;

    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🌿', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 20),
          Text("Xush kelibsiz, ${user?.firstName ?? ''}", style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text("Ilovaga kirish uchun parolingizni kiriting", style: GoogleFonts.nunito(color: c.textMuted)),
          const SizedBox(height: 40),
          TextField(
            controller: _pc,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            textAlign: TextAlign.center,
            style: GoogleFonts.sora(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 20),
            decoration: InputDecoration(counterText: "", border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), errorText: _err),
            onChanged: (v) {
              if (v.length == 4) {
                if (context.read<AppProvider>().verifyPin(v)) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
                } else {
                  setState(() => _err = "Parol noto'g'ri");
                  _pc.clear();
                }
              }
            },
          ),
          const SizedBox(height: 20),
          TextButton(onPressed: () {
             context.read<AppProvider>().logout();
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          }, child: Text("Boshqa hisobga o'tish", style: GoogleFonts.nunito(color: c.primary, fontWeight: FontWeight.w700))),
        ]),
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
  bool _loading = false;

  Future<void> _login() async {
    if (!_fk.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final p = context.read<AppProvider>();
      await p.login(_ec.text.trim(), _pc.text);
      if (mounted) {
        if (p.hasPin) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PinSetupScreen()));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AuthErrorHandler.getErrorMessage(e)), backgroundColor: context.colors.errorRed));
    } finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Form(key: _fk, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 40),
        Center(child: Text("Kirish", style: GoogleFonts.sora(fontSize: 28, fontWeight: FontWeight.w900))),
        const SizedBox(height: 40),
        _FieldW('Email', _ec, AppIconData.email, false),
        const SizedBox(height: 20),
        _FieldW('Parol', _pc, AppIconData.lock, true),
        const SizedBox(height: 40),
        SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: _loading ? null : _login, child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Kirish'))),
        const SizedBox(height: 20),
        Center(child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: Text("Ro'yxatdan o'tish", style: GoogleFonts.nunito(fontWeight: FontWeight.w800)))),
      ])))),
    );
  }

  Widget _FieldW(String lbl, TextEditingController ctrl, AppIconData icon, bool obscure) {
    return TextFormField(controller: ctrl, obscureText: obscure, decoration: InputDecoration(labelText: lbl, prefixIcon: Padding(padding: const EdgeInsets.all(12), child: AppIcon(icon, size: 18, color: context.colors.textMuted))));
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
  final _fn = TextEditingController(), _ln = TextEditingController(), _ec = TextEditingController(), _pw = TextEditingController();
  bool _loading = false;

  Future<void> _reg() async {
    if (!_fk.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AppProvider>().register(email: _ec.text.trim(), password: _pw.text, firstName: _fn.text.trim(), lastName: _ln.text.trim(), school: '', grade: '7-sinf');
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PinSetupScreen()));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AuthErrorHandler.getErrorMessage(e)), backgroundColor: context.colors.errorRed));
    } finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: const Text("Ro'yxatdan o'tish")),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Form(key: _fk, child: Column(children: [
        _FieldW('Ism', _fn),
        _FieldW('Familiya', _ln),
        _FieldW('Email', _ec),
        _FieldW('Parol', _pw, obscure: true),
        const SizedBox(height: 40),
        SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: _loading ? null : _reg, child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text("Ro'yxatdan o'tish"))),
      ]))),
    );
  }

  Widget _FieldW(String lbl, TextEditingController ctrl, {bool obscure = false}) {
    return Padding(padding: const EdgeInsets.only(bottom: 16), child: TextFormField(controller: ctrl, obscureText: obscure, decoration: InputDecoration(labelText: lbl)));
  }
}
