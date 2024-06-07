import 'package:coonch/common/methods/method.dart';
import 'package:coonch/features/add_post/widgets/content_upload_success_dialog.dart';
import 'package:coonch/features/auth/models/UserDataModel.dart';
import 'package:coonch/utils/api/rest_api.dart';
import 'package:coonch/utils/constants/text_strings.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final valueOfSwitch = true.obs;
  final RestAPI restAPI = Get.find<RestAPI>();

  Rx<UserDataModel>? userDataModel =
      UserDataModel.fromJson(MLocalStorage.getUserData()).obs;

  void toggleSwitch(bool value) {
    valueOfSwitch.value = value;
  }

  Future<void> subscribeCreatorAPI(String? creatorUserId, bool isGold) async {
    print("creatorUserId : --> ${creatorUserId}");
    print("subscriberId : --> ${userDataModel?.value.user?.userid}");
    print("isGold ---> $isGold");

    var response =
        await restAPI.postDataMethod("api/subscribe/subscribeCreator", data: {
      "subscriberId": userDataModel?.value.user?.userid ?? '',
      "creatorId": creatorUserId ?? '',
      "plan_type": isGold ? 'gold' : 'silver',
    }, headers: {
      'Authorization': "Bearer ${MLocalStorage.getToken() ?? ''}"
    });

    print("subscribeCreatorAPI =====> response:: ${response}");

    if (response == null || response?.isEmpty) {
      showToast(title: "subscribeCreatorAPI response null or empty");
      return;
    }

    if (response['message'] == "Already subscribed") {
      showToast(title: response['message']);
    } else {
      contentUploadSuccessfullyDialog(
        Get.context!,
        title: MTexts.strSubscribeSuccessfullyTitle,
        subTitle: MTexts.strSubscribeSuccessfullySubTitle,
      );
    }
  }
}
