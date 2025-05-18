import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_snap/theme/app_colors.dart';
import 'package:food_snap/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  static const String route = '/detailPage';
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Detail Food')),
      body: Stack(
        children: [
          Consumer<HomeViewmodel>(
            builder: (_, value, _) {
              final imagePath = value.imagePath;
              return ClipRRect(
                child: Image.file(
                  File(imagePath.toString()),
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.3,

                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 1,
            minChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: 5.0,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
