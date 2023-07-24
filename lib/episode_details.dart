import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:podcast_search/podcast_search.dart';

class EpisodeDetails extends ConsumerWidget {
  const EpisodeDetails({super.key, required this.episode});
  final Episode episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Duration? duration = episode.duration;
    String formattedDuration = durationFormat(duration);
    return Scaffold(
      appBar: AppBar(
        // title: Text(episode.title),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          SizedBox(
            height: 400,
            width: double.infinity,
            child: Image.network(
              episode.imageUrl ??
                  'https://icon-library.com/images/found-icon/found-icon-20.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(
                  episode.title,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat.yMMMMd()
                        .format(episode.publicationDate ?? DateTime.now())),
                    Text(formattedDuration)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String durationFormat(Duration? duration) {
    int hours = duration!.inHours;
    int minutes = duration.inMinutes.remainder(Duration.minutesPerHour);

    final formatter = NumberFormat('00');
    String formattedHours = formatter.format(hours);
    String formattedMinutes = formatter.format(minutes);

    return '$formattedHours h $formattedMinutes mins';
  }
}
