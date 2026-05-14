import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';
import 'package:intl/intl.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostDialog(context),
        backgroundColor: c.primary,
        icon: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
        label: Text("Ulashish", style: GoogleFonts.sora(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            backgroundColor: c.surface,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text("Jamiyat",
                  style: GoogleFonts.sora(
                      fontWeight: FontWeight.w800,
                      color: c.textPrimary,
                      fontSize: 18)),
              background: Container(color: c.surface),
            ),
            actions: [
              IconButton(
                  icon: const Icon(Icons.search_rounded), onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopStudentsRow(),
                  const SizedBox(height: 24),
                  Text("Yangi gerbariylar",
                      style: GoogleFonts.sora(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: c.textPrimary)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          StreamBuilder<List<CommunityPostModel>>(
            stream: FirebaseService.communityPostsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.eco_rounded, size: 64, color: c.textMuted),
                        const SizedBox(height: 16),
                        Text("Hozircha hech qanday post yo'q",
                            style: GoogleFonts.nunito(color: c.textMuted)),
                      ],
                    ),
                  ),
                );
              }
              final posts = snapshot.data!;
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _FeedCard(post: posts[index]),
                    childCount: posts.length,
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final c = context.colors;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setModalState) {

          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(5)))),
                const SizedBox(height: 20),
                Text("Yangi gerbariy ulashish",
                    style: GoogleFonts.sora(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: c.primary)),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "O'simlik nomi",
                    filled: true,
                    fillColor: c.background,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Tavsif va foydali ma'lumotlar...",
                    filled: true,
                    fillColor: c.background,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (nameController.text.isEmpty ||
                                descController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Barcha maydonlarni to'ldiring")),
                              );
                              return;
                            }

                            final user = FirebaseService.currentFirebaseUser;
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Post yuklash uchun ro'yxatdan o'tish zarur")),
                              );
                              return;
                            }

                            setModalState(() => isLoading = true);

                            try {
                              final userData =
                                  await FirebaseService.loadUser(user.uid);

                              final post = CommunityPostModel(
                                id: '',
                                userId: user.uid,
                                userName: userData?.fullName ?? "O'quvchi",
                                userGrade: userData?.grade ?? "",
                                plantName: nameController.text,
                                description: descController.text,
                                likes: 0,
                                comments: 0,
                              );

                              await FirebaseService.createPost(post);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Post muvaffaqiyatli saqlandi!"),
                                      backgroundColor: Colors.green),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                setModalState(() => isLoading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Xatolik yuz berdi: $e"),
                                      backgroundColor: Colors.red),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text("Yuborish",
                            style: GoogleFonts.sora(
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      );
    },
  );
}
}

class _TopStudentsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Faol o'quvchilar",
                style: GoogleFonts.sora(
                    fontSize: 15, fontWeight: FontWeight.w700)),
            TextButton(
                onPressed: () {},
                child: Text("Barchasi", style: TextStyle(color: c.primary))),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: StreamBuilder<List<UserModel>>(
            stream: FirebaseService.topUsersStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final users = snapshot.data!;
              if (users.isEmpty) {
                return Text("Hozircha hech kim ro'yxatdan o'tmagan",
                    style: GoogleFonts.nunito(
                        fontSize: 12, color: c.textMuted));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, i) => Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: c.primary.withValues(alpha: 0.1),
                        child: Text('👤', style: const TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(height: 6),
                      Text(users[i].firstName,
                          style: GoogleFonts.nunito(
                              fontSize: 11, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FeedCard extends StatelessWidget {
  final CommunityPostModel post;
  const _FeedCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final timeAgo = DateFormat('HH:mm').format(post.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.cardBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                    backgroundColor: c.primary.withValues(alpha: 0.1),
                    radius: 18,
                    child: const Text('👨‍🎓', style: TextStyle(fontSize: 12))),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.userName,
                            style: GoogleFonts.sora(
                                fontSize: 13, fontWeight: FontWeight.w700)),
                        Text("${post.userGrade}-sinf o'quvchisi",
                            style: GoogleFonts.nunito(
                                fontSize: 11, color: c.textMuted)),
                      ]),
                ),
                Text(timeAgo,
                    style: GoogleFonts.nunito(
                        fontSize: 10, color: c.textMuted)),
              ],
            ),
          ),
          if (post.imageUrl != null)
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: NetworkImage(post.imageUrl!), fit: BoxFit.cover),
              ),
            )
          else
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                  child: Icon(Icons.eco_rounded,
                      size: 50, color: Colors.green.withValues(alpha: 0.5))),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.plantName,
                    style: GoogleFonts.sora(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.green)),
                const SizedBox(height: 4),
                Text(post.description,
                    style: GoogleFonts.nunito(
                        fontSize: 12, color: c.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ActionIcon(
                      Icons.favorite_rounded,
                      "${post.likes}",
                      Colors.red,
                      onTap: () => FirebaseService.likePost(post.id),
                    ),
                    const SizedBox(width: 15),
                    _ActionIcon(
                      Icons.chat_bubble_outline_rounded,
                      "${post.comments}",
                      c.textMuted,
                      onTap: () {
                        // Kelajakda izohlar uchun
                      },
                    ),
                    const Spacer(),
                    const Icon(Icons.bookmark_border_rounded),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String count;
  final Color color;
  final VoidCallback? onTap;

  const _ActionIcon(this.icon, this.count, this.color, {this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 5),
            Text(count,
                style: GoogleFonts.sora(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textSecondary))
          ]),
        ),
      );
}
