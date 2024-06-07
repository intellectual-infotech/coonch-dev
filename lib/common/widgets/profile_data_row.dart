
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';

class ProfileDataRow extends StatelessWidget {
  const ProfileDataRow({
    super.key,
    required this.profileUrl,
    required this.username,
    required this.userCategory,
  });

  final String profileUrl;
  final String username;
  final String userCategory;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(MSizes.sm),
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: MColors.borderStatus, width: 2),
            color: Colors.white,
          ),
          child: Image.asset(profileUrl),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: const TextStyle(fontSize: MSizes.fontSizeMd),
            ),
            Text(
              userCategory,
              style: const TextStyle(fontSize: MSizes.fontSizeSm),
            )
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            MIcons.iconSelectionProfileRow,
            height: 18,
            width: 18,
          ),
        ),
      ],
    );
  }
}
