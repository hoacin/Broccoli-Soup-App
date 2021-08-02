import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'RecipeListView.dart';
import 'StepDetailsWidget.dart';

class RecipeStep {
  final String shortDescription;
  final String longDescription;
  final String image;

  RecipeStep(
      {required this.shortDescription,
      required this.longDescription,
      required this.image});

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
        shortDescription: json['shortDescription'],
        longDescription: json['longDescription'],
        image: json['image']);
  }
}

class StepsListView extends StatelessWidget {
  final RecipeName recipeName;
  StepsListView({required this.recipeName});

  Future<List<RecipeStep>> _fetchSteps() async {
    final stepsListAPIUrl = Uri.parse(
        ('https://broccolisoupapi.azurewebsites.net/api/Recipes/Steps/${recipeName.id}'));
    final response = await http.get(stepsListAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var steps = jsonResponse
          .map((recipe) => new RecipeStep.fromJson(recipe))
          .toList();

      return steps;
    } else {
      throw Exception('Failed to load steps from API');
    }
  }

  ListView _stepsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(context, data[index]);
        });
  }

  ListTile _tile(BuildContext context, RecipeStep recipeStep) {
    return ListTile(
        title: Text(recipeStep.shortDescription,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        leading: Icon(Icons.arrow_downward,
            color: Colors.pink, size: 24.0, semanticLabel: 'Icon of food'),
        trailing: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Hero(
              tag: recipeStep.shortDescription,
              child: CachedNetworkImage(
                  height: 48,
                  width: 48,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageUrl: recipeStep.image,
                  errorWidget: (context, url, error) => Icon(Icons.error))),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      StepDetailsWidget(recipeStep: recipeStep)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecipeStep>>(
        future: _fetchSteps(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<RecipeStep> data = snapshot.data!;
            return Expanded(child: _stepsListView(data));
          } else if (snapshot.hasError) {
            return Expanded(child: Center(child: Text("${snapshot.error}")));
          }
          return Expanded(child: Center(child: CircularProgressIndicator()));
        });
  }
}
