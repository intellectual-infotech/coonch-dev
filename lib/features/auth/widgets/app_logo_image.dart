import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/constants/sizes.dart';

class AppLogoImage extends StatelessWidget {
  const AppLogoImage({
    super.key,
    required this.imgString,
  });

  final String imgString;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image(image: AssetImage(imgString)),
        Container(
          child: SvgPicture.asset(
            imgString,
            // color: Colors.blue,
          ),
          // color: Colors.red,
        ),
        const SizedBox(height: MSizes.spaceBtwItems),
      ],
    );
  }
}
