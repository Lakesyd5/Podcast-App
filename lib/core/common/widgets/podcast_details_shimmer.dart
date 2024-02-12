import 'package:flutter/material.dart';
import 'package:podcast_app/core/common/widgets/shimmer_container.dart';
import 'package:shimmer/shimmer.dart';

class PodcastDetailsShimmer extends StatelessWidget {
  const PodcastDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.purple[300]!,
      highlightColor: Colors.white,
      direction: ShimmerDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                shimmerContainer(height: 170, width: 170),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerContainer(width: 200, height: 20),
                      const SizedBox(height: 6),
                      shimmerContainer(width: 110, height: 15),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            shimmerContainer(height: 50, width: double.infinity),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {  
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        shimmerContainer(height: 50, width: 50),
                        Column(
                          children: [
                            shimmerContainer(width: 150, height: 30),
                            shimmerContainer(width: 150, height: 60),
                          ],
                        )
                      ],
                    ),
                    shimmerContainer(width: 200, height: 30),
                    const SizedBox(height: 20)
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
