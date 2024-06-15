import 'package:cached_network_image/cached_network_image.dart';
import 'package:coonch/api.dart';
import 'package:coonch/common/widgets/profile_data_row.dart';
import 'package:coonch/features/home/screen/video_player_screen.dart';
import 'package:coonch/features/profile/controllers/profile_controller.dart';
import 'package:coonch/features/profile/widgets/profile_elevated_button.dart';
import 'package:coonch/features/profile/widgets/user_statistics_column.dart';
import 'package:coonch/features/search/controllers/search_controller.dart';
import 'package:coonch/utils/constants/colors.dart';
import 'package:coonch/utils/constants/image_strings.dart';
import 'package:coonch/utils/constants/sizes.dart';
import 'package:coonch/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SearchUserProfileScreen extends StatelessWidget {
  SearchUserProfileScreen({
    super.key,
    required this.searchedUserId,
    required this.following,
    required this.subscription,
  });

  final String searchedUserId;
  final bool following;
  final String subscription;
  final RxInt currIndex = 0.obs;
  final RxString selectedContentType = 'free'.obs;

  void changeTab(int index) {
    currIndex.value = index;
  }

  void changeContentType(String contentType) {
    selectedContentType.value = contentType;
    Get.find<SearchScreenController>().searchUserProfileAPI(
      searchUserId: searchedUserId,
      moneyType: contentType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>()
      ..callGetProfile(otherUserId: searchedUserId);

    final SearchScreenController searchScreenController =
        Get.find<SearchScreenController>()
          ..searchUserProfileAPI(searchUserId: searchedUserId);

    return Scaffold(
      backgroundColor: MColors.softGrey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                        child: profileController.otherUser?.value.profilePic !=
                                null
                            ? CachedNetworkImage(
                                imageUrl: profileController
                                        .otherUser?.value.profilePic ??
                                    '',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Image.asset(MImages.imgMyStatusProfile2),
                      ),
                      const SizedBox(width: MSizes.defaultSpace),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profileController.otherUser?.value.username ??
                              'default name'),
                          const SizedBox(height: MSizes.spaceBtwTexts),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(MIcons.iconLocation),
                              const SizedBox(width: MSizes.spaceBtwTexts),
                              Text(
                                  profileController.otherUser?.value.bio ?? ''),
                            ],
                          ),
                        ],
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
                                  .otherUser?.value.followersCount
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
                                  .otherUser?.value.followingCount
                                  ?.toString() ??
                              '',
                          title: MTexts.strFollowing,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: MSizes.spaceBtwItems),

                  /// Follow & Create Playlist
                  Row(
                    children: [
                      Expanded(
                        child: ProfileElevatedButton(
                          onPressed: () {},
                          title:
                              following ? MTexts.strUnFollow : MTexts.strFollow,
                        ),
                      ),
                      const SizedBox(width: MSizes.sm),
                      Expanded(
                        child: ProfileElevatedButton(
                          onPressed: () {},
                          title: subscription,
                          isTransparent: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MSizes.spaceBtwItems),

                  /// Paid and Free Content Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => changeContentType('free'),
                        child: Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedContentType.value == 'free'
                                  ? MColors.buttonPrimary
                                  : MColors.white,
                              borderRadius:
                                  BorderRadius.circular(MSizes.borderRadiusLg),
                            ),
                            child: Text(
                              'Free',
                              style: TextStyle(
                                color: selectedContentType.value == 'free'
                                    ? MColors.white
                                    : MColors.darkGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => changeContentType('paid'),
                        child: Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedContentType.value == 'paid'
                                  ? MColors.buttonPrimary
                                  : MColors.white,
                              borderRadius:
                                  BorderRadius.circular(MSizes.borderRadiusLg),
                            ),
                            child: Text(
                              'Paid',
                              style: TextStyle(
                                color: selectedContentType.value == 'paid'
                                    ? MColors.white
                                    : MColors.darkGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MSizes.spaceBtwItems),

                  /// Choice Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: searchScreenController.choiceItem
                        .map((currChoice) => Obx(() {
                              bool isSelected =
                                  currIndex == currChoice['value'];
                              return GestureDetector(
                                onTap: () => changeTab(currChoice['value']),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? MColors.buttonPrimary
                                        : MColors.white,
                                    borderRadius: BorderRadius.circular(
                                        MSizes.borderRadiusLg),
                                  ),
                                  child: Text(
                                    currChoice['name'],
                                    style: TextStyle(
                                      color: isSelected
                                          ? MColors.white
                                          : MColors.darkGrey,
                                    ),
                                  ),
                                ),
                              );
                            }))
                        .toList(),
                  ),

                  Obx(
                    () {
                      /// Showing Video
                      if (currIndex.value == 0) {
                        if (searchScreenController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              searchScreenController.userProfileResult.value?.videos.length,
                          itemBuilder: (context, index) {
                            String videoUrl = APIConstants.strVideosBaseUrl +
                                searchScreenController.userProfileResult.value!
                                    .videos[index].videoPath;
                            String thumbnailUrl =
                                APIConstants.strVideosBaseUrl +
                                    searchScreenController.userProfileResult
                                        .value!.videos[index].thumbnailPath;
                            // String thumbnailUrl2 =
                            //     "${APIConstants.strBaseUrl}coonch_nodejs/videos/${searchScreenController.userProfileResult.value!.videos[index].thumbnailPath}";

                            return Column(
                              children: [
                                const SizedBox(height: MSizes.smmd),
                                ProfileDataRow(
                                  profileUrl: MImages.imgMyStatusProfile2,
                                  // profileUrl: searchScreenController.filteredVideos[index].profilePicUrl,
                                  username: searchScreenController
                                      .userProfileResult.value!.videos[index].username,
                                  userCategory: searchScreenController
                                      .userProfileResult.value!.videos[index].category,
                                ),

                                /// Thumbnail
                                GestureDetector(
                                  onTap: () {
                                    Get.to(
                                        VideoPlayerScreen(videoUrl: videoUrl));
                                  },
                                  child: SizedBox(
                                    height: 200,
                                    child: Image.network(
                                      thumbnailUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                            .expectedTotalBytes ??
                                                        1)
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: MSizes.sm),
                              ],
                            );
                          },
                        );
                      }

                      /// Showing Audio
                      else if (currIndex.value == 1) {
                        if (searchScreenController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchScreenController
                              .userProfileResult.value!.videos.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                const SizedBox(height: MSizes.smmd),
                                ProfileDataRow(
                                  profileUrl: MImages.imgMyStatusProfile2,
                                  username: searchScreenController
                                      .userProfileResult.value!.audios[index].username,
                                  userCategory: searchScreenController
                                      .userProfileResult.value!.audios[index].category,
                                ),
                                const SizedBox(height: MSizes.sm),
                              ],
                            );
                          },
                        );
                      } else {
                        if (searchScreenController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              searchScreenController.userProfileResult.value!.text.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: MSizes.smmd),
                                ProfileDataRow(
                                  profileUrl: MImages.imgMyStatusProfile2,
                                  username: searchScreenController
                                      .userProfileResult.value!.text[index].username,
                                  userCategory: searchScreenController
                                      .userProfileResult.value!.text[index].category,
                                ),

                                /// Thumbnail
                                Text(searchScreenController
                                    .userProfileResult.value!.text[index].textContent ?? ""),
                                const SizedBox(height: MSizes.sm),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
