import 'package:coonch/api.dart';
import 'package:coonch/common/controller/follow_unfollow_controller.dart';
import 'package:coonch/common/widgets/image_builder.dart';
import 'package:coonch/features/search/controllers/search_screen_controller.dart';
import 'package:coonch/features/search/model/search_result.dart';
import 'package:coonch/features/search/screen/search_user_profile_screen.dart';
import 'package:coonch/features/setting/screen/subscription_screen.dart';
import 'package:coonch/utils/constants/colors.dart';
import 'package:coonch/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchScreenController searchScreenController =
      Get.find<SearchScreenController>();

  final FollowUnfollowController followUnfollowController =
      Get.find<FollowUnfollowController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(MSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Search Field
            TextFormField(
              controller: searchScreenController.searchProfileController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(MSizes.borderRadiusLg),
                    ),
                    borderSide: BorderSide(
                      width: 1,
                      color: MColors.textFieldBorder,
                    ),
                  ),
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: MColors.buttonUnSelected,
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(
                    fontSize: MSizes.fontSizeMd,
                    color: MColors.buttonUnSelected,
                  )),
            ),
            const SizedBox(height: MSizes.spaceBtwItems),

            /// Related Search
            Expanded(
              child: Obx(() {
                if (!searchScreenController.isSearchStart.value) {
                  return const SizedBox();
                } else if (searchScreenController.searchResults.isEmpty) {
                  return const Text('No results found');
                }
                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: searchScreenController.searchResults.length,
                  itemBuilder: (context, index) {
                    SearchResultModel user =
                        searchScreenController.searchResults[index];
                    return ListTile(
                      onTap: () {
                        Get.to(SearchUserProfileScreen(
                          searchedUserId: user.userid,
                          isFollowing: RxBool(user.following),
                          subscription: user.subscription,
                        ));
                      },
                      leading: ImageBuilder(
                        url:
                            "${APIConstants.strProfilePicBaseUrl}${user.profilePic}",
                      ),
                      title: Text(user.username),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Get.to(SubscriptionScreen(
                            creatorUserId: user.userid,
                          ));
                        },
                        child: const Text("Subscribe"),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
