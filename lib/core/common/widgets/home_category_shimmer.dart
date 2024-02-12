import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategoryShimmer extends StatelessWidget {
  const HomeCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.purple[300]!,
      highlightColor: Colors.white,
      direction: ShimmerDirection.ltr,
      child: SizedBox(
        height: 170,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5, 
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 160,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.black87,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}
