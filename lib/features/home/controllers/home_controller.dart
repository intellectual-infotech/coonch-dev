import 'package:coonch/common/methods/method.dart';
import 'package:coonch/features/auth/models/UserDataModel.dart';
import 'package:coonch/features/home/models/postDataModel.dart';
import 'package:coonch/utils/api/rest_api.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currIndex = 0.obs;
  RxBool isExpanded = false.obs;
  final RestAPI restAPI = Get.find<RestAPI>();
  UserDataModel? userDataModel =
      UserDataModel.fromJson(MLocalStorage.getUserData());
  RxList<PostDataModel> postDataModelList = <PostDataModel>[].obs;
  final List<Map<String, dynamic>> choiceItem = [
    {
      "name": "All",
      "value": 0,
      "filter": "all"
    },
    {
      "name": "Video",
      "value": 1,
      "filter": "video"

    },
    {
      "name": "Audio",
      "value": 2,
      "filter": "audio"
    },
    {
      "name": "Text",
      "value": 3,
      "filter": "text"
    }
  ];

  void changeTab(int index) {
    currIndex.value = index;
  }

  void getAllPostData({String selectedCategory = "all"}) async {
    var response =
        await restAPI.postDataMethod("api/getposts/fetchallFreePosts", data: {
      "userId": userDataModel?.user?.userid ?? '',
      "page": "0",
      "pageSize": "1",
      "filters": selectedCategory,
    }, headers: {
      'Authorization': "Bearer ${MLocalStorage.getToken() ?? ''}"
    });
    if (response == null || response?.isEmpty) {
      showToast(title: "getAllPostData Response null or Empty");
      return;
    }
    print("getAllPostData=====>res::$response");
    if (response?.isNotEmpty ?? false) {
      List? responseList = response ?? [];
      List<PostDataModel> tempPostDataList =
          responseList?.map((e) => PostDataModel.fromJson(e)).toList() ?? [];
      postDataModelList.value = tempPostDataList;
    } else {
      showToast(title: response['error'].toString());
    }
  }

  // -- show more & show less
  void toggleExpansion() {
    isExpanded.value = !isExpanded.value;
  }
}