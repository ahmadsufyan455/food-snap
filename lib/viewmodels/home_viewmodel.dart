import 'package:flutter/foundation.dart';
import 'package:food_snap/utils/image_crop_helper.dart';
import 'package:image_picker/image_picker.dart';

class HomeViewmodel extends ChangeNotifier {
  String? imagePath;
  XFile? pickedFile;

  void _setImage(XFile? value) {
    pickedFile = value;
    imagePath = value?.path;
    notifyListeners();
  }

  void pickImage(ImageSource source) async {
    final picker = ImagePicker();

    pickedFile = await picker.pickImage(source: source);
    _cropImage();
  }

  Future<void> _cropImage() async {
    if (pickedFile == null) return;

    final croppedPath = await ImageCropperHelper.cropImage(
      imagePath: pickedFile!.path,
    );

    if (croppedPath != null) {
      _setImage(XFile(croppedPath));
    }
  }

  void resetState() {
    imagePath = null;
    pickedFile = null;
    notifyListeners();
  }
}
