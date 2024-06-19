


import 'package:coonch/common/methods/method.dart';
import 'package:coonch/utils/api/rest_api.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:get/get.dart';

class PurchaseController extends GetxController {

  final RestAPI restAPI = Get.find<RestAPI>();
  late final MLocalStorage localStorage;


  Future<void> purchaseContentAPI(
      String creatorId,
      String subscriberId,
      String planType,
      String contentId,
      String contentType,
      ) async {
    var response = await restAPI.postDataMethod(
      "109.199.105.248:7900/api/subscribe/selectContent",
      data: {
        "creatorId": creatorId,
        "subscriberId": subscriberId,
        "plan_type": planType,
        "contentId": contentId,
        "content_type": contentType,
      },
      headers: {
        'Authorization': "Bearer ${localStorage.getToken() ?? ''}"
      },
    );

    print("purchaseContentAPI=====> response:: ${response}");

    if (response == null || response.isEmpty) {
      showToast(title: "purchaseContentAPI response null or empty");
      return;
    } else {
      // Handle successful response
      showToast(title: "Content purchased successfully");
    }
  }
}