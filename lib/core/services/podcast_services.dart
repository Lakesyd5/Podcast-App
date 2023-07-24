import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';

final podcastServiceProvider = Provider((ref) => PodcastServices());

class PodcastServices {
  Future<SearchResult> fetchPodcast({String genre = ''}) async {
    final search = Search();
    final results = await search.charts(country: Country.nigeria, limit: 10, genre: genre);
    return results;
  }

  Future<Podcast> getPodcast(String feedUrl) async {
    final podcast = await Podcast.loadFeed(url: feedUrl);
    return podcast;
  }
} 