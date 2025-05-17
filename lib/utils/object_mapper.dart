import 'package:food_snap/dtos/classification_result_dto.dart';
import 'package:food_snap/models/classification_model.dart';

extension ClassificationResultToModel on ClassificationResultDto {
  ClassificationModel toModel(List<String> labels) {
    return ClassificationModel(label: labels[index], confidenceScore: score);
  }
}
