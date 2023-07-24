import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_app/core/services/podcast_services.dart';

final podcastCategoryProvider = FutureProvider.family((ref, String genre,) {
  final podcastservice = ref.read(podcastServiceProvider);
  return podcastservice.fetchPodcast(genre: genre);
});