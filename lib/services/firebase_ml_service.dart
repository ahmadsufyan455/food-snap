import 'dart:io';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

class FirebaseMlService {
  Future<File> loadModel() async {
    final instance = FirebaseModelDownloader.instance;
    final model = await instance.getModel(
      'food_recognition_model',
      FirebaseModelDownloadType.localModel,
      FirebaseModelDownloadConditions(
        
      ),
    );
    return model.file;
  }
}
