//Create a file: dependency_injection.dart
import 'package:coonch/features/add_post/controllers/add_post_controller.dart';
import 'package:coonch/features/auth/controllers/auth_controller.dart';
import 'package:coonch/features/explore/controllers/explore_controller.dart';
import 'package:coonch/features/home/controllers/home_controller.dart';
import 'package:coonch/features/profile/controllers/profile_controller.dart';
import 'package:coonch/features/search/controllers/search_controller.dart';
import 'package:coonch/features/setting/controllers/setting_controller.dart';
import 'package:coonch/utils/api/rest_api.dart';
import 'package:get/get.dart';

void init() {
  Get.put<GetConnect>(GetConnect()); //initializing GetConnect
  Get.put<RestAPI>(RestAPI()); //initializing REST API class
  Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  Get.lazyPut<AddPostController>(() => AddPostController(), fenix: true);
  Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  Get.lazyPut<SettingController>(() => SettingController(), fenix: true);
  Get.lazyPut<SearchScreenController>(() => SearchScreenController(), fenix: true);
  Get.lazyPut<ExploreController>(() => ExploreController(), fenix: true);

}
