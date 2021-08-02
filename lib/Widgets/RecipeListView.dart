import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'RecipeDetailsWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeName {
  final int id;
  final String name;
  final String image;
  final String ingredients;

  RecipeName(
      {required this.id,
      required this.name,
      required this.image,
      required this.ingredients});

  factory RecipeName.fromJson(Map<String, dynamic> json) {
    return RecipeName(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        ingredients: json['ingredients']);
  }
}

class RecipeListView extends StatelessWidget {
  Future<List<RecipeName>> _fetchRecipes() async {
    final recipeListAPIUrl =
        Uri.parse(('https://broccolisoupapi.azurewebsites.net/api/Recipes'));
    final response = await http.get(recipeListAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var recipes = jsonResponse
          .map((recipe) => new RecipeName.fromJson(recipe))
          .toList();

      return recipes;
    } else {
      throw Exception('Failed to load recipes from API');
    }
  }

  ListView _recipesListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(context, data[index]);
        });
  }

  ListTile _tile(BuildContext context, RecipeName recipeName) {
    return ListTile(
        title: Text(recipeName.name,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        leading: Icon(Icons.food_bank,
            color: Colors.pink, size: 24.0, semanticLabel: 'Icon of food'),
        trailing: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Hero(
              tag: recipeName.name,
              child: CachedNetworkImage(
                  height: 48,
                  width: 48,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageUrl: recipeName.image,
                  errorWidget: (context, url, error) => Icon(Icons.error))),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RecipeDetailsWidget(recipeName: recipeName)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecipeName>>(
        future: _fetchRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<RecipeName> data = snapshot.data!;
            return Expanded(child: _recipesListView(data));
          } else if (snapshot.hasError) {
            return Expanded(child: Center(child: Text("${snapshot.error}")));
          }
          return Expanded(child: Center(child: CircularProgressIndicator()));
        });
  }
}
