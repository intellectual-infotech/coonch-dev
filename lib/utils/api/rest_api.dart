//Create a file: rest_api.dart
import 'package:coonch/common/methods/method.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:get/get.dart';

class RestAPI {
  final GetConnect connect = Get.find<GetConnect>();
  String baseURL = 'http://109.199.105.248:7900/';
  Map headerData = {};

  //GET request example
  Future<dynamic> getDataMethod(String url,
      {bool isShowToast = false, required Map<String, String> data}) async {
    String fullUrl = baseURL + url;
    print('getDataMethod=====>URL::$fullUrl');
    print('getDataMethod=====>query::$data');
    print('getDataMethod=====>Token::${MLocalStorage.getToken() ?? ''}');

    Response response = await connect.get(fullUrl,
        query: data,
        headers: {'Authorization': 'Bearer ${MLocalStorage.getToken() ?? ''}'});

    print('getDataMethod=====>response::${response}');

    if (response.statusCode == 200) {
      return response.body;
    } else {
      if (isShowToast) {
        showToast(title: response.statusText.toString());
      }
    }
  }

  //post request example
  Future<dynamic> postDataMethod(String url,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    //body data
    try {
      String fullUrl = baseURL + url;
      print('postDataMethod=====>URL::$fullUrl');
      print('postDataMethod=====>data::$data');
      Response response;
      if (headers != null) {
        response = await connect.post(fullUrl, data, headers: headers);
      } else {
        print("header is null");
        response = await connect.post(fullUrl, data);
      }

      print('postDataMethod=====>response::${response.body}');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // print(response.statusText.toString());
        showToast(title: response.statusText.toString());
        return null;
      }
    } catch (e) {
      print("print e");
      print(e);
    }
  }
}
