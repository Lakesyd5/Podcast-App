import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast_app/core/services/audio_player_services.dart';
import 'package:podcast_app/ui/widgets/podcast_details_body.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:readmore/readmore.dart';

// TODO - Fix all issues relating to the stream for the progress indicator
// & also when the podcast stops the icon should return to play

class EpisodeDetails extends ConsumerStatefulWidget {
  const EpisodeDetails({super.key, required this.episode});
  final Episode episode;

  @override
  ConsumerState<EpisodeDetails> createState() => _EpisodeDetailsState();
}

class _EpisodeDetailsState extends ConsumerState<EpisodeDetails> {
  String? currentUrl;

  @override
  Widget build(BuildContext context) {
    final episode = widget.episode;
    final audioPlayerService = ref.read(audioPlayerServiceProvider);
    final audioPlayer = audioPlayerService.audioPlayer;
    Duration? duration = widget.episode.duration;
    String formattedDuration = durationFormat(duration);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.6)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Hero(
                tag: 'image-art-${episode.duration}',
                child: Image.network(
                  widget.episode.imageUrl ??
                      'https://icon-library.com/images/found-icon/found-icon-20.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.episode.title,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(
                            widget.episode.publicationDate ?? DateTime.now()),
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                      Text(
                        formattedDuration,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                        value: ref.watch(audioPlayerServiceProvider).progress,
                        minHeight: 3,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              audioPlayer.seekToPrevious();
                            },
                            icon: Icon(
                              Icons.skip_previous_rounded,
                              size: 50,
                              color: Colors.purple[900],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (audioPlayerService.audioPlayer.playing) {
                                audioPlayerService.pause();
                              } else {
                                audioPlayerService.play(widget.episode);
                              }
                            },
                            icon: StreamBuilder(
                              stream: audioPlayer.playerStateStream,
                              builder: (context, snapshot) {
                                final playerState = snapshot.data;
                                final processingState =
                                    playerState?.processingState;
                                final playing = playerState?.playing;

                                if (processingState ==
                                        ProcessingState.loading ||
                                    processingState ==
                                        ProcessingState.buffering) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return playing != true
                                      ? Icon(Icons.play_arrow_rounded,
                                          size: 50, color: Colors.purple[900])
                                      : Icon(Icons.pause_rounded,
                                          size: 50, color: Colors.purple[900]);
                                }
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              audioPlayer.seekToNext();
                            },
                            icon: Icon(
                              Icons.skip_next_rounded,
                              size: 50,
                              color: Colors.purple[900],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const Text(
                    'Description',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  ReadMoreText(
                    parseHtml(widget.episode.description),
                    trimLines: 9,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Read more',
                    trimExpandedText: 'Read less',
                    moreStyle: TextStyle(
                        color: Colors.red[400], fontWeight: FontWeight.w500),
                    lessStyle: TextStyle(
                        color: Colors.red[400], fontWeight: FontWeight.w500),
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  )
                ],
              ),
            )
          ],
        ),
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
