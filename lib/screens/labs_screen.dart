import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class LabsScreen extends StatelessWidget {
  const LabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final labs = [
      {
        'title': 'Membrana orqali tashish',
        'desc': 'Moddalarning hujayra membranasi orqali harakatlanishini o\'rganing (PhET).',
        'url': 'https://phet.colorado.edu/sims/html/membrane-transport/latest/membrane-transport_all.html',
        'icon': '🧬',
        'tag': 'Hujayra',
        'color': const Color(0xFF22C55E),
      },
      {
        'title': 'Tabiiy tanlanish',
        'desc': 'Evolyutsion jarayonlar va o\'simliklar populyatsiyasi o\'zgarishini simulyatsiya qiling (PhET).',
        'url': 'https://phet.colorado.edu/sims/html/natural-selection/latest/natural-selection_all.html',
        'icon': '🐰',
        'tag': 'Evolyutsiya',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'pH shkalasi',
        'desc': 'Tuproq tarkibi va pH darajasining o\'simliklarga ta\'sirini tushunish uchun (PhET).',
        'url': 'https://phet.colorado.edu/sims/html/ph-scale/latest/ph-scale_all.html',
        'icon': '🧪',
        'tag': 'Kimyo',
        'color': const Color(0xFF34D399),
      },
      {
        'title': 'Gen ifodalanishi',
        'desc': 'Molekulyar biologiya va genetika asoslarini virtual o\'rganing (PhET).',
        'url': 'https://phet.colorado.edu/sims/html/gene-expression-essentials/latest/gene-expression-essentials_all.html',
        'icon': '🧬',
        'tag': 'Genetika',
        'color': const Color(0xFF15803D),
      },
      {
        'title': 'O\'simlik parvarishi',
        'desc': 'Suv, yorug\'lik va harorat o\'simlik o\'sishiga ta\'sirini tekshiruvchi virtual eksperiment.',
        'url': 'virtual_care',
        'icon': '🌱',
        'tag': 'Simulatsiya',
        'color': const Color(0xFF16A34A),
      },
      {
        'title': 'Fotosintez',
        'desc': 'Yorug\'lik energiyasining kimyoviy energiyaga aylanishi laboratoriyasi.',
        'url': 'https://www.labxchange.org/library/items/lb:LabXchange:6304c4f3:html:1',
        'icon': '☀️',
        'tag': 'Fiziologiya',
        'color': const Color(0xFF4ADE80),
      },
    ];

    return Scaffold(
      backgroundColor: c.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: c.surface,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Elektron Laboratoriya",
                  style: GoogleFonts.sora(
                      fontWeight: FontWeight.w800,
                      color: c.textPrimary,
                      fontSize: 18)),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              background: Container(color: c.surface),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(18),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _LabCard(lab: labs[index]),
                childCount: labs.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _LabCard extends StatelessWidget {
  final Map<String, dynamic> lab;
  const _LabCard({required this.lab});

  Future<void> _launchLab(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Havolani ochib bo'lmadi: $url")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = lab['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.cardBorder),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: InkWell(
        onTap: () {
          if (lab['url'] == 'virtual_care') {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => _VirtualCareSimulationSheet(),
            );
          } else {
            _launchLab(context, lab['url']);
          }
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(lab['icon'], style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(lab['tag'],
                          style: GoogleFonts.sora(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: color)),
                    ),
                    const SizedBox(height: 6),
                    Text(lab['title'],
                        style: GoogleFonts.sora(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: c.textPrimary)),
                    const SizedBox(height: 4),
                    Text(lab['desc'],
                        style: GoogleFonts.nunito(
                            fontSize: 12, color: c.textMuted)),
                  ],
                ),
              ),
              Icon(Icons.open_in_new_rounded, size: 18, color: c.textLight),
            ],
          ),
        ),
      ),
    );
  }
}

class _VirtualCareSimulationSheet extends StatefulWidget {
  @override
  State<_VirtualCareSimulationSheet> createState() => _VirtualCareSimulationSheetState();
}

class _VirtualCareSimulationSheetState extends State<_VirtualCareSimulationSheet> {
  double _water = 50, _sun = 60, _temp = 22;
  bool _simulating = false;
  int _health = 70;

  void _simulate() {
    setState(() => _simulating = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      int h = 0;
      h += (_water >= 40 && _water <= 80) ? 35 : (_water < 20 || _water > 90) ? 5 : 20;
      h += (_sun >= 50 && _sun <= 80) ? 35 : 15;
      h += (_temp >= 15 && _temp <= 30) ? 30 : 10;
      setState(() { _health = h.clamp(0, 100); _simulating = false; });
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hColor = Color.lerp(c.errorRed, c.successGreen, _health / 100)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(color: c.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: c.cardBorder, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        Text("O'simlik parvarishi", style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w800, color: c.textPrimary)),
        const SizedBox(height: 40),
        Center(child: Text(_health >= 80 ? '🌳' : _health >= 60 ? '🌿' : _health >= 40 ? '🌱' : '🥀', style: const TextStyle(fontSize: 80))),
        const SizedBox(height: 12),
        Text("Sog'liq: $_health%", style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w800, color: hColor)),
        const SizedBox(height: 40),
        _Slider('💧 Suv', _water, 0, 100, '%', (v) => setState(() => _water = v), c.primary),
        const SizedBox(height: 16),
        _Slider('☀️ Nur', _sun, 0, 100, '%', (v) => setState(() => _sun = v), Colors.amber),
        const SizedBox(height: 16),
        _Slider('🌡️ Harorat', _temp, 0, 45, '°C', (v) => setState(() => _temp = v), Colors.orange),
        const Spacer(),
        SizedBox(
          width: double.infinity, height: 55,
          child: ElevatedButton(
            onPressed: _simulating ? null : _simulate,
            child: _simulating ? const CircularProgressIndicator(color: Colors.white) : const Text("Tekshirish"),
          ),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }

  Widget _Slider(String lbl, double val, double min, double max, String unit, Function(double) onChanged, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(lbl, style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 13, color: context.colors.textPrimary)),
        Text('${val.round()}$unit', style: GoogleFonts.sora(fontWeight: FontWeight.w800, fontSize: 12, color: color)),
      ]),
      Slider(value: val, min: min, max: max, activeColor: color, onChanged: onChanged),
    ]);
  }
}
