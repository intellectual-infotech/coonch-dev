import 'dart:convert';

import 'package:coonch/features/auth/models/UserDataModel.dart';
import 'package:get_storage/get_storage.dart';

class MLocalStorage {
  static final MLocalStorage _instance = MLocalStorage._internal();

  factory MLocalStorage() {
    return _instance;
  }

  static GetStorage? _storage;

  MLocalStorage._internal();

  init() {
    _storage = GetStorage();
  }

  static const String tokenKey = 'token';
  static const String userDataKey = 'userData';

  static setToken(String? value) {
    saveData<String?>(tokenKey, value);
  }

  static  String? getToken() {
    return readData<String?>(tokenKey);
  }

  static setUserData(dynamic value) {
    saveData(userDataKey, jsonEncode(value));
  }

  static dynamic getUserData() {
    return jsonDecode(readData(userDataKey));
  }

  // Generic method to save data
  static Future<void> saveData<T>(String key, T value) async {
    await _storage!.write(key, value);
  }

  // Generic method to read data
  static T? readData<T>(String key) {
    return _storage!.read<T>(key);
  }

  // Generic method to remove data
  static Future<void> removeData(String key) async {
    await _storage!.remove(key);
  }

  // Clear all data in storage
  static Future<void> clearALl() async {
    await _storage!.erase();
  }
}
