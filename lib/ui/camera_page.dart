import 'package:flutter/material.dart';
import 'package:food_snap/viewmodels/image_classification_viewmodel.dart';
import 'package:food_snap/widgets/camera_view.dart';
import 'package:food_snap/widgets/classification_item.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatefulWidget {
  static const String route = '/cameraPage';
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late final imageClassificationViewModel =
      context.read<ImageClassificationViewmodel>();

  @override
  void dispose() {
    Future.microtask(() async => await imageClassificationViewModel.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: ColoredBox(
        color: Colors.black,
        child: Center(
          child: Stack(
            children: [
              CameraView(
                onImage: (cameraImage) async {
                  await imageClassificationViewModel
                      .runClassificationFromCamera(cameraImage);
                },
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Consumer<ImageClassificationViewmodel>(
                  builder: (_, updateViewmodel, __) {
                    final classification = updateViewmodel.classification;
                    if (classification == null) {
                      return const SizedBox.shrink();
                    }
                    return ClassificatioinItem(
                      item: classification.label,
                      value:
                          '${(classification.confidenceScore * 100).toStringAsFixed(2)}%',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
