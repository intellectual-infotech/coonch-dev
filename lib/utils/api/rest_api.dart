//Create a file: rest_api.dart
import 'package:coonch/api.dart';
import 'package:coonch/common/methods/method.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:get/get.dart';

class RestAPI {
  final GetConnect connect = Get.find<GetConnect>();
  Map headerData = {};

  //GET request example
  Future<dynamic> getDataMethod(String url,
      {bool isShowToast = false, required Map<String, String> data}) async {
    final localStorage = Get.find<MLocalStorage>();

    String fullUrl = APIConstants.strBaseUrlWithPort + url;
    print('getDataMethod=====>URL::$fullUrl');
    print('getDataMethod=====>query::$data');
    print('getDataMethod=====>Token::${localStorage.getToken() ?? ''}');

    Response response = await connect.get(fullUrl,
        query: data,
        headers: {'Authorization': 'Bearer ${localStorage.getToken() ?? ''}'});

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
  Future<dynamic> postDataMethod(
    String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    //body data
    try {
      String fullUrl = APIConstants.strBaseUrlWithPort + url;
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
      print('postDataMethod statusCode =====>response::${response.statusCode}');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print("response.body.toString()");
        print(response.body.toString());
        showToast(title: response.body.toString());
        return ;
      }
    } catch (e) {
      print("print e");
      print(e);
    }
  }
}
