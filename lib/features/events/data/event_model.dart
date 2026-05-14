class EventModel {
  final String id;
  final String title;
  final String emoji;
  final DateTime date;
  final String location;
  final String category;
  bool isSaved;

  EventModel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.date,
    required this.location,
    required this.category,
    this.isSaved = false,
  });

  EventModel copyWith({
    String? title,
    String? emoji,
    DateTime? date,
    String? location,
    String? category,
    bool? isSaved,
  }) =>
      EventModel(
        id: id,
        title: title ?? this.title,
        emoji: emoji ?? this.emoji,
        date: date ?? this.date,
        location: location ?? this.location,
        category: category ?? this.category,
        isSaved: isSaved ?? this.isSaved,
      );
}

const eventCategories = ['All', 'Tech', 'Sports', 'Social', 'Academic', 'Arts'];

const categoryEmojis = {
  'Tech': '💻',
  'Sports': '⚽',
  'Social': '🎉',
  'Academic': '📚',
  'Arts': '🎨',
};
