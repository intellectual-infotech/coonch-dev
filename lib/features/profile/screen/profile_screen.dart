import 'package:coonch/api.dart';
import 'package:coonch/common/widgets/profile_data_row_free.dart';
import 'package:coonch/common/widgets/profile_data_row_paid.dart';
import 'package:coonch/features/profile/controllers/profile_controller.dart';
import 'package:coonch/features/profile/screen/edit_profile_screen.dart';
import 'package:coonch/features/profile/widgets/choice_selection_profile.dart';
import 'package:coonch/features/profile/widgets/current_user_profile_statistics.dart';
import 'package:coonch/features/profile/widgets/profile_elevated_button.dart';
import 'package:coonch/features/search/controllers/search_screen_controller.dart';
import 'package:coonch/features/search/model/search_user_profile_result.dart';
import 'package:coonch/features/search/widgets/audio_content_search_screen.dart';
import 'package:coonch/features/search/widgets/search_profile_video_free.dart';
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

  final RxString selectedContentType = 'free'.obs;

  void changeContentType(String contentType) {
    selectedContentType.value = contentType;
    Get.find<SearchScreenController>().searchUserProfileAPI(
      searchUserId: profileController.userDataModel?.value.user?.userid ?? "",
      moneyType: contentType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String ownProfileId =
        profileController.userDataModel?.value.user?.userid ?? "";

    final SearchScreenController searchScreenController =
        Get.find<SearchScreenController>()
          ..searchUserProfileAPI(searchUserId: ownProfileId);

    return Scaffold(
      backgroundColor: MColors.softGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.md),
          child: Obx(
            () {
              var userPScreen = profileController.userDataModel?.value.user;
              return userPScreen == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
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
                                  ""),
                            ),
                            const SizedBox(width: MSizes.defaultSpace),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userPScreen.username ??
                                      'Null Username'),
                                  const SizedBox(height: MSizes.spaceBtwTexts),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SvgPicture.asset(MIcons.iconLocation),
                                      const SizedBox(
                                          width: MSizes.spaceBtwTexts),
                                      Flexible(
                                        child: Text(
                                          profileController.userDataModel?.value
                                                  .user?.bio ??
                                              'Null Bio',
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
                        CurrentUserProfileStatistics(
                            profileController: profileController),
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
                                    borderRadius: BorderRadius.circular(
                                        MSizes.borderRadiusLg),
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
                                    borderRadius: BorderRadius.circular(
                                        MSizes.borderRadiusLg),
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
                        ChoiceSelectionProfile(
                            profileController: profileController),
                        const SizedBox(height: MSizes.spaceBtwItems),

                        Obx(
                          () {
                            /// Showing Video
                            if (profileController.currIndex.value == 0) {
                              if (searchScreenController.isLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (searchScreenController.userProfileResult.value
                                      ?.videos.isEmpty ??
                                  true) {
                                return const Center(
                                  child: Text('No videos uploaded'),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: searchScreenController
                                    .userProfileResult.value?.videos.length,
                                itemBuilder: (context, index) {
                                  String videoUrl =
                                      APIConstants.strVideosBaseUrl +
                                          searchScreenController
                                              .userProfileResult
                                              .value!
                                              .videos[index]
                                              .videoPath;
                                  String thumbnailUrl =
                                      APIConstants.strVideosBaseUrl +
                                          searchScreenController
                                              .userProfileResult
                                              .value!
                                              .videos[index]
                                              .thumbnailPath;
                                  String username = searchScreenController
                                      .userProfileResult
                                      .value!
                                      .videos[index]
                                      .username;
                                  String userCategory = searchScreenController
                                      .userProfileResult
                                      .value!
                                      .videos[index]
                                      .category;
                                  String contentId = searchScreenController
                                      .userProfileResult
                                      .value!
                                      .videos[index]
                                      .contentId;
                                  // String userProfilePic = searchScreenController
                                  //     .filteredVideos[index].profilePicUrl;

                                  return selectedContentType.value == 'free'
                                      ? SearchProfileVideoFree(
                                          // profileUrl: userProfilePic,
                                          searchScreenController:
                                              searchScreenController,
                                          videoUrl: videoUrl,
                                          thumbnailUrl: thumbnailUrl,
                                          username: username,
                                          userCategory: userCategory,
                                        )
                                      : SearchProfileVideoFree(
                                          // profileUrl: userProfilePic,
                                          searchScreenController:
                                              searchScreenController,
                                          thumbnailUrl: thumbnailUrl,
                                          username: username,
                                          userCategory: userCategory,
                                          videoUrl: videoUrl,
                                          // contentId: contentId,
                                          // planType: subscription,
                                          // creatorId: searchedUserId,
                                        );
                                },
                              );
                            }

                            /// Showing Audio
                            else if (profileController.currIndex.value == 1) {
                              if (searchScreenController.isLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (searchScreenController.userProfileResult.value
                                      ?.audios.isEmpty ??
                                  true) {
                                return const Center(
                                  child: Text('No audios uploaded'),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchScreenController
                                    .userProfileResult.value!.audios.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: MSizes.smmd),
                                      AudioContentSearch(
                                        audioModel: Audio(
                                          id: searchScreenController
                                              .userProfileResult
                                              .value!
                                              .audios[index]
                                              .id,
                                          contentId: searchScreenController
                                              .userProfileResult
                                              .value!
                                              .audios[index]
                                              .contentId,
                                          moneyType: searchScreenController
                                              .userProfileResult
                                              .value!
                                              .audios[index]
                                              .moneyType,
                                          category: searchScreenController
                                              .userProfileResult
                                              .value!
                                              .audios[index]
                                              .category,
                                          uploadedBy: searchScreenController
                                              .userProfileResult
                                              .value!
                                              .audios[index]
                                              .uploadedBy,
                                          uploadedAt: searchScreenController
                                              .userProfileResult
                                              .value!
                                              .audios[index]
                                              .uploadedAt,
                                          username: searchScreenController
                                              .userProfileResult
                                              .value!
                                              .audios[index]
                                              .username,
                                          profilePic: searchScreenController
                                              .userProfileResult
                                              .value!
                                              .audios[index]
                                              .profilePic,
                                        ),
                                        isFree: (selectedContentType.value ==
                                                'free')
                                            ? true
                                            : false,
                                      ),
                                      const SizedBox(height: MSizes.sm),
                                    ],
                                  );
                                },
                              );
                            }

                            /// Showing Text
                            else {
                              if (searchScreenController.isLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (searchScreenController
                                      .userProfileResult.value?.text.isEmpty ??
                                  true) {
                                return const Center(
                                  child: Text('No text uploaded'),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchScreenController
                                    .userProfileResult.value!.text.length,
                                itemBuilder: (context, index) {
                                  String username = searchScreenController
                                      .userProfileResult
                                      .value!
                                      .text[index]
                                      .username;
                                  String userCategory = searchScreenController
                                      .userProfileResult
                                      .value!
                                      .text[index]
                                      .category;
                                  String textContent = searchScreenController
                                          .userProfileResult
                                          .value!
                                          .text[index]
                                          .textContent ??
                                      "Null Text Content";

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: MSizes.smmd),
                                      selectedContentType.value == 'free'
                                          ? ProfileDataRowFree(
                                              profileUrl:
                                                  MImages.imgMyStatusProfile2,
                                              username: username,
                                              userCategory: userCategory,
                                            )
                                          : ProfileDataRowPaid(
                                              profileUrl:
                                                  MImages.imgMyStatusProfile2,
                                              username: username,
                                              userCategory: userCategory,
                                            ),
                                      Text(textContent),
                                      const SizedBox(height: MSizes.sm),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
