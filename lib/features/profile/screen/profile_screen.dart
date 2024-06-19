import 'package:coonch/features/home/models/text_model.dart';
import 'package:coonch/features/home/models/video_model.dart';
import 'package:coonch/features/profile/controllers/profile_controller.dart';
import 'package:coonch/features/profile/screen/edit_profile_screen.dart';
import 'package:coonch/features/profile/widgets/choice_selection_profile.dart';
import 'package:coonch/features/profile/widgets/profile_elevated_button.dart';
import 'package:coonch/features/profile/widgets/text_content_profile.dart';
import 'package:coonch/features/profile/widgets/user_statistics_column.dart';
import 'package:coonch/features/profile/widgets/video_content_profile.dart';
import 'package:coonch/utils/constants/colors.dart';
import 'package:coonch/utils/constants/image_strings.dart';
import 'package:coonch/utils/constants/sizes.dart';
import 'package:coonch/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController profileController = Get.find<ProfileController>()
    ..callGetProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.softGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.md),
          child: Obx(
            () => Column(
              children: [
                /// Profile Photo row
                Row(
                  children: [
                    Container(
                      height: 88,
                      width: 88,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.network(profileController
                              .userDataModel?.value.user?.profilePic ??
                          MImages.imgMyStatusProfile2),
                    ),
                    const SizedBox(width: MSizes.defaultSpace),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profileController
                                  .userDataModel?.value.user?.username ??
                              ''),
                          const SizedBox(height: MSizes.spaceBtwTexts),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SvgPicture.asset(MIcons.iconLocation),
                              const SizedBox(width: MSizes.spaceBtwTexts),
                              Flexible(
                                child: Text(
                                  profileController
                                          .userDataModel?.value.user?.bio ??
                                      '',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: MSizes.spaceBtwItems),

                /// User Statistics row
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Posts
                      const UserStatisticsColumn(
                        count: "34235",
                        title: MTexts.strPosts,
                      ),
                      const VerticalDivider(
                        color: MColors.grey,
                        thickness: 1,
                        indent: 8,
                        endIndent: 8,
                      ),
                      UserStatisticsColumn(
                        count: profileController
                                .userDataModel?.value.user?.followersCount
                                ?.toString() ??
                            '',
                        title: MTexts.strFriends,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      const VerticalDivider(
                        color: MColors.grey,
                        thickness: 1,
                        indent: 8,
                        endIndent: 8,
                      ),
                      UserStatisticsColumn(
                        count: profileController
                                .userDataModel?.value.user?.followingCount
                                ?.toString() ??
                            '',
                        title: MTexts.strFollowing,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: MSizes.spaceBtwItems),

                /// Edit Profile & Create Playlist
                Row(
                  children: [
                    Expanded(
                      child: ProfileElevatedButton(
                        onPressed: () {
                          Get.to(EditProfileScreen());
                        },
                        title: MTexts.strEditProfile,
                        icon: Icons.mode_edit_outline_outlined,
                      ),
                    ),
                    const SizedBox(width: MSizes.sm),
                    Expanded(
                      child: ProfileElevatedButton(
                        onPressed: () {},
                        title: MTexts.strCreatePlayList,
                        icon: Icons.add,
                        isTransparent: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MSizes.spaceBtwItems),

                /// Choice Selection
                ChoiceSelectionProfile(profileController: profileController),
                const SizedBox(height: MSizes.spaceBtwSections),

                /// Video
                VideoContentProfile(
                  videoModel: VideoModel(
                    commentNo: 425,
                    likesNo: 75,
                    profilePicUrl: MImages.imgMyStatusProfile2,
                    userCategory: 'Engineer',
                    userName: 'Ryan Calzoni',
                    thumbnailUrl:
                        'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pngfind.com%2Fmpng%2FhmTmmwT_preview-thumbnail-wallpaper-for-youtube-hd-png-download%2F&psig=AOvVaw1i3CpSQRjdGh6qngmTd_N_&ust=1717924523890000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCNinzuPVy4YDFQAAAAAdAAAAABAE',
                    videoUrl:
                        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                    description:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
                  ),
                  profileController: profileController,
                ),
                const SizedBox(height: MSizes.spaceBtwSections),

                /// Text
                TextContentProfile(
                  textModel: TextModel(
                    profilePicUrl: MImages.imgMyStatusProfile2,
                    userName: 'Ahmad Curtis',
                    userCategory: 'Engineer',
                    textDescription: 'This is my some text description',
                    likesNo: 90,
                    commentNo: 12,
                  ),
                  profileController: profileController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
