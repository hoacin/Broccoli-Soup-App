import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'StepsListView.dart';

class StepDetailsWidget extends StatelessWidget {
  final RecipeStep recipeStep;

  StepDetailsWidget({required this.recipeStep});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(recipeStep.shortDescription),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Hero(
                    tag: recipeStep.shortDescription,
                    child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: recipeStep.image,
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error))),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Text(recipeStep.longDescription,
                        style: TextStyle(fontSize: 25))),
              ]),
        ));
  }
}
