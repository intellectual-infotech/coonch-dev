import 'package:coonch/common/widgets/like_share_row.dart';
import 'package:coonch/common/widgets/profile_data_row.dart';
import 'package:coonch/features/home/controllers/home_controller.dart';
import 'package:coonch/features/home/models/text_model.dart';
import 'package:coonch/features/home/widgets/description_with_changeable_height_home.dart';
import 'package:coonch/utils/constants/image_strings.dart';
import 'package:coonch/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';

class TextContentHome extends StatelessWidget {
  const TextContentHome({
    super.key,
    required this.textModel,
    required this.homeController,
  });

  final TextModel textModel;
  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Profile Data Row
        ProfileDataRow(
          profileUrl: MImages.imgMyStatusProfile2,
          username: textModel.userName,
          userCategory: textModel.userCategory,
        ),

        /// Text
        DescriptionWithChangeableHeightHome(
          // homeController: homeController,
          model: textModel,
        ),

        /// Like, Share & etc.
        LikeShareRow(
          commentNo: textModel.commentNo,
          likeNo: textModel.likesNo,
        ),
        const SizedBox(
          height: MSizes.spaceBtwSections,
        )
      ],
    );
  }
}
