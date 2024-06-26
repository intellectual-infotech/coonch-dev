import 'package:coonch/api.dart';
import 'package:coonch/common/controller/fetch_following_controller.dart';
import 'package:coonch/common/widgets/image_builder.dart';
import 'package:coonch/utils/constants/sizes.dart';
import 'package:coonch/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisplayFollowersScreen extends StatelessWidget {
  const DisplayFollowersScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {

    final FetchFollowingController fetchFollowingController =
    Get.find<FetchFollowingController>()
      ..fetchAllFollowers(id: id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(CupertinoIcons.back),
        ),
        title: const Text(
          MTexts.strFollowers,
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
        print(("${fetchFollowingController.followersUserList.length}"));
        return ListView.builder(
          itemCount: fetchFollowingController.followersUserList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              leading: ImageBuilder(
                url:
                "${APIConstants.strProfilePicBaseUrl}${fetchFollowingController
                    .followersUserList[index].profilePic}",
              ),
              title: Text(
                  fetchFollowingController.followersUserList[index].username),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text(MTexts.strUnFollow),
              ),
            );
          },
        );
      }),
    );
  }
}
