import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast_app/episode_details.dart';
import 'package:podcast_app/ui/providers/audio_player_provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';

class PodcastDetails extends ConsumerStatefulWidget {
  const PodcastDetails({super.key, required this.item, required this.podcast});

  final Item item;
  final Podcast podcast;

  @override
  ConsumerState<PodcastDetails> createState() => _PodcastDetailsState();
}

class _PodcastDetailsState extends ConsumerState<PodcastDetails> {
  int currentEpisodeIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = ref.read(audioPlayerProvider);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.podcast.image ?? '',
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.trackName ?? '',
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'By: ${widget.item.artistName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          // Text(widget.podcast.description ?? '')
          ReadMoreText(
            parseHtml(widget.podcast.description ?? ''),
            colorClickableText: Colors.green,
            trimLines: 4,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Read more',
            trimExpandedText: 'Read less',
            moreStyle:
                TextStyle(color: Colors.red[400], fontWeight: FontWeight.w500),
            lessStyle:
                TextStyle(color: Colors.red[400], fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const SizedBox(
            width: double.infinity,
            child: Text(
              'All Episodes',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.separated(
              itemCount: widget.podcast.episodes.length,
              itemBuilder: (context, index) {
                final episode = widget.podcast.episodes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  EpisodeDetails(episode: episode)));
                  },
                  child: Column(
                    children: [
                      ListTile(
                        titleAlignment: ListTileTitleAlignment.top,
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            episode.imageUrl ??
                                widget.podcast.image ??
                                'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          episode.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        subtitle: Text(
                          parseHtml(episode.description),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              if (episode.contentUrl == null) return;
                              setState(() {
                                currentEpisodeIndex = index;
                              });
                              if (currentEpisodeIndex == index &&
                                  audioPlayer.playing) {
                                audioPlayer.pause();
                                currentEpisodeIndex = -1;
                                return;
                              }
                              audioPlayer.setUrl(episode.contentUrl!);
                              final audioSource = AudioSource.uri(
                                Uri.parse(episode.contentUrl ?? ''),
                                tag: MediaItem(
                                  // Specify a unique ID for each media item:
                                  id: Key(episode.guid).toString(),
                                  // Metadata to display in the notification:
                                  album: widget.podcast.title,
                                  title: episode.title,
                                  artUri: Uri.parse(widget.podcast.image ?? ''),
                                ),
                              );
                              audioPlayer.setAudioSource(audioSource);
                              audioPlayer.play();
                            },
                            icon: currentEpisodeIndex == index
                                ? const Icon(Icons.pause)
                                : const Icon(Icons.play_arrow_rounded)),
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat.yMMMMd().format(
                                episode.publicationDate ?? DateTime.now()),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 0.5,
                  color: Colors.black45,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String parseHtml(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}
