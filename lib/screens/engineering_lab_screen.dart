import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

// Engineering Lab Screen
class EngineeringLabScreen extends StatefulWidget {
  const EngineeringLabScreen({super.key});
  @override
  State<EngineeringLabScreen> createState() => _EngineeringLabScreenState();
}

class _EngineeringLabScreenState extends State<EngineeringLabScreen>
    with TickerProviderStateMixin {
  late TabController _tab;
  int _selectedLab = 0;

  static final List<_LabConfig> _labs = [
    _LabConfig(
      id: 'photosynthesis',
      title: "Fotosintez laboratoriyasi",
      icon: Icons.eco_rounded,
      color: const Color(0xFF16A34A),
      desc: "CO₂, suv va yorug'lik orqali fotosintez samaradorligini o'lchaymiz",
      params: [
        _Param('☀️ Yorug\'lik', 0, 100, 60, '%', const Color(0xFFF59E0B)),
        _Param('💧 Suv miqdori', 0, 100, 70, '%', const Color(0xFF0284C7)),
        _Param('🌬️ CO₂', 200, 800, 400, ' ppm', const Color(0xFF6B7280)),
        _Param('🌡️ Harorat', 5, 45, 25, '°C', const Color(0xFFDC2626)),
      ],
      resultFn: _photoResult,
      resultLabel: "Hosil bo'lgan O₂",
      unit: 'mmol/m²/s',
      fact: "Optimal: yorug'lik 60-80%, suv 60-80%, CO₂ 400-600 ppm, harorat 20-30°C",
    ),
    _LabConfig(
      id: 'osmosis',
      title: "Osmoz jarayoni",
      icon: Icons.water_drop_rounded,
      color: const Color(0xFF0284C7),
      desc: "Hujayra membranasi orqali suv o'tishini nazorat qilamiz",
      params: [
        _Param('🧂 Ichki tuz (hujayra)', 0, 100, 30, ' g/L', const Color(0xFF0284C7)),
        _Param('🧂 Tashqi tuz (muhit)', 0, 100, 50, ' g/L', const Color(0xFF7C3AED)),
        _Param('🌡️ Harorat', 5, 40, 20, '°C', const Color(0xFFDC2626)),
      ],
      resultFn: _osmosisResult,
      resultLabel: "Suv o'tish tezligi",
      unit: 'μm/s',
      fact: "Tashqi muhit konsentratsiyasi > ichki → hujayra suv yo'qotadi (плазмолиз)",
    ),
    _LabConfig(
      id: 'respiration',
      title: "O'simlik nafas olishi",
      icon: Icons.air_rounded,
      color: const Color(0xFFDC2626),
      desc: "Aerob nafas olish: ATP va CO₂ ishlab chiqarishni o'lchaymiz",
      params: [
        _Param('🌡️ Harorat', 0, 45, 25, '°C', const Color(0xFFDC2626)),
        _Param('💧 Namlik', 0, 100, 60, '%', const Color(0xFF0284C7)),
        _Param('⚡ O₂ miqdori', 0, 25, 21, '%', const Color(0xFFF59E0B)),
        _Param('🍬 Glyukoza', 0, 100, 50, ' mmol', const Color(0xFF16A34A)),
      ],
      resultFn: _respirationResult,
      resultLabel: "ATP ishlab chiqarish",
      unit: 'mol ATP',
      fact: "Aerob nafas: C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + 38 ATP",
    ),
    _LabConfig(
      id: 'pollination',
      title: "Changlanish (Gullash sikli)",
      icon: Icons.local_florist_rounded,
      color: const Color(0xFFDB2777),
      desc: "Changlanish sharoitlarini sozlab, urug'lanish foizini aniqlaymiz",
      params: [
        _Param('🌡️ Harorat', 5, 40, 20, '°C', const Color(0xFFDC2626)),
        _Param('☀️ Kun uzunligi', 6, 18, 12, ' soat', const Color(0xFFF59E0B)),
        _Param('💧 Namlik', 20, 100, 60, '%', const Color(0xFF0284C7)),
        _Param('🐝 Hasharot faolligi', 0, 100, 70, '%', const Color(0xFF16A34A)),
      ],
      resultFn: _pollinationResult,
      resultLabel: "Changlanish foizi",
      unit: '%',
      fact: "Ko'pchilik gullar 18-25°C harorat va 8-16 soatlik kun uzunligida yaxshi changlanadi",
    ),
    _LabConfig(
      id: 'soil',
      title: "Tuproq tarkibi",
      icon: Icons.layers_rounded,
      color: const Color(0xFF92400E),
      desc: "Mineral oziqalar miqdorini tartiblab, o'simlik o'sishini kuzatamiz",
      params: [
        _Param('🟢 Azot (N)', 0, 100, 50, ' mg/kg', const Color(0xFF16A34A)),
        _Param('🟠 Fosfor (P)', 0, 100, 40, ' mg/kg', const Color(0xFFEA580C)),
        _Param('🔵 Kaliy (K)', 0, 100, 45, ' mg/kg', const Color(0xFF0284C7)),
        _Param('⚗️ pH', 40, 90, 65, '', const Color(0xFF7C3AED)),
      ],
      resultFn: _soilResult,
      resultLabel: "O'simlik o'sish indeksi",
      unit: '%',
      fact: "Optimal: N=40-60, P=30-50, K=40-60 mg/kg, pH 6.0-7.0 (60-70)",
    ),
    _LabConfig(
      id: 'hydroponics',
      title: "Gidroponika",
      icon: Icons.science_rounded,
      color: const Color(0xFF7C3AED),
      desc: "Tuproqsiz o'stirish — eritma tarkibi va muhitni boshqaramiz",
      params: [
        _Param('⚗️ Eritma pH', 40, 90, 60, '', const Color(0xFF7C3AED)),
        _Param('💡 EC (tuz)', 0, 40, 20, ' mS/cm', const Color(0xFFF59E0B)),
        _Param('🌡️ Eritma harorat', 10, 35, 22, '°C', const Color(0xFFDC2626)),
        _Param('☀️ Fotosintez nuri', 0, 100, 70, '%', const Color(0xFF16A34A)),
      ],
      resultFn: _hydroResult,
      resultLabel: "Hosildorlik indeksi",
      unit: '%',
      fact: "Ideal gidroponika: pH 5.5-6.5, EC 1.5-2.5 mS/cm, harorat 18-24°C",
    ),
  ];

  static final List<Map<String, dynamic>> _phetLabs = [
    {
      'title': 'Membrana transporti',
      'desc': 'Moddalarning hujayra membranasi orqali harakatlanishini o\'rganing.',
      'url': 'https://phet.colorado.edu/sims/html/membrane-transport/latest/membrane-transport_all.html',
      'icon': Icons.biotech_rounded,
      'tag': 'Hujayra',
      'color': const Color(0xFF22C55E),
    },
    {
      'title': 'Tabiiy tanlanish',
      'desc': 'Evolyutsion jarayonlar va o\'simliklar populyatsiyasi o\'zgarishini simulyatsiya qiling.',
      'url': 'https://phet.colorado.edu/sims/html/natural-selection/latest/natural-selection_all.html',
      'icon': Icons.group_work_rounded,
      'tag': 'Evolyutsiya',
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'pH shkalasi',
      'desc': 'Tuproq tarkibi va pH darajasining o\'simliklarga ta\'sirini tushunish uchun.',
      'url': 'https://phet.colorado.edu/sims/html/ph-scale/latest/ph-scale_all.html',
      'icon': Icons.biotech_rounded,
      'tag': 'Kimyo',
      'color': const Color(0xFF34D399),
    },
    {
      'title': 'Gen ifodalanishi',
      'desc': 'Molekulyar biologiya va genetika asoslarini virtual o\'rganing.',
      'url': 'https://phet.colorado.edu/sims/html/gene-expression-essentials/latest/gene-expression-essentials_all.html',
      'icon': Icons.biotech_rounded,
      'tag': 'Genetika',
      'color': const Color(0xFF15803D),
    },
    {
      'title': 'Fotosintez (LabX)',
      'desc': 'Yorug\'lik energiyasining kimyoviy energiyaga aylanishi laboratoriyasi.',
      'url': 'https://www.labxchange.org/library/items/lb:LabXchange:6304c4f3:html:1',
      'icon': Icons.wb_sunny_rounded,
      'tag': 'Fiziologiya',
      'color': const Color(0xFF4ADE80),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
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
            leading: Navigator.canPop(context) 
                ? Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: c.cardBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: c.cardBorder),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: c.textPrimary, size: 16),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  )
                : null,
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Elektron Laboratoriya', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              Text('${_labs.length + _phetLabs.length} ta virtual tajriba', style: GoogleFonts.nunito(fontSize: 11, color: c.textMuted)),
            ]),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEA580C).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFEA580C).withValues(alpha: 0.25)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.settings_outlined, color: Color(0xFFEA580C), size: 14),
                  const SizedBox(width: 5),
                  Text('Engineer', style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFEA580C))),
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
              labelStyle: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w700),
              tabs: const [
                Tab(text: "Mahalliy"),
                Tab(text: "Tajriba"),
                Tab(text: "PhET Lab"),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: [
            _LabListTab(
              labs: _labs,
              selected: _selectedLab,
              onSelect: (i) {
                setState(() => _selectedLab = i);
                _tab.animateTo(1);
              },
            ),
            _ExperimentTab(key: ValueKey(_selectedLab), lab: _labs[_selectedLab]),
            _PhetTab(labs: _phetLabs),
          ],
        ),
      ),
    );
  }

  // ── Result functions ──────────────────────────────────
  static double _photoResult(List<double> v) {
    // v: [yorug'lik, suv, co2, harorat]
    double s = 0;
    s += (v[0] >= 40 && v[0] <= 80) ? 35 : (v[0] < 20) ? 5 : 18;
    s += (v[1] >= 50 && v[1] <= 85) ? 30 : (v[1] < 20) ? 3 : 14;
    s += (v[2] >= 350 && v[2] <= 650) ? 25 : (v[2] < 250) ? 5 : 12;
    s += (v[3] >= 18 && v[3] <= 30) ? 10 : (v[3] < 5 || v[3] > 40) ? 0 : 5;
    return s.clamp(0, 100);
  }

  static double _osmosisResult(List<double> v) {
    // v: [ichki tuz, tashqi tuz, harorat]
    final diff = (v[1] - v[0]).abs();
    double base = diff * 1.2;
    final tempBonus = (v[2] >= 15 && v[2] <= 30) ? 1.2 : 0.8;
    return (base * tempBonus).clamp(0, 100);
  }

  static double _respirationResult(List<double> v) {
    // v: [harorat, namlik, o2, glyukoza]
    double s = 0;
    s += (v[0] >= 15 && v[0] <= 35) ? 30 : (v[0] < 5 || v[0] > 42) ? 2 : 14;
    s += (v[1] >= 40 && v[1] <= 80) ? 25 : 10;
    s += (v[2] >= 18) ? 30 : (v[2] < 5) ? 2 : 15;
    s += (v[3] >= 30) ? 15 : 5;
    return s.clamp(0, 100);
  }

  static double _pollinationResult(List<double> v) {
    // v: [harorat, kun uzunligi, namlik, hasharot]
    double s = 0;
    s += (v[0] >= 15 && v[0] <= 28) ? 30 : (v[0] < 8 || v[0] > 37) ? 2 : 15;
    s += (v[1] >= 8 && v[1] <= 16) ? 25 : 10;
    s += (v[2] >= 40 && v[2] <= 80) ? 25 : 8;
    s += (v[3] >= 50) ? 20 : v[3] * 0.2;
    return s.clamp(0, 100);
  }

  static double _soilResult(List<double> v) {
    // v: [azot, fosfor, kaliy, pH]
    double s = 0;
    s += (v[0] >= 30 && v[0] <= 70) ? 28 : (v[0] < 10) ? 5 : 14;
    s += (v[1] >= 25 && v[1] <= 60) ? 25 : (v[1] < 10) ? 5 : 12;
    s += (v[2] >= 30 && v[2] <= 65) ? 25 : (v[2] < 10) ? 5 : 12;
    s += (v[3] >= 58 && v[3] <= 72) ? 22 : (v[3] < 45 || v[3] > 85) ? 3 : 10;
    return s.clamp(0, 100);
  }

  static double _hydroResult(List<double> v) {
    // v: [pH, EC, harorat, nur]
    double s = 0;
    s += (v[0] >= 52 && v[0] <= 68) ? 30 : (v[0] < 42 || v[0] > 80) ? 3 : 15;
    s += (v[1] >= 12 && v[1] <= 28) ? 28 : (v[1] < 5) ? 4 : 14;
    s += (v[2] >= 16 && v[2] <= 26) ? 25 : (v[2] < 10 || v[2] > 33) ? 3 : 12;
    s += (v[3] >= 55 && v[3] <= 90) ? 17 : (v[3] < 20) ? 2 : 9;
    return s.clamp(0, 100);
  }
}

// ─── Lab list tab ──────────────────────────────────────────
class _LabListTab extends StatelessWidget {
  final List<_LabConfig> labs;
  final int selected;
  final void Function(int) onSelect;
  const _LabListTab({required this.labs, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [const Color(0xFFEA580C).withValues(alpha: 0.1), const Color(0xFFEA580C).withValues(alpha: 0.02)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEA580C).withValues(alpha: 0.2)),
          ),
          child: Row(children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: const Color(0xFFEA580C).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
              child: Icon(Icons.biotech_rounded, color: const Color(0xFFEA580C), size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Virtual tajribaxona", style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w800, color: c.textPrimary)),
              const SizedBox(height: 4),
              Text("Har bir mavzuga mos alohida simulyatsiya tajribasi", style: GoogleFonts.nunito(fontSize: 11.5, color: c.textMuted, height: 1.4)),
            ])),
          ]),
        ),
        const SizedBox(height: 20),
        Text("Laboratoriyani tanlang", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.92),
          itemCount: labs.length,
          itemBuilder: (_, i) {
            final lab = labs[i];
            final isSelected = selected == i;
            return GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? lab.color.withValues(alpha: 0.12) : c.cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isSelected ? lab.color.withValues(alpha: 0.45) : c.cardBorder, width: isSelected ? 2 : 1),
                  boxShadow: isSelected ? [BoxShadow(color: lab.color.withValues(alpha: 0.22), blurRadius: 14, offset: const Offset(0, 4))] : [],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Icon(lab.icon, color: lab.color, size: 32),
                    if (isSelected)
                      Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: lab.color, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, color: Colors.white, size: 12)),
                  ]),
                  const Spacer(),
                  Text(lab.title, style: GoogleFonts.sora(fontSize: 11.5, fontWeight: FontWeight.w800, color: c.textPrimary, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(lab.desc, style: GoogleFonts.nunito(fontSize: 9.5, color: c.textMuted, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: lab.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text("Tajriba boshlash →", style: GoogleFonts.sora(fontSize: 9, fontWeight: FontWeight.w700, color: lab.color)),
                  ),
                ]),
              ),
            );
          },
        ),
        const SizedBox(height: 80),
      ]),
    );
  }
}

// ─── Experiment Tab ────────────────────────────────────────
class _ExperimentTab extends StatefulWidget {
  final _LabConfig lab;
  const _ExperimentTab({super.key, required this.lab});

  @override
  State<_ExperimentTab> createState() => _ExperimentTabState();
}

class _ExperimentTabState extends State<_ExperimentTab> {
  late List<double> _values;
  bool _running = false;
  bool _finished = false;
  double _result = 0;

  @override
  void initState() {
    super.initState();
    _values = widget.lab.params.map((p) => p.defaultVal).toList();
  }

  void _run() {
    setState(() { _running = true; _finished = false; });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final res = widget.lab.resultFn(_values);
      setState(() { _running = false; _finished = true; _result = res; });
    });
  }

  String get _grade {
    if (_result >= 85) return '🏆 A+ — Mukammal natija!';
    if (_result >= 70) return '🎉 A — Ajoyib!';
    if (_result >= 55) return '👍 B — Yaxshi';
    if (_result >= 35) return '💪 C — O\'rtacha';
    return 'D — Qayta urinib ko\'ring';
  }

  Color _gradeColor(BuildContext ctx) {
    final c = ctx.colors;
    if (_result >= 70) return c.successGreen;
    if (_result >= 55) return c.warningYellow;
    return c.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final lab = widget.lab;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Lab header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [lab.color, lab.color.withValues(alpha: 0.65)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(children: [
            Icon(lab.icon, color: Colors.white, size: 48),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(lab.title, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 4),
              Text(lab.desc, style: GoogleFonts.nunito(fontSize: 11.5, color: Colors.white.withValues(alpha: 0.88), height: 1.4)),
            ])),
          ]),
        ),
        const SizedBox(height: 18),

        // Parametrlar
        Text("Tajriba shartlarini sozlang", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...List.generate(lab.params.length, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildSlider(context, i),
        )),
        const SizedBox(height: 8),

        // Maslahat
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: lab.color.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(12), border: Border.all(color: lab.color.withValues(alpha: 0.18))),
          child: Row(children: [
            Icon(Icons.lightbulb_outline_rounded, color: lab.color, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(lab.fact, style: GoogleFonts.nunito(fontSize: 11.5, color: c.textSecondary, height: 1.4))),
          ]),
        ),
        const SizedBox(height: 16),

        // Natija
        if (_finished) ...[
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 400),
            builder: (_, v, child) => Opacity(opacity: v, child: child),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _gradeColor(context).withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _gradeColor(context).withValues(alpha: 0.28)),
              ),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${_result.toStringAsFixed(1)}',
                      style: GoogleFonts.sora(fontSize: 42, fontWeight: FontWeight.w900, color: _gradeColor(context))),
                  const SizedBox(width: 6),
                  Text(lab.unit, style: GoogleFonts.sora(fontSize: 14, color: _gradeColor(context).withValues(alpha: 0.7))),
                ]),
                const SizedBox(height: 4),
                Text(lab.resultLabel, style: GoogleFonts.nunito(fontSize: 12, color: c.textMuted)),
                const SizedBox(height: 10),
                Text(_grade, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w700, color: c.textPrimary)),
                // Progress bar
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _result / 100,
                    minHeight: 8,
                    backgroundColor: c.cardBorder,
                    valueColor: AlwaysStoppedAnimation<Color>(_gradeColor(context)),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Tugma
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _running ? null : _run,
            style: ElevatedButton.styleFrom(
              backgroundColor: lab.color,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: _running
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)),
                    const SizedBox(width: 10),
                    Text("Simulyatsiya o'tkazilmoqda...", style: GoogleFonts.sora(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                  ])
                : Text(_finished ? '🔄  Qayta o\'tkazish' : '▶  Tajribani boshlash',
                    style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 80),
      ]),
    );
  }

  Widget _buildSlider(BuildContext context, int i) {
    final c = context.colors;
    final p = widget.lab.params[i];
    final v = _values[i];
    // pH ko'rsatish uchun
    final displayVal = p.label.contains('pH') ? '${(v / 10).toStringAsFixed(1)}' : '${v.toStringAsFixed(0)}${p.unit}';
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(14), border: Border.all(color: c.cardBorder)),
      child: Column(children: [
        Row(children: [
          Text(p.label, style: GoogleFonts.sora(fontWeight: FontWeight.w600, fontSize: 12.5, color: c.textPrimary)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(color: p.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(displayVal, style: GoogleFonts.sora(fontSize: 11.5, fontWeight: FontWeight.w700, color: p.color)),
          ),
        ]),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(activeTrackColor: p.color, thumbColor: p.color, inactiveTrackColor: p.color.withValues(alpha: 0.15), overlayColor: p.color.withValues(alpha: 0.1), trackHeight: 4),
          child: Slider(value: v, min: p.min, max: p.max, onChanged: (val) => setState(() => _values[i] = val)),
        ),
      ]),
    );
  }
}

// ─── Data classes ─────────────────────────────────────────
class _LabConfig {
  final String id, title, desc, resultLabel, unit, fact;
  final IconData icon;
  final Color color;
  final List<_Param> params;
  final double Function(List<double>) resultFn;
  const _LabConfig({required this.id, required this.title, required this.icon, required this.color, required this.desc, required this.params, required this.resultFn, required this.resultLabel, required this.unit, required this.fact});
}

class _Param {
  final String label, unit;
  final double min, max, defaultVal;
  final Color color;
  const _Param(this.label, this.min, this.max, this.defaultVal, this.unit, this.color);
}

// ─── PhET Tab ──────────────────────────────────────────────
class _PhetTab extends StatelessWidget {
  final List<Map<String, dynamic>> labs;
  const _PhetTab({required this.labs});

  Future<void> _launch(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Havolani ochib bo'lmadi: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: labs.length,
      itemBuilder: (context, index) {
        final lab = labs[index];
        final color = lab['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: c.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.cardBorder),
          ),
          child: InkWell(
            onTap: () => _launch(context, lab['url']),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                  width: 54, height: 54,
                  decoration: BoxDecoration(color: color.withValues(alpha:0.1), borderRadius: BorderRadius.circular(15)),
                  child: Center(child: Icon(lab['icon'] as IconData, color: color, size: 26)),
                ),
                const SizedBox(width: 15),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(lab['title'], style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w800, color: c.textPrimary)),
                  const SizedBox(height: 4),
                  Text(lab['desc'], style: GoogleFonts.nunito(fontSize: 11, color: c.textMuted), maxLines: 2),
                ])),
                const Icon(Icons.open_in_new_rounded, size: 16, color: Colors.grey),
              ]),
            ),
          ),
        );
      },
    );
  }
}
