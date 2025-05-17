import 'package:flutter/material.dart';
import 'package:food_snap/services/image_classification_service.dart';
import 'package:food_snap/ui/camera_page.dart';
import 'package:food_snap/ui/detail_page.dart';
import 'package:food_snap/ui/home_page.dart';
import 'package:food_snap/ui/result_page.dart';
import 'package:food_snap/viewmodels/image_classification_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ImageClassificationService()),
        ChangeNotifierProvider(
          create:
              (_) => ImageClassificationViewmodel(
                context.read<ImageClassificationService>(),
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        initialRoute: HomePage.route,
        routes: {
          HomePage.route: (context) => HomePage(),
          DetailPage.route: (context) => DetailPage(),
          CameraPage.route: (context) => CameraPage(),
          ResultPage.route: (context) => ResultPage(),
        },
      ),
    );
  }
}
