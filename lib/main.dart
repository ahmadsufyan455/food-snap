import 'package:flutter/material.dart';
import 'package:food_snap/ui/camera_page.dart';
import 'package:food_snap/ui/detail_page.dart';
import 'package:food_snap/ui/home_page.dart';
import 'package:food_snap/ui/result_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (context) => HomePage(),
        DetailPage.route: (context) => DetailPage(),
        CameraPage.route: (context) => CameraPage(),
        ResultPage.route: (context) => ResultPage(),
      },
    );
  }
}
