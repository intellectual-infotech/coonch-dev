import 'package:cached_network_image/cached_network_image.dart';
import 'package:coonch/features/profile/controllers/profile_controller.dart';
import 'package:coonch/utils/constants/image_strings.dart';
import 'package:coonch/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchUserProfilePhotoRow extends StatelessWidget {
  const SearchUserProfilePhotoRow({
    super.key,
    required this.profilePicUrl,
    required this.userName,
    required this.bio,
  });


  final String profilePicUrl;
  final String userName;
  final String bio;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 88,
          width: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child: CachedNetworkImage(
                  imageUrl: profilePicUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                          Colors.red,
                          BlendMode.colorBurn,
                        ),
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
        ),
        const SizedBox(width: MSizes.defaultSpace),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName),
            const SizedBox(height: MSizes.spaceBtwTexts),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(MIcons.iconLocation),
                const SizedBox(width: MSizes.spaceBtwTexts),
                Text(bio),
              ],
            ),
          ],
        )
      ],
    );
  }
}
