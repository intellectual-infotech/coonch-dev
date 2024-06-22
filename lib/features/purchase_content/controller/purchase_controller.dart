import 'package:coonch/common/methods/method.dart';
import 'package:coonch/features/auth/models/UserDataModel.dart';
import 'package:coonch/utils/api/rest_api.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:get/get.dart';

class PurchaseController extends GetxController {
  final RestAPI restAPI = Get.find<RestAPI>();
  late final MLocalStorage localStorage;

  Rx<UserDataModel>? userDataModel = UserDataModel().obs;


  @override
  void onInit(){
    super.onInit();
    localStorage = Get.find<MLocalStorage>();
    userDataModel = UserDataModel.fromJson(localStorage.getUserData()).obs;
  }

  Future<void> purchaseContentAPI({
    required String creatorId,
    required String planType,
    required String contentId,
    required String contentType,
  }) async {
    try{
      var response = await restAPI.postDataMethod(
        "api/subscribe/selectContent",
        data: {
          "creatorId": creatorId,
          "subscriberId": userDataModel?.value.user?.userid ?? "",
          "plan_type": planType,
          "contentId": contentId,
          "content_type": contentType,
        },
        headers: {'Authorization': "Bearer ${localStorage.getToken() ?? ''}"},
      );

      print("purchaseContentAPI response =====> response:: ${response}");
      print("subscriberId for purchaseContentAPI :: ${userDataModel?.value.user?.userid}");
      print("creatorId for purchaseContentAPI :: $creatorId");
      print("planType for purchaseContentAPI :: $planType");
      print("contentId for purchaseContentAPI :: $contentId");
      print("contentType for purchaseContentAPI :: $contentType");

      if (response == null || response.isEmpty) {
        Get.back();
        showToast(title: "Error: Response is null or empty");
        return;
      }

      if (response.containsKey('error')) {
        showToast(title: "Something Went Wrong!", subTitle: response['error']);
        return;
      } else {
        showToast(title: "Success", subTitle: "Content purchased successfully");
        return;
      }
    } catch (e){
      print(e);
      showToast(title: "Error: $e");
      return;
    }

  }
}
