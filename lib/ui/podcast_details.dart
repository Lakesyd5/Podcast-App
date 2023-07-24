import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_app/core/services/podcast_services.dart';
import 'package:podcast_app/ui/widgets/podcast_details_body.dart';
import 'package:podcast_search/podcast_search.dart';

class PodcastDetailsScreen extends ConsumerWidget {
  const PodcastDetailsScreen({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final podcastService = ref.read(podcastServiceProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          item.trackName ?? '',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<Podcast>(
        future: PodcastServices().getPodcast(item.feedUrl ?? ''),
        builder: (BuildContext context, AsyncSnapshot<Podcast> snapshot) {
          if (snapshot.hasData) {
            final podcast = snapshot.data;
            if (podcast == null) {
              return const Center(
                child: Text('This podcast is not available.'),
              );
            }
            return PodcastDetails(item: item, podcast: podcast);
          }

          if (snapshot.hasError) {
            return const Center(child: Text('An error occured, Please try again later.'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
