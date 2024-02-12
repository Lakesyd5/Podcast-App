import 'package:flutter/material.dart';

Widget shimmerContainer({
  double? width,
  double? height
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
