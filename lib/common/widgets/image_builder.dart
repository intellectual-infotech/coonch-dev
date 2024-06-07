import 'package:flutter/material.dart';

class ImageBuilder extends StatelessWidget {
  const ImageBuilder({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      // scale: scale,
      fit: BoxFit.fitWidth,
      errorBuilder: (_, __, ___) => Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(shape: BoxShape.circle),
      ),
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) {
          return Container(
            // color: AppColor.lightGrey,
            width: 30,
            height: 30,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: child,
          );
        }
        return const SizedBox(
          width: 30,
          height: 30,
        );
      },
    );
  }
}
