import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:coonch/api.dart';
import 'package:coonch/common/methods/method.dart';
import 'package:coonch/features/auth/models/UserDataModel.dart';
import 'package:coonch/features/auth/screens/create_password.dart';
import 'package:coonch/features/auth/screens/login_screen.dart';
import 'package:coonch/features/dashboard/screens/dashboard.dart';
import 'package:coonch/features/home/screen/home_screen.dart';
import 'package:coonch/features/profile/controllers/profile_controller.dart';
import 'package:coonch/utils/api/rest_api.dart';
import 'package:coonch/utils/constants/image_strings.dart';
import 'package:coonch/utils/constants/text_strings.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AuthController extends GetxController {
  final RestAPI restAPI = Get.find<RestAPI>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController =
      TextEditingController(text: "viveklumbhani69@gmail.com");
  TextEditingController resetEmailController = TextEditingController();
  TextEditingController passwordController =
      TextEditingController(text: "vivek123");
  TextEditingController resetPasswordController = TextEditingController();
  TextEditingController resetOTPController = TextEditingController();
  TextEditingController resetConfirmPasswordController =
      TextEditingController();
  TextEditingController forgotPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxBool isPasswordHidden = true.obs;

  var selectedPhoneCode = '+91'.obs; // Default phone code is +91

  void clearControllers() {
    emailController.clear();
    resetEmailController.clear();
    passwordController.clear();
    resetConfirmPasswordController.clear();
    resetPasswordController.clear();
    confirmPasswordController.clear();
    forgotPasswordController.clear();
  }

  /// Almost There Page
  // Set Mobile Number Code
  void setPhoneCode(String code) {
    selectedPhoneCode.value = code;
  }

  /// Login Page
  // Observable variable to keep track of checkbox state
  var keepSignedIn = false.obs;

  // Function to toggle checkbox state
  void toggleKeepSignedIn(bool? value) {
    if (value != null) {
      keepSignedIn.value = value;
    }
  }

  void onLogin() async {
    var response = await restAPI.postDataMethod(
      "api/auth/login",
      data: {
        "email": emailController.text,
        "password": passwordController.text,
      },
    );
    if (response == null || response?.isEmpty) {
      showToast(title: "Login Response is Null or Empty");
      return;
    }
    if (response['message'] == "Login successful") {
      UserDataModel userDataModel = UserDataModel.fromJson(response);

      final localStorage = Get.find<MLocalStorage>();

      await localStorage.setUserData(userDataModel.toJson());
      await localStorage.setToken(response["token"]);
      Get.to(DashBoardScreen());
      Get.find<ProfileController>().callGetProfile();
    } else {
      showToast(title: response.error.toString());
    }
  }

  void forgotPasswordOTPApi() async {
    var response = await restAPI.postDataMethod(
      "${APIConstants.strDefaultAuthPath}/forgotpassword",
      data: {
        "email": resetEmailController.text,
      },
    );
    if (response == null || response?.isEmpty) {
      showToast(title: "Forget password Response is Null or Empty");
      return;
    }
    print("forgotPasswordOTPApi=====>response::${response}");
    if (response == "Password reset email sent successfully.") {
      Get.to(CreatePasswordScreen());
    } else {
      showToast(title: response.error.toString());
    }
  }

  void createNewPasswordVerifyOTPApi() async {
    var response = await restAPI.postDataMethod(
      "${APIConstants.strDefaultAuthPath}/resetforgotpassword",
      data: {
        "email": resetEmailController.text,
        "token": resetOTPController.text.isNotEmpty
            ? int.parse(resetOTPController.text)
            : 0,
        "newPassword": resetPasswordController.text
      },
    );
    print("createNewPasswordVerifyOTPApi=====>response::${response}");
    if (response == null || response?.isEmpty) {
      showToast(
          title: "createNewPasswordVerifyOTPApi Response is Null or Empty");
      return;
    }
    if (response['msg'] == "password changed successfully") {
      showToast(title: response['msg']);
      Get.offAll(LoginScreen());
    } else {
      showToast(title: "createNewPasswordVerifyOTPApi response not matched");
    }
  }

  String generateUsername(String name, String email) {
    // Remove whitespace from the name and convert it to lowercase
    String cleanedName = name.replaceAll(' ', '').toLowerCase();

    // Split the email address at the '@' symbol
    List<String> emailParts = email.split('@');

    // Take the first part of the email address
    String emailUsername = emailParts[0];

    // Combine the cleaned name and email username
    String username = '$cleanedName$emailUsername';

    // Limit the username to 8 characters
    if (username.length > 8) {
      username = username.substring(0, 8);
    }

    return username;
  }

  Future<File> getAssetFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final file = File(
        '${(await getTemporaryDirectory()).path}/${assetPath.split('/').last}');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  void onSignUp(XFile profile) async {
    try {
      /// Validation
      if (StringUtils.isNullOrEmpty(nameController.text)) {
        showToast(title: MTexts.strPlzEnterName);
        return;
      }
      if (phoneController.text.length != 10) {
        showToast(title: MTexts.strPlzEnterValidPhoneNum);
        return;
      }
      print(
          "Signup URL : ${APIConstants.strBaseUrlWithPort}${APIConstants.strDefaultAuthPath}/register");

      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${APIConstants.strBaseUrlWithPort}${APIConstants.strDefaultAuthPath}/register'));
      final Map<String, String> mappedBody = {
        'email': emailController.text,
        'username': generateUsername(nameController.text, emailController.text),
        'password': passwordController.text,
        'display_name': nameController.text,
        'bio': 'lorem ipsum',
        'phone': phoneController.text.toString()
      }.map((k, v) => MapEntry(k.toString(), v.toString()));
      request.fields.addAll(mappedBody);

      print("mappedBody : $mappedBody");

      Uint8List? fileBytes = await profile.readAsBytes();
      final http.MultipartFile imgRequest = http.MultipartFile.fromBytes(
        'profile_pic_url',
        fileBytes.toList(),
        filename: profile.name,
        contentType: MediaType("photo", "jpeg, jpg, svg"),
      );

      request.files.add(imgRequest);

      http.StreamedResponse response = await request.send();
      http.Response response3 = await http.Response.fromStream(response);
      print("response3 : ${response3.body}");
      dynamic jsonResponse = jsonDecode(response3.body);

      var encodeFirst = json.encode(response3.body);
      var data = json.decode(encodeFirst);
      print("dataa : $data");

      if (jsonResponse == null || jsonResponse.isEmpty) {
        showToast(title: "onSignUp jsonResponse is null or empty");
        return;
      }

      print("Sign up =======>jsonResponse::$jsonResponse");
      if (response.statusCode == 200) {
        if (jsonResponse.containsKey("msg")) {
          String message = jsonResponse["msg"];
          if (message == "Account created successfully") {
            if (jsonResponse["user"] != null) {
              UserDataModel userDataModel =
                  UserDataModel.fromJson(jsonResponse["user"]);

              final localStorage = Get.find<MLocalStorage>();

              await localStorage.setUserData(userDataModel.toJson());
              await localStorage.setToken(jsonResponse["token"]);
              showToast(title: message);
              Future.delayed(const Duration(seconds: 1), () {
                Get.to(HomeScreen());
              });
            }
          }
        } else {
          print("No message found in the response.");
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }

  bool onLoginScreenValidation() {
    if (StringUtils.isNullOrEmpty(emailController.text)) {
      showToast(title: MTexts.strPlzEnterEmail);
      return false;
    }
    if (!EmailUtils.isEmail(emailController.text)) {
      showToast(title: MTexts.strPlzEnterValidEmail);
      return false;
    }
    if (StringUtils.isNullOrEmpty(passwordController.text)) {
      showToast(title: MTexts.strPlzEnterPassword);
      return false;
    }
    return true;
  }

  bool onSignUpScreenValidation() {
    if (StringUtils.isNullOrEmpty(emailController.text)) {
      showToast(title: MTexts.strPlzEnterEmail);
      return false;
    }
    if (!EmailUtils.isEmail(emailController.text)) {
      showToast(title: MTexts.strPlzEnterValidEmail);
      return false;
    }
    if (StringUtils.isNullOrEmpty(passwordController.text)) {
      showToast(title: MTexts.strPlzEnterPassword);
      return false;
    }
    if (passwordController.text.toString() !=
        confirmPasswordController.text.toString()) {
      showToast(title: MTexts.strPasswordNotMatched);
      return false;
    }
    return true;
  }

  bool onResetPasswordScreenValidation() {
    if (StringUtils.isNullOrEmpty(resetEmailController.text)) {
      showToast(title: MTexts.strPlzEnterEmail);
      return false;
    }
    if (!EmailUtils.isEmail(resetEmailController.text)) {
      showToast(title: MTexts.strPlzEnterValidEmail);
      return false;
    }
    if (StringUtils.isNullOrEmpty(resetPasswordController.text)) {
      showToast(title: MTexts.strPlzEnterPassword);
      return false;
    }
    if (resetPasswordController.text.toString() !=
        resetConfirmPasswordController.text.toString()) {
      showToast(title: MTexts.strPasswordNotMatched);
      return false;
    }
    if (resetOTPController.text.isEmpty) {
      showToast(title: MTexts.strOTPError);
      return false;
    }
    return true;
  }

  bool onResetEmailScreenValidation() {
    if (StringUtils.isNullOrEmpty(resetEmailController.text)) {
      showToast(title: MTexts.strPlzEnterEmail);
      return false;
    }
    return true;
  }

  void onForgetPassword() {
    restAPI.postDataMethod(
      "${APIConstants.strBaseUrl}/${APIConstants.strDefaultAuthPath}/forgotpassword",
      data: {
        "email": emailController.text,
      },
    );
  }

  RxString imgProfileString = MImages.imgAddProfilePhoto.obs;
  Rxn<File> convertedFile = Rxn<File>();

  void setProfilePhoto(String newImageUrl) {
    convertedFile = Rxn<File>();
    imgProfileString.value = newImageUrl;
  }

  void setSelectedProfilePhoto(XFile newSelectedFile) {
    imgProfileString.value = "";
    // Convert XFile to File and set imgProfileString with the file path
    convertXFileToFile(newSelectedFile).then((file) {
      convertedFile.value = file;
      // print(" fdsafds ${convertedFile.value}");
    });
  }
}
