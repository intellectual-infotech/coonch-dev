import 'package:coonch/api.dart';
import 'package:coonch/common/methods/method.dart';
import 'package:coonch/features/auth/models/UserDataModel.dart';
import 'package:coonch/features/search/model/search_user_profile_result.dart';
import 'package:coonch/features/search/model/search_result.dart';
import 'package:coonch/utils/api/rest_api.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../setting/controllers/setting_controller.dart';

class SearchScreenController extends GetxController {
  TextEditingController searchProfileController = TextEditingController();
  final RestAPI restAPI = Get.find<RestAPI>();

  Rx<User>? searchedUser = User().obs;
  Rx<UserDataModel>? userDataModel = UserDataModel().obs;

  List<SearchResultModel> searchResults = <SearchResultModel>[];

  var userProfileResult = Rxn<SearchUserProfileResult>();
  RxBool isLoading = true.obs;

  RxBool isSearchStart = false.obs;

  late final MLocalStorage localStorage;

  RxInt currIndex = 0.obs;
  final List<Map<String, dynamic>> choiceItem = [
    {
      "name": "Video",
      "value": 0,
    },
    {
      "name": "Audio",
      "value": 1,
    },
    {
      "name": "Text",
      "value": 2,
    }
  ];

  void changeTab(int index) {
    currIndex.value = index;
  }


  @override
  void onInit() {
    super.onInit();
    localStorage = Get.find<MLocalStorage>();
    searchProfileController.addListener(() {
      if (searchProfileController.text.isNotEmpty) {
        searchUserAPI();
      }
    });
  }

  void cleanSearchResult() {
    searchProfileController.clear();
    searchResults.clear();
  }

  Future<void> searchUserAPI() async {
    UserDataModel? userDataModel;
    if (Get.isRegistered<SettingController>()) {
      userDataModel = Get.find<SettingController>().userDataModel?.value;
    }
    searchResults.clear();
    isSearchStart.value = false;
    var response = await restAPI.postDataMethod(
        "${APIConstants.strDefaultSearchPath}searchUser",
        data: {
          "searchString": searchProfileController.text,
          "myId": userDataModel?.user?.userid ?? ''
        },
        headers: {
          'Authorization': "Bearer ${localStorage.getToken() ?? ''}"
        });
    print("searchUserAPI=====> response:: ${response}");
    print(userDataModel?.user?.userid ?? '');

    if (response == null || response?.isEmpty) {
      isSearchStart.value = true;
      showToast(title: "searchUserAPI response null or empty");
      return;
    }
    isSearchStart.value = true;
    for (int i = 0; i < (response as List<dynamic>).length; i++) {
      SearchResultModel model = SearchResultModel.fromJson(response[i]);
      searchResults.add(model);
    }
    update();
  }

  Future<void> searchUserProfileAPI(
      {required String searchUserId, Function()? callback}) async {
    isLoading.value = true;
    var response =
        await restAPI.postDataMethod("api/getposts/getMyPosts", data: {
      "userId": searchUserId,
      "page": 0,
      "pageSize": 2,
      "moneyType": "free" //optional
    }, headers: {
      'Authorization': "Bearer ${localStorage.getToken() ?? ''}"
    });

    if (response != null) {
      if (response.containsKey('audios') || response.containsKey('videos') || response.containsKey('text')) {
        searchedUser?.value = User.fromJson(response);
        userProfileResult.value = SearchUserProfileResult.fromJson(response);
        print("userProfileResult.value ::: ${userProfileResult.value?.text.length}");
        if (callback != null) {
          callback();
        }
        isLoading.value = false;
      } else {
        print("searchUserProfileAPI response is missing expected keys");
        isLoading.value = false;
      }
    } else {
      print("searchUserProfileAPI response is null or empty");
      isLoading.value = false;
      return;
    }


    print("searchUserProfileAPI=====>response::${response}");
    print("searchUserId::${searchUserId}");
    print("searchUser username::${searchedUser?.value.username}");
    print("searchUser bio::${searchedUser?.value.bio}");

  }
}
