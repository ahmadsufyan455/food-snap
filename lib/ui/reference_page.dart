import 'package:flutter/material.dart';
import 'package:food_snap/models/meal_model.dart';
import 'package:food_snap/theme/app_colors.dart';
import 'package:food_snap/viewmodels/reference_viewmodel.dart';
import 'package:provider/provider.dart';

class ReferencePage extends StatefulWidget {
  static const String route = '/referencePage';
  final String foodName;
  const ReferencePage({super.key, required this.foodName});

  @override
  State<ReferencePage> createState() => _ReferencePageState();
}

class _ReferencePageState extends State<ReferencePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ReferenceViewmodel>().getMeal(widget.foodName);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Reference Food')),
      body: Consumer<ReferenceViewmodel>(
        builder: (_, mealViewModel, __) {
          final data = mealViewModel.meal;

          if (mealViewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (data == null) {
            return const Center(
              child: Text(
                'No data found',
                style: TextStyle(color: AppColors.primary, fontSize: 20),
              ),
            );
          }

          return Stack(
            children: [
              _ReferenceImage(imageUrl: data.image),
              _ReferenceDraggableSheet(data: data),
            ],
          );
        },
      ),
    );
}

class _ReferenceImage extends StatelessWidget {
  final String imageUrl;
  const _ReferenceImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) => ClipRRect(
      child: Image.network(
        imageUrl,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 0.3,
        fit: BoxFit.cover,
      ),
    );
}

class _ReferenceDraggableSheet extends StatelessWidget {
  final MealModel data;
  const _ReferenceDraggableSheet({required this.data});

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.7,
      builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DragHandle(),
                  const SizedBox(height: 16.0),
                  Center(
                    child: Text(
                      data.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '(${data.category} - ${data.area})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(color: AppColors.primary, thickness: 1),
                  const SizedBox(height: 8.0),
                  const _SectionTitle(title: 'Ingredients'),
                  const SizedBox(height: 8.0),
                  _IngredientsList(
                    ingredients: data.ingredients,
                    measures: data.measures,
                  ),
                  const Divider(color: AppColors.primary, thickness: 1),
                  const SizedBox(height: 8.0),
                  const _SectionTitle(title: 'Instructions'),
                  const SizedBox(height: 8.0),
                  Text(
                    data.instructions,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.1,
        height: 5.0,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) => Text(
      title,
      style: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
    );
}

class _IngredientsList extends StatelessWidget {
  final List<dynamic> ingredients;
  final List<dynamic> measures;

  const _IngredientsList({required this.ingredients, required this.measures});

  @override
  Widget build(BuildContext context) {
    final validIngredients = ingredients
        .asMap()
        .entries
        .where((entry) => (entry.value as String).isNotEmpty)
        .toList();

    return Column(
      children: List.generate(validIngredients.length, (i) {
        final index = validIngredients[i].key;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ingredients[index],
                style: const TextStyle(fontSize: 16, color: AppColors.primary),
              ),
              Text(
                measures[index],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
