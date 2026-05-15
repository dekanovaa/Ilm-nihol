import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class ArtsHerbariumScreen extends StatefulWidget {
  const ArtsHerbariumScreen({super.key});

  @override
  State<ArtsHerbariumScreen> createState() => _ArtsHerbariumScreenState();
}

class _ArtsHerbariumScreenState extends State<ArtsHerbariumScreen>
    with TickerProviderStateMixin {
  late TabController _tab;
  final List<_HerbariumPhoto> _photos = [];
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (file != null && mounted) {
        // Web uchun bytes o'qish
        final Uint8List bytes = await file.readAsBytes();
        final controller = TextEditingController();
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _AddPhotoSheet(
            imageBytes: bytes,
            controller: controller,
            onSave: (name) {
              setState(() {
                _photos.insert(0, _HerbariumPhoto(
                  bytes: bytes,
                  name: name.isEmpty ? "Gerbariy #${_photos.length + 1}" : name,
                  date: DateTime.now(),
                ));
              });
            },
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Rasm yuklashda xatolik: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showPickerDialog() {
    final c = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: c.cardBorder,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Text("Rasm qo'shish",
                style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: c.textPrimary)),
            const SizedBox(height: 16),
            _PickerOption(
              icon: Icons.photo_camera_rounded,
              label: "Kamera",
              subtitle: "Yangi rasm olish",
              color: const Color(0xFF0284C7),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 10),
            _PickerOption(
              icon: Icons.photo_library_rounded,
              label: "Galereya",
              subtitle: "Mavjud rasmni tanlash",
              color: const Color(0xFF7C3AED),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
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
              Text("Gerbariy Bo'limi", style: Theme.of(context).textTheme.displaySmall),
              Text("Videolar va mening kolleksiyam", style: GoogleFonts.nunito(fontSize: 12, color: c.textMuted)),
            ]),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDB2777).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFDB2777).withValues(alpha: 0.25)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.palette_outlined,
                      color: Color(0xFFDB2777), size: 14),
                  const SizedBox(width: 5),
                  Text('Arts',
                      style: GoogleFonts.sora(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFDB2777))),
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
              tabs: [
                const Tab(text: "Videolar"),
                Tab(text: "Kolleksiyam (${_photos.length})"),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: [
            const _VideosTab(),
            _MyHerbariumTab(
              photos: _photos,
              onAdd: _showPickerDialog,
              onDelete: (i) => setState(() => _photos.removeAt(i)),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tab,
        builder: (_, __) => _tab.index == 1
            ? FloatingActionButton.extended(
                onPressed: _showPickerDialog,
                backgroundColor: const Color(0xFFDB2777),
                icon: const Icon(Icons.add_photo_alternate_rounded,
                    color: Colors.white),
                label: Text("Rasm qo'shish",
                    style: GoogleFonts.sora(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

// Videos Tab
class _VideosTab extends StatelessWidget {
  const _VideosTab();

  static const List<Map<String, dynamic>> _videos = [
    {
      'title': "Gerbariy tayyorlash",
      'icon': Icons.assignment_rounded,
      'duration': '0:58',
      'channel': 'Ilmnihol',
      'color': Color(0xFFF59E0B),
      'url': 'https://youtube.com/shorts/96UAaf0NsSE',
    },
    {
      'title': "Gerbariy tayyorlash",
      'icon': Icons.eco_rounded,
      'duration': '0:56',
      'channel': 'Ilmnihol',
      'color': Color(0xFF16A34A),
      'url': 'https://youtube.com/shorts/vqD5OBIXJAo',
    },
    {
      'title': "Gerbariy tayyorlash",
      'icon': Icons.auto_awesome_rounded,
      'duration': '0:45',
      'channel': 'BotanikaTV',
      'color': Color(0xFF7C3AED),
      'url': 'https://youtube.com/shorts/BlBvibGYvuE',
    },
    {
      'title': "Gerbariy tayyorlash",
      'icon': Icons.book_rounded,
      'duration': '12:15',
      'channel': 'Ilmnihol',
      'color': Color(0xFFDB2777),
      'url': 'https://youtu.be/FXsIaYxGU3M',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFDB2777), Color(0xFF9D174D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Gerbariy yasash bo'yicha",
                    style: GoogleFonts.sora(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text("Video darslar",
                    style: GoogleFonts.sora(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("${_videos.length} ta video mavjud",
                      style: GoogleFonts.sora(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
              ]),
            ),
            const Icon(Icons.palette_rounded, color: Colors.white, size: 56),
          ]),
        ),
        const SizedBox(height: 20),
        Text("Barcha videolar",
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _videos.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => _VideoCard(video: _videos[i]),
        ),
        const SizedBox(height: 80),
      ]),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final Map<String, dynamic> video;
  const _VideoCard({required this.video});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = video['color'] as Color;
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(video['url']!);
        if (await canLaunchUrl(uri)) {
          launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Videoni ochib bo'lmadi: ${video['url']}"),
          ));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: c.cardBorder),
          boxShadow: Theme.of(context).brightness == Brightness.light
              ? [
                  BoxShadow(
                      color: color.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3))
                ]
              : [],
        ),
        child: Row(children: [
          // Thumbnail
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(18)),
            ),
            child: Stack(alignment: Alignment.center, children: [
              Icon(video['icon'] as IconData, color: Colors.white, size: 34),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(video['duration'] as String,
                      style: GoogleFonts.sora(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.red.withValues(alpha: 0.4),
                        blurRadius: 8)
                  ],
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 18),
              ),
            ]),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(video['title'] as String,
                    style: GoogleFonts.sora(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: c.textPrimary,
                        height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(video['desc'] as String,
                    style: GoogleFonts.nunito(
                        fontSize: 10.5, color: c.textMuted, height: 1.35),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(video['channel'] as String,
                        style: GoogleFonts.sora(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: color)),
                  ),
                  const Spacer(),
                  const Icon(Icons.play_circle_outline_rounded,
                      color: Colors.red, size: 18),
                ]),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

// My Herbarium Tab
class _MyHerbariumTab extends StatelessWidget {
  final List<_HerbariumPhoto> photos;
  final VoidCallback onAdd;
  final void Function(int) onDelete;
  const _MyHerbariumTab(
      {required this.photos, required this.onAdd, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (photos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFDB2777).withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFDB2777).withValues(alpha: 0.2)),
              ),
              child: const Center(
                  child: Icon(Icons.eco_rounded, color: Color(0xFFDB2777), size: 48)),
            ),
            const SizedBox(height: 20),
            Text("Hali gerbariy yo'q",
                style: GoogleFonts.sora(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: c.textPrimary)),
            const SizedBox(height: 8),
            Text(
              "Yasagan gerbariyngiz yoki ekkan gulingizning rasmini yuklab, kolleksiyangizni boshlang!",
              style: GoogleFonts.nunito(
                  fontSize: 14, color: c.textMuted, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_photo_alternate_rounded),
              label: Text("Birinchi rasmni qo'shish",
                  style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDB2777),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ]),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _StatBadge("${photos.length}", "Rasm", const Color(0xFFDB2777)),
          const SizedBox(width: 10),
          _StatBadge(
              "${photos.where((p) => DateTime.now().difference(p.date).inDays < 7).length}",
              "Bu hafta",
              const Color(0xFF16A34A)),
        ]),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),
          itemCount: photos.length,
          itemBuilder: (_, i) =>
              _PhotoCard(photo: photos[i], onDelete: () => onDelete(i)),
        ),
      ]),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatBadge(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(value,
            style: GoogleFonts.sora(
                fontSize: 18, fontWeight: FontWeight.w900, color: color)),
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.nunito(
                fontSize: 12,
                color: c.textMuted,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final _HerbariumPhoto photo;
  final VoidCallback onDelete;
  const _PhotoCard({required this.photo, required this.onDelete});

  String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inDays > 0) return '${d.inDays} kun oldin';
    if (d.inHours > 0) return '${d.inHours} soat oldin';
    return 'Az oldin';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.cardBorder),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFDB2777).withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Image — Image.memory web uchun ✅
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          child: Stack(children: [
            Image.memory(
              photo.bytes,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 140,
                color: const Color(0xFFDB2777).withValues(alpha: 0.1),
                child: const Center(
                    child: Icon(Icons.eco_rounded, color: Color(0xFFDB2777), size: 48)),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("O'chirish"),
                      content: Text("'${photo.name}' ni o'chirasizmi?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Yo'q")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onDelete();
                            },
                            child: const Text("Ha",
                                style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 14),
                ),
              ),
            ),
          ]),
        ),
        // Info
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(photo.name,
                style: GoogleFonts.sora(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Text(_timeAgo(photo.date),
                style: GoogleFonts.nunito(fontSize: 10, color: c.textMuted)),
          ]),
        ),
      ]),
    );
  }
}

// Add Photo Sheet
class _AddPhotoSheet extends StatefulWidget {
  final Uint8List imageBytes;
  final TextEditingController controller;
  final void Function(String) onSave;
  const _AddPhotoSheet(
      {required this.imageBytes,
      required this.controller,
      required this.onSave});

  @override
  State<_AddPhotoSheet> createState() => _AddPhotoSheetState();
}

class _AddPhotoSheetState extends State<_AddPhotoSheet> {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: c.cardBorder,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text("Gerbariy nomini kiriting",
                style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: c.textPrimary)),
            const SizedBox(height: 14),
            // Image.memory — web uchun ✅
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.memory(
                widget.imageBytes,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: const Color(0xFFDB2777).withValues(alpha: 0.1),
                  child: const Center(
                      child: Icon(Icons.eco_rounded, color: Color(0xFFDB2777), size: 48)),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: widget.controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Masalan: Qizil atirgul, Lola...",
                hintStyle: GoogleFonts.nunito(color: c.textMuted),
                filled: true,
                fillColor: c.cardBg,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: c.cardBorder)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: c.cardBorder)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFDB2777), width: 2)),
                prefixIcon: const Icon(Icons.local_florist_rounded,
                    color: Color(0xFFDB2777)),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave(widget.controller.text.trim());
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDB2777),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Saqlash",
                    style: GoogleFonts.sora(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.white)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─── Picker option ────────────────────────────────────────
class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _PickerOption(
      {required this.icon,
      required this.label,
      required this.subtitle,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary)),
            Text(subtitle,
                style: GoogleFonts.nunito(fontSize: 11.5, color: c.textMuted)),
          ]),
          const Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: c.textMuted),
        ]),
      ),
    );
  }
}

// ─── Data class (bytes saqlanadi) ─────────────────────────
class _HerbariumPhoto {
  final Uint8List bytes; // ✅ File o'rniga bytes — web uchun
  final String name;
  final DateTime date;
  _HerbariumPhoto(
      {required this.bytes, required this.name, required this.date});
}
