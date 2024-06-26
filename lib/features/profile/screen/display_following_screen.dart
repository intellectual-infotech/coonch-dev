import 'package:coonch/api.dart';
import 'package:coonch/common/controller/fetch_following_controller.dart';
import 'package:coonch/common/widgets/image_builder.dart';
import 'package:coonch/utils/constants/sizes.dart';
import 'package:coonch/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisplayFollowingScreen extends StatelessWidget {
  const DisplayFollowingScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {

    final FetchFollowingController fetchFollowingController =
    Get.find<FetchFollowingController>()
      ..fetchAllFollowing(id: id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(CupertinoIcons.back),
        ),
        title: const Text(
          MTexts.strFollowing,
          style: TextStyle(
            fontSize: MSizes.fontSizeLg,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body:
      Obx(() {
        if (fetchFollowingController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        print(("${fetchFollowingController.followingUserList.length}"));
        return ListView.builder(
          itemCount: fetchFollowingController.followingUserList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              leading: ImageBuilder(
                url:
                "${APIConstants.strProfilePicBaseUrl}${fetchFollowingController
                    .followingUserList[index].profilePic}",
              ),
              title: Text(
                  fetchFollowingController.followingUserList[index].username),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text(MTexts.strFollowing),
              ),
            );
          },
        );
      }),
    );
  }
}
