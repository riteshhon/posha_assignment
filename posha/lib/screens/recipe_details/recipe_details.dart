import 'package:flutter/material.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String? recipeId;
  final dynamic recipe;

  const RecipeDetailsScreen({super.key, this.recipeId, this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Recipe Details Screen'),
            if (widget.recipeId != null) Text('Recipe ID: ${widget.recipeId}'),
          ],
        ),
      ),
    );
  }
}
