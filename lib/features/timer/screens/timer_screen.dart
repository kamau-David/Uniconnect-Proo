import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_connect/core/theme/app_theme.dart';
import 'package:uni_connect/features/timer/providers/timer_provider.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerProvider);

    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        backgroundColor: AppColors.dark,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      '${timer.sessionsCompleted} done',
                      style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Mode Selector ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: TimerMode.values.map((mode) {
                  final isSelected = timer.mode == mode;
                  final label = switch (mode) {
                    TimerMode.focus => 'Focus',
                    TimerMode.shortBreak => 'Short Break',
                    TimerMode.longBreak => 'Long Break',
                  };
                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(timerProvider.notifier).setMode(mode),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white54,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Ring Timer ────────────────────────────────────────────────────
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: CustomPaint(
                      painter: _RingPainter(
                        progress: timer.progress,
                        color: switch (timer.mode) {
                          TimerMode.focus => AppColors.primary,
                          TimerMode.shortBreak => AppColors.success,
                          TimerMode.longBreak => AppColors.secondary,
                        },
                        isRunning: timer.status == TimerStatus.running,
                      ),
                    ),
                  )
                      .animate(
                        onPlay: (c) => c.repeat(),
                      )
                      .shimmer(
                        duration: 3.seconds,
                        color: Colors.white.withOpacity(0.03),
                        delay: 1.seconds,
                      ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timer.timeString,
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -2,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      )
                          .animate(
                              target:
                                  timer.status == TimerStatus.running ? 1 : 0)
                          .scale(
                              end: const Offset(1.02, 1.02), duration: 500.ms),
                      const SizedBox(height: 6),
                      Text(
                        switch (timer.mode) {
                          TimerMode.focus => 'Stay focused 🎯',
                          TimerMode.shortBreak => 'Short break ☕',
                          TimerMode.longBreak => 'Long break 🌿',
                        },
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Session Dots ──────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final filled = i < (timer.sessionsCompleted % 4);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: filled ? 24 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: filled
                      ? AppColors.success
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            'Session ${(timer.sessionsCompleted % 4) + 1} of 4',
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),

          // ── Controls ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Reset
                _ControlButton(
                  icon: Icons.refresh_rounded,
                  label: 'Reset',
                  onTap: () => ref.read(timerProvider.notifier).reset(),
                  color: Colors.white24,
                  iconColor: Colors.white60,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(width: 20),
                // Play / Pause
                GestureDetector(
                  onTap: () {
                    final notifier = ref.read(timerProvider.notifier);
                    if (timer.status == TimerStatus.running) {
                      notifier.pause();
                    } else {
                      notifier.start();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: timer.status == TimerStatus.running
                          ? AppColors.warning
                          : AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (timer.status == TimerStatus.running
                                  ? AppColors.warning
                                  : AppColors.primary)
                              .withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      timer.status == TimerStatus.running
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ).animate().scale(delay: 100.ms),
                const SizedBox(width: 20),
                // Skip
                _ControlButton(
                  icon: Icons.skip_next_rounded,
                  label: 'Skip',
                  onTap: () => ref.read(timerProvider.notifier).reset(),
                  color: Colors.white24,
                  iconColor: Colors.white60,
                ).animate().fadeIn(delay: 200.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Ring Painter ─────────────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isRunning;

  const _RingPainter({
    required this.progress,
    required this.color,
    required this.isRunning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 14.0;

    // Background track
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        progressPaint,
      );
    }

    // Glow dot at tip
    if (progress > 0.01 && isRunning) {
      final angle = -pi / 2 + 2 * pi * progress;
      final dotX = center.dx + radius * cos(angle);
      final dotY = center.dy + radius * sin(angle);
      final glowPaint = Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(dotX, dotY), 8, glowPaint);
      canvas.drawCircle(Offset(dotX, dotY), 6, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.isRunning != isRunning;
}

// ─── Control Button ───────────────────────────────────────────────────────────
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color iconColor;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    color: iconColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
