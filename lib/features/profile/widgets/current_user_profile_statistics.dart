import 'package:coonch/features/profile/controllers/profile_controller.dart';
import 'package:coonch/features/profile/screen/display_followers_screen.dart';
import 'package:coonch/features/profile/screen/display_following_screen.dart';
import 'package:coonch/features/profile/widgets/user_statistics_column.dart';
import 'package:coonch/utils/constants/colors.dart';
import 'package:coonch/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrentUserProfileStatistics extends StatelessWidget {
  const CurrentUserProfileStatistics({
    super.key,
    required this.profileController,
  });

  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Posts
          UserStatisticsColumn(
            count:
                profileController.userDataModel?.value.totalPosts?.toString() ??
                    "",
            crossAxisAlignment: CrossAxisAlignment.center,
            title: MTexts.strPosts,
          ),
          const VerticalDivider(
            color: MColors.grey,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          UserStatisticsColumn(
            count: profileController.userDataModel?.value.followersCount
                    ?.toString() ??
                '',
            title: MTexts.strFollowers,
            crossAxisAlignment: CrossAxisAlignment.center,
            onTap: () {
              print(
                  "profileController.userDataModel?.value.userid === ${profileController.userDataModel?.value.userid}");
              Get.to(DisplayFollowersScreen(
                id: profileController.userDataModel?.value.userid ?? "",
              ));
            },
          ),
          const VerticalDivider(
            color: MColors.grey,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          UserStatisticsColumn(
            count: profileController.userDataModel?.value.followingCount
                    ?.toString() ??
                '',
            crossAxisAlignment: CrossAxisAlignment.center,
            title: MTexts.strFollowing,
            onTap:  () {
              print(
                  "profileController.userDataModel?.value.userid === ${profileController.userDataModel?.value.userid}");
              Get.to(DisplayFollowingScreen(
                id: profileController.userDataModel?.value.userid ?? "",
              ));
            },
          ),
        ],
      ),
    );
  }
}
