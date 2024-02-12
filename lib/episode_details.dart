import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast_app/ui/providers/audio_player_provider.dart';
import 'package:podcast_app/ui/widgets/podcast_details_body.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:readmore/readmore.dart';

// TODO - Fix all issues relating to the play/pause & the stream for the progress indicator

class EpisodeDetails extends ConsumerStatefulWidget {
  const EpisodeDetails({super.key, required this.episode});
  final Episode episode;

  @override
  ConsumerState<EpisodeDetails> createState() => _EpisodeDetailsState();
}

class _EpisodeDetailsState extends ConsumerState<EpisodeDetails> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void initializePlayer() async {
    final audioPlayer = ref.read(audioPlayerProvider);
    audioPlayer.positionStream.listen((position) {
      final currentPosition = position.inMilliseconds.toDouble();
      final totalDuration =
          audioPlayer.bufferedPosition.inMilliseconds.toDouble();

      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          setState(() {
            if (totalDuration > 0 &&
                currentPosition.isFinite &&
                totalDuration.isFinite) {
              progress = currentPosition;
            }
          });
        },
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    ref.read(audioPlayerProvider).dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _episode = widget.episode;
    final audioPlayer = ref.read(audioPlayerProvider);
    Duration? duration = widget.episode.duration;
    String formattedDuration = durationFormat(duration);
    // bool isPlaying = audioPlayer.playing;
    Icon playPauseIcon = audioPlayer.playing
        ? Icon(Icons.pause_rounded, size: 50, color: Colors.purple[900])
        : Icon(Icons.play_arrow_rounded, size: 50, color: Colors.purple[900]);
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
                tag: 'image-art-${_episode.imageUrl}',
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
                        value: progress,
                        minHeight: 3,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.skip_previous_rounded,
                              size: 50,
                              color: Colors.purple[900],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (widget.episode.contentUrl == null) return;
                              if (audioPlayer.playing) {
                                audioPlayer.pause();
                              }
                              audioPlayer.setUrl(widget.episode.contentUrl!);
                              final audioSource = AudioSource.uri(
                                Uri.parse(widget.episode.contentUrl ?? ''),
                                tag: MediaItem(
                                  // Specify a unique ID for each media item:
                                  id: Key(widget.episode.guid).toString(),
                                  // Metadata to display in the notification:
                                  album: widget.episode.title,
                                  title: widget.episode.title,
                                  artUri: Uri.parse(widget.episode.imageUrl ??
                                      'https://icon-library.com/images/found-icon/found-icon-20.jpg'),
                                ),
                              );
                              audioPlayer.setAudioSource(audioSource);
                              audioPlayer.play();
                            },
                            icon: playPauseIcon,
                          ),
                          IconButton(
                            onPressed: () {},
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
