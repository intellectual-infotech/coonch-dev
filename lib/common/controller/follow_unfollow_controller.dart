import 'package:coonch/common/methods/method.dart';
import 'package:coonch/features/auth/models/user_data_model.dart';
import 'package:coonch/utils/api/rest_api.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FollowUnfollowController extends GetxController {
  final RestAPI restAPI = Get.find<RestAPI>();
  late final MLocalStorage localStorage;
  Rx<UserModel>? currUser = UserModel().obs;
  RxBool isFollowing = false.obs;

  RxBool isFollow = false.obs;

  bool checkIfFollowing = false;
  var checkSubscription = "";

  @override
  void onInit() {
    super.onInit();
    localStorage = Get.find<MLocalStorage>();
    currUser = UserModel.fromJson(localStorage.getUserData()).obs;
  }

  /// Follow User
  Future<void> followUserAPI(
      {required String followingId, required String followId}) async {
    try {
      var response = await restAPI.postDataMethod("api/follow/follow", data: {
        "followingid": followingId,
        "followid": followId,
      }, headers: {
        'Authorization': "Bearer ${localStorage.getToken() ?? ''}"
      });

      if (response != null && response['error'] == null) {
        isFollowing.value = true;
        showToast(title: "Followed successfully");
      } else {
        if (response['error'] == "Already following this person") {
          isFollowing.value = true;
        }
        showToast(title: response['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// UnFollow User
  Future<void> unFollowUserAPI(
      {required String followingId, required String followId}) async {
    try {
      var response =
          await restAPI.deleteDataMethod("api/follow/unfollow", data: {
        "followid": followId,
        "followingid": followingId,
      }, headers: {
        'Authorization': "Bearer ${localStorage.getToken() ?? ''}"
      });

      if (response != null && response['error'] == null) {
        isFollowing.value = false;
        showToast(title: "Unfollowed successfully");
      } else {
        if (response['error'] == "Not following this person") {
          isFollowing.value = false;
        }
        showToast(title: response['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Check If Follow
  Future<void> checkFollowingStatus({required String searchedUserId}) async {
    try {
      var response =
          await restAPI.postDataMethod("api/follow/checkIfFollow", data: {
        "myId": currUser?.value.id ?? "",
        "otherId": searchedUserId,
      }, headers: {
        'Authorization': "Bearer ${localStorage.getToken() ?? ''}"
      });

      debugPrint("checkIfFollow====>response::$response");
      if (response == null || response?.isEmpty) {
        showToast(title: "checkIfFollow response null or empty");
      }
      checkIfFollowing = response['follows'];
      checkSubscription = response['subscription'];
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
