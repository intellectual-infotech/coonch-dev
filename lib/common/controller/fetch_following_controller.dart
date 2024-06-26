import 'package:coonch/common/methods/method.dart';
import 'package:coonch/common/model/fetch_following_followers_model.dart';
import 'package:coonch/utils/api/rest_api.dart';
import 'package:get/get.dart';

class FetchFollowingController extends GetxController {
  final RestAPI restAPI = Get.find<RestAPI>();

  RxBool isLoading = true.obs;

  RxList<FetchFollowingFollowersModel> followingUserList =
      <FetchFollowingFollowersModel>[].obs;


  RxList<FetchFollowingFollowersModel> followersUserList =
      <FetchFollowingFollowersModel>[].obs;


  /// Fetch All Following User
  Future<void> fetchAllFollowing({required String id}) async {
    try {
      print("Calling fetchAllFollowing");
      var response =
          await restAPI.getDataMethod("api/follow/fetchAllFollowing", data: {
        "subscriberId": id,
      });
      print("response of fetchAllFollowing $response");
      response.forEach((json) {
        followingUserList.add(FetchFollowingFollowersModel.fromJson(json));
      });
      print("followingUserList.length");
      print("${followingUserList.length}");
      isLoading.value = false;
    } catch (e) {
      print("fetchAllFollowing Error ${e.toString()}");
      showToast(title: e.toString());
      isLoading.value = false;
    }
  }


  /// Fetch All Followers User
  Future<void> fetchAllFollowers({required String id}) async {
    try {
      print("Calling fetchAllFollowers");
      var response =
      await restAPI.getDataMethod("api/follow/fetchAllFollowers", data: {
        "subscriberId": id,
      });
      print("response of fetchAllFollowers $response");
      response.forEach((json) {
        followersUserList.add(FetchFollowingFollowersModel.fromJson(json));
      });
      print("followingUserList.length");
      print("${followingUserList.length}");
      isLoading.value = false;
    } catch (e) {
      print("fetchAllFollowers Error ${e.toString()}");
      showToast(title: e.toString());
      isLoading.value = false;
    }
  }
}
