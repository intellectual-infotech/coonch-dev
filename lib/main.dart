import 'package:coonch/app.dart';
import 'package:coonch/dependancy_injection.dart';
import 'package:flutter/material.dart';

import 'utils/local_storage/storage_utility.dart';

void main() {
  MLocalStorage().init();
  init(); //calling DependencyInjection init method
  runApp(const App());
}