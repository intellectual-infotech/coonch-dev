import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class MLocalStorage {
  final GetStorage _storage = GetStorage();

  GetStorage get storage => _storage;

  Future<void> init()  async {
   await GetStorage.init();
  }

   static const String tokenKey = 'token';
   static const String userDataKey = 'userData';

   removeUserData(){
     removeData(tokenKey);
     removeData(userDataKey);
   }

   setToken(String? value) {
    saveData<String?>(tokenKey, value);
  }

    String? getToken() {
    return readData<String?>(tokenKey);
  }

  setUserData(dynamic value) {
    saveData(userDataKey, jsonEncode(value));
  }

   dynamic getUserData() {
    return jsonDecode(readData(userDataKey));
  }

  // Generic method to save data
   Future<void> saveData<T>(String key, T value) async {
    await storage.write(key, value);
  }

  // Generic method to read data
   T? readData<T>(String key) {
    return storage.read<T>(key);
  }

  // Generic method to remove data
   Future<void> removeData(String key) async {
    await storage.remove(key);
  }

  // Clear all data in storage
   Future<void> clearALl() async {
    await storage.erase();
  }
}
