import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class HomeViewmodel extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;

  void _setImage(XFile? value) {
    imageFile = value;
    imagePath = value?.path;
    notifyListeners();
  }

  void pickImage(ImageSource source) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _setImage(pickedFile);
    }
  }

  void resetState() {
    imagePath = null;
    imageFile = null;
    notifyListeners();
  }
}
