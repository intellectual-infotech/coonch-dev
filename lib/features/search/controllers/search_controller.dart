import 'package:coonch/api.dart';
import 'package:coonch/common/methods/method.dart';
import 'package:coonch/features/auth/models/UserDataModel.dart';
import 'package:coonch/features/search/model/search_result.dart';
import 'package:coonch/utils/api/rest_api.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../setting/controllers/setting_controller.dart';

class SearchScreenController extends GetxController {
  TextEditingController searchProfileController = TextEditingController();
  final RestAPI restAPI = Get.find<RestAPI>();

  List<SearchResultModel> searchResults = <SearchResultModel>[];

  RxBool isSearchStart = false.obs;

  late final MLocalStorage localStorage;

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
    if(Get.isRegistered<SettingController>()){
      userDataModel = Get.find<SettingController>().userDataModel?.value;
    }
    searchResults.clear();
    isSearchStart.value = false;
    var response = await restAPI.postDataMethod(
        "${APIConstants.strDefaultSearchPath}/searchUser",
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

}
