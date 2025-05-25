import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_snap/firebase_options.dart';
import 'package:food_snap/services/api_service.dart';
import 'package:food_snap/services/database_service.dart';
import 'package:food_snap/services/firebase_ml_service.dart';
import 'package:food_snap/services/gemini_service.dart';
import 'package:food_snap/services/image_classification_service.dart';
import 'package:food_snap/theme/app_colors.dart';
import 'package:food_snap/ui/camera_page.dart';
import 'package:food_snap/ui/home_page.dart';
import 'package:food_snap/ui/reference_page.dart';
import 'package:food_snap/ui/result_page.dart';
import 'package:food_snap/viewmodels/home_viewmodel.dart';
import 'package:food_snap/viewmodels/image_classification_viewmodel.dart';
import 'package:food_snap/viewmodels/nutrition_viewmodel.dart';
import 'package:food_snap/viewmodels/reference_viewmodel.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => DatabaseService()),
        Provider(create: (_) => FirebaseMlService()),
        Provider(
          create: (context) {
            return ImageClassificationService(
              context.read<FirebaseMlService>(),
            );
          },
        ),
        Provider(create: (_) => GeminiService()),
        ChangeNotifierProvider(
          create: (context) => ImageClassificationViewmodel(
            context.read<ImageClassificationService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewmodel(context.read<DatabaseService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              NutritionViewmodel(context.read<GeminiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ReferenceViewmodel(context.read<ApiService>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.secondary,
          appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
        ),
        initialRoute: HomePage.route,
        routes: {
          HomePage.route: (context) => HomePage(),
          ReferencePage.route: (context) {
            final args =
                ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>;
            return ReferencePage(foodName: args['foodName']);
          },
          CameraPage.route: (context) => CameraPage(),
          ResultPage.route: (context) => ResultPage(),
        },
      ),
    );
  }
}
