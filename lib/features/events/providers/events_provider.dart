import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:uni_connect/features/events/data/event_model.dart';

final _uuid = Uuid();

class EventsNotifier extends StateNotifier<List<EventModel>> {
  EventsNotifier() : super(_seedEvents());

  void addEvent({
    required String title,
    required String emoji,
    required DateTime date,
    required String location,
    required String category,
  }) {
    final event = EventModel(
      id: _uuid.v4(),
      title: title,
      emoji: emoji,
      date: date,
      location: location,
      category: category,
    );
    state = [event, ...state];
  }

  void removeEvent(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void toggleSaved(String id) {
    state = state
        .map((e) => e.id == id ? e.copyWith(isSaved: !e.isSaved) : e)
        .toList();
  }
}

final eventsProvider = StateNotifierProvider<EventsNotifier, List<EventModel>>(
    (ref) => EventsNotifier());

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final filteredEventsProvider = Provider<List<EventModel>>((ref) {
  final events = ref.watch(eventsProvider);
  final category = ref.watch(selectedCategoryProvider);
  if (category == 'All') return events;
  return events.where((e) => e.category == category).toList();
});

List<EventModel> _seedEvents() {
  final now = DateTime.now();
  return [
    EventModel(
      id: '1',
      title: 'Tech Talk: AI in Africa',
      emoji: '🎤',
      date: now.add(const Duration(hours: 3)),
      location: 'Room 204',
      category: 'Tech',
    ),
    EventModel(
      id: '2',
      title: 'Hackathon Kickoff',
      emoji: '🏆',
      date: now.add(const Duration(days: 2)),
      location: 'Main Hall',
      category: 'Tech',
      isSaved: true,
    ),
    EventModel(
      id: '3',
      title: 'Design Workshop',
      emoji: '🎨',
      date: now.add(const Duration(days: 4)),
      location: 'Room 101',
      category: 'Arts',
    ),
    EventModel(
      id: '4',
      title: 'Inter-Club Football',
      emoji: '⚽',
      date: now.add(const Duration(days: 5)),
      location: 'Main Field',
      category: 'Sports',
    ),
    EventModel(
      id: '5',
      title: 'Club Social Night',
      emoji: '🎉',
      date: now.add(const Duration(days: 7)),
      location: 'Common Room',
      category: 'Social',
    ),
    EventModel(
      id: '6',
      title: 'Research Symposium',
      emoji: '📚',
      date: now.add(const Duration(days: 10)),
      location: 'Auditorium',
      category: 'Academic',
    ),
  ];
}
