import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';

class PodcastDetails extends StatefulWidget {
  const PodcastDetails({super.key, required this.item, required this.podcast});

  final Item item;
  final Podcast podcast;

  @override
  State<PodcastDetails> createState() => _PodcastDetailsState();
}

class _PodcastDetailsState extends State<PodcastDetails> {
  late AudioPlayer _player;
  int currentEpisodeIndex = -1;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    // Row(
                    //   children: [

                    //   Text( ?? '', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)
                    // ],)
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          // Text(widget.podcast.description ?? '')
          ReadMoreText(
            widget.podcast.description ?? '',
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
                return Column(
                  children: [
                    ListTile(
                      // tileColor: Colors.grey[300],
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
                        episode.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            if (episode.contentUrl == null) return;
                            setState(() {
                              currentEpisodeIndex == index;
                            });
                            if (currentEpisodeIndex == index && _player.playing) {
                              _player.pause();
                              currentEpisodeIndex == -1;
                              return;
                            }
                            _player.setUrl(episode.contentUrl!);
                            _player.play();
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
