class ClubModel {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final String category;
  final int memberCount;
  final String meetingDay;
  bool isFavourite;

  ClubModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.category,
    required this.memberCount,
    required this.meetingDay,
    this.isFavourite = false,
  });

  ClubModel copyWith({bool? isFavourite}) => ClubModel(
        id: id,
        name: name,
        emoji: emoji,
        description: description,
        category: category,
        memberCount: memberCount,
        meetingDay: meetingDay,
        isFavourite: isFavourite ?? this.isFavourite,
      );
}

const clubFilterCategories = [
  'All',
  'Tech',
  'Sports',
  'Arts',
  'Community',
  'Academic'
];

final seedClubs = [
  ClubModel(
      id: '1',
      name: 'Tech & Innovation',
      emoji: '💻',
      description:
          'Build, hack, and launch ideas that solve real problems. Weekly workshops, hackathons, and mentorship.',
      category: 'Tech',
      memberCount: 120,
      meetingDay: 'Thursdays 5PM',
      isFavourite: true),
  ClubModel(
      id: '2',
      name: 'Design Society',
      emoji: '🎨',
      description:
          'UI/UX, graphic design, motion graphics. Monthly critiques and guest designer sessions.',
      category: 'Arts',
      memberCount: 85,
      meetingDay: 'Tuesdays 4PM'),
  ClubModel(
      id: '3',
      name: 'Sports Union',
      emoji: '⚽',
      description:
          'Football, basketball, volleyball, athletics. Inter-university tournaments every semester.',
      category: 'Sports',
      memberCount: 200,
      meetingDay: 'Mon & Wed 6AM',
      isFavourite: true),
  ClubModel(
      id: '4',
      name: 'Drama Club',
      emoji: '🎭',
      description:
          'Stage performances, improv sessions, and storytelling workshops for all skill levels.',
      category: 'Arts',
      memberCount: 60,
      meetingDay: 'Fridays 3PM'),
  ClubModel(
      id: '5',
      name: 'Environment Club',
      emoji: '🌍',
      description:
          'Campus clean-ups, tree planting, sustainability campaigns, and policy advocacy.',
      category: 'Community',
      memberCount: 95,
      meetingDay: 'Saturdays 9AM'),
  ClubModel(
      id: '6',
      name: 'Debate Society',
      emoji: '🗣️',
      description:
          'Parliamentary debate, public speaking, and critical thinking. National competition team.',
      category: 'Academic',
      memberCount: 70,
      meetingDay: 'Wednesdays 5PM'),
  ClubModel(
      id: '7',
      name: 'Photography Club',
      emoji: '📸',
      description:
          'Street photography, portraits, drone footage, and darkroom sessions.',
      category: 'Arts',
      memberCount: 55,
      meetingDay: 'Sundays 2PM'),
  ClubModel(
      id: '8',
      name: 'Entrepreneurship Hub',
      emoji: '🚀',
      description:
          'Pitch competitions, business plan workshops, investor meetups, and startup incubation.',
      category: 'Tech',
      memberCount: 110,
      meetingDay: 'Fridays 5PM'),
  ClubModel(
      id: '9',
      name: 'Music Society',
      emoji: '🎵',
      description:
          'Choir, band, afrobeat ensemble. Perform at campus events and external venues.',
      category: 'Arts',
      memberCount: 80,
      meetingDay: 'Tuesdays 6PM'),
  ClubModel(
      id: '10',
      name: 'Community Service',
      emoji: '🤝',
      description:
          'Volunteering, tutoring, fundraising, and outreach programs in the local community.',
      category: 'Community',
      memberCount: 130,
      meetingDay: 'Saturdays 8AM'),
];
