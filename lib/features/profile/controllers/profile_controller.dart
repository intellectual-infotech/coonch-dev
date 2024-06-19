import 'package:basic_utils/basic_utils.dart';
import 'package:coonch/api.dart';
import 'package:coonch/common/methods/method.dart';
import 'package:coonch/common/widgets/loader_dialogue.dart';
import 'package:coonch/features/auth/models/UserDataModel.dart';
import 'package:coonch/utils/api/rest_api.dart';
import 'package:coonch/utils/constants/text_strings.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class ProfileController extends GetxController {
  RxInt currIndex = 0.obs;
  RxBool isExpanded = false.obs;
  RxBool isPasswordHidden = true.obs;
  RxBool isConPasswordHidden = true.obs;
  final RestAPI restAPI = Get.find<RestAPI>();
  TextEditingController editProfileFirstNameController =
      TextEditingController();
  TextEditingController editProfileLastNameController = TextEditingController();
  TextEditingController editProfileBioController = TextEditingController();
  TextEditingController editProfilePhoneController = TextEditingController();
  TextEditingController editProfileNewPasswordController =
      TextEditingController();
  TextEditingController editProfileConfirmPasswordController =
      TextEditingController();
  Rx<UserDataModel>? userDataModel = UserDataModel().obs;
  Rx<User>? otherUser = User().obs;
  RxBool isLoading = false.obs;

  late final MLocalStorage localStorage;

  @override
  void onInit() {
    super.onInit();
    localStorage = Get.find<MLocalStorage>();
    userDataModel = UserDataModel.fromJson(localStorage.getUserData()).obs;
  }

  setUserProfileData() {
    editProfileFirstNameController.text =
        userDataModel?.value.user?.displayName ?? '';
    editProfileLastNameController.text =
        userDataModel?.value.user?.username ?? '';
    editProfileBioController.text = userDataModel?.value.user?.bio ?? '';
    editProfilePhoneController.text = userDataModel?.value.user?.phone ?? '';
  }

  clearPassword() {
    editProfileNewPasswordController.clear();
    editProfileConfirmPasswordController.clear();
  }

  /// Edit profile
  Future<void> callUpdateProfile() async {
    showLoader();
    var response = await restAPI.postDataMethod(
        "${APIConstants.strDefaultAuthPath}/editprofile",
        data: {
          "userid": userDataModel?.value.user?.userid ?? '',
          "display_name": editProfileFirstNameController.text ?? "",
          "email": userDataModel?.value.user?.email ?? '',
          "bio": editProfileBioController.text ?? '',
          "phone": editProfilePhoneController.text ?? ''
        },
        headers: {
          'Authorization': "Bearer ${localStorage.getToken() ?? ''}"
        });

    if (response == null || response?.isEmpty) {
      showToast(title: "callUpdateProfile response null or empty");
      return;
    }
    print("callUpdateProfile=====>response::${response}");
    if (response['message'] == "Profile updated successfully.") {
      await callGetProfile(
        callback: () {
          dismissLoader();
          dismissLoader();
        },
      );
      showToast(title: response['message']);
    } else {
      dismissLoader();
      showToast(title: response.error.toString());
    }
  }

  /// Get Searched User Profile Info
  Future<void> callGetProfile(
      {String? otherUserId, Function()? callback}) async {

    isLoading.value = true;
    var response = await restAPI.postDataMethod(
        "${APIConstants.strDefaultAuthPath}/getuserInfo",
        data: {
          "userid": otherUserId ?? userDataModel?.value.user?.userid ?? '',
        },
        headers: {
          'Authorization': "Bearer ${localStorage.getToken() ?? ''}"
        });

    print("callGetProfile=====>response::${response}");
    print("otherUserId::${otherUserId}");
    print("userId::${userDataModel?.value.user?.userid}");
    // print("userToken::${userDataModel?.value.token}");

    if (response != null) {
      if (otherUserId == null) {
        userDataModel!.value.user = User.fromJson(response);
        userDataModel!.refresh();
      } else {
        print("otheruserId Data is Set");
        otherUser?.value = User.fromJson(response);
      }
      if (callback != null) {
        callback();
      }
    } else {
      if (response == null || response?.isEmpty) {
        print("callGetProfile response is null");
        showToast(title: "callGetProfile response is null");
        return;
      }
    }
    isLoading.value = false;
  }

  Future<void> changePasswordAPI() async {
    var response = await restAPI.postDataMethod(
        "${APIConstants.strDefaultAuthPath}/resetpassword",
        data: {
          "email": userDataModel?.value.user?.email ?? "",
          "oldpass": editProfileNewPasswordController.text,

          /// Problem
          "newpass": editProfileConfirmPasswordController.text
        },
        headers: {
          'Authorization': "Bearer ${localStorage.getToken() ?? ''}"
        });
    print("changePasswordAPI=====>response::${response}");
    if (response == null || response?.isEmpty) {
      showToast(title: "changePasswordAPI response null or empty");
      return;
    }
    if (response['message'] == "Password updated successfully.") {
      Get.back();
      showToast(title: response['message']);
    } else {
      showToast(title: response['error'].toString());
    }
  }

  bool onChangePasswordScreenValidation() {
    if (StringUtils.isNullOrEmpty(editProfileNewPasswordController.text)) {
      showToast(title: MTexts.strPlzEnterEmail);
      return false;
    }
    if (StringUtils.isNullOrEmpty(editProfileConfirmPasswordController.text)) {
      showToast(title: MTexts.strPlzEnterPassword);
      return false;
    }
    if (editProfileConfirmPasswordController.text.toString() !=
        editProfileConfirmPasswordController.text.toString()) {
      showToast(title: MTexts.strPasswordNotMatched);
      return false;
    }
    return true;
  }

  final List<Map<String, dynamic>> choiceItem = [
    {
      "name": "All",
      "value": 0,
    },
    {
      "name": "Video",
      "value": 1,
    },
    {
      "name": "Audio",
      "value": 2,
    },
    {
      "name": "Text",
      "value": 3,
    }
  ];

  void changeTab(int index) {
    currIndex.value = index;
  }

  // -- show more & show less
  void toggleExpansion() {
    isExpanded.value = !isExpanded.value;
  }
}
