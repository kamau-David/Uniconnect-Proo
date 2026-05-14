import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_connect/features/clubs/data/club_model.dart';

class ClubsNotifier extends StateNotifier<List<ClubModel>> {
  ClubsNotifier() : super(List.from(seedClubs));

  void toggleFavourite(String id) {
    state = state
        .map((c) => c.id == id ? c.copyWith(isFavourite: !c.isFavourite) : c)
        .toList();
  }
}

final clubsProvider = StateNotifierProvider<ClubsNotifier, List<ClubModel>>(
    (ref) => ClubsNotifier());

final clubSearchProvider = StateProvider<String>((ref) => '');
final clubCategoryProvider = StateProvider<String>((ref) => 'All');

final filteredClubsProvider = Provider<List<ClubModel>>((ref) {
  final clubs = ref.watch(clubsProvider);
  final search = ref.watch(clubSearchProvider).toLowerCase();
  final category = ref.watch(clubCategoryProvider);

  return clubs.where((c) {
    final matchesSearch = search.isEmpty ||
        c.name.toLowerCase().contains(search) ||
        c.description.toLowerCase().contains(search);
    final matchesCategory = category == 'All' || c.category == category;
    return matchesSearch && matchesCategory;
  }).toList();
});
