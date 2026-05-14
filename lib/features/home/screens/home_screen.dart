import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uni_connect/core/theme/app_theme.dart';
import 'package:uni_connect/core/widgets/shared_widgets.dart';
import 'package:uni_connect/features/home/providers/home_providers.dart';
import 'package:uni_connect/features/events/data/event_model.dart';
import 'package:uni_connect/features/budget/providers/budget_provider.dart';
import 'package:uni_connect/features/timer/providers/timer_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final greeting = ref.watch(greetingProvider);
    final upcoming = ref.watch(upcomingEventsProvider);
    final quote = ref.watch(dailyQuoteProvider);
    final budget = ref.watch(budgetProvider);
    final sessions = ref.watch(completedSessionsProvider);

    return Scaffold(
      backgroundColor: AppColors.offwhite,
      body: CustomScrollView(
        slivers: [
          // ── Collapsing App Bar ────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.dark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.dark,
                      AppColors.dark2,
                      Color(0xFF4338CA)
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$greeting, ${user.name}! 👋',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(delay: 100.ms)
                                    .slideX(begin: -0.1),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('EEEE, d MMMM y')
                                      .format(DateTime.now()),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ).animate().fadeIn(delay: 200.ms),
                              ],
                            ),
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                user.name[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(delay: 150.ms)
                                .scale(begin: const Offset(0.8, 0.8)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${user.course}  •  ${user.year}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(delay: 250.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Body Content ─────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        value: '${upcoming.length}',
                        label: 'Upcoming',
                        icon: Icons.event_rounded,
                        color: AppColors.primary,
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        value: '$sessions',
                        label: 'Pomodoros',
                        icon: Icons.timer_rounded,
                        color: AppColors.secondary,
                      ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        value:
                            'KES ${(budget.totalSpent / 1000).toStringAsFixed(1)}k',
                        label: 'Spent',
                        icon: Icons.account_balance_wallet_rounded,
                        color: AppColors.warning,
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Upcoming Events
                SectionHeader(
                  title: 'Upcoming Events',
                  action: 'See all',
                  onAction: () => context.go('/events'),
                ).animate().fadeIn(delay: 250.ms),
                const SizedBox(height: 12),
                if (upcoming.isEmpty)
                  UniCard(
                    child: const EmptyState(
                      icon: Icons.event_busy_rounded,
                      title: 'No upcoming events',
                      subtitle: 'Add events to see them here',
                    ),
                  )
                else
                  ...upcoming.asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _EventTile(event: e.value)
                            .animate()
                            .fadeIn(
                                delay: Duration(milliseconds: 300 + e.key * 80))
                            .slideX(begin: 0.1),
                      )),

                const SizedBox(height: 24),

                // Daily Quote
                SectionHeader(title: 'Daily Quote')
                    .animate()
                    .fadeIn(delay: 400.ms),
                const SizedBox(height: 12),
                _QuoteCard(quote: quote)
                    .animate()
                    .fadeIn(delay: 450.ms)
                    .slideY(begin: 0.1),

                const SizedBox(height: 24),

                // Quick Actions
                SectionHeader(title: 'Quick Actions')
                    .animate()
                    .fadeIn(delay: 500.ms),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _QuickAction(
                      icon: Icons.timer_rounded,
                      label: 'Start Focus',
                      color: AppColors.secondary,
                      onTap: () => context.go('/timer'),
                    )
                        .animate()
                        .fadeIn(delay: 550.ms)
                        .scale(begin: const Offset(0.9, 0.9)),
                    const SizedBox(width: 12),
                    _QuickAction(
                      icon: Icons.add_card_rounded,
                      label: 'Log Expense',
                      color: AppColors.warning,
                      onTap: () => context.go('/budget'),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms)
                        .scale(begin: const Offset(0.9, 0.9)),
                    const SizedBox(width: 12),
                    _QuickAction(
                      icon: Icons.group_add_rounded,
                      label: 'Find Clubs',
                      color: AppColors.purple,
                      onTap: () => context.go('/clubs'),
                    )
                        .animate()
                        .fadeIn(delay: 650.ms)
                        .scale(begin: const Offset(0.9, 0.9)),
                  ],
                ),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Event Tile ───────────────────────────────────────────────────────────────
class _EventTile extends StatelessWidget {
  final EventModel event;
  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(event.date, DateTime.now());
    return UniCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(event.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.dark)),
                const SizedBox(height: 2),
                Text(
                  '${DateFormat('EEE h:mm a').format(event.date)} • ${event.location}',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          if (isToday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Today',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success)),
            ),
        ],
      ),
    );
  }
}

// ─── Quote Card ───────────────────────────────────────────────────────────────
class _QuoteCard extends StatelessWidget {
  final ({String text, String author}) quote;
  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.dark, AppColors.dark2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote_rounded,
              color: AppColors.secondary, size: 28),
          const SizedBox(height: 8),
          Text(
            '"${quote.text}"',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '— ${quote.author}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Action ─────────────────────────────────────────────────────────────
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
