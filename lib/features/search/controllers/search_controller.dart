import 'package:coonch/api.dart';
import 'package:coonch/common/methods/method.dart';
import 'package:coonch/features/auth/models/UserDataModel.dart';
import 'package:coonch/features/home/models/audio_model.dart';
import 'package:coonch/features/home/models/text_model.dart';
import 'package:coonch/features/home/models/video_model.dart';
import 'package:coonch/features/search/model/search_result.dart';
import 'package:coonch/features/search/model/search_user_profile_result.dart';
import 'package:coonch/utils/api/rest_api.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  var videos = <VideoModel>[].obs;
  var audios = <AudioModel>[].obs;
  var texts = <TextModel>[].obs;
  var filteredVideos = <VideoModel>[].obs;
  var filteredAudios = <AudioModel>[].obs;
  var filteredTexts = <TextModel>[].obs;

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

  /// Searching List
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
    // print();

    if (response == null || response?.isEmpty) {
      isSearchStart.value = true;
      showToast(title: "searchUserAPI response null or empty");
      return;
    }
    isSearchStart.value = true;
    for (var user in response) {
      SearchResultModel model = SearchResultModel.fromJson(user);
      searchResults.add(model);

      // Retrieve the value of following and print or store it as needed
      bool isFollowing = user['following'];
      bool subscription = user['subscription'];
      print('User ID: ${user['userid']}, Following: $isFollowing');
      print('User ID: ${user['subscription']}, subscription: $subscription');
    }

    update();
  }

  /// Searched User Profile
  Future<void> searchUserProfileAPI(
      {required String searchUserId,
      Function()? callback,
      String moneyType = 'free'}) async {
    isLoading.value = true;
    var response = await restAPI.postDataMethod("api/getposts/getMyPosts",
        data: {
          "userId": searchUserId,
          "page": 0,
          "pageSize": 2,
          "moneyType": moneyType
        },
        headers: {
          'Authorization': "Bearer ${localStorage.getToken() ?? ''}"
        });

    if (response != null) {
      // Filter and assign the content based on moneyType
      List<dynamic> filteredAudios = [];
      List<dynamic> filteredVideos = [];
      List<dynamic> filteredTexts = [];

      if (response.containsKey('audios')) {
        filteredAudios = response['audios']
            .where((audio) => audio['moneyType'] == moneyType)
            .toList();
        print("filteredAudios :: --> $filteredAudios");
      }

      if (response.containsKey('videos')) {
        filteredVideos = response['videos']
            .where((video) => video['moneyType'] == moneyType)
            .toList();
        print("filteredVideos :: --> $filteredVideos");
      }

      if (response.containsKey('text')) {
        filteredTexts = response['text']
            .where((text) => text['moneyType'] == moneyType)
            .toList();
        print("filteredTexts :: --> $filteredTexts");
      }

      // Assign the filtered content to the userProfileResult
      userProfileResult.value = SearchUserProfileResult.fromJson({
        'audios': filteredAudios,
        'videos': filteredVideos,
        'text': filteredTexts
      });
      print(
          "userProfileResult.value :: --> ${userProfileResult.value!.videos}");
      print("userProfileResult.value :: --> ${userProfileResult.value!.text}");
      print(
          "userProfileResult.value :: --> ${userProfileResult.value!.audios}");
      print(" searchUserProfileAPI response :: --> $response");

      if (callback != null) {
        callback();
      }
      isLoading.value = false;
    } else {
      print("searchUserProfileAPI response is null or empty");
      isLoading.value = false;
      return;
    }
  }
}
