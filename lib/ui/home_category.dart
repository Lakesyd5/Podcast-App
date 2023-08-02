import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_app/ui/podcast_details.dart';
import 'package:podcast_app/ui/providers/podcast_provider.dart';
import 'package:podcast_app/ui/see_all_category.dart';
import 'package:podcast_search/podcast_search.dart';

class HomeCategory extends ConsumerWidget {
  const HomeCategory({super.key, required this.title, this.genre = ''});
  final String title;
  final String genre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcastItems = ref.watch(podcastCategoryProvider(genre));
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 17, fontWeight: FontWeight.w500),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SeeAll(title: title, genre: genre,)));
              },
              child: const Text('See all'),
            )
          ],
        ),
        podcastItems.when(
          data: (SearchResult data) {
            return SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: data.resultCount,
                itemBuilder: (BuildContext context, int index) {
                  final items = data.items;
                  final item = items[index];

                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PodcastDetailsScreen(item: item),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Hero(
                          tag: 'image-art${item.artworkUrl600}',
                          child: Image.network(
                            item.artworkUrl600 ?? '',
                            // height: 450,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 10,
                  );
                },
              ),
            );
          },
          error: (Object error,StackTrace stackTrace) {
            return const Center(
              child: Text('Opps! Something went wrong'),
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ],
    );
  }
}
