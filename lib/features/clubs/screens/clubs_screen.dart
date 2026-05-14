import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_connect/core/theme/app_theme.dart';
import 'package:uni_connect/core/widgets/shared_widgets.dart';
import 'package:uni_connect/features/clubs/data/club_model.dart';
import 'package:uni_connect/features/clubs/providers/clubs_provider.dart';

class ClubsScreen extends ConsumerWidget {
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubs = ref.watch(filteredClubsProvider);
    final category = ref.watch(clubCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.offwhite,
      body: CustomScrollView(
        slivers: [
          // ── App Bar with Search ───────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: AppColors.dark,
            title: const Text('Club Directory'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(112),
              child: Container(
                color: AppColors.dark,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  children: [
                    // Search field
                    TextField(
                      onChanged: (v) =>
                          ref.read(clubSearchProvider.notifier).state = v,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search clubs...',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.4)),
                        prefixIcon: Icon(Icons.search_rounded,
                            color: Colors.white.withOpacity(0.5)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Category chips
                    SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: clubFilterCategories.map((cat) {
                          final isSelected = cat == category;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (_) => ref
                                  .read(clubCategoryProvider.notifier)
                                  .state = cat,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.white70,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white24,
                              ),
                              showCheckmark: false,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Club Grid ─────────────────────────────────────────────────────
          if (clubs.isEmpty)
            const SliverFillRemaining(
              child: EmptyState(
                icon: Icons.search_off_rounded,
                title: 'No clubs found',
                subtitle: 'Try a different search or category',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.88,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _ClubCard(
                    club: clubs[index],
                    index: index,
                    onTap: () => _showClubDetail(context, ref, clubs[index]),
                  ),
                  childCount: clubs.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showClubDetail(BuildContext context, WidgetRef ref, ClubModel club) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ClubDetailSheet(club: club),
    );
  }
}

// ─── Club Card ────────────────────────────────────────────────────────────────
class _ClubCard extends ConsumerWidget {
  final ClubModel club;
  final int index;
  final VoidCallback onTap;

  const _ClubCard({
    required this.club,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Hero(
      tag: 'club_${club.id}',
      child: Material(
        color: Colors.transparent,
        child: UniCard(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(club.emoji,
                          style: const TextStyle(fontSize: 26)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ref
                        .read(clubsProvider.notifier)
                        .toggleFavourite(club.id),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        club.isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        key: ValueKey(club.isFavourite),
                        color: club.isFavourite
                            ? AppColors.danger
                            : AppColors.muted,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(club.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.dark)),
              const SizedBox(height: 4),
              Text(
                '${club.memberCount} members',
                style: const TextStyle(fontSize: 12, color: AppColors.muted),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(club.category,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 60 * index))
        .scale(begin: const Offset(0.92, 0.92));
  }
}

// ─── Club Detail Sheet ────────────────────────────────────────────────────────
class _ClubDetailSheet extends ConsumerWidget {
  final ClubModel club;
  const _ClubDetailSheet({required this.club});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Re-watch so favourite toggle updates in real time
    final liveClub =
        ref.watch(clubsProvider).firstWhere((c) => c.id == club.id);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Hero(
                tag: 'club_${liveClub.id}',
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.light,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(liveClub.emoji,
                        style: const TextStyle(fontSize: 32)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(liveClub.name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.dark)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.light,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(liveClub.category,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => ref
                    .read(clubsProvider.notifier)
                    .toggleFavourite(liveClub.id),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    liveClub.isFavourite
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                    key: ValueKey(liveClub.isFavourite),
                    color: liveClub.isFavourite
                        ? AppColors.danger
                        : AppColors.muted,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(liveClub.description,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textCol, height: 1.6)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _DetailChip(
                  icon: Icons.people_rounded,
                  label: '${liveClub.memberCount} members',
                ),
                const SizedBox(width: 20),
                _DetailChip(
                  icon: Icons.calendar_today_rounded,
                  label: liveClub.meetingDay,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.group_add_rounded),
              label: const Text('Join Club'),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.1, duration: 300.ms).fadeIn();
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.dark)),
      ],
    );
  }
}
