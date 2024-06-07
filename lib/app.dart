import 'package:coonch/features/auth/screens/login_screen.dart';
import 'package:coonch/features/dashboard/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/local_storage/storage_utility.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
          // useMaterial3: false
          ),
      home: MLocalStorage.getToken() == null ||
              (MLocalStorage.getToken() ?? '').isEmpty
          ? LoginScreen()
          : DashBoardScreen(),
    );
  }
}
