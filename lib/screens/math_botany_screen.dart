import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class MathBotanyScreen extends StatefulWidget {
  const MathBotanyScreen({super.key});

  @override
  State<MathBotanyScreen> createState() => _MathBotanyScreenState();
}

class _MathBotanyScreenState extends State<MathBotanyScreen>
    with TickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: c.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: c.cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: c.cardBorder)),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: c.textPrimary, size: 16),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Botanika Matematikasi',
                  style: Theme.of(context).textTheme.displaySmall),
              Text('Formulalar va kalkulyator',
                  style: GoogleFonts.nunito(fontSize: 12, color: c.textMuted)),
            ]),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.25)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.calculate_outlined,
                      color: Color(0xFFF59E0B), size: 14),
                  const SizedBox(width: 5),
                  Text('Math',
                      style: GoogleFonts.sora(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF59E0B))),
                ]),
              ),
            ],
            bottom: TabBar(
              controller: _tab,
              labelColor: c.primary,
              unselectedLabelColor: c.textMuted,
              indicatorColor: c.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: c.cardBorder,
              labelStyle:
                  GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.w700),
              tabs: const [
                Tab(text: '📐 Formulalar'),
                Tab(text: '🔢 Kalkulyator'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: const [
            _FormulasTab(),
            _CalculatorTab(),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// FORMULAS TAB
// ══════════════════════════════════════════════════════════
class _FormulasTab extends StatelessWidget {
  const _FormulasTab();

  @override
  Widget build(BuildContext context) {
    final sections = _formulaSections(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Botanika formulalari',
                    style: GoogleFonts.sora(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                const SizedBox(height: 6),
                Text(
                    "O'simliklar biologiyasi va ekologiyasiga oid asosiy matematik formulalar",
                    style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.88),
                        height: 1.4)),
              ]),
            ),
            const Text('📐', style: TextStyle(fontSize: 52)),
          ]),
        ),
        const SizedBox(height: 22),
        ...sections.map((s) => _FormulaSection(section: s)),
        const SizedBox(height: 80),
      ]),
    );
  }

  List<_Section> _formulaSections(BuildContext context) => [
        _Section(
          title: 'Fotosintez formulalari',
          emoji: '🌿',
          color: const Color(0xFF16A34A),
          formulas: [
            _Formula(
              name: 'Asosiy fotosintez reaksiyasi',
              formula: "6CO\u2082 + 6H\u2082O + yorug'lik \u2192 C\u2086H\u2081\u2082O\u2086 + 6O\u2082",
              description:
                  'O\'simlik karbonat angidrid va suvdan quyosh nuri yordamida glyukoza va kislorod hosil qiladi.',
              variables: [
                'CO₂ — karbonat angidrid',
                'H₂O — suv',
                'C₆H₁₂O₆ — glyukoza (shakar)',
                'O₂ — kislorod',
              ],
            ),
            _Formula(
              name: 'Fotosintez samaradorligi',
              formula: 'η = (ΔG / E_nur) × 100%',
              description:
                  'O\'simlikdagi fotosintez samaradorligini foizda hisoblaydi.',
              variables: [
                'η — samaradorlik (%)',
                'ΔG — hosil bo\'lgan kimyoviy energiya (J)',
                'E_nur — yutilgan nur energiyasi (J)',
              ],
            ),
          ],
        ),
        _Section(
          title: 'O\'sish va rivojlanish',
          emoji: '🌱',
          color: const Color(0xFF0284C7),
          formulas: [
            _Formula(
              name: "Nisbiy o'sish tezligi (RGR)",
              formula: 'RGR = (ln W₂ − ln W₁) / (t₂ − t₁)',
              description:
                  "O'simlikning vaqt birligiga nisbatan biomassa to'plash tezligi.",
              variables: [
                'W₁ — boshlang\'ich massa (g)',
                'W₂ — yakuniy massa (g)',
                't₁, t₂ — vaqt nuqtalari (kun)',
                'ln — natural logarifm',
              ],
            ),
            _Formula(
              name: 'Barglar maydoni indeksi (LAI)',
              formula: 'LAI = ΣA_barg / A_tuproq',
              description:
                  "Tuproq maydoniga nisbatan barcha barglar umumiy maydonining nisbati.",
              variables: [
                'A_barg — barcha barglar umumiy maydoni (m²)',
                'A_tuproq — tuproq gorizontal maydoni (m²)',
              ],
            ),
            _Formula(
              name: 'Net assimilyatsiya tezligi (NAR)',
              formula: 'NAR = (W₂ − W₁) / ((A₁ + A₂)/2 × (t₂ − t₁))',
              description:
                  "Barg maydoni birligiga to'g'ri keladigan quruq massa to'planish tezligi.",
              variables: [
                'W — quruq massa (g)',
                'A — barg maydoni (cm²)',
                't — vaqt (kun)',
              ],
            ),
          ],
        ),
        _Section(
          title: 'Ekologiya va populyatsiya',
          emoji: '🌳',
          color: const Color(0xFF7C3AED),
          formulas: [
            _Formula(
              name: 'Populyatsiya zichligi',
              formula: 'D = N / A',
              description:
                  "Birlik maydondagi individlar soni — populyatsiya zichligi.",
              variables: [
                'D — zichlik (dona/m²)',
                'N — individlar soni',
                'A — maydon (m²)',
              ],
            ),
            _Formula(
              name: 'Logistik o\'sish modeli',
              formula: 'dN/dt = rN × (K − N) / K',
              description:
                  "Populyatsiya sig'im chegarasiga (K) yaqinlashganda o'sish tezlashishi pasayadi.",
              variables: [
                'N — populyatsiya hajmi',
                'r — o\'sish koeffitsienti',
                'K — ekologik sig\'im (carrying capacity)',
                't — vaqt',
              ],
            ),
            _Formula(
              name: "Shanon xilma-xillik indeksi",
              formula: 'H\' = −Σ (pᵢ × ln pᵢ)',
              description:
                  "Ekotizimdagi o'simlik turlarining xilma-xillik darajasini o'lchaydi.",
              variables: [
                'H\' — Shanon indeksi',
                'pᵢ — i-tur ulushi (nisbiy ko\'pligi)',
                'Σ — barcha turlar bo\'yicha yig\'indisi',
              ],
            ),
          ],
        ),
        _Section(
          title: 'Suv va transport',
          emoji: '💧',
          color: const Color(0xFF0891B2),
          formulas: [
            _Formula(
              name: 'Transpiratsiya samaradorligi (TE)',
              formula: 'TE = ΔBiomassa / ΔSuv',
              description:
                  "Bug'latilgan har litr suv hisobiga hosil bo'lgan biomassa miqdori.",
              variables: [
                'ΔBiomassa — hosil bo\'lgan massa (g)',
                'ΔSuv — sarflangan suv (L)',
              ],
            ),
            _Formula(
              name: "Suv potentsiali",
              formula: 'Ψ = Ψs + Ψp',
              description:
                  "Hujayradagi umumiy suv potentsiali osmotik va bosim potentsiallarining yig'indisi.",
              variables: [
                'Ψ — umumiy suv potentsiali (MPa)',
                'Ψs — osmotik potentsial (MPa)',
                'Ψp — bosim potentsiali (MPa)',
              ],
            ),
          ],
        ),
      ];
}

class _Section {
  final String title, emoji;
  final Color color;
  final List<_Formula> formulas;
  const _Section({
    required this.title,
    required this.emoji,
    required this.color,
    required this.formulas,
  });
}

class _Formula {
  final String name, formula, description;
  final List<String> variables;
  const _Formula({
    required this.name,
    required this.formula,
    required this.description,
    required this.variables,
  });
}

class _FormulaSection extends StatefulWidget {
  final _Section section;
  const _FormulaSection({required this.section});

  @override
  State<_FormulaSection> createState() => _FormulaSectionState();
}

class _FormulaSectionState extends State<_FormulaSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = widget.section;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(children: [
            Text(s.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(s.title,
                  style: GoogleFonts.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: c.textPrimary)),
            ),
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_down_rounded,
                  color: c.textMuted, size: 22),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _expanded
              ? Column(
                  children: s.formulas
                      .map((f) => _FormulaCard(formula: f, color: s.color))
                      .toList())
              : const SizedBox.shrink(),
        ),
      ]),
    );
  }
}

class _FormulaCard extends StatefulWidget {
  final _Formula formula;
  final Color color;
  const _FormulaCard({required this.formula, required this.color});

  @override
  State<_FormulaCard> createState() => _FormulaCardState();
}

class _FormulaCardState extends State<_FormulaCard> {
  bool _showVars = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.cardBorder),
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [BoxShadow(
                color: widget.color.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3))]
            : [],
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(widget.formula.name,
                    style: GoogleFonts.sora(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: c.textPrimary)),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.formula.formula));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Formulani nusxaladingiz!"),
                    duration: Duration(seconds: 1),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.copy_rounded,
                      color: widget.color, size: 15),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: widget.color.withValues(alpha: 0.18)),
              ),
              child: Text(
                widget.formula.formula,
                style: GoogleFonts.robotoMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: widget.color,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Text(widget.formula.description,
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: c.textMuted,
                    height: 1.5)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _showVars = !_showVars),
              child: Row(children: [
                Icon(
                  _showVars
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: widget.color,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  _showVars ? "O'zgaruvchilarni yashirish" : "O'zgaruvchilarni ko'rish",
                  style: GoogleFonts.sora(
                      fontSize: 11,
                      color: widget.color,
                      fontWeight: FontWeight.w700),
                ),
              ]),
            ),
            if (_showVars) ...[
              const SizedBox(height: 8),
              ...widget.formula.variables.map((v) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 5, right: 8),
                        decoration: BoxDecoration(
                            color: widget.color, shape: BoxShape.circle),
                      ),
                      Expanded(
                        child: Text(v,
                            style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: c.textSecondary,
                                height: 1.4)),
                      ),
                    ]),
                  )),
            ],
          ]),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════
// CALCULATOR TAB
// ══════════════════════════════════════════════════════════
class _CalculatorTab extends StatefulWidget {
  const _CalculatorTab();

  @override
  State<_CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<_CalculatorTab> {
  String _display = '0';
  String _expression = '';
  double? _prevNum;
  String? _operation;
  bool _justCalculated = false;
  int _selectedCalc = 0;

  // Botanika kalkulyator turlari
  final List<Map<String, dynamic>> _calcTypes = [
    {'label': 'Oddiy', 'emoji': '🔢'},
    {'label': 'O\'sish', 'emoji': '🌱'},
    {'label': 'Transpiratsiya', 'emoji': '💧'},
    {'label': 'Populyatsiya', 'emoji': '🌳'},
  ];

  // Controllers for botany calculators
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();
  String _calcResult = '';

  @override
  void dispose() {
    _c1.dispose(); _c2.dispose(); _c3.dispose();
    super.dispose();
  }

  void _press(String val) {
    setState(() {
      if (_justCalculated && RegExp(r'[0-9.]').hasMatch(val)) {
        _display = val; _expression = ''; _justCalculated = false; return;
      }
      _justCalculated = false;
      if (val == 'AC') {
        _display = '0'; _expression = ''; _prevNum = null; _operation = null;
      } else if (val == '⌫') {
        if (_display.length > 1) _display = _display.substring(0, _display.length - 1);
        else _display = '0';
      } else if (val == '+/-') {
        if (_display != '0') {
          _display = _display.startsWith('-') ? _display.substring(1) : '-$_display';
        }
      } else if (val == '%') {
        final n = double.tryParse(_display) ?? 0;
        _display = _format(n / 100);
      } else if (['+', '−', '×', '÷'].contains(val)) {
        _prevNum = double.tryParse(_display);
        _operation = val;
        _expression = '$_display $val';
        _display = '0';
      } else if (val == '=') {
        if (_prevNum != null && _operation != null) {
          final curr = double.tryParse(_display) ?? 0;
          double res = 0;
          switch (_operation) {
            case '+': res = _prevNum! + curr; break;
            case '−': res = _prevNum! - curr; break;
            case '×': res = _prevNum! * curr; break;
            case '÷': res = curr != 0 ? _prevNum! / curr : double.nan; break;
          }
          _expression = '${_expression} $_display =';
          _display = res.isNaN ? 'Xato' : _format(res);
          _prevNum = null; _operation = null; _justCalculated = true;
        }
      } else if (val == '.') {
        if (!_display.contains('.')) _display += '.';
      } else {
        if (_display == '0') _display = val;
        else if (_display.length < 12) _display += val;
      }
    });
  }

  String _format(double v) {
    if (v == v.truncateToDouble()) return v.truncate().toString();
    final s = v.toStringAsFixed(8);
    return s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  void _calcBotany() {
    setState(() {
      try {
        switch (_selectedCalc) {
          case 1: // RGR
            final w1 = double.parse(_c1.text);
            final w2 = double.parse(_c2.text);
            final days = double.parse(_c3.text);
            final rgr = (log(w2) - log(w1)) / days;
            _calcResult = 'RGR = ${rgr.toStringAsFixed(4)} g/g/kun';
          case 2: // Transpiratsiya
            final biomass = double.parse(_c1.text);
            final water = double.parse(_c2.text);
            final te = biomass / water;
            _calcResult = 'TE = ${te.toStringAsFixed(3)} g/L';
          case 3: // Populyatsiya zichligi
            final n = double.parse(_c1.text);
            final area = double.parse(_c2.text);
            final d = n / area;
            _calcResult = 'D = ${d.toStringAsFixed(2)} dona/m²';
        }
      } catch (_) {
        _calcResult = "Xatolik: To'g'ri qiymat kiriting!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 80),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Calc type selector
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_calcTypes.length, (i) {
              final on = _selectedCalc == i;
              final gold = const Color(0xFFF59E0B);
              return GestureDetector(
                onTap: () => setState(() { _selectedCalc = i; _calcResult = ''; _c1.clear(); _c2.clear(); _c3.clear(); }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: on ? gold : c.cardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: on ? gold : c.cardBorder, width: on ? 2 : 1),
                    boxShadow: on ? [BoxShadow(color: gold.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))] : [],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(_calcTypes[i]['emoji']!, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(_calcTypes[i]['label']!,
                        style: GoogleFonts.sora(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: on ? Colors.white : c.textMuted)),
                  ]),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 18),

        if (_selectedCalc == 0) ...[
          // ── Standard Calculator ──────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1C1C1E), Color(0xFF2C2C2E)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(_expression,
                  style: GoogleFonts.sora(fontSize: 13, color: Colors.white.withValues(alpha: 0.45)),
                  maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(_display,
                    style: GoogleFonts.sora(
                        fontSize: 56,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        letterSpacing: -1)),
              ),
              const SizedBox(height: 18),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 16),
              ..._buildButtonRows(),
            ]),
          ),
        ] else ...[
          // ── Botany Calculator ───────────────────────────
          _BotanyCalcWidget(
            type: _selectedCalc,
            c1: _c1, c2: _c2, c3: _c3,
            result: _calcResult,
            onCalc: _calcBotany,
          ),
        ],
      ]),
    );
  }

  List<Widget> _buildButtonRows() {
    const rows = [
      ['AC', '+/-', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
      ['⌫', '0', '.', '='],
    ];
    return rows.map((row) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: row.map((btn) {
          final isOp = ['÷', '×', '−', '+', '='].contains(btn);
          final isTop = ['AC', '+/-', '%'].contains(btn);
          final isDel = btn == '⌫';
          Color bg = const Color(0xFF3A3A3C);
          Color fg = Colors.white;
          if (isOp) { bg = const Color(0xFFF59E0B); fg = Colors.white; }
          if (isTop) { bg = const Color(0xFF636366); fg = Colors.white; }
          if (isDel) { bg = const Color(0xFF3A3A3C); fg = const Color(0xFFF59E0B); }
          if (btn == '=') { bg = const Color(0xFFD97706); }

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () { HapticFeedback.selectionClick(); _press(btn); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  height: 62,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 6, offset: const Offset(0, 3))],
                  ),
                  child: Center(
                    child: Text(btn,
                        style: GoogleFonts.sora(
                            fontSize: btn.length > 1 ? 13 : 20,
                            fontWeight: FontWeight.w600,
                            color: fg)),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    )).toList();
  }
}

// ── Botany specific calculators ─────────────────────────
class _BotanyCalcWidget extends StatelessWidget {
  final int type;
  final TextEditingController c1, c2, c3;
  final String result;
  final VoidCallback onCalc;
  const _BotanyCalcWidget({required this.type, required this.c1, required this.c2, required this.c3, required this.result, required this.onCalc});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final gold = const Color(0xFFF59E0B);

    final configs = {
      1: {
        'title': "Nisbiy o'sish tezligi (RGR)",
        'formula': 'RGR = (ln W₂ − ln W₁) / (t₂ − t₁)',
        'fields': [
          {'label': 'W₁ — boshlang\'ich massa', 'hint': 'gramm', 'ctrl': c1},
          {'label': 'W₂ — yakuniy massa', 'hint': 'gramm', 'ctrl': c2},
          {'label': 'Davr', 'hint': 'kunlar soni', 'ctrl': c3},
        ],
      },
      2: {
        'title': 'Transpiratsiya samaradorligi (TE)',
        'formula': 'TE = ΔBiomassa / ΔSuv',
        'fields': [
          {'label': 'Hosil bo\'lgan biomassa', 'hint': 'gramm', 'ctrl': c1},
          {'label': 'Sarflangan suv', 'hint': 'litr', 'ctrl': c2},
        ],
      },
      3: {
        'title': 'Populyatsiya zichligi (D)',
        'formula': 'D = N / A',
        'fields': [
          {'label': 'Individlar soni (N)', 'hint': 'dona', 'ctrl': c1},
          {'label': 'Maydon (A)', 'hint': 'm²', 'ctrl': c2},
        ],
      },
    };

    final cfg = configs[type]!;
    final title = cfg['title'] as String;
    final formula = cfg['formula'] as String;
    final fields = cfg['fields'] as List;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: gold.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: gold.withValues(alpha: 0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w800, color: c.textPrimary)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: gold.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(formula, style: GoogleFonts.sourceCodePro(fontSize: 13, color: gold, fontWeight: FontWeight.w700)),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      ...fields.map((f) {
        final field = f as Map;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(field['label'] as String, style: GoogleFonts.sora(fontSize: 12.5, fontWeight: FontWeight.w700, color: c.textPrimary)),
            const SizedBox(height: 6),
            TextField(
              controller: field['ctrl'] as TextEditingController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.sora(fontSize: 14, color: c.textPrimary),
              decoration: InputDecoration(
                hintText: field['hint'] as String,
                hintStyle: GoogleFonts.nunito(color: c.textMuted),
                filled: true, fillColor: c.cardBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.cardBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.cardBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: gold, width: 2)),
              ),
            ),
          ]),
        );
      }),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onCalc,
          style: ElevatedButton.styleFrom(
            backgroundColor: gold,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text('Hisoblash', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
        ),
      ),
      if (result.isNotEmpty) ...[
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [gold.withValues(alpha: 0.12), gold.withValues(alpha: 0.04)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: gold.withValues(alpha: 0.3)),
          ),
          child: Column(children: [
            const Text('📊', style: TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text('Natija', style: GoogleFonts.sora(fontSize: 12, color: gold, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(result, style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w900, color: c.textPrimary), textAlign: TextAlign.center),
          ]),
        ),
      ],
    ]);
  }
}
