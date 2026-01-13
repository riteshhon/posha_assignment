import 'package:flutter/material.dart';

class RecipeFavouriteScreen extends StatefulWidget {
  const RecipeFavouriteScreen({super.key});

  @override
  State<RecipeFavouriteScreen> createState() => _RecipeFavouriteScreenState();
}

class _RecipeFavouriteScreenState extends State<RecipeFavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite Recipes')),
      body: const Center(child: Text('Favourite Recipes Screen')),
    );
  }
}
