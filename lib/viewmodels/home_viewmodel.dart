import 'package:flutter/foundation.dart';
import 'package:food_snap/models/food_table.dart';
import 'package:food_snap/services/database_service.dart';
import 'package:food_snap/utils/image_crop_helper.dart';
import 'package:image_picker/image_picker.dart';

class HomeViewmodel extends ChangeNotifier {
  final DatabaseService _databaseService;

  HomeViewmodel(this._databaseService);

  String? imagePath;
  XFile? pickedFile;

  List<FoodTable>? _foodRecents;
  List<FoodTable>? get foodRecents => _foodRecents;

  FoodTable? _selectedFood;
  FoodTable? get selectedFood => _selectedFood;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaved = false;
  bool get isSaved => _isSaved;

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
    if (pickedFile != null) {
      final croppedPath = await ImageCropperHelper.cropImage(
        imagePath: pickedFile!.path,
      );

      if (croppedPath != null) {
        _setImage(XFile(croppedPath));
      }
    }
  }

  void resetState() {
    imagePath = null;
    pickedFile = null;
    notifyListeners();
  }

  void resetSaveState() {
    _isSaved = false;
    notifyListeners();
  }

  Future<void> savedResult(FoodTable data) async {
    try {
      await _databaseService.insertFood(data);
      _isSaved = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to save result: $e');
    }
  }

  Future<void> getRecents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final recents = await _databaseService.getAllFoods();
      _foodRecents = recents;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRecentById(int id) async {
    try {
      _selectedFood = await _databaseService.getFoodById(id);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to get food by ID $id: $e');
    }
  }
}
