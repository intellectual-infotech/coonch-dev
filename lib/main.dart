import 'package:coonch/app.dart';
import 'package:coonch/dependency_injection.dart';
import 'package:flutter/material.dart';


Future<void> main() async {

  await init(); //calling DependencyInjection init method
  runApp(const App());
}