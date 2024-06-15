import 'package:coonch/api.dart';
import 'package:coonch/features/home/controllers/home_controller.dart';
import 'package:coonch/features/home/models/audio_model.dart';
import 'package:coonch/features/home/models/postDataModel.dart';
import 'package:coonch/features/home/models/text_model.dart';
import 'package:coonch/features/home/models/video_model.dart';
import 'package:coonch/features/home/widgets/audio_content_home.dart';
import 'package:coonch/features/home/widgets/text_content_home.dart';
import 'package:coonch/features/profile/screen/other_user_profile_screen.dart';
import 'package:coonch/utils/constants/colors.dart';
import 'package:coonch/utils/constants/image_strings.dart';
import 'package:coonch/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/choice_selection_home.dart';
import '../widgets/video_content_home.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController homeController = Get.find<HomeController>()
    ..getAllPostData();

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.softGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.smmd),
          child: Column(
            children: [
              /// Story
              SizedBox(
                height: 200, // Set the height to 200 pixels
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 160,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      MSizes.borderRadiusMd),
                                  child: Image.asset(MImages.imgMyStory),
                                  // child: SvgPicture.asset(MImages.imgMyStatus),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: (100 - 32) / 2,
                                right: (100 - 32) / 2,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Colors.white,
                                        // width: 2,
                                      ),
                                    ),
                                    // child: SvgPicture.asset(MImages.imgMyStatusProfile)
                                    child:
                                        Image.asset(MImages.imgMyStatusProfile),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Text("data"),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// Choice Selection
              ChoiceSelectionHome(homeController: homeController),
              const SizedBox(height: MSizes.spaceBtwSections),

              /// Further body
              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: homeController.postDataModelList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    PostDataModel postDataModel =
                        homeController.postDataModelList[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(OtherProfileScreen(
                            otherUserId: postDataModel.uploadedBy));
                      },
                      child: postDataModel.contentType == "audio"
                          ? AudioContentHome(
                              audioModel: AudioModel(
                                  profilePicUrl: MImages.imgMyStatusProfile2,
                                  userName: postDataModel.username ?? '',
                                  userCategory: postDataModel.category ?? '',
                                  audioUrl:
                                      '${APIConstants.strBaseUrl}/coonch_nodejs/backend/audios/${postDataModel.audioPath}',
                                  likesNo: 897,
                                  commentNo: 231,
                                  description: postDataModel.description ?? ''),
                            )
                          : postDataModel.contentType == "video"
                              ? VideoContentHome(
                                  videoModel: VideoModel(
                                      commentNo: 425,
                                      likesNo: 75,
                                      profilePicUrl:
                                          MImages.imgMyStatusProfile2,
                                      userCategory:
                                          postDataModel.category ?? '',
                                      userName: postDataModel.username ?? '',
                                      thumbnailUrl:
                                          '${APIConstants.strBaseUrl}coonch_nodejs/videos/${postDataModel.thumbnailPath}',
                                      videoUrl:
                                          '${APIConstants.strBaseUrl}coonch_nodejs/videos/${postDataModel.videoPath}',
                                      description:
                                          postDataModel.description ?? ''),
                                )
                              : TextContentHome(
                                  textModel: TextModel(
                                    profilePicUrl: MImages.imgMyStatusProfile2,
                                    userName: postDataModel.username ?? '',
                                    userCategory: postDataModel.category ?? '',
                                    textDescription:
                                        postDataModel.textContent ?? '',
                                    likesNo: 90,
                                    commentNo: 12,
                                  ),
                                ),
                    );
                  },
                ),
              ),

              /// Video

              const SizedBox(height: MSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
