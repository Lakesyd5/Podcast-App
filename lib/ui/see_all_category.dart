import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_app/ui/podcast_details.dart';
import 'package:podcast_app/ui/providers/podcast_provider.dart';
import 'package:podcast_search/podcast_search.dart';

class SeeAll extends ConsumerWidget {
  const SeeAll({super.key, required this.title, required this.genre});
  final String title;
  final String genre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seeallPodcast = ref.watch(podcastCategoryProvider(genre));
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: seeallPodcast.when(
        data: (SearchResult data) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: data.resultCount,
              itemBuilder: (BuildContext context, int index) {
                final items = data.items;
                final item = items[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PodcastDetailsScreen(item: item),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.artworkUrl600 ?? '',
                      // height: 450,
                      width: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          );
        },
        error: (error, stackTrace) {
          return const Center(
            child: Text('Opps! Somethign went wrong.'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
