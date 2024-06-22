import 'package:coonch/app.dart';
import 'package:coonch/dependency_injection.dart';
import 'package:coonch/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init(); //calling DependencyInjection init method
  runApp(const App());
}