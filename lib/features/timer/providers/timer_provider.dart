import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TimerMode { focus, shortBreak, longBreak }

enum TimerStatus { idle, running, paused }

class TimerState {
  final int secondsRemaining;
  final int totalSeconds;
  final TimerStatus status;
  final TimerMode mode;
  final int sessionsCompleted;

  const TimerState({
    required this.secondsRemaining,
    required this.totalSeconds,
    required this.status,
    required this.mode,
    required this.sessionsCompleted,
  });

  double get progress => 1.0 - (secondsRemaining / totalSeconds);

  String get timeString {
    final m = secondsRemaining ~/ 60;
    final s = secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  TimerState copyWith({
    int? secondsRemaining,
    int? totalSeconds,
    TimerStatus? status,
    TimerMode? mode,
    int? sessionsCompleted,
  }) =>
      TimerState(
        secondsRemaining: secondsRemaining ?? this.secondsRemaining,
        totalSeconds: totalSeconds ?? this.totalSeconds,
        status: status ?? this.status,
        mode: mode ?? this.mode,
        sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      );

  static TimerState initial() => const TimerState(
        secondsRemaining: 25 * 60,
        totalSeconds: 25 * 60,
        status: TimerStatus.idle,
        mode: TimerMode.focus,
        sessionsCompleted: 0,
      );
}

int _secondsFor(TimerMode mode) {
  switch (mode) {
    case TimerMode.focus:
      return 25 * 60;
    case TimerMode.shortBreak:
      return 5 * 60;
    case TimerMode.longBreak:
      return 15 * 60;
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;

  TimerNotifier() : super(TimerState.initial());

  void start() {
    if (state.status == TimerStatus.running) return;
    state = state.copyWith(status: TimerStatus.running);
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void reset() {
    _timer?.cancel();
    final secs = _secondsFor(state.mode);
    state = state.copyWith(
      secondsRemaining: secs,
      totalSeconds: secs,
      status: TimerStatus.idle,
    );
  }

  void setMode(TimerMode mode) {
    _timer?.cancel();
    final secs = _secondsFor(mode);
    state = state.copyWith(
      mode: mode,
      secondsRemaining: secs,
      totalSeconds: secs,
      status: TimerStatus.idle,
    );
  }

  void _tick(Timer t) {
    if (state.secondsRemaining <= 0) {
      t.cancel();
      final completed = state.mode == TimerMode.focus
          ? state.sessionsCompleted + 1
          : state.sessionsCompleted;
      state = state.copyWith(
        status: TimerStatus.idle,
        sessionsCompleted: completed,
        secondsRemaining: 0,
      );
    } else {
      state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider =
    StateNotifierProvider<TimerNotifier, TimerState>((ref) => TimerNotifier());

final completedSessionsProvider = Provider<int>((ref) {
  return ref.watch(timerProvider).sessionsCompleted;
});
