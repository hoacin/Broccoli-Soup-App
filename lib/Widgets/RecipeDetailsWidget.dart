import 'package:broccolisoup/Widgets/RecipeListView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeDetailsWidget extends StatelessWidget {
  final RecipeName recipeName;

  RecipeDetailsWidget({required this.recipeName});

  void _showIngredientsSnack(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(recipeName.ingredients)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(recipeName.name),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Hero(
                  tag: recipeName.name,
                  child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      imageUrl: recipeName.image,
                      errorWidget: (context, url, error) => Icon(Icons.error))),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showIngredientsSnack(context);
          },
          tooltip: AppLocalizations.of(context)!.ingredientsTooltip,
          child: Icon(Icons.shopping_cart),
        ));
  }
}
