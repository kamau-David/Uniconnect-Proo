import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_connect/features/events/data/event_model.dart';
import 'package:uni_connect/features/events/providers/events_provider.dart';
import 'package:uni_connect/features/budget/providers/budget_provider.dart';
import 'package:uni_connect/features/timer/providers/timer_provider.dart';

// User profile state
class UserProfile {
  final String name;
  final String course;
  final String year;

  const UserProfile({
    required this.name,
    required this.course,
    required this.year,
  });

  UserProfile copyWith({String? name, String? course, String? year}) =>
      UserProfile(
        name: name ?? this.name,
        course: course ?? this.course,
        year: year ?? this.year,
      );
}

class UserNotifier extends StateNotifier<UserProfile> {
  UserNotifier()
      : super(const UserProfile(
          name: 'Alex',
          course: 'Computer Science',
          year: 'Year 3',
        ));

  void updateName(String name) => state = state.copyWith(name: name);
}

final userProvider =
    StateNotifierProvider<UserNotifier, UserProfile>((ref) => UserNotifier());

// Greeting derived from time of day
final greetingProvider = Provider<String>((ref) {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
});

// Today's upcoming events (first 2)
final upcomingEventsProvider = Provider<List<EventModel>>((ref) {
  final events = ref.watch(eventsProvider);
  final now = DateTime.now();
  return events.where((e) => e.date.isAfter(now)).take(2).toList();
});

// Daily quotes
const _quotes = [
  _Quote("Build things that matter.", "Tim Cook"),
  _Quote("The best way to predict the future is to invent it.", "Alan Kay"),
  _Quote("Code is like humor. When you have to explain it, it's bad.",
      "Cory House"),
  _Quote("First, solve the problem. Then, write the code.", "John Johnson"),
  _Quote("Simplicity is the soul of efficiency.", "Austin Freeman"),
  _Quote("Make it work, make it right, make it fast.", "Kent Beck"),
  _Quote("Innovation distinguishes between a leader and a follower.",
      "Steve Jobs"),
];

class _Quote {
  final String text;
  final String author;
  const _Quote(this.text, this.author);
}

final dailyQuoteProvider = Provider<({String text, String author})>((ref) {
  final idx = DateTime.now().day % _quotes.length;
  final q = _quotes[idx];
  return (text: q.text, author: q.author);
});
